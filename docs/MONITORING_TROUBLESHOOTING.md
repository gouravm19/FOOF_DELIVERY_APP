# 📊 Monitoring, Troubleshooting & Performance

## 13. Monitoring & Observability

### 13.1 Prometheus Metrics

**Access:** http://localhost:9090

#### Key Metrics

**Request Rate (RED Method):**
```promql
# Requests per second
rate(http_server_requests_seconds_count[5m])

# By endpoint
sum by (uri) (rate(http_server_requests_seconds_count[5m]))
```

**Error Rate:**
```promql
# Percentage of 5xx errors
sum(rate(http_server_requests_seconds_count{status=~"5.."}[5m])) / 
sum(rate(http_server_requests_seconds_count[5m])) * 100
```

**Latency (p95):**
```promql
histogram_quantile(0.95, 
  sum(rate(http_server_requests_seconds_bucket[5m])) by (le, uri)
)
```

**Kafka Consumer Lag:**
```promql
kafka_consumer_group_lag{group="notification-service", topic="order.created"}
```

**Database Connections:**
```promql
# Active connections
hikaricp_connections_active{pool="fooddeliveryHikariCP"}

# Idle connections
hikaricp_connections_idle{pool="fooddeliveryHikariCP"}

# Connection timeout
rate(hikaricp_connections_timeout_total[5m])
```

**JVM Metrics:**
```promql
# Heap memory used
jvm_memory_used_bytes{area="heap"}

# GC pause time
rate(jvm_gc_pause_seconds_sum[5m])

# Thread count
jvm_threads_live_threads
```

---

### 13.2 Grafana Dashboards

**Access:** http://localhost:3004 (admin/admin)

#### Dashboard 1: Platform Overview

**Panels:**
1. **Total Orders Today** (Stat) - Single number
2. **Orders/min** (Graph) - Time series
3. **Active Users** (Gauge) - Current count
4. **API Success Rate** (Gauge) - Percentage with red/yellow/green zones
5. **Average Response Time** (Graph) - p50, p95, p99 lines
6. **Error Rate by Service** (Bar chart) - Horizontal bars
7. **Top 5 Slow Endpoints** (Table) - URL + p95 latency

#### Dashboard 2: Service Health

**Row per service (User, Restaurant, Order, Payment, Delivery):**
- Request rate
- Error rate
- p95 latency
- Instance count (if scaled)

#### Dashboard 3: Kafka Monitoring

**Panels:**
1. **Consumer Lag by Topic** (Graph) - Stacked area chart
2. **Messages Produced/sec** (Graph) - Per topic
3. **Messages Consumed/sec** (Graph) - Per consumer group
4. **DLQ Message Count** (Stat) - Alert if > 0

#### Dashboard 4: Database Performance

**PostgreSQL:**
- Active connections
- Connection pool utilization
- Slow queries (> 1s)
- Deadlocks

**MongoDB:**
- Operations/sec (insert, query, update)
- Avg query time
- Connection count

**Redis:**
- Memory usage
- Connected clients
- Commands/sec

---

### 13.3 Distributed Tracing (Zipkin)

**Access:** http://localhost:9411

#### How to Trace an Order

1. Open Zipkin UI
2. Search by:
   - **serviceName**: `order-service`
   - **Tags**: `orderId=550e8400-e29b-41d4-a716-446655440000`
   - **Min Duration**: 500ms (to find slow traces)
3. Click trace to see waterfall:

```
order-service: POST /api/v1/orders (1.2s)
  ├─ restaurant-service: GET /restaurants/{id} (150ms)
  ├─ user-service: GET /users/{id} (80ms)
  ├─ payment-service: POST /payments/create-order (200ms)
  │   └─ Razorpay API (180ms)
  └─ Kafka publish: order.created (10ms)
```

**Finding Bottlenecks:**
- Longest span = bottleneck
- If `restaurant-service` takes 2s → optimize that query

---

### 13.4 Structured Logging

**Log Format (JSON):**
```json
{
  "timestamp": "2024-01-15T10:30:00.123Z",
  "level": "INFO",
  "thread": "http-nio-8081-exec-5",
  "logger": "com.gouravmishra.fooddelivery.user.controller.UserController",
  "message": "User profile updated successfully",
  "traceId": "abc123xyz",
  "spanId": "def456",
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "context": {
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0..."
  }
}
```

**Log Levels Used:**
- **ERROR**: Exceptions, payment failures, Kafka consumer errors
- **WARN**: Rate limit exceeded, OTP max attempts, order timeout
- **INFO**: Order placed, payment completed, status updates
- **DEBUG**: Request/response bodies (dev only)
- **TRACE**: SQL queries (dev only)

---

## 14. Troubleshooting Guide

### 14.1 Docker & Infrastructure

#### Problem: Port already in use

**Symptom:**
```
ERROR: for foodflow-postgres Cannot start service postgres: 
Ports are not available: listen tcp 0.0.0.0:5432: bind: address already in use
```

**Diagnosis:**
```bash
# Find process using port 5432
lsof -ti:5432
# Or on Windows:
netstat -ano | findstr :5432
```

**Fix:**
```bash
# Kill process (Mac/Linux)
lsof -ti:5432 | xargs kill -9

# Or change port in docker-compose.yml
ports:
  - "5433:5432"  # Use 5433 externally
```

---

#### Problem: Out of disk space

**Symptom:**
```
ERROR: for foodflow-postgres Cannot create container: 
no space left on device
```

**Diagnosis:**
```bash
docker system df
```

**Fix:**
```bash
# Remove unused images, containers, volumes
docker system prune -a --volumes

# WARNING: This deletes ALL stopped containers and unused volumes
```

---

### 14.2 Kafka Issues

#### Problem: Consumer not receiving messages

**Symptom:** Order placed, but notification not sent

**Diagnosis:**
```bash
# Check if message was published
kafka-console-consumer --bootstrap-server localhost:9092 \
  --topic order.created \
  --from-beginning \
  --max-messages 10

# Check consumer group lag
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --describe \
  --group notification-service
```

**Fix:**

**If lag is growing:**
```yaml
# Increase consumer threads
spring:
  kafka:
    listener:
      concurrency: 5  # Was 3
```

**If consumer crashed:**
```bash
# Restart consumer service
docker-compose restart notification-service

# Check logs
docker-compose logs notification-service | tail -100
```

---

### 14.3 Database Issues

#### Problem: PostgreSQL connection refused

**Symptom:**
```
Caused by: org.postgresql.util.PSQLException: Connection to localhost:5432 refused
```

**Diagnosis:**
```bash
# Check if PostgreSQL is running
docker-compose ps postgres

# Check logs
docker-compose logs postgres | grep "ready to accept connections"
```

**Fix:**
```bash
# Restart PostgreSQL
docker-compose restart postgres

# Wait for ready message (takes ~10 seconds)
docker-compose logs -f postgres
```

---

### 14.4 Authentication Issues

#### Problem: JWT signature invalid

**Symptom:**
```json
{
  "error": "INVALID_TOKEN",
  "message": "JWT signature does not match locally computed signature"
}
```

**Root Cause:** JWT secret changed or multiple services using different secrets

**Fix:**
```yaml
# Ensure all services use SAME secret
jwt:
  secret: ${JWT_SECRET}  # From .env file

# Restart all services after changing
docker-compose restart
```

---

### 14.5 Payment Issues

#### Problem: Razorpay signature mismatch

**Symptom:**
```
PaymentVerificationException: Invalid payment signature
```

**Root Cause:** Using wrong key secret or incorrect HMAC calculation

**Diagnosis:**
```java
log.info("Expected signature: {}", expectedSignature);
log.info("Received signature: {}", razorpaySignature);
log.info("Payload: {}", payload);
```

**Fix:**

1. **Verify key secret:**
   ```bash
   echo $RAZORPAY_KEY_SECRET
   # Should match Dashboard → API Keys
   ```

2. **Check payload order:**
   ```java
   // MUST be in this exact order
   String payload = razorpayOrderId + "|" + razorpayPaymentId;
   ```

3. **Check encoding:**
   ```java
   // Use UTF-8
   HmacUtils.hmacSha256Hex(keySecret.getBytes(StandardCharsets.UTF_8), payload)
   ```

---

### 14.6 Maps & Location

#### Problem: API_KEY_HTTP_REFERRER_BLOCKED

**Symptom:**
```json
{
  "error_message": "This API key is restricted. See API restrictions.",
  "status": "REQUEST_DENIED"
}
```

**Fix:**

1. Google Cloud Console → Credentials
2. Click API key → Edit
3. Application restrictions:
   - Add `http://localhost:3000/*`
   - Add `https://yourdomain.com/*`
4. Save
5. Wait 5 minutes for propagation

---

## 15. Performance Optimizations

### Optimization Summary

| # | What Was Slow | Before | Fix Applied | After | Technique |
|---|---------------|--------|-------------|-------|----------|
| 1 | Restaurant list | 800ms | MongoDB 2dsphere index | 45ms | Geospatial index |
| 2 | Menu page load | 600ms | Redis caching 5min TTL | 90ms | Cache-aside |
| 3 | Search results | 400ms | Elasticsearch | 80ms | Inverted index |
| 4 | Cart add item | 150ms | Redis hash | 2ms | In-memory |
| 5 | Order status | 2s | Kafka + WebSocket | 200ms | Event-driven |
| 6 | OTP verification | 80ms | Redis lookup | 1ms | Cache |
| 7 | Auth token check | 50ms | Stateless JWT | 0ms | Stateless |
| 8 | Delivery ETA | 500ms | Redis cache 5min | 2ms | Cache |
| 9 | Image load | 3s | CDN + WebP | 500ms | CDN + compression |
| 10 | DB queries | 200ms | Connection pool + indexes | 20ms | HikariCP + B-tree |

### Connection Pool Settings

**HikariCP (PostgreSQL):**
```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000  # 30s
      idle-timeout: 600000  # 10min
      max-lifetime: 1800000  # 30min
```

**Why these numbers:**
- `maximum-pool-size: 20` → Enough for 100 concurrent requests (5 per connection)
- `minimum-idle: 5` → Avoid creating connections on every request
- `max-lifetime: 30min` → Prevents stale connections

**MongoDB Connection Pool:**
```yaml
spring:
  data:
    mongodb:
      uri: mongodb://localhost:27017/fooddelivery?maxPoolSize=100&minPoolSize=10
```

---

## 16. Known Limitations & Roadmap

### Current Limitations

| # | Limitation | Business Impact | Technical Reason | Phase 2 Fix |
|---|------------|-----------------|------------------|-------------|
| 1 | Single city only (Pune) | Can't expand to other cities | Hardcoded geospatial queries | Multi-city support with city selector |
| 2 | No in-app chat | Customer can't chat with partner | WebSocket only used for tracking | Socket.io rooms for 1-on-1 chat |
| 3 | No table booking | Restaurants lose dine-in revenue | Out of initial scope | Integrate reservation system |
| 4 | No group ordering | Friends can't split bill | Complex cart sharing logic | Shared cart with payment split |
| 5 | No scheduled orders | Can't order for later | Order created = immediate | Add `scheduledFor` field |
| 6 | No restaurant analytics export | Owners can't analyze data offline | No export feature | CSV/PDF export |
| 7 | No loyalty program | No repeat customer incentive | Complex points system | Loyalty points + tiers |
| 8 | No voice ordering | Accessibility issue | No speech-to-text | Integrate Google Speech API |

### Phase 2 Features (Next 3 Months)

1. **In-App Chat** (2 weeks)
   - Socket.io rooms
   - Message history (MongoDB)
   - Push notifications on new message

2. **Multi-City Support** (3 weeks)
   - City selector on homepage
   - Geo-partitioned databases
   - City-specific coupons

3. **AI Recommendations** (4 weeks)
   - "You might also like" on restaurant page
   - Personalized homepage feed
   - Based on order history + collaborative filtering

4. **Subscription Plans** (3 weeks)
   - "FoodFlow Plus": ₹199/month
   - Benefits: Free delivery, 10% off all orders
   - Razorpay subscription API

### Phase 3 Features (6+ Months)

- **Machine Learning Fraud Detection**
- **Dynamic Surge Pricing**
- **Drone Delivery Integration**
- **AR Menu Viewing**
- **Carbon Footprint Tracking**

---

**END OF MONITORING & TROUBLESHOOTING**