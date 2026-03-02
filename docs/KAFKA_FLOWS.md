# 📡 Kafka Event Flows — Complete Documentation

**Event-Driven Architecture: Order Lifecycle & Error Handling**

---

## Table of Contents

1. [Kafka Configuration](#kafka-configuration)
2. [Topic Specifications](#topic-specifications)
3. [Order Placement Flow (Success)](#order-placement-flow-success)
4. [Failed Payment Flow](#failed-payment-flow)
5. [Restaurant Rejects Order](#restaurant-rejects-order)
6. [Order Cancellation by Customer](#order-cancellation-by-customer)
7. [Delivery Partner Assignment](#delivery-partner-assignment)
8. [Consumer Error Handling](#consumer-error-handling)
9. [Monitoring & Alerting](#monitoring--alerting)

---

## Kafka Configuration

### Broker Configuration

```yaml
version: '3.8'
services:
  kafka:
    image: confluentinc/cp-kafka:7.5.0
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_LOG_RETENTION_HOURS: 168  # 7 days
      KAFKA_LOG_SEGMENT_BYTES: 1073741824  # 1GB
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: 'false'  # Create topics explicitly
```

### Producer Configuration (Spring Boot)

```yaml
spring:
  kafka:
    bootstrap-servers: localhost:9092
    producer:
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.springframework.kafka.support.serializer.JsonSerializer
      acks: all  # Wait for all replicas
      retries: 3
      properties:
        linger.ms: 10  # Batch messages for 10ms
        compression.type: snappy
        max.in.flight.requests.per.connection: 5
        enable.idempotence: true  # Exactly-once semantics
```

### Consumer Configuration (Spring Boot)

```yaml
spring:
  kafka:
    consumer:
      group-id: ${spring.application.name}
      auto-offset-reset: earliest  # Start from beginning on first run
      enable-auto-commit: false  # Manual commit after processing
      max-poll-records: 10  # Process in small batches
      key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      value-deserializer: org.springframework.kafka.support.serializer.JsonDeserializer
      properties:
        spring.json.trusted.packages: "com.gouravmishra.fooddelivery.*"
    listener:
      ack-mode: manual  # Commit offsets manually
      concurrency: 3  # 3 threads per consumer
```

---

## Topic Specifications

| Topic Name | Partitions | Replication | Key | Retention | Purpose |
|------------|------------|-------------|-----|-----------|----------|
| **order.created** | 12 | 3 | restaurantId | 7 days | New order placed, triggers notifications |
| **payment.completed** | 8 | 3 | orderId | 7 days | Payment successful, update order status |
| **payment.failed** | 8 | 3 | orderId | 7 days | Payment declined, rollback order |
| **order.status.updated** | 12 | 3 | orderId | 7 days | Status change (CONFIRMED, PREPARING, etc.) |
| **order.cancelled** | 8 | 3 | orderId | 7 days | Order cancelled, initiate refund |
| **delivery.assigned** | 8 | 3 | orderId | 7 days | Partner assigned to order |
| **delivery.location.updated** | 24 | 3 | deliveryPartnerId | **1 hour** | Real-time GPS updates (high frequency) |
| **restaurant.updated** | 4 | 3 | restaurantId | 7 days | Menu/info updated, reindex in Elasticsearch |

### Creating Topics

```bash
# Run once during setup
docker exec -it foodflow-kafka kafka-topics --create \
  --bootstrap-server localhost:9092 \
  --topic order.created \
  --partitions 12 \
  --replication-factor 3 \
  --config retention.ms=604800000

# Repeat for all topics...
```

Or use the automated script:
```bash
bash docker/init-kafka-topics.sh
```

---

## Order Placement Flow (Success)

**End-to-End: Customer clicks "Place Order" → Food Delivered**

### Timeline Overview

```
00:00  Customer clicks "Place Order"
00:01  Order created in DB
00:02  Kafka: order.created published
00:03  Payment gateway order created
00:05  Customer completes payment
00:06  Kafka: payment.completed published
00:07  Order status → PENDING
00:10  Restaurant receives notification
01:00  Restaurant accepts (Kafka: order.status.updated → CONFIRMED)
03:00  Restaurant marks PREPARING
18:00  Restaurant marks READY_FOR_PICKUP
18:05  Kafka triggers delivery assignment
18:30  Partner accepts (Kafka: delivery.assigned)
19:00  Partner picks up (Kafka: order.status.updated → PICKED_UP)
28:00  Partner marks OUT_FOR_DELIVERY
35:00  Partner marks DELIVERED
35:05  Customer receives review request notification
```

### Step-by-Step Flow

#### Step 1: Customer Places Order (00:00 - 00:02)

**Service:** Order Service  
**API:** `POST /api/v1/orders`

**What Happens:**

1. **Validate Cart:**
   ```java
   // Fetch cart from Redis
   Cart cart = redisTemplate.opsForHash().entries("cart:" + userId);
   if (cart.isEmpty()) throw new CartEmptyException();
   ```

2. **Validate Menu Items:**
   ```java
   // Call Restaurant Service to verify items still available
   List<MenuItem> items = restaurantServiceClient.validateMenuItems(cart.getItemIds());
   ```

3. **Lock Prices (Race Condition Prevention):**
   ```sql
   BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   -- Prices locked at this moment, can't change during order creation
   ```

4. **Create Order Record:**
   ```java
   Order order = Order.builder()
       .orderNumber(generateOrderNumber())  // FD-2024-000123
       .userId(userId)
       .restaurantId(cart.getRestaurantId())
       .status(OrderStatus.PENDING)
       .subtotal(cart.calculateSubtotal())
       .deliveryFee(30.00)
       .platformFee(5.00)
       .gstAmount(calculateGST())
       .totalAmount(calculateTotal())
       .build();
   orderRepository.save(order);
   
   // Save order items (snapshot of menu at order time)
   for (CartItem item : cart.getItems()) {
       OrderItem orderItem = OrderItem.builder()
           .orderId(order.getId())
           .menuItemId(item.getMenuItemId())
           .menuItemName(item.getName())  // SNAPSHOT
           .unitPrice(item.getPrice())    // SNAPSHOT
           .quantity(item.getQuantity())
           .customizations(item.getCustomizations())
           .build();
       orderItemRepository.save(orderItem);
   }
   
   COMMIT;
   ```

5. **Publish Kafka Event:**
   ```java
   OrderCreatedEvent event = OrderCreatedEvent.builder()
       .orderId(order.getId())
       .orderNumber(order.getOrderNumber())
       .userId(order.getUserId())
       .restaurantId(order.getRestaurantId())
       .items(order.getItems())
       .totalAmount(order.getTotalAmount())
       .deliveryAddress(order.getDeliveryAddress())
       .customerPhone(user.getPhoneNumber())
       .createdAt(order.getCreatedAt())
       .build();
   
   kafkaTemplate.send("order.created", order.getRestaurantId().toString(), event);
   ```

6. **Return Response:**
   ```json
   {
     "orderId": "order-uuid",
     "orderNumber": "FD-2024-000123",
     "razorpayOrderId": "order_MNopqr123456",
     "amount": 450.00,
     "currency": "INR"
   }
   ```

**Customer Sees:** "Proceeding to payment..." loading screen

---

#### Step 2: Kafka Consumers React to order.created (00:02 - 00:10)

##### Consumer 1: Notification Service

```java
@KafkaListener(topics = "order.created", groupId = "notification-service")
public void handleOrderCreated(OrderCreatedEvent event) {
    log.info("Order created: {}", event.getOrderNumber());
    
    // Send push notification to customer
    User customer = userService.getUser(event.getUserId());
    firebaseService.sendNotification(
        customer.getFcmToken(),
        "Order Placed Successfully!",
        "Your order #" + event.getOrderNumber() + " has been placed. Awaiting restaurant confirmation.",
        Map.of("orderId", event.getOrderId(), "type", "ORDER_PLACED")
    );
    
    // Send push notification to restaurant
    Restaurant restaurant = restaurantService.getRestaurant(event.getRestaurantId());
    firebaseService.sendNotification(
        restaurant.getOwner().getFcmToken(),
        "🍴 New Order!",
        "Order #" + event.getOrderNumber() + " - ₹" + event.getTotalAmount() + " - " + event.getItems().size() + " items",
        Map.of("orderId", event.getOrderId(), "type", "NEW_ORDER"),
        "high"  // High priority for restaurant notifications
    );
    
    log.info("Notifications sent for order: {}", event.getOrderNumber());
}
```

##### Consumer 2: Delivery Service (Standby)

```java
@KafkaListener(topics = "order.created", groupId = "delivery-service")
public void handleOrderCreated(OrderCreatedEvent event) {
    log.info("Order created, preparing for future assignment: {}", event.getOrderNumber());
    
    // Cache order details in Redis for fast retrieval during assignment
    redisTemplate.opsForHash().put(
        "order:pending:" + event.getOrderId(),
        "restaurantId", event.getRestaurantId()
    );
    redisTemplate.opsForHash().put(
        "order:pending:" + event.getOrderId(),
        "deliveryAddress", event.getDeliveryAddress()
    );
    redisTemplate.expire("order:pending:" + event.getOrderId(), 1, TimeUnit.HOURS);
}
```

**Customer Sees:** Push notification: "Order placed successfully!"

---

#### Step 3: Customer Completes Payment (00:05 - 00:07)

**Service:** Payment Service  
**API:** `POST /api/v1/payments/verify`

**What Happens:**

1. **Razorpay Callback:**
   ```javascript
   // Frontend receives callback from Razorpay
   const response = {
     razorpay_order_id: "order_MNopqr123456",
     razorpay_payment_id: "pay_XYZabc789012",
     razorpay_signature: "abc123..."
   };
   
   // Send to backend for verification
   await axios.post('/api/v1/payments/verify', response);
   ```

2. **Verify Signature (CRITICAL):**
   ```java
   String payload = razorpayOrderId + "|" + razorpayPaymentId;
   String expectedSignature = HmacUtils.hmacSha256Hex(razorpayKeySecret, payload);
   
   if (!expectedSignature.equals(razorpaySignature)) {
       log.error("Payment signature mismatch for order: {}", orderId);
       throw new PaymentVerificationException("Invalid payment signature");
   }
   ```

3. **Fetch Payment Details from Razorpay:**
   ```java
   Payment razorpayPayment = razorpayClient.Payments.fetch(razorpayPaymentId);
   
   if (!razorpayPayment.get("status").equals("captured")) {
       throw new PaymentNotCaptured Exception();
   }
   
   if (razorpayPayment.get("amount") != order.getTotalAmount() * 100) {  // Amount in paise
       throw new AmountMismatchException();
   }
   ```

4. **Update Payment Record:**
   ```java
   payment.setRazorpayPaymentId(razorpayPaymentId);
   payment.setRazorpaySignature(razorpaySignature);
   payment.setStatus(PaymentStatus.CAPTURED);
   payment.setPaymentMethod(razorpayPayment.get("method"));  // card, upi, netbanking
   payment.setGatewayResponse(razorpayPayment.toJson());
   paymentRepository.save(payment);
   ```

5. **Publish Kafka Event:**
   ```java
   PaymentCompletedEvent event = PaymentCompletedEvent.builder()
       .orderId(order.getId())
       .paymentId(payment.getId())
       .razorpayPaymentId(razorpayPaymentId)
       .amount(payment.getAmount())
       .paymentMethod(payment.getPaymentMethod())
       .status("CAPTURED")
       .completedAt(Instant.now())
       .build();
   
   kafkaTemplate.send("payment.completed", order.getId().toString(), event);
   ```

**Customer Sees:** "Payment successful! Awaiting restaurant confirmation."

---

#### Step 4: Order Service Receives payment.completed (00:07)

```java
@KafkaListener(topics = "payment.completed", groupId = "order-service")
public void handlePaymentCompleted(PaymentCompletedEvent event) {
    log.info("Payment completed for order: {}", event.getOrderId());
    
    // Update order payment status
    Order order = orderRepository.findById(event.getOrderId())
        .orElseThrow(() -> new OrderNotFoundException(event.getOrderId()));
    
    order.setPaymentStatus(PaymentStatus.PAID);
    order.setPaymentMethod(event.getPaymentMethod());
    // Order status remains PENDING (awaiting restaurant acceptance)
    orderRepository.save(order);
    
    // Clear user's cart (payment confirmed, no longer needed)
    redisTemplate.delete("cart:" + order.getUserId());
    
    log.info("Order payment status updated to PAID: {}", order.getOrderNumber());
}
```

---

#### Step 5: Restaurant Accepts Order (01:00)

**Service:** Restaurant Service  
**API:** `PUT /api/v1/restaurant/orders/{orderId}/accept`

**Request Body:**
```json
{
  "preparationTime": 15
}
```

**What Happens:**

1. **Update Order Status:**
   ```java
   order.setStatus(OrderStatus.CONFIRMED);
   order.setEstimatedDeliveryTime(
       Instant.now().plus(preparationTime + 20, ChronoUnit.MINUTES)  // prep + delivery
   );
   orderRepository.save(order);
   ```

2. **Record Status History:**
   ```java
   OrderStatusHistory history = OrderStatusHistory.builder()
       .orderId(order.getId())
       .status(OrderStatus.CONFIRMED)
       .changedBy("RESTAURANT")
       .changedById(restaurantOwnerId)
       .notes("Estimated preparation time: " + preparationTime + " minutes")
       .build();
   orderStatusHistoryRepository.save(history);
   ```

3. **Publish Kafka Event:**
   ```java
   OrderStatusUpdatedEvent event = OrderStatusUpdatedEvent.builder()
       .orderId(order.getId())
       .previousStatus(OrderStatus.PENDING)
       .newStatus(OrderStatus.CONFIRMED)
       .updatedBy("RESTAURANT")
       .updatedById(restaurantOwnerId)
       .timestamp(Instant.now())
       .metadata(Map.of(
           "preparationTime", preparationTime,
           "estimatedDeliveryTime", order.getEstimatedDeliveryTime()
       ))
       .build();
   
   kafkaTemplate.send("order.status.updated", order.getId().toString(), event);
   ```

**Customer Sees:** Push notification: "🎉 Biryani House confirmed your order! ETA: 35 mins"

---

#### Step 6: Delivery Partner Assignment (18:05 - 18:30)

**Trigger:** Restaurant marks order as `READY_FOR_PICKUP`

**Service:** Delivery Service  
**Algorithm:** See [Section 7: Delivery Partner Assignment](#delivery-partner-assignment)

**Kafka Event Published:**
```java
DeliveryAssignedEvent event = DeliveryAssignedEvent.builder()
    .orderId(order.getId())
    .deliveryPartnerId(partner.getId())
    .partnerName(partner.getUser().getName())
    .partnerPhone(partner.getUser().getPhoneNumber())
    .vehicleNumber(partner.getVehicleNumber())
    .estimatedPickupTime(Instant.now().plus(10, ChronoUnit.MINUTES))
    .assignedAt(Instant.now())
    .build();

kafkaTemplate.send("delivery.assigned", order.getId().toString(), event);
```

**Customer Sees:** Push notification: "🚛 Vijay is delivering your order! ETA: 15 mins" + Live tracking map

---

#### Step 7: Order Delivered (35:00)

**Service:** Delivery Service  
**API:** `POST /api/v1/delivery/assignments/{assignmentId}/delivered`

**Request Body:**
```json
{
  "proofImageUrl": "https://foodflow-images.s3.amazonaws.com/deliveries/proof-123.jpg",
  "recipientName": "Raj Sharma"
}
```

**What Happens:**

1. **Update Order:**
   ```java
   order.setStatus(OrderStatus.DELIVERED);
   order.setActualDeliveryTime(Instant.now());
   orderRepository.save(order);
   ```

2. **Update Partner Stats:**
   ```java
   partner.setIsAvailable(true);  // Back online for new orders
   partner.setTotalDeliveries(partner.getTotalDeliveries() + 1);
   partner.setTotalEarnings(partner.getTotalEarnings() + deliveryEarnings);
   deliveryPartnerRepository.save(partner);
   ```

3. **Publish Kafka Event:**
   ```java
   OrderStatusUpdatedEvent event = OrderStatusUpdatedEvent.builder()
       .orderId(order.getId())
       .previousStatus(OrderStatus.OUT_FOR_DELIVERY)
       .newStatus(OrderStatus.DELIVERED)
       .updatedBy("DELIVERY")
       .updatedById(partner.getId())
       .timestamp(Instant.now())
       .metadata(Map.of(
           "actualDeliveryTime", order.getActualDeliveryTime(),
           "deliveryDuration", calculateDuration()
       ))
       .build();
   
   kafkaTemplate.send("order.status.updated", order.getId().toString(), event);
   ```

**Customer Sees:** Push notification: "🎉 Your order has been delivered! Rate your experience."

---

## Failed Payment Flow

**Scenario:** Payment declined by bank or user closes Razorpay checkout

### Flow Diagram

```
Customer Places Order → Order Created (status: PENDING, payment: PENDING)
  ↓
Customer Attempts Payment → Razorpay Declined (insufficient funds)
  ↓
Payment Service publishes: payment.failed
  ↓
Order Service consumes → Update order (payment_status: FAILED)
  ↓
Notification Service → Send retry notification to customer
  ↓
Scheduled Job (runs every 5 min) → Find orders with payment_status=FAILED for >30 min
  ↓
Auto-cancel order → Publish: order.cancelled (reason: PAYMENT_TIMEOUT)
```

### Implementation

#### Payment Service: Detect Failure

```java
@RestController
@RequestMapping("/api/v1/payments")
public class PaymentController {
    
    @PostMapping("/webhook")
    public ResponseEntity<Void> handleRazorpayWebhook(
            @RequestBody RazorpayWebhookEvent webhook,
            @RequestHeader("X-Razorpay-Signature") String signature) {
        
        // Verify webhook signature
        if (!razorpayService.verifyWebhookSignature(webhook, signature)) {
            log.error("Invalid webhook signature");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        if (webhook.getEvent().equals("payment.failed")) {
            handlePaymentFailed(webhook.getPayload());
        }
        
        return ResponseEntity.ok().build();
    }
    
    private void handlePaymentFailed(PaymentPayload payload) {
        Payment payment = paymentRepository.findByRazorpayOrderId(payload.getOrderId())
            .orElseThrow(() -> new PaymentNotFoundException());
        
        payment.setStatus(PaymentStatus.FAILED);
        payment.setGatewayResponse(payload.toJson());
        paymentRepository.save(payment);
        
        // Publish Kafka event
        PaymentFailedEvent event = PaymentFailedEvent.builder()
            .orderId(payment.getOrderId())
            .paymentId(payment.getId())
            .reason(payload.getErrorReason())  // "insufficient_funds", "card_declined"
            .failedAt(Instant.now())
            .build();
        
        kafkaTemplate.send("payment.failed", payment.getOrderId().toString(), event);
    }
}
```

#### Order Service: Handle payment.failed

```java
@KafkaListener(topics = "payment.failed", groupId = "order-service")
public void handlePaymentFailed(PaymentFailedEvent event) {
    log.warn("Payment failed for order: {}", event.getOrderId());
    
    Order order = orderRepository.findById(event.getOrderId())
        .orElseThrow(() -> new OrderNotFoundException());
    
    order.setPaymentStatus(PaymentStatus.FAILED);
    // Keep order status as PENDING (allow retry)
    orderRepository.save(order);
    
    log.info("Order payment status updated to FAILED: {}", order.getOrderNumber());
}
```

#### Notification Service: Notify Customer

```java
@KafkaListener(topics = "payment.failed", groupId = "notification-service")
public void handlePaymentFailed(PaymentFailedEvent event) {
    Order order = orderService.getOrder(event.getOrderId());
    User customer = userService.getUser(order.getUserId());
    
    String message = getPaymentFailureMessage(event.getReason());
    
    firebaseService.sendNotification(
        customer.getFcmToken(),
        "Payment Failed",
        message + " Please retry or choose a different payment method.",
        Map.of(
            "orderId", order.getId(),
            "type", "PAYMENT_FAILED",
            "action", "RETRY_PAYMENT"
        )
    );
}

private String getPaymentFailureMessage(String reason) {
    return switch (reason) {
        case "insufficient_funds" -> "Your card has insufficient funds.";
        case "card_declined" -> "Your card was declined by the bank.";
        case "authentication_failed" -> "Card authentication failed.";
        default -> "Payment could not be processed.";
    };
}
```

#### Scheduled Job: Auto-Cancel Failed Orders

```java
@Component
public class FailedPaymentCleanupJob {
    
    @Scheduled(fixedDelay = 300000)  // Every 5 minutes
    public void cancelOrdersWithFailedPayments() {
        log.info("Running failed payment cleanup job...");
        
        Instant cutoff = Instant.now().minus(30, ChronoUnit.MINUTES);
        
        List<Order> failedOrders = orderRepository.findAll().stream()
            .filter(o -> o.getPaymentStatus() == PaymentStatus.FAILED)
            .filter(o -> o.getCreatedAt().isBefore(cutoff))
            .filter(o -> o.getStatus() == OrderStatus.PENDING)
            .toList();
        
        for (Order order : failedOrders) {
            log.info("Auto-cancelling order due to payment timeout: {}", order.getOrderNumber());
            
            order.setStatus(OrderStatus.CANCELLED);
            order.setCancelledAt(Instant.now());
            order.setCancelledBy("SYSTEM");
            order.setCancellationReason("Payment not completed within 30 minutes");
            orderRepository.save(order);
            
            // Publish cancellation event
            OrderCancelledEvent event = OrderCancelledEvent.builder()
                .orderId(order.getId())
                .cancelledBy("SYSTEM")
                .reason("PAYMENT_TIMEOUT")
                .refundAmount(0.00)  // No refund needed (payment never succeeded)
                .cancelledAt(Instant.now())
                .build();
            
            kafkaTemplate.send("order.cancelled", order.getId().toString(), event);
        }
        
        log.info("Cancelled {} orders with failed payments", failedOrders.size());
    }
}
```

---

## Restaurant Rejects Order

**Scenario:** Restaurant is too busy, item out of stock, or doesn't accept within 2-minute window

### Manual Rejection

**API:** `PUT /api/v1/restaurant/orders/{orderId}/reject`

**Request Body:**
```json
{
  "reason": "OUT_OF_STOCK"
}
```

**Implementation:**

```java
public void rejectOrder(UUID orderId, String reason) {
    Order order = orderRepository.findById(orderId)
        .orElseThrow(() -> new OrderNotFoundException());
    
    if (order.getStatus() != OrderStatus.PENDING) {
        throw new InvalidOrderStateException("Can only reject PENDING orders");
    }
    
    order.setStatus(OrderStatus.CANCELLED);
    order.setCancelledAt(Instant.now());
    order.setCancelledBy("RESTAURANT");
    order.setCancellationReason(reason);
    orderRepository.save(order);
    
    // Calculate refund amount (full refund if restaurant rejects)
    double refundAmount = (order.getPaymentStatus() == PaymentStatus.PAID) 
        ? order.getTotalAmount() 
        : 0.00;
    
    // Publish cancellation event
    OrderCancelledEvent event = OrderCancelledEvent.builder()
        .orderId(order.getId())
        .cancelledBy("RESTAURANT")
        .reason(reason)
        .refundAmount(refundAmount)
        .cancelledAt(Instant.now())
        .build();
    
    kafkaTemplate.send("order.cancelled", order.getId().toString(), event);
}
```

### Auto-Rejection (2-Minute Timeout)

```java
@Component
public class OrderAcceptanceTimeoutJob {
    
    @Scheduled(fixedDelay = 30000)  // Every 30 seconds
    public void checkPendingOrders() {
        Instant cutoff = Instant.now().minus(2, ChronoUnit.MINUTES);
        
        List<Order> timedOutOrders = orderRepository.findByStatusAndCreatedAtBefore(
            OrderStatus.PENDING, cutoff
        );
        
        for (Order order : timedOutOrders) {
            log.warn("Restaurant did not accept order within 2 minutes: {}", order.getOrderNumber());
            rejectOrder(order.getId(), "RESTAURANT_TIMEOUT");
        }
    }
}
```

### Refund Processing

**Payment Service consumes order.cancelled:**

```java
@KafkaListener(topics = "order.cancelled", groupId = "payment-service")
public void handleOrderCancelled(OrderCancelledEvent event) {
    if (event.getRefundAmount() == 0.00) {
        log.info("No refund needed for cancelled order: {}", event.getOrderId());
        return;
    }
    
    Payment payment = paymentRepository.findByOrderId(event.getOrderId())
        .orElseThrow(() -> new PaymentNotFoundException());
    
    if (payment.getStatus() != PaymentStatus.CAPTURED) {
        log.warn("Cannot refund payment that was not captured: {}", payment.getId());
        return;
    }
    
    try {
        // Call Razorpay refund API
        JSONObject refundRequest = new JSONObject();
        refundRequest.put("amount", (int)(event.getRefundAmount() * 100));  // Paise
        refundRequest.put("speed", "optimum");  // 5-7 business days
        refundRequest.put("notes", Map.of(
            "reason", event.getReason(),
            "orderId", event.getOrderId()
        ));
        
        Refund refund = razorpayClient.Payments.refund(
            payment.getRazorpayPaymentId(),
            refundRequest
        );
        
        payment.setRefundId(refund.get("id"));
        payment.setRefundAmount(event.getRefundAmount());
        payment.setRefundStatus(RefundStatus.INITIATED);
        paymentRepository.save(payment);
        
        log.info("Refund initiated: {} for order: {}", refund.get("id"), event.getOrderId());
        
    } catch (RazorpayException e) {
        log.error("Refund failed for order: {}", event.getOrderId(), e);
        // TODO: Send alert to admin, manual intervention needed
    }
}
```

---

## Order Cancellation by Customer

**Cancellation Window:** Before order status reaches `PICKED_UP`

**Cancellation Fee Logic:**

| Order Status | Cancellation Fee | Refund Amount |
|--------------|------------------|---------------|
| PENDING | ₹0 | 100% |
| CONFIRMED | ₹0 | 100% |
| PREPARING | ₹50 | Total - ₹50 |
| READY_FOR_PICKUP | ₹100 | Total - ₹100 |
| PICKED_UP onwards | **Not allowed** | N/A |

### Implementation

```java
public CancellationResult cancelOrder(UUID orderId, UUID userId, String reason) {
    Order order = orderRepository.findById(orderId)
        .orElseThrow(() -> new OrderNotFoundException());
    
    // Verify ownership
    if (!order.getUserId().equals(userId)) {
        throw new UnauthorizedException("Cannot cancel another user's order");
    }
    
    // Check if cancellation allowed
    if (order.getStatus().ordinal() >= OrderStatus.PICKED_UP.ordinal()) {
        throw new OrderCannotBeCancelledException(
            "Order cannot be cancelled after pickup"
        );
    }
    
    // Calculate cancellation fee
    double cancellationFee = switch (order.getStatus()) {
        case PENDING, CONFIRMED -> 0.00;
        case PREPARING -> 50.00;
        case READY_FOR_PICKUP -> 100.00;
        default -> throw new IllegalStateException();
    };
    
    double refundAmount = order.getTotalAmount() - cancellationFee;
    
    // Update order
    order.setStatus(OrderStatus.CANCELLED);
    order.setCancelledAt(Instant.now());
    order.setCancelledBy("USER");
    order.setCancellationReason(reason);
    orderRepository.save(order);
    
    // Publish event
    OrderCancelledEvent event = OrderCancelledEvent.builder()
        .orderId(order.getId())
        .cancelledBy("USER")
        .cancelledById(userId)
        .reason(reason)
        .refundAmount(refundAmount)
        .cancellationFee(cancellationFee)
        .cancelledAt(Instant.now())
        .build();
    
    kafkaTemplate.send("order.cancelled", order.getId().toString(), event);
    
    return CancellationResult.builder()
        .cancellationFee(cancellationFee)
        .refundAmount(refundAmount)
        .estimatedRefundDays(7)
        .build();
}
```

---

## Delivery Partner Assignment

**See detailed algorithm in DOCUMENTATION.md Section 3.7**

Key Kafka Events:

1. **Trigger:** `order.status.updated` with `newStatus=READY_FOR_PICKUP`
2. **Delivery Service consumes:**
   - Query nearest 3 available partners
   - Send FCM push notifications
3. **Partner accepts:**
   - Update order: `delivery_partner_id`
   - Update partner: `is_available=false`
   - Publish: `delivery.assigned`
4. **Notification Service consumes `delivery.assigned`:**
   - Notify customer: "Vijay is delivering your order!"
   - Notify other 2 partners: "Order already assigned"

---

## Consumer Error Handling

### Retry Strategy

**Configuration:**

```yaml
spring:
  kafka:
    listener:
      ack-mode: manual
      retry:
        max-attempts: 3
        backoff:
          initial-interval: 1000  # 1 second
          multiplier: 2  # Exponential: 1s, 2s, 4s
          max-interval: 8000  # Cap at 8 seconds
```

**Implementation:**

```java
@KafkaListener(topics = "order.created", groupId = "notification-service")
public void handleOrderCreated(
        OrderCreatedEvent event,
        Acknowledgment acknowledgment,
        @Header(KafkaHeaders.RECEIVED_TOPIC) String topic,
        @Header(KafkaHeaders.OFFSET) long offset) {
    
    String messageId = topic + ":" + offset;
    
    // Idempotency check
    if (redisTemplate.hasKey("processed:" + messageId)) {
        log.info("Message already processed, skipping: {}", messageId);
        acknowledgment.acknowledge();
        return;
    }
    
    try {
        // Process message
        sendNotifications(event);
        
        // Mark as processed (24h TTL)
        redisTemplate.opsForValue().set(
            "processed:" + messageId,
            "true",
            24,
            TimeUnit.HOURS
        );
        
        // Commit offset
        acknowledgment.acknowledge();
        
        log.info("Successfully processed: {}", messageId);
        
    } catch (Exception e) {
        log.error("Error processing message: {}", messageId, e);
        // Don't acknowledge, let Kafka retry
        throw e;  // Trigger retry
    }
}
```

### Dead Letter Queue (DLQ)

**After 3 failed attempts, send to DLQ:**

```java
@Bean
public ConcurrentKafkaListenerContainerFactory<String, Object> kafkaListenerContainerFactory() {
    ConcurrentKafkaListenerContainerFactory<String, Object> factory = 
        new ConcurrentKafkaListenerContainerFactory<>();
    
    factory.setConsumerFactory(consumerFactory());
    
    // Error handler with DLQ
    DeadLetterPublishingRecoverer recoverer = new DeadLetterPublishingRecoverer(
        kafkaTemplate(),
        (record, ex) -> new TopicPartition(record.topic() + ".dlq", record.partition())
    );
    
    DefaultErrorHandler errorHandler = new DefaultErrorHandler(
        recoverer,
        new FixedBackOff(1000L, 3L)  // 3 retries with 1s interval
    );
    
    factory.setCommonErrorHandler(errorHandler);
    
    return factory;
}
```

### Monitoring DLQ

**Kafka UI or CLI:**

```bash
# Check DLQ messages
kafka-console-consumer --bootstrap-server localhost:9092 \
  --topic order.created.dlq \
  --from-beginning

# Count messages in DLQ
kafka-run-class kafka.tools.GetOffsetShell \
  --broker-list localhost:9092 \
  --topic order.created.dlq
```

**Grafana Alert:**

```yaml
alert: DLQ Messages Growing
expr: kafka_log_log_size{topic=~".*\.dlq"} > 10
for: 5m
labels:
  severity: critical
annotations:
  summary: "DLQ has {{ $value }} messages, manual intervention needed"
```

### Manual Replay from DLQ

```java
@RestController
@RequestMapping("/api/v1/admin/kafka")
public class KafkaAdminController {
    
    @PostMapping("/replay-dlq/{topic}")
    public ResponseEntity<ReplayResult> replayDLQ(
            @PathVariable String topic,
            @RequestParam(required = false) Long fromOffset,
            @RequestParam(required = false) Long toOffset) {
        
        String dlqTopic = topic + ".dlq";
        String originalTopic = topic;
        
        Consumer<String, String> consumer = createConsumer(dlqTopic);
        
        if (fromOffset != null && toOffset != null) {
            consumer.seek(new TopicPartition(dlqTopic, 0), fromOffset);
        }
        
        int replayedCount = 0;
        ConsumerRecords<String, String> records = consumer.poll(Duration.ofSeconds(10));
        
        for (ConsumerRecord<String, String> record : records) {
            if (toOffset != null && record.offset() > toOffset) break;
            
            // Republish to original topic
            kafkaTemplate.send(originalTopic, record.key(), record.value());
            replayedCount++;
        }
        
        consumer.close();
        
        return ResponseEntity.ok(ReplayResult.builder()
            .topic(dlqTopic)
            .replayedMessages(replayedCount)
            .build());
    }
}
```

---

## Monitoring & Alerting

### Key Metrics to Monitor

| Metric | PromQL Query | Alert Threshold |
|--------|--------------|----------------|
| Consumer Lag | `kafka_consumer_group_lag` | > 1000 messages |
| Messages/sec | `rate(kafka_messages_consumed_total[1m])` | < 10 (too slow) |
| Error Rate | `rate(kafka_consumer_errors_total[5m])` | > 1% |
| DLQ Size | `kafka_log_log_size{topic=~".*\.dlq"}` | > 10 messages |
| Avg Processing Time | `kafka_consumer_processing_duration_seconds_sum / kafka_consumer_processing_duration_seconds_count` | > 5 seconds |

### Grafana Dashboard Panels

1. **Consumer Lag by Topic** (Graph)
2. **Messages Consumed/Produced** (Counter)
3. **Error Rate** (Gauge with red/yellow/green)
4. **DLQ Message Count** (Bar chart)
5. **Processing Time p95** (Heatmap)

---

**END OF KAFKA FLOWS DOCUMENTATION**