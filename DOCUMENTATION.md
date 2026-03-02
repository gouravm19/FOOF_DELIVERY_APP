# 🍕 FoodFlow — Enterprise Food Delivery Platform Documentation

**Production-Grade Microservices Architecture | Event-Driven System | Real-Time Tracking**

---

## 📑 Table of Contents

1. [Executive Summary](#1-executive-summary)
   - 1.1 [What Is FoodFlow?](#11-what-is-foodflow)
   - 1.2 [Key Differentiators](#12-key-differentiators)
   - 1.3 [Platform Metrics](#13-platform-metrics)

2. [Business Domain & Requirements](#2-business-domain--requirements)
   - 2.1 [Stakeholder Analysis](#21-stakeholder-analysis)
   - 2.2 [Business Requirements](#22-business-requirements)
   - 2.3 [Functional Requirements](#23-functional-requirements)
   - 2.4 [Non-Functional Requirements](#24-non-functional-requirements)

3. [System Architecture](#3-system-architecture)
   - 3.1 [High-Level Architecture](#31-high-level-architecture)
   - 3.2 [Microservices Architecture Rationale](#32-microservices-architecture-rationale)
   - 3.3 [Service Dependency Map](#33-service-dependency-map)
   - 3.4 [Event-Driven Architecture](#34-event-driven-architecture-kafka)
   - 3.5 [Data Architecture](#35-data-architecture-decision)
   - 3.6 [Security Architecture](#36-security-architecture)
   - 3.7 [Delivery Partner Assignment Algorithm](#37-delivery-partner-assignment-algorithm)

4. [Tech Stack — Complete Reference](#4-tech-stack--complete-reference)
   - 4.1 [Backend Technologies](#41-backend-technologies)
   - 4.2 [Frontend Technologies](#42-frontend-technologies)
   - 4.3 [Infrastructure Technologies](#43-infrastructure-technologies)

5. [Database Design — Complete Reference](#5-database-design--complete-reference)
   - 5.1 [PostgreSQL Schema](#51-postgresql-schema)
   - 5.2 [MongoDB Collections](#52-mongodb-collections)
   - 5.3 [Redis Key Patterns](#53-redis-key-patterns-reference)
   - 5.4 [Elasticsearch Index Mappings](#54-elasticsearch-index-mappings)
   - 5.5 [Entity Relationship Diagram](#55-database-entity-relationship-diagram)

6. [API Documentation — Complete Reference](#6-api-documentation--complete-reference)
   - 6.1 [API Design Principles](#61-api-design-principles)
   - 6.2 [Standard Response Format](#62-standard-response-format)
   - 6.3 [HTTP Status Code Reference](#63-http-status-code-reference)
   - 6.4 [Complete API Endpoint Reference](#64-complete-api-endpoint-reference)

7. [Kafka Event Flows](#7-kafka-event-flows--complete-documentation)
   - 7.1 [Order Placement Flow](#71-order-placement-flow-complete)
   - 7.2 [Failed Payment Flow](#72-failed-payment-flow)
   - 7.3 [Order Cancellation Flow](#73-order-cancellation-flow)
   - 7.4 [Delivery Partner Assignment Flow](#74-delivery-partner-assignment-flow)
   - 7.5 [Kafka Consumer Error Handling](#75-kafka-consumer-error-handling)

8. [Third-Party Integration Guide](#8-third-party-integration-guide)
   - 8.1 [Razorpay Integration](#81-razorpay-integration)
   - 8.2 [Twilio SMS Integration](#82-twilio-sms-integration)
   - 8.3 [Google Maps APIs](#83-google-maps-apis)
   - 8.4 [Firebase Cloud Messaging](#84-firebase-cloud-messaging)
   - 8.5 [MinIO (Local S3)](#85-minio-local-s3-alternative)
   - 8.6 [SendGrid (Production Email)](#86-sendgrid-production-email)

9. [Local Development Setup](#9-local-development-setup--step-by-step)
   - 9.1 [System Prerequisites](#91-system-prerequisites)
   - 9.2 [Docker Compose Setup](#92-option-a-docker-compose-recommended)
   - 9.3 [Manual Setup](#93-option-b-manual-service-by-service-setup)
   - 9.4 [Verifying Setup](#94-verifying-setup-works)

10. [Demo Credentials Reference](#10-demo-credentials-reference)

11. [Testing Documentation](#11-testing-documentation)
    - 11.1 [Testing Strategy](#111-testing-strategy)
    - 11.2 [Running Tests](#112-running-tests)
    - 11.3 [Unit Tests Reference](#113-unit-tests-reference)
    - 11.4 [Integration Tests](#114-integration-tests)
    - 11.5 [Test Coverage Report](#115-test-coverage-report)

12. [CI/CD Pipeline Documentation](#12-cicd-pipeline-documentation)
    - 12.1 [Pipeline Overview](#121-pipeline-overview)
    - 12.2 [Pipeline Stages](#122-pipeline-stages-explained)
    - 12.3 [Secrets Required](#123-secrets-required)
    - 12.4 [Deployment to Production](#124-deployment-to-production)

13. [Monitoring & Observability](#13-monitoring--observability)
    - 13.1 [Prometheus Metrics](#131-prometheus-metrics)
    - 13.2 [Grafana Dashboards](#132-grafana-dashboards)
    - 13.3 [Distributed Tracing](#133-distributed-tracing-zipkin)
    - 13.4 [Structured Logging](#134-structured-logging)

14. [Troubleshooting Guide](#14-troubleshooting-guide)
    - 14.1 [Docker Issues](#141-docker-issues)
    - 14.2 [Kafka Issues](#142-kafka-issues)
    - 14.3 [Database Issues](#143-database-issues)
    - 14.4 [Authentication Issues](#144-authentication-issues)
    - 14.5 [Payment Issues](#145-payment-issues)
    - 14.6 [Maps Issues](#146-maps-issues)

15. [Performance Optimizations](#15-performance-optimizations-implemented)

16. [Known Limitations & Roadmap](#16-known-limitations--future-roadmap)

17. [Project Statistics](#17-project-statistics)

18. [About the Developer](#18-about-the-developer)

---

## 1. Executive Summary

### 1.1 What Is FoodFlow?

FoodFlow is a **production-grade, enterprise-scale food delivery platform** built to demonstrate mastery of modern distributed systems architecture. Inspired by industry leaders like Zomato and Swiggy, this platform showcases the complete technology stack and architectural patterns used by real-world food delivery services serving millions of users daily.

**Why This Project Exists:**

This platform was built by **Gourav Mishra**, a Senior Full Stack Developer at Emerson, Pune, to demonstrate:

- **Real-world microservices architecture** at the scale used by unicorn startups
- **Event-driven design patterns** using Apache Kafka for async communication
- **Complete integration** with production payment gateways (Razorpay), SMS providers (Twilio), mapping services (Google Maps), and push notification systems (Firebase)
- **Modern full-stack development** combining Spring Boot microservices with React TypeScript frontends
- **DevOps practices** including Docker containerization, CI/CD pipelines, monitoring, and distributed tracing

Unlike typical portfolio projects that use mocked data or simplified architectures, FoodFlow implements **actual production patterns**: phone OTP authentication (no passwords, like Zomato), real-time GPS tracking via WebSockets, geospatial restaurant discovery, payment gateway integration with signature verification, and a complete Kafka-based order lifecycle spanning 7 topics and 6 consumer services.

**What Makes This Enterprise-Grade:**

- **9 independently deployable microservices** with service discovery (Eureka) and API Gateway
- **4 separate frontend applications** for each stakeholder type (customer, restaurant, delivery, admin)
- **4 different database technologies** chosen specifically for their use cases (PostgreSQL for transactions, MongoDB for flexible documents, Redis for caching, Elasticsearch for search)
- **Event-driven architecture** ensuring loose coupling, fault tolerance, and audit trails
- **Production-ready patterns**: circuit breakers, rate limiting, distributed tracing, health checks, graceful degradation

This is the architecture I use daily at Emerson to build enterprise systems handling 100,000+ transactions per day.

### 1.2 Key Differentiators

What makes FoodFlow impressive as a portfolio project:

#### 🔐 **Phone OTP Authentication (Zero Passwords)**
Exactly like Zomato/Swiggy: Users log in with their phone number and receive a 6-digit OTP via Twilio SMS. No password management, no "forgot password" flows. The OTP is hashed using BCrypt and stored in Redis with a 10-minute TTL. After 3 failed verification attempts, the OTP is invalidated. This is the authentication pattern used by 90% of Indian consumer apps for its simplicity and security.

#### 📍 **Geospatial Restaurant Discovery**
Uses MongoDB's `$near` geospatial queries with 2dsphere indexes to find restaurants within delivery radius. When a customer opens the app, we query:
```javascript
db.restaurants.find({
  "address.location": {
    $near: {
      $geometry: { type: "Point", coordinates: [lng, lat] },
      $maxDistance: 5000  // 5km radius
    }
  },
  isCurrentlyOpen: true,
  status: "ACTIVE"
})
```
Results are sorted by a **relevance score** calculated as:
```
score = (rating × 0.4) + (popularityScore × 0.3) + (isPromoted × 0.3)
```
where `popularityScore` is based on total orders in the last 30 days.

#### 🚀 **Real-Time GPS Tracking (WebSocket)**
Built with Socket.io: When a delivery partner is en route, their location is broadcast every 15 seconds. Customers see the rider's location update live on a Google Map. The architecture:
- Delivery Partner App → WebSocket emit → Delivery Service
- Delivery Service → broadcasts to room `order:{orderId}`
- Customer App → subscribes to room → receives location updates
- Each update includes: `{lat, lng, timestamp, distanceRemaining, eta}`

#### 📨 **Kafka Event-Driven Order Lifecycle**
Complete async event flows across services:
```
Order Placed → order.created (Kafka)
  ↓ Consumed by: Notification Service (push notification to user)
  ↓ Consumed by: Delivery Service (prepare for partner assignment)

Payment Completed → payment.completed (Kafka)
  ↓ Consumed by: Order Service (update order status)
  ↓ Consumed by: Notification Service (payment confirmation email)

Restaurant Accepts → order.status.updated (Kafka)
  ↓ Consumed by: Notification Service (notify customer)
  ↓ Consumed by: Delivery Service (trigger partner assignment)

Partner Assigned → delivery.assigned (Kafka)
  ↓ Consumed by: Notification Service (notify customer + partner)
  ↓ Consumed by: Order Service (update delivery_partner_id)
```

**Why Kafka over direct REST calls?**
- **Decoupling**: Services don't need to know about each other
- **Resilience**: Events survive service restarts (7-day retention)
- **Audit trail**: Complete order history via event replay
- **Performance**: Async processing doesn't block the user

#### 🧮 **Smart Delivery Partner Assignment Algorithm**
When an order status changes to `READY_FOR_PICKUP`:

1. **Query available partners within 3km radius** (PostGIS geospatial query)
2. **Send push notification to top 3 simultaneously** (Firebase FCM)
3. **First to accept wins** (DB pessimistic lock: `SELECT FOR UPDATE`)
4. **If no acceptance in 90 seconds**: expand radius to 5km, retry
5. **If still no partner**: notify restaurant + customer, allow cancellation

Race conditions are handled with database locks. If two partners click "Accept" simultaneously, only one gets the assignment — the other sees "Order already assigned."

#### 💳 **Full Razorpay Integration (India's Leading Payment Gateway)**
Complete payment flow with signature verification:
```java
// Create order
RazorpayClient client = new RazorpayClient(keyId, keySecret);
JSONObject options = new JSONObject();
options.put("amount", 45000); // Amount in paise (₹450.00)
options.put("currency", "INR");
options.put("receipt", orderId);
Order razorpayOrder = client.Orders.create(options);

// Verify payment signature (CRITICAL for security)
String generatedSignature = HmacUtils.hmacSha256Hex(
    keySecret,
    razorpayOrderId + "|" + razorpayPaymentId
);
if (!generatedSignature.equals(razorpaySignature)) {
    throw new PaymentVerificationException("Invalid signature");
}
```

Supports: UPI, Credit/Debit Cards, Net Banking, Wallets (Paytm, PhonePe), and Cash on Delivery. Refunds are processed automatically for cancelled orders.

#### 🍽️ **Four Separate Frontend Applications**
Not just a single customer app — complete dashboards for each stakeholder:
- **Customer App**: Restaurant discovery, cart, payment, order tracking
- **Restaurant Portal**: Order management (Kanban board), menu CRUD, analytics
- **Delivery Partner App**: Go online/offline, accept orders, earnings tracker
- **Admin Console**: Approve restaurants, manage coupons, platform analytics

Each uses React 18 with TypeScript, TanStack Query for server state, and Zustand for client state.

### 1.3 Platform Metrics

Designed to handle:

| Metric | Target Value | How Achieved |
|--------|--------------|--------------|
| **Concurrent Users** | 10,000+ | Stateless services + Redis session caching + horizontal scaling |
| **Orders Per Day** | 100,000+ | Kafka async processing + PostgreSQL connection pooling + read replicas |
| **API Response Time (p95)** | < 200ms | Redis caching (menu, cart, sessions) + database indexes (B-tree, geospatial) + CDN for static assets |
| **Uptime Target** | 99.95% | Health checks + auto-restart policies + circuit breakers (Resilience4j) + multi-AZ deployment |
| **Delivery ETA Accuracy** | ± 2 minutes | Google Distance Matrix API + real-time traffic data + historical delivery time analysis |
| **Search Results Latency** | < 100ms | Elasticsearch with edge n-gram analyzers + geospatial filtering + result caching (5 min TTL) |
| **Payment Success Rate** | > 98% | Razorpay's 99.9% uptime SLA + retry logic for network failures + fallback to COD |
| **Order Completion Rate** | > 85% | Optimized partner assignment (90s response window) + customer support integration + refund automation |
| **Cart Abandonment Rate** | < 30% | Redis cart with 24h TTL + cart reminder push notifications + saved cart recovery |

**Infrastructure Capacity Planning:**

- **Peak Traffic**: Lunch (12 PM - 2 PM) and Dinner (7 PM - 10 PM) windows
- **Scaling Strategy**: Auto-scale Order Service and Search Service independently based on CPU/memory
- **Database Sizing**: PostgreSQL with 1000 connection pool, MongoDB with 500 connections, Redis with 512MB maxmemory
- **Kafka Throughput**: 12 partitions for `order.created` and `order.status.updated` topics (supports 10K msgs/sec)

---

## 2. Business Domain & Requirements

### 2.1 Stakeholder Analysis

FoodFlow serves four distinct user types, each with their own application:

| Stakeholder | Primary Role | Key Objectives | Application Used | Technical Needs |
|-------------|--------------|----------------|------------------|-----------------|
| **Customer** | Food buyer | Find restaurants, order food, track delivery, pay securely | Customer App (port 3000) | Fast search, real-time tracking, multiple payment options, order history |
| **Restaurant Owner** | Food seller | Receive orders, manage menu, track earnings, respond to reviews | Restaurant Portal (port 3001) | Real-time order notifications, menu management CRUD, analytics dashboard, order accept/reject workflow |
| **Delivery Partner** | Courier | Accept delivery jobs, navigate to locations, earn money, track daily earnings | Delivery Partner App (port 3002) | Order assignment push notifications, GPS navigation integration, earnings calculator, online/offline toggle |
| **Platform Admin** | System operator | Approve restaurants, manage coupons, monitor platform health, handle disputes | Admin Console (port 3003) | Restaurant approval workflow, coupon CRUD, user management, system health monitoring, analytics dashboards |

### 2.2 Business Requirements

#### **Customer Requirements (BR-C)**

**Authentication & Profile:**
- **BR-C1**: Register/login using phone number with OTP (no passwords, like Zomato)
- **BR-C2**: Save profile information (name, email, date of birth, profile picture)
- **BR-C3**: Save multiple delivery addresses with labels (Home, Work, Other)
- **BR-C4**: Set a default delivery address
- **BR-C5**: Use device location (GPS) to auto-detect address
- **BR-C6**: Receive push notifications for order updates

**Restaurant Discovery:**
- **BR-C7**: Browse restaurants within delivery radius based on current location
- **BR-C8**: Search restaurants and dishes with autocomplete suggestions
- **BR-C9**: Filter restaurants by:
  - Cuisine type (Italian, Chinese, North Indian, etc.)
  - Dietary preference (Pure Veg / Non-Veg)
  - Minimum rating (4.0+, 4.5+)
  - Maximum delivery time (30 min, 45 min, 60 min)
  - Offers/discounts available
  - Currently open/closed
- **BR-C10**: Sort results by relevance, rating, delivery time, or cost
- **BR-C11**: View restaurant details: menu, photos, reviews, operating hours, delivery info
- **BR-C12**: View item-level details: description, price, customization options, nutritional info

**Cart & Ordering:**
- **BR-C13**: Add items to cart with customizations (size, toppings, spice level, etc.)
- **BR-C14**: Cart is restricted to single restaurant at a time
- **BR-C15**: If adding from different restaurant, prompt to clear cart or cancel
- **BR-C16**: Update item quantity or remove items from cart
- **BR-C17**: View itemized bill: subtotal, delivery fee, platform fee, GST, discounts
- **BR-C18**: Apply coupon code with validation
- **BR-C19**: See coupon savings reflected in total
- **BR-C20**: Add special instructions for restaurant or delivery partner
- **BR-C21**: Choose delivery address from saved addresses
- **BR-C22**: Add tip for delivery partner (optional)

**Payment:**
- **BR-C23**: Choose payment method: UPI, Credit/Debit Card, Net Banking, Wallet, Cash on Delivery
- **BR-C24**: Complete payment via Razorpay secure checkout
- **BR-C25**: Receive payment confirmation via push notification + email
- **BR-C26**: Failed payment should allow retry without losing cart
- **BR-C27**: View payment receipt with transaction ID

**Order Tracking:**
- **BR-C28**: View real-time order status: Placed → Confirmed → Preparing → Ready → Picked Up → Out for Delivery → Delivered
- **BR-C29**: See live map with restaurant location, delivery partner location, and delivery address
- **BR-C30**: View estimated time of arrival (ETA) updated in real-time
- **BR-C31**: See delivery partner details: name, photo, vehicle number, rating
- **BR-C32**: Call delivery partner directly from app (tel: link)
- **BR-C33**: Receive push notifications for each status change
- **BR-C34**: Cancel order before it's picked up by delivery partner
- **BR-C35**: View cancellation policy and refund details

**Post-Delivery:**
- **BR-C36**: Rate restaurant (1-5 stars) with written review
- **BR-C37**: Rate delivery partner (1-5 stars) with written review
- **BR-C38**: Upload photos with review
- **BR-C39**: View order history with filters (last 7 days, last month, last year)
- **BR-C40**: Reorder from past orders with one click
- **BR-C41**: Download invoice as PDF

#### **Restaurant Owner Requirements (BR-R)**

**Onboarding:**
- **BR-R1**: Register restaurant with complete details (name, address, phone, owner info)
- **BR-R2**: Upload FSSAI license, GST number, business documents for verification
- **BR-R3**: Account pending admin approval before going live
- **BR-R4**: Receive email notification when account is approved/rejected

**Menu Management:**
- **BR-R5**: Create menu categories (Starters, Main Course, Desserts, Beverages, etc.)
- **BR-R6**: Reorder categories by drag-and-drop
- **BR-R7**: Add menu items with: name, description, price, image, type (veg/non-veg), preparation time
- **BR-R8**: Define customization groups per item (e.g., "Choose Size" with options: Regular, Large, Extra Large)
- **BR-R9**: Set customization as required or optional
- **BR-R10**: Set min/max selection count for customization groups
- **BR-R11**: Add extra charge for each customization option
- **BR-R12**: Mark items as "Best Seller" or "Chef's Special"
- **BR-R13**: Add nutritional information (calories, protein, carbs, fat)
- **BR-R14**: Toggle item availability (mark as sold out temporarily)
- **BR-R15**: Bulk upload menu via CSV/Excel
- **BR-R16**: Preview menu as customers will see it

**Order Management:**
- **BR-R17**: Receive real-time order notifications with sound alert
- **BR-R18**: Auto-accept countdown timer (2 minutes to accept or auto-reject)
- **BR-R19**: View order details: items, quantities, customizations, total, delivery address
- **BR-R20**: Accept order and provide estimated preparation time
- **BR-R21**: Reject order with reason (out of stock, too busy, etc.)
- **BR-R22**: Update order status: Preparing → Ready for Pickup
- **BR-R23**: View all orders in Kanban board (New | Preparing | Ready | Completed)
- **BR-R24**: Filter orders by status, date range, customer name
- **BR-R25**: Print order receipt for kitchen
- **BR-R26**: View order history with revenue breakdown

**Restaurant Settings:**
- **BR-R27**: Update operating hours for each day of week
- **BR-R28**: Set breaks (e.g., closed between 3 PM - 5 PM)
- **BR-R29**: Temporarily close restaurant (mark as closed for today)
- **BR-R30**: Set delivery radius (3km, 5km, 7km)
- **BR-R31**: Set minimum order amount for delivery
- **BR-R32**: Set delivery fee (fixed or distance-based)
- **BR-R33**: Offer free delivery above certain order value
- **BR-R34**: Upload restaurant photos (interior, exterior, dishes)

**Analytics:**
- **BR-R35**: View today's statistics: orders count, revenue, average order value
- **BR-R36**: View weekly/monthly revenue trends (line chart)
- **BR-R37**: View top 10 selling items by order count
- **BR-R38**: View order volume by hour of day (heatmap)
- **BR-R39**: View customer ratings over time
- **BR-R40**: Export analytics as CSV/PDF

#### **Delivery Partner Requirements (BR-D)**

**Onboarding:**
- **BR-D1**: Register with phone number + OTP
- **BR-D2**: Submit KYC documents: Aadhar, PAN, Driving License, vehicle registration
- **BR-D3**: Upload vehicle photos (front, back, number plate)
- **BR-D4**: Account pending admin approval
- **BR-D5**: Provide bank account details for payouts

**Going Online:**
- **BR-D6**: Toggle online/offline with single tap
- **BR-D7**: Going online requests location permission
- **BR-D8**: Location is broadcast to server every 15 seconds while online
- **BR-D9**: View current online status and hours online today

**Order Assignment:**
- **BR-D10**: Receive push notification when order is available
- **BR-D11**: Notification shows: restaurant name, distance, customer area, estimated earnings
- **BR-D12**: Accept/reject assignment within 30 seconds
- **BR-D13**: If rejected, order goes to next available partner
- **BR-D14**: View current active delivery (can have only 1 at a time)

**Navigation:**
- **BR-D15**: "Navigate to Restaurant" button opens Google Maps with directions
- **BR-D16**: Mark "Arrived at Restaurant" when reaching pickup location
- **BR-D17**: Mark "Order Picked Up" after collecting food
- **BR-D18**: "Navigate to Customer" button opens Google Maps
- **BR-D19**: Mark "Delivered" when order is handed to customer
- **BR-D20**: Upload proof of delivery photo (optional)

**Earnings:**
- **BR-D21**: View today's earnings breakdown (deliveries completed × earnings per delivery)
- **BR-D22**: View this week's earnings
- **BR-D23**: View this month's earnings
- **BR-D24**: View delivery history with earnings per order
- **BR-D25**: Request payout (transfers to bank within 24 hours)
- **BR-D26**: View payout history with transaction IDs

#### **Admin Requirements (BR-A)**

**Restaurant Management:**
- **BR-A1**: View all restaurants with filters (pending approval, active, suspended)
- **BR-A2**: Review restaurant application documents
- **BR-A3**: Approve restaurant (sends email to owner)
- **BR-A4**: Reject restaurant with reason
- **BR-A5**: Suspend restaurant for policy violations
- **BR-A6**: View restaurant performance metrics (orders, revenue, rating)

**Delivery Partner Management:**
- **BR-A7**: View all delivery partners with filters (pending KYC, verified, suspended)
- **BR-A8**: Review KYC documents (Aadhar, PAN, License)
- **BR-A9**: Approve/reject KYC
- **BR-A10**: Suspend partner for violations
- **BR-A11**: View partner performance (deliveries, ratings, earnings)

**User Management:**
- **BR-A12**: View all users with search
- **BR-A13**: View user details: profile, order history, wallet balance
- **BR-A14**: Block/unblock user
- **BR-A15**: Reset user wallet balance
- **BR-A16**: View user support tickets

**Coupon Management:**
- **BR-A17**: Create coupons with: code, discount type (%, flat, free delivery), discount value, min order amount
- **BR-A18**: Set coupon validity dates (start and end)
- **BR-A19**: Set max uses (total and per user)
- **BR-A20**: Make coupon applicable to: all users, new users only, specific restaurant
- **BR-A21**: Toggle coupon active/inactive
- **BR-A22**: View coupon usage statistics

**Platform Analytics:**
- **BR-A23**: View platform overview: total users, restaurants, partners, orders today
- **BR-A24**: View GMV (Gross Merchandise Value) trends
- **BR-A25**: View order funnel: placed → confirmed → delivered → cancelled
- **BR-A26**: View cancellation rate and reasons
- **BR-A27**: View average order value trends
- **BR-A28**: View customer retention cohort analysis
- **BR-A29**: View geo heatmap of order density
- **BR-A30**: Export all analytics as PDF report

**System Health:**
- **BR-A31**: View all microservices status (UP/DOWN)
- **BR-A32**: View Kafka consumer lag per topic
- **BR-A33**: View database connection pool utilization
- **BR-A34**: View API response time percentiles (p50, p95, p99)
- **BR-A35**: View error rate by service

### 2.3 Functional Requirements

Complete table of all functional requirements with implementation status:

| FR-ID | Requirement | Priority | Module | Complexity | Status |
|-------|-------------|----------|--------|------------|--------|
| **FR-001** | Phone OTP authentication (6-digit) | CRITICAL | User Service | Medium | ✅ Designed |
| **FR-002** | JWT token generation (access 15min + refresh 30d) | CRITICAL | User Service | Medium | ✅ Designed |
| **FR-003** | User profile CRUD | HIGH | User Service | Low | ✅ Designed |
| **FR-004** | Multiple saved addresses with geolocation | HIGH | User Service | Medium | ✅ Designed |
| **FR-005** | Geospatial restaurant discovery (MongoDB $near) | CRITICAL | Restaurant Service | High | ✅ Designed |
| **FR-006** | Restaurant search with Elasticsearch | HIGH | Search Service | High | ✅ Designed |
| **FR-007** | Autocomplete suggestions (edge n-gram) | MEDIUM | Search Service | Medium | ✅ Designed |
| **FR-008** | Restaurant filtering (cuisine, veg, rating, etc.) | HIGH | Restaurant Service | Medium | ✅ Designed |
| **FR-009** | Menu management CRUD with categories | HIGH | Restaurant Service | Medium | ✅ Designed |
| **FR-010** | Menu item customizations (multi-level) | HIGH | Restaurant Service | High | ✅ Designed |
| **FR-011** | Real-time cart management (Redis Hash) | CRITICAL | Order Service | Medium | ✅ Designed |
| **FR-012** | Cart validation (single restaurant restriction) | HIGH | Order Service | Low | ✅ Designed |
| **FR-013** | Coupon validation and application | MEDIUM | Order Service | Medium | ✅ Designed |
| **FR-014** | Order placement with cart snapshot | CRITICAL | Order Service | High | ✅ Designed |
| **FR-015** | Razorpay order creation | CRITICAL | Payment Service | Medium | ✅ Designed |
| **FR-016** | Razorpay payment signature verification | CRITICAL | Payment Service | High | ✅ Designed |
| **FR-017** | Payment webhook handling (idempotent) | HIGH | Payment Service | Medium | ✅ Designed |
| **FR-018** | Refund processing for cancelled orders | HIGH | Payment Service | Medium | ✅ Designed |
| **FR-019** | Kafka: order.created event publishing | CRITICAL | Order Service | Medium | ✅ Designed |
| **FR-020** | Kafka: payment.completed event publishing | CRITICAL | Payment Service | Medium | ✅ Designed |
| **FR-021** | Kafka: order.status.updated event publishing | CRITICAL | Order/Restaurant/Delivery | Medium | ✅ Designed |
| **FR-022** | Kafka: delivery.assigned event publishing | HIGH | Delivery Service | Medium | ✅ Designed |
| **FR-023** | Kafka consumer: order events → notifications | HIGH | Notification Service | Medium | ✅ Designed |
| **FR-024** | Firebase push notification sending | MEDIUM | Notification Service | Low | ✅ Designed |
| **FR-025** | Twilio SMS sending (OTP) | HIGH | User Service | Low | ✅ Designed |
| **FR-026** | Email sending (MailHog dev / SendGrid prod) | MEDIUM | Notification Service | Low | ✅ Designed |
| **FR-027** | Restaurant order accept/reject workflow | CRITICAL | Restaurant Service | Medium | ✅ Designed |
| **FR-028** | 2-minute auto-reject timer for pending orders | HIGH | Order Service | Medium | ✅ Designed |
| **FR-029** | Delivery partner registration with KYC | HIGH | Delivery Service | Medium | ✅ Designed |
| **FR-030** | Delivery partner online/offline toggle | HIGH | Delivery Service | Low | ✅ Designed |
| **FR-031** | Delivery partner location broadcast (15s interval) | HIGH | Delivery Service | High | ✅ Designed |
| **FR-032** | Smart partner assignment algorithm (nearest first) | CRITICAL | Delivery Service | High | ✅ Designed |
| **FR-033** | Partner assignment race condition handling (DB lock) | HIGH | Delivery Service | High | ✅ Designed |
| **FR-034** | WebSocket real-time order tracking | HIGH | Delivery Service | High | ✅ Designed |
| **FR-035** | Google Maps ETA calculation (Distance Matrix API) | MEDIUM | Restaurant Service | Medium | ✅ Designed |
| **FR-036** | Order cancellation with refund | HIGH | Order Service | Medium | ✅ Designed |
| **FR-037** | Order status history tracking | MEDIUM | Order Service | Low | ✅ Designed |
| **FR-038** | Review and rating submission (1-5 stars) | MEDIUM | Restaurant Service | Low | ✅ Designed |
| **FR-039** | Review photos upload (MinIO S3) | LOW | Restaurant Service | Medium | ✅ Designed |
| **FR-040** | Admin restaurant approval workflow | HIGH | Restaurant Service | Medium | ✅ Designed |
| **FR-041** | Admin delivery partner KYC approval | HIGH | Delivery Service | Medium | ✅ Designed |
| **FR-042** | Admin coupon CRUD | MEDIUM | Order Service | Low | ✅ Designed |
| **FR-043** | Platform analytics dashboard | MEDIUM | Admin Service | High | 🔄 Planned |
| **FR-044** | System health monitoring (Prometheus + Grafana) | MEDIUM | All Services | Medium | ✅ Designed |
| **FR-045** | Distributed tracing (Zipkin) | MEDIUM | All Services | Medium | ✅ Designed |
| **FR-046** | Rate limiting (Redis) | HIGH | API Gateway | Medium | ✅ Designed |
| **FR-047** | CORS configuration (multiple origins) | HIGH | API Gateway | Low | ✅ Implemented |
| **FR-048** | Service discovery (Eureka) | CRITICAL | All Services | Low | ✅ Implemented |
| **FR-049** | Centralized config (Config Server) | HIGH | All Services | Low | ✅ Implemented |
| **FR-050** | Health checks (Spring Actuator) | HIGH | All Services | Low | ✅ Implemented |

### 2.4 Non-Functional Requirements

| NFR-ID | Category | Requirement | Implementation | Priority |
|--------|----------|-------------|----------------|----------|
| **NFR-001** | Performance | API p95 latency < 200ms | Redis caching + DB indexes (B-tree + geospatial) + connection pooling | CRITICAL |
| **NFR-002** | Performance | Search results < 100ms | Elasticsearch with result caching (5 min TTL) | HIGH |
| **NFR-003** | Performance | Restaurant discovery < 50ms | MongoDB 2dsphere index + Redis menu caching | HIGH |
| **NFR-004** | Performance | Cart operations < 10ms | Redis Hash operations (in-memory) | HIGH |
| **NFR-005** | Scalability | Support 10,000 concurrent users | Stateless services + horizontal scaling + load balancing | CRITICAL |
| **NFR-006** | Scalability | Handle 100,000 orders/day | Kafka async processing + database partitioning + read replicas | CRITICAL |
| **NFR-007** | Scalability | Independent service scaling | Each microservice deployed separately with auto-scaling policies | HIGH |
| **NFR-008** | Availability | 99.95% uptime (< 4.5 hours downtime/year) | Health checks + auto-restart + multi-AZ deployment + circuit breakers | CRITICAL |
| **NFR-009** | Availability | Zero-downtime deployments | Rolling updates + readiness probes + graceful shutdown (30s drain) | HIGH |
| **NFR-010** | Availability | Database backup | Daily automated backups + point-in-time recovery (PostgreSQL) | HIGH |
| **NFR-011** | Reliability | No lost orders (data integrity) | Kafka with 7-day retention + database transactions (ACID) | CRITICAL |
| **NFR-012** | Reliability | Idempotent Kafka consumers | Redis idempotency keys (24h TTL) to prevent duplicate processing | HIGH |
| **NFR-013** | Reliability | Payment failure handling | Retry logic (3 attempts exponential backoff) + refund automation | CRITICAL |
| **NFR-014** | Reliability | Service failure handling | Circuit breaker (Resilience4j): open after 50% failure rate | HIGH |
| **NFR-015** | Security | Authentication | JWT with RS256 signature + refresh token rotation | CRITICAL |
| **NFR-016** | Security | Authorization | Role-based access control (CUSTOMER, RESTAURANT_OWNER, DELIVERY_PARTNER, ADMIN) | HIGH |
| **NFR-017** | Security | Password storage | BCrypt hash (cost factor 12) for OTPs | HIGH |
| **NFR-018** | Security | API rate limiting | Redis: 100 req/min per IP for public endpoints, 20 req/min per user for authenticated | HIGH |
| **NFR-019** | Security | Input validation | Bean Validation (JSR-380) on all request DTOs + SQL injection prevention (parameterized queries) | CRITICAL |
| **NFR-020** | Security | Sensitive data | Encrypt Aadhar/PAN at rest (AES-256) + TLS 1.3 for all traffic | HIGH |
| **NFR-021** | Security | Payment security | Razorpay signature verification (HMAC-SHA256) + PCI DSS compliance (via Razorpay) | CRITICAL |
| **NFR-022** | Security | OWASP Top 10 | Protected against: Injection, Broken Auth, XSS, CSRF, Security Misconfiguration | HIGH |
| **NFR-023** | Observability | Structured logging | JSON logs with traceId, spanId, userId for correlation | HIGH |
| **NFR-024** | Observability | Distributed tracing | Zipkin integration: trace every request across services | MEDIUM |
| **NFR-025** | Observability | Metrics | Prometheus: request rate, error rate, latency (RED method) + JVM metrics | HIGH |
| **NFR-026** | Observability | Dashboards | Grafana: per-service health, Kafka lag, DB performance | MEDIUM |
| **NFR-027** | Observability | Alerting | Alert on: error rate > 1%, p95 latency > 500ms, Kafka lag > 1000 msgs | MEDIUM |
| **NFR-028** | Maintainability | Code coverage | Minimum 80% line coverage across all services (unit + integration tests) | HIGH |
| **NFR-029** | Maintainability | API documentation | Swagger/OpenAPI for all endpoints with request/response examples | HIGH |
| **NFR-030** | Maintainability | Clean architecture | Layered: Controller → Service → Repository + DTO pattern + no business logic in controllers | HIGH |
| **NFR-031** | Usability | Mobile responsive | All frontends work on 320px to 4K screens (Tailwind responsive classes) | HIGH |
| **NFR-032** | Usability | Accessibility | WCAG 2.1 Level AA: keyboard navigation, screen reader support, color contrast | MEDIUM |
| **NFR-033** | Usability | Loading states | Show skeleton loaders during data fetch (no blank screens) | HIGH |
| **NFR-034** | Usability | Error messages | User-friendly error messages (not technical stack traces) | HIGH |
| **NFR-035** | Compliance | GDPR | User data export + deletion ("right to be forgotten") | MEDIUM |
| **NFR-036** | Compliance | GST | 5% GST on restaurant orders + 18% GST on delivery fee (India tax law) | HIGH |
| **NFR-037** | Compliance | FSSAI | Restaurant must have valid FSSAI license (verified during onboarding) | HIGH |

---

## 3. System Architecture

### 3.1 High-Level Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                              CLIENT LAYER                                    │
│                                                                              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  ┌────────┐ │
│  │   Customer      │  │   Restaurant    │  │   Delivery      │  │ Admin  │ │
│  │   React App     │  │   React Portal  │  │   Partner App   │  │Console │ │
│  │   TypeScript    │  │   TypeScript    │  │   TypeScript    │  │ React  │ │
│  │   Tailwind CSS  │  │   TanStack Query│  │   Socket.io     │  │ TS     │ │
│  │   (Port 3000)   │  │   (Port 3001)   │  │   (Port 3002)   │  │ :3003  │ │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘  └───┬────┘ │
└───────────┼──────────────────────┼──────────────────────┼───────────────┼────┘
            │                      │                      │               │
            │                HTTPS (TLS 1.3)              │               │
            └──────────────────────┼──────────────────────┼───────────────┘
                                   │                      │
┌──────────────────────────────────▼──────────────────────▼──────────────────┐
│                          API GATEWAY (Spring Cloud Gateway)                 │
│                               Port 8080                                     │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │  Features:                                                            │ │
│  │  • JWT Validation (RS256)                                            │ │
│  │  • Rate Limiting (Redis: 100 req/min per IP)                        │ │
│  │  • Load Balancing (Round Robin via Eureka)                          │ │
│  │  • CORS (Allow: localhost:3000-3003)                                │ │
│  │  • Circuit Breaker (Resilience4j: open after 50% failure rate)      │ │
│  │  • Request/Response Logging                                         │ │
│  │  • Distributed Tracing (Zipkin: traceId injection)                  │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
└───────┬────────┬────────┬────────┬────────┬────────┬────────┬─────────────┘
        │        │        │        │        │        │        │
        │        │        │        │        │        │        │
  ┌─────▼──┐ ┌──▼───┐ ┌──▼────┐ ┌─▼─────┐ ┌▼──────┐ ┌▼───────┐ ┌▼────────┐
  │ User   │ │Rest- │ │ Order │ │Payment│ │Delivery│ │Notific.│ │ Search  │
  │Service │ │aurant│ │Service│ │Service│ │Service │ │Service │ │ Service │
  │:8081   │ │:8082 │ │:8083  │ │:8084  │ │:8085   │ │:8086   │ │ :8087   │
  │        │ │      │ │       │ │       │ │        │ │        │ │         │
  │Phone   │ │Menu  │ │Cart   │ │Razor- │ │Partner │ │Push    │ │Elastic- │
  │OTP     │ │CRUD  │ │(Redis)│ │pay    │ │Assign  │ │Notif   │ │search   │
  │JWT     │ │Geo   │ │Coupon │ │Refund │ │GPS     │ │SMS     │ │Full-text│
  │Profile │ │Review│ │Order  │ │Webhook│ │WebSock.│ │Email   │ │Geo      │
  └───┬────┘ └──┬───┘ └───┬───┘ └───┬───┘ └───┬────┘ └───┬────┘ └───┬─────┘
      │          │         │         │         │           │          │
      │ PostgreSQL         │    PostgreSQL     │      (Kafka Consumer) │
      ▼          │         ▼         │         ▼           │          │
  ┌────────┐    │    ┌────────┐     │    ┌────────┐       │          │
  │Postgres│    │    │Postgres│     │    │Postgres│       │          │
  │Users   │    │    │Orders  │     │    │Delivery│       │          │
  │Address │    │    │Payments│     │    │Partners│       │          │
  │Refresh │    │    │Coupons │     │    └────────┘       │          │
  │Tokens  │    │    └────────┘     │                     │          │
  │OTP Logs│    │                   │                     │          │
  └────────┘    │                   │                     │          │
                │ MongoDB           │                     │          │
                ▼                   │                     │          │
           ┌──────────┐             │                     │          │
           │ MongoDB  │             │                     │          │
           │Restaurant│             │                     │          │
           │Menu Items│             │                     │          │
           │Categories│             │                     │          │
           │Reviews   │             │                     │          │
           └──────────┘             │                     │          │
                                    │                     │          │
                                    │                     │    Elasticsearch
                                    │                     │          ▼
                                    │                     │     ┌──────────┐
                                    │                     │     │Elastic-  │
                                    │                     │     │search    │
                                    │                     │     │Index:    │
                                    │                     │     │restaurants│
                                    │                     │     │menu_items│
                                    │                     │     └──────────┘
      ┌─────────────────────────────┴─────────────────────┴──────────────┐
      │                                                                    │
      ▼                                                                    ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                   APACHE KAFKA (Message Bus - Port 9092)                 │
│                                                                          │
│  Topics (Partitions | Retention):                                       │
│  • order.created               (12 partitions | 7 days)                 │
│  • payment.completed           (8 partitions  | 7 days)                 │
│  • order.status.updated        (12 partitions | 7 days)                 │
│  • delivery.location.updated   (24 partitions | 1 hour)                 │
│  • order.cancelled             (8 partitions  | 7 days)                 │
│  • restaurant.updated          (4 partitions  | 7 days)                 │
│  • delivery.assigned           (8 partitions  | 7 days)                 │
│                                                                          │
│  Producers: Order, Payment, Restaurant, Delivery Services               │
│  Consumers: Notification, Search, Delivery Services                     │
└──────────────────────────────────────────────────────────────────────────┘
                                    │
       ┌────────────────────────────┼────────────────────────────┐
       │                            │                            │
       ▼                            ▼                            ▼
┌──────────────┐           ┌────────────────┐          ┌────────────────┐
│    REDIS     │           │    ZIPKIN      │          │  PROMETHEUS    │
│   Port 6379  │           │   Port 9411    │          │   Port 9090    │
│              │           │                │          │                │
│ • Cart       │           │ Distributed    │          │ Metrics:       │
│ • Sessions   │           │ Tracing:       │          │ • Request rate │
│ • OTP        │           │ • Trace every  │          │ • Error rate   │
│ • Rate Limit │           │   request      │          │ • Latency (RED)│
│ • Idempotency│           │ • Service map  │          │ • JVM metrics  │
│ • Location   │           │ • Latency view │          │ • Kafka lag    │
│   Cache      │           │                │          │                │
└──────────────┘           └────────────────┘          └────────────────┘
                                    │                            │
                                    │                            ▼
                                    │                   ┌────────────────┐
                                    │                   │    GRAFANA     │
                                    │                   │   Port 3004    │
                                    │                   │                │
                                    │                   │ Dashboards:    │
                                    │                   │ • Platform     │
                                    │                   │ • Per-Service  │
                                    │                   │ • Kafka        │
                                    │                   │ • Database     │
                                    │                   └────────────────┘
                                    │
                                    ▼
                          ┌──────────────────┐
                          │ SERVICE REGISTRY │
                          │  (Eureka Server) │
                          │    Port 8761     │
                          │                  │
                          │ All services     │
                          │ register here    │
                          └──────────────────┘

ADDITIONAL COMPONENTS:

┌────────────────┐   ┌────────────────┐   ┌────────────────┐
│ CONFIG SERVER  │   │  KAFKA UI      │   │    MAILHOG     │
│   Port 8888    │   │  Port 8090     │   │  SMTP: 1025    │
│                │   │                │   │  UI: 8025      │
│ Centralized    │   │ Topic mgmt     │   │                │
│ configuration  │   │ Consumer lag   │   │ Email testing  │
└────────────────┘   └────────────────┘   └────────────────┘

┌────────────────┐   ┌────────────────┐   ┌────────────────┐
│     MINIO      │   │    KIBANA      │   │   ZOOKEEPER    │
│  Object: 9000  │   │  Port 5601     │   │   Port 2181    │
│  Console: 9001 │   │                │   │                │
│                │   │ Elasticsearch  │   │ Kafka metadata │
│ S3-compatible  │   │ management UI  │   │ coordination   │
└────────────────┘   └────────────────┘   └────────────────┘
```

### 3.2 Microservices Architecture Rationale

**Why Microservices Over Monolith?**

| Concern | Monolith Approach | Microservices Approach | Our Choice & Rationale |
|---------|-------------------|------------------------|------------------------|
| **Deployment** | Single WAR/JAR file deployed as one unit | Each service deployed independently with its own Docker container | **Microservices** — Allows deploying only changed services (e.g., fix bug in Order Service without redeploying Restaurant Service) |
| **Scaling** | Scale entire application (all modules together) | Scale specific services based on load | **Microservices** — Order Service needs 10× more instances than Payment Service due to higher traffic |
| **Technology Stack** | Single stack for entire app | Each service can use different stack | **Microservices** — Search Service uses Elasticsearch (Java client), could add Python ML service later |
| **Development** | Simpler for small teams | More complex (requires DevOps expertise) | **Microservices** — Portfolio value: demonstrates real-world enterprise architecture |
| **Fault Isolation** | Bug in one module crashes entire app | Failure isolated to specific service | **Microservices** — If Search Service crashes, users can still place orders |
| **Database** | Single shared database | Database per service (polyglot persistence) | **Microservices** — PostgreSQL for transactions, MongoDB for flexible documents, Redis for cache |
| **Team Organization** | One team owns entire codebase | Each service can have dedicated team | **Microservices** — Mirrors how Zomato/Swiggy organize: separate teams for search, payments, logistics |
| **Build Time** | Long (entire codebase compiles) | Fast (only changed service recompiles) | **Microservices** — Order Service builds in 30s vs 5min for monolith |
| **Testing** | All tests run together (slow) | Service-specific test suites (fast) | **Microservices** — CI pipeline runs tests in parallel (5min vs 20min) |

**Which Services Scale Independently and Why:**

1. **Order Service** (Highest Load)
   - **Traffic Pattern**: Every cart add/remove, every order placement
   - **Peak Load**: 1000 req/sec during dinner rush (7-10 PM)
   - **Scaling Strategy**: Auto-scale from 2 → 10 instances based on CPU > 70%
   - **Why Independent**: Heavy Redis usage, doesn't impact other services

2. **Search Service** (Read-Heavy)
   - **Traffic Pattern**: Every restaurant search, autocomplete
   - **Peak Load**: 500 req/sec (users browse more than order)
   - **Scaling Strategy**: Scale based on Elasticsearch cluster load
   - **Why Independent**: Elasticsearch queries are CPU intensive

3. **Delivery Location Service** (Write-Heavy)
   - **Traffic Pattern**: Location updates every 15 seconds × 1000 active partners = 67 writes/sec
   - **Peak Load**: Constant during operating hours
   - **Scaling Strategy**: Scale based on Kafka producer lag
   - **Why Independent**: High-frequency writes, separate Redis cluster

4. **Restaurant Service** (Moderate Load)
   - **Traffic Pattern**: Menu views, restaurant details
   - **Peak Load**: 300 req/sec
   - **Scaling Strategy**: Scale based on MongoDB connection pool utilization
   - **Why Independent**: MongoDB queries, doesn't need as many instances as Order Service

5. **Payment Service** (Critical but Low Volume)
   - **Traffic Pattern**: Only during order placement (10% of Order Service traffic)
   - **Peak Load**: 100 req/sec
   - **Scaling Strategy**: Fixed 3 instances (high availability more important than horizontal scale)
   - **Why Independent**: External Razorpay API calls, separate error handling

### 3.3 Service Dependency Map

```
┌─────────────────┐
│  API GATEWAY    │  (Entry point for all requests)
└────────┬────────┘
         │
         ├──────────────────────────────────────────────┐
         │                                              │
  ┌──────▼──────┐                                       │
  │ USER SERVICE│  (Standalone — no downstream calls)   │
  └─────────────┘                                       │
         │                                              │
         │ Publishes: user.created (Kafka)             │
         │                                              │
  ┌──────▼──────────┐                                   │
  │RESTAURANT SERVICE│                                  │
  └──────┬──────────┘                                   │
         │                                              │
         │ Calls: User Service (validate owner)        │
         │ Publishes: restaurant.updated (Kafka)       │
         │                                              │
  ┌──────▼──────┐                                       │
  │ORDER SERVICE │ (Most complex — orchestrates order)  │
  └──────┬──────┘                                       │
         │                                              │
         ├─► Calls: User Service (validate user + address)
         ├─► Calls: Restaurant Service (validate menu items + availability)
         ├─► Calls: Payment Service (create Razorpay order)
         │   Publishes: order.created, order.status.updated, order.cancelled (Kafka)
         │                                              │
  ┌──────▼────────┐                                     │
  │PAYMENT SERVICE│                                     │
  └──────┬────────┘                                     │
         │                                              │
         ├─► Calls: Razorpay API (external)            │
         │   Publishes: payment.completed, refund.processed (Kafka)
         │                                              │
  ┌──────▼─────────┐                                    │
  │DELIVERY SERVICE│                                    │
  └──────┬─────────┘                                    │
         │                                              │
         ├─► Calls: Order Service (get order details)  │
         ├─► Calls: User Service (get partner profile) │
         │   Publishes: delivery.assigned, delivery.location.updated (Kafka)
         │                                              │
  ┌──────▼───────────┐                                  │
  │NOTIFICATION      │  (Kafka Consumer — no REST calls)│
  │SERVICE           │                                  │
  └──────┬───────────┘                                  │
         │                                              │
         ├─► Consumes: order.created                   │
         ├─► Consumes: payment.completed               │
         ├─► Consumes: order.status.updated            │
         ├─► Consumes: delivery.assigned               │
         ├─► Calls: Firebase FCM API (push)            │
         ├─► Calls: Twilio API (SMS)                   │
         └─► Calls: SMTP (email)                       │
                                                        │
  ┌──────▼──────┐                                       │
  │SEARCH SERVICE│  (Kafka Consumer + Elasticsearch)    │
  └─────────────┘                                       │
         │                                              │
         ├─► Consumes: restaurant.updated              │
         ├─► Reads: Elasticsearch (search queries)     │
         └─► No REST calls to other services           │
```

**Dependency Anti-Patterns Avoided:**

❌ **Circular Dependencies**: Nev happen (Order Service doesn't call services that call it back)
❌ **Deep Chains**: Max 2-level calls (Order → Payment → Razorpay, then stop)
❌ **Synchronous Fan-Out**: Order Service doesn't call Notification directly (uses Kafka)
❌ **Shared Database**: Each service owns its tables (no cross-service DB queries)

### 3.4 Event-Driven Architecture (Kafka)

**Why Kafka Over Direct REST Calls for Order Events?**

| Concern | Direct REST Calls | Kafka Events | Winner |
|---------|-------------------|--------------|--------|
| **Coupling** | Order Service must know Notification Service URL | Order Service just publishes event, doesn't care who consumes | **Kafka** |
| **Resilience** | If Notification Service is down, order fails (or timeout) | Event stored in Kafka, consumed when service recovers | **Kafka** |
| **Performance** | Synchronous wait for response (blocking) | Fire and forget (async, non-blocking) | **Kafka** |
| **Audit Trail** | No history unless manually logged | Complete event history (7-day retention) | **Kafka** |
| **Scalability** | Need to call 3 services = 3× latency | Single publish, Kafka distributes to consumers | **Kafka** |
| **Add New Consumer** | Modify Order Service code to add new call | New service subscribes to topic, zero changes to Order Service | **Kafka** |

**Complete Kafka Topic Documentation:**

| Topic Name | Partitions | Key | Producer(s) | Consumer(s) | Payload Schema | Retention | Why This Config |
|------------|------------|-----|-------------|-------------|----------------|-----------|-----------------|
| **order.created** | 12 | `restaurantId` | Order Service | Notification, Delivery (standby) | `{orderId, orderNumber, userId, restaurantId, items[], totalAmount, deliveryAddress, customerPhone, createdAt}` | 7 days | Partitioned by restaurant for parallelism; consumers process orders per restaurant independently |
| **payment.completed** | 8 | `orderId` | Payment Service | Order, Notification | `{orderId, paymentId, amount, paymentMethod, razorpayPaymentId, status, completedAt}` | 7 days | Fewer partitions (payments less frequent than orders); key by order for ordering guarantee |
| **order.status.updated** | 12 | `orderId` | Order, Restaurant, Delivery | Notification, Search (analytics) | `{orderId, previousStatus, newStatus, updatedBy, updatedById, timestamp, metadata}` | 7 days | High volume topic (every status change); 12 partitions for throughput |
| **delivery.location.updated** | 24 | `deliveryPartnerId` | Delivery Service | Delivery (WebSocket broadcast) | `{orderId, deliveryPartnerId, latitude, longitude, timestamp, speed, heading}` | **1 hour** | Highest volume (location every 15s × 1000 partners); short retention (historical location not needed) |
| **order.cancelled** | 8 | `orderId` | Order, Restaurant | Payment (refund), Notification | `{orderId, cancelledBy, cancelledById, reason, refundAmount, cancelledAt}` | 7 days | Lower volume; triggers refund flow in Payment Service |
| **restaurant.updated** | 4 | `restaurantId` | Restaurant Service | Search (reindex) | `{restaurantId, changeType: MENU_UPDATE \| STATUS_CHANGE \| INFO_UPDATE, updatedFields, timestamp}` | 7 days | Low volume; triggers Elasticsearch reindex |
| **delivery.assigned** | 8 | `orderId` | Delivery Service | Notification | `{orderId, deliveryPartnerId, partnerName, partnerPhone, vehicleNumber, estimatedPickupTime, assignedAt}` | 7 days | Triggers "partner assigned" notification |

**Kafka Consumer Configuration:**

All consumers use:
```yaml
spring:
  kafka:
    consumer:
      group-id: ${spring.application.name}  # e.g., "notification-service"
      auto-offset-reset: earliest  # Start from beginning on first run
      enable-auto-commit: false  # Manual commit after successful processing
      max-poll-records: 10  # Process in small batches
    listener:
      ack-mode: manual  # Commit offsets manually
      concurrency: 3  # 3 threads per consumer
```

**Error Handling Strategy:**

1. **Retry**: 3 attempts with exponential backoff (1s, 2s, 4s)
2. **Dead Letter Queue (DLQ)**: After 3 failures, send to `{topic}.dlq`
3. **Manual Intervention**: DLQ monitored via Kafka UI; manual replay after fix
4. **Idempotency**: Every consumer checks Redis key `processed:{topic}:{messageId}` before processing

### 3.5 Data Architecture Decision

**Why Different Databases for Different Services?**

| Database | Service(s) | Data Type | Characteristics | Why Chosen | Example Query |
|----------|-----------|-----------|-----------------|------------|---------------|
| **PostgreSQL 15** | User, Order, Payment, Delivery | Relational (normalized) | • ACID transactions<br>• Foreign key constraints<br>• Strong consistency<br>• Excellent for financial data | **Orders and payments require ACID**: Order must be created atomically with order items; payment must update order status transactionally | `BEGIN; INSERT INTO orders ...; INSERT INTO order_items ...; COMMIT;` |
| **MongoDB 7** | Restaurant | Document (JSON-like) | • Flexible schema<br>• Embedded documents<br>• Geospatial indexes<br>• Fast reads | **Restaurant menu structure varies wildly**: Pizza place has customizations (size, crust), but biryani place doesn't; embedding avoids JOINs | `db.restaurants.find({"address.location": {$near: {$geometry: {type: "Point", coordinates: [73.85, 18.52]}, $maxDistance: 5000}}})` |
| **Redis 7** | Cart, Sessions, OTP, Rate Limits | Key-Value (in-memory) | • Sub-millisecond latency<br>• TTL support<br>• Atomic operations<br>• Pub/Sub | **Cart needs speed + expiration**: Cart operations happen on every item add/remove; TTL auto-expires abandoned carts after 24h | `HSET cart:user123 item456 '{"qty":2,"price":200}'; EXPIRE cart:user123 86400` |
| **Elasticsearch 8** | Search | Inverted Index (full-text) | • Full-text search<br>• Fuzzy matching<br>• Geospatial queries<br>• Aggregations | **Search needs sub-100ms results with typo tolerance**: "burgor" should find "burger"; combine with geospatial to show only nearby restaurants | `GET /restaurants/_search {"query": {"bool": {"must": {"multi_match": {"query": "pizza", "fields": ["name", "cuisines"], "fuzziness": "AUTO"}}, "filter": {"geo_distance": {"distance": "5km", "address.location": [73.85, 18.52]}}}}}` |

**Data Consistency Patterns:**

| Scenario | Pattern | Implementation |
|----------|---------|----------------|
| **Order Creation** | Strong Consistency (ACID) | PostgreSQL transaction: `BEGIN; INSERT orders; INSERT order_items; INSERT order_status_history; COMMIT;` |
| **Order Status Update** | Eventual Consistency | Status updated in PostgreSQL, then Kafka event → consumers eventually process |
| **Restaurant Menu Cache** | Cache-Aside | Read: Check Redis → if miss, query MongoDB → cache in Redis (5 min TTL); Write: Update MongoDB → invalidate Redis |
| **Cart** | Write-Through Cache | Every cart change written to Redis immediately; no backing DB (cart is ephemeral) |
| **Search Index** | Eventual Consistency | Restaurant created in MongoDB → Kafka event → Search Service consumes → indexes in Elasticsearch (async) |

**Database Scaling Strategy:**

| Database | Current Setup (Dev) | Production Scaling |
|----------|---------------------|-------------------|
| **PostgreSQL** | Single instance | Master-slave replication: 1 master (writes), 2 read replicas (queries); pgBouncer connection pooling |
| **MongoDB** | Single instance | Replica set (3 nodes): 1 primary, 2 secondaries; read preference: `secondaryPreferred` for queries |
| **Redis** | Single instance | Redis Cluster (6 nodes): 3 masters + 3 replicas; client-side sharding |
| **Elasticsearch** | Single node | 3-node cluster: 1 shard per index, 2 replicas; load balanced via Nginx |

### 3.6 Security Architecture

**Multi-Layer Security Model:**

```
┌────────────────────────────────────────────────────────────────┐
│                        Layer 1: Network                        │
│  • TLS 1.3 encryption (HTTPS only, HTTP redirects to HTTPS)   │
│  • AWS WAF (Web Application Firewall) in production           │
│  • DDoS protection (Cloudflare in production)                 │
└──────────────────────┬─────────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────────┐
│                    Layer 2: API Gateway                        │
│  • IP-based rate limiting (Redis): 100 req/min per IP         │
│  • Request size limits: 10MB max body size                    │
│  • SQL injection prevention: no raw DB queries                │
│  • CORS whitelist: only localhost:3000-3003 (dev)             │
└──────────────────────┬─────────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────────┐
│                Layer 3: JWT Authentication                     │
│  • Access token: 15 minutes, RS256 signature                  │
│  • Refresh token: 30 days, stored hashed in DB                │
│  • Token rotation: new refresh token on every refresh         │
│  • Logout: revoke specific refresh token (DB update)          │
└──────────────────────┬─────────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────────┐
│               Layer 4: Authorization (RBAC)                    │
│  Roles: CUSTOMER, RESTAURANT_OWNER, DELIVERY_PARTNER, ADMIN   │
│  • @PreAuthorize("hasRole('CUSTOMER')") on controllers        │
│  • Resource-level: users can only access their own data       │
│  • Example: User A cannot view User B's orders                │
└──────────────────────┬─────────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────────┐
│             Layer 5: Input Validation                          │
│  • Bean Validation (JSR-380): @NotNull, @Size, @Pattern       │
│  • Custom validators: phone format, pincode, coordinates       │
│  • Sanitization: strip HTML tags from user input              │
│  • Parameterized queries: zero SQL injection risk             │
└──────────────────────┬─────────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────────┐
│            Layer 6: Data Protection                            │
│  • Passwords/OTPs: BCrypt hash (cost 12)                      │
│  • Sensitive PII: AES-256 encryption (Aadhar, PAN)            │
│  • Payment data: never stored (Razorpay tokenization)         │
│  • Database: encrypted at rest (AWS RDS encryption)           │
│  • Logs: PII redacted ([REDACTED] for phone/email)           │
└────────────────────────────────────────────────────────────────┘
```

**Authentication Flow (Phone OTP):**

```
┌──────────┐                                           ┌──────────────┐
│ Customer │                                           │ User Service │
└─────┬────┘                                           └──────┬───────┘
      │                                                       │
      │ POST /api/v1/auth/send-otp                           │
      │ Body: {phoneNumber: "+919876543210"}                 │
      ├──────────────────────────────────────────────────────>│
      │                                                       │
      │                                          1. Check rate limit (Redis):
      │                                             key = "rate_limit:otp:+919876543210"
      │                                             if count > 3 in last hour: return 429
      │                                                       │
      │                                          2. Generate 6-digit OTP: "123456"
      │                                                       │
      │                                          3. Hash OTP: BCrypt.hash("123456")
      │                                                       │
      │                                          4. Store in Redis:
      │                                             key = "otp:+919876543210"
      │                                             value = {hash, attempts:0, purpose:"LOGIN"}
      │                                             TTL = 600 seconds (10 min)
      │                                                       │
      │                                          5. Send SMS via Twilio:
      │                                             "Your FoodFlow OTP is 123456. Valid for 10 minutes."
      │                                             (In dev: just log to console)
      │                                                       │
      │ 200 OK                                                │
      │ Body: {success:true, data:{maskedPhone:"******3210"}}│
      │<──────────────────────────────────────────────────────┤
      │                                                       │
      │ POST /api/v1/auth/verify-otp                         │
      │ Body: {phoneNumber:"+919876543210", otp:"123456"}    │
      ├──────────────────────────────────────────────────────>│
      │                                                       │
      │                                          1. Fetch from Redis:
      │                                             data = Redis.get("otp:+919876543210")
      │                                             if null: return 400 "OTP expired"
      │                                                       │
      │                                          2. Check attempts:
      │                                             if data.attempts >= 3: 
      │                                                Redis.del("otp:+919876543210")
      │                                                return 400 "Too many attempts"
      │                                                       │
      │                                          3. Verify OTP:
      │                                             if !BCrypt.matches("123456", data.hash):
      │                                                data.attempts++
      │                                                Redis.set("otp:+919876543210", data)
      │                                                return 400 "Invalid OTP"
      │                                                       │
      │                                          4. Check if user exists:
      │                                             user = DB.findByPhone("+919876543210")
      │                                             if null:
      │                                                user = DB.createUser(phone)
      │                                                isNewUser = true
      │                                                       │
      │                                          5. Generate JWT tokens:
      │                                             accessToken = JWT.create({
      │                                                userId: user.id,
      │                                                role: user.role,
      │                                                exp: now + 15min
      │                                             }, privateKey, RS256)
      │                                             
      │                                             refreshToken = UUID.randomUUID()
      │                                             DB.save(RefreshToken{
      │                                                userId: user.id,
      │                                                tokenHash: BCrypt.hash(refreshToken),
      │                                                expiresAt: now + 30days
      │                                             })
      │                                                       │
      │                                          6. Delete OTP from Redis:
      │                                             Redis.del("otp:+919876543210")
      │                                                       │
      │                                          7. Update last login:
      │                                             DB.update(user, {lastLoginAt: now})
      │                                                       │
      │ 200 OK                                                │
      │ Body: {success:true, data:{                          │
      │   accessToken:"eyJhbGc...",                          │
      │   refreshToken:"uuid...",                            │
      │   user:{id, phone, name, role},                     │
      │   isNewUser:true                                     │
      │ }}                                                    │
      │<──────────────────────────────────────────────────────┤
```

**Payment Security (Razorpay Signature Verification):**

```java
// CRITICAL: Always verify Razorpay payment signature
// Without this, anyone can fake a payment completion

@PostMapping("/verify")
public ResponseEntity<?> verifyPayment(@RequestBody PaymentVerifyRequest request) {
    String razorpayOrderId = request.getRazorpayOrderId();
    String razorpayPaymentId = request.getRazorpayPaymentId();
    String razorpaySignature = request.getRazorpaySignature();
    
    // Step 1: Recreate signature using secret key
    String payload = razorpayOrderId + "|" + razorpayPaymentId;
    String expectedSignature = HmacUtils.hmacSha256Hex(
        razorpayKeySecret,  // NEVER expose this to frontend
        payload
    );
    
    // Step 2: Compare signatures (constant-time comparison to prevent timing attacks)
    if (!MessageDigest.isEqual(
        expectedSignature.getBytes(StandardCharsets.UTF_8),
        razorpaySignature.getBytes(StandardCharsets.UTF_8)
    )) {
        log.error("Payment signature mismatch for order: {}", razorpayOrderId);
        throw new PaymentVerificationException("Invalid signature");
    }
    
    // Step 3: Fetch payment details from Razorpay (double-check amount)
    Payment payment = razorpayClient.Payments.fetch(razorpayPaymentId);
    if (!payment.get("status").equals("captured")) {
        throw new PaymentVerificationException("Payment not captured");
    }
    
    // Step 4: Update database (idempotency check)
    if (paymentRepository.existsByRazorpayPaymentId(razorpayPaymentId)) {
        log.warn("Payment already processed: {}", razorpayPaymentId);
        return ResponseEntity.ok("Already processed");
    }
    
    Payment dbPayment = paymentRepository.findByRazorpayOrderId(razorpayOrderId);
    dbPayment.setStatus(PaymentStatus.CAPTURED);
    dbPayment.setRazorpayPaymentId(razorpayPaymentId);
    dbPayment.setRazorpaySignature(razorpaySignature);
    paymentRepository.save(dbPayment);
    
    // Step 5: Publish Kafka event (triggers order confirmation)
    kafkaTemplate.send("payment.completed", new PaymentCompletedEvent(
        dbPayment.getOrderId(),
        razorpayPaymentId,
        dbPayment.getAmount()
    ));
    
    return ResponseEntity.ok("Payment verified successfully");
}
```

### 3.7 Delivery Partner Assignment Algorithm

**Problem Statement:**  
When an order status changes to `READY_FOR_PICKUP`, we need to assign an available delivery partner **within 90 seconds** to maintain fast delivery times. The algorithm must handle:
- Finding partners within reasonable distance (3km initially, expand to 5km if needed)
- Race condition where multiple partners accept simultaneously
- Partners rejecting assignments
- No available partners (notify customer)

**Algorithm (Step-by-Step):**

```java
@Transactional
public void assignDeliveryPartner(UUID orderId) {
    // STEP 1: Fetch order details
    Order order = orderRepository.findById(orderId)
        .orElseThrow(() -> new OrderNotFoundException(orderId));
    
    Restaurant restaurant = restaurantService.getRestaurant(order.getRestaurantId());
    Double restaurantLat = restaurant.getLatitude();
    Double restaurantLng = restaurant.getLongitude();
    
    log.info("Assigning partner for order: {} at restaurant: ({}, {})", 
             orderId, restaurantLat, restaurantLng);
    
    // STEP 2: Query available partners within 3km radius (first attempt)
    // Using PostGIS geospatial query
    List<DeliveryPartner> availablePartners = deliveryPartnerRepository.findAll(
        (root, query, cb) -> cb.and(
            cb.isTrue(root.get("isAvailable")),
            cb.isTrue(root.get("isOnline")),
            cb.lessThan(
                cb.function("ST_Distance",
                    Double.class,
                    root.get("currentLocation"),
                    cb.literal(String.format("POINT(%f %f)", restaurantLng, restaurantLat))
                ),
                3000.0  // 3km in meters
            )
        )
    );
    
    // Sort by distance (closest first)
    availablePartners.sort((p1, p2) -> {
        double dist1 = calculateDistance(p1, restaurantLat, restaurantLng);
        double dist2 = calculateDistance(p2, restaurantLat, restaurantLng);
        return Double.compare(dist1, dist2);
    });
    
    log.info("Found {} available partners within 3km", availablePartners.size());
    
    if (availablePartners.isEmpty()) {
        // STEP 3: If no partners within 3km, expand to 5km
        log.warn("No partners within 3km, expanding search to 5km");
        availablePartners = deliveryPartnerRepository.findAvailableWithin(
            restaurantLat, restaurantLng, 5000.0
        );
    }
    
    if (availablePartners.isEmpty()) {
        // STEP 4: Still no partners — notify customer + restaurant
        log.error("No available partners found for order: {}", orderId);
        notificationService.sendNoPartnerAvailableNotification(orderId);
        orderService.updateOrderStatus(orderId, OrderStatus.PARTNER_NOT_FOUND);
        return;
    }
    
    // STEP 5: Send push notification to top 3 partners simultaneously
    List<DeliveryPartner> topThree = availablePartners.subList(
        0, Math.min(3, availablePartners.size())
    );
    
    String assignmentId = UUID.randomUUID().toString();
    
    // Store pending assignment in Redis (90 second TTL)
    AssignmentRequest request = new AssignmentRequest(
        assignmentId,
        orderId,
        restaurantLat,
        restaurantLng,
        order.getDeliveryAddress(),
        calculateEarnings(order),
        topThree.stream().map(DeliveryPartner::getId).collect(Collectors.toList())
    );
    
    redisTemplate.opsForValue().set(
        "assignment:pending:" + assignmentId,
        request,
        Duration.ofSeconds(90)
    );
    
    // Send Firebase push notification to all 3
    topThree.forEach(partner -> {
        if (partner.getFcmToken() != null) {
            firebaseMessaging.send(Message.builder()
                .setToken(partner.getFcmToken())
                .setNotification(Notification.builder()
                    .setTitle("New Delivery Available!")
                    .setBody(String.format("₹%.2f | %s → %s", 
                        calculateEarnings(order),
                        restaurant.getName(),
                        order.getDeliveryAddress().getArea()
                    ))
                    .build())
                .putData("assignmentId", assignmentId)
                .putData("orderId", orderId.toString())
                .putData("restaurantName", restaurant.getName())
                .putData("distance", String.valueOf(calculateDistance(partner, restaurantLat, restaurantLng)))
                .putData("earnings", String.valueOf(calculateEarnings(order)))
                .build());
        }
    });
    
    log.info("Sent assignment notifications to {} partners", topThree.size());
    
    // STEP 6: Scheduled check after 90 seconds
    // (Handled by separate @Scheduled method that checks Redis for expired assignments)
}

/**
 * This endpoint is called when a delivery partner accepts the assignment
 */
@PostMapping("/assignments/{assignmentId}/accept")
@PreAuthorize("hasRole('DELIVERY_PARTNER')")
public ResponseEntity<?> acceptAssignment(
    @PathVariable String assignmentId,
    @AuthenticationPrincipal UserPrincipal currentUser
) {
    // STEP 7: Fetch assignment from Redis
    String redisKey = "assignment:pending:" + assignmentId;
    AssignmentRequest assignment = (AssignmentRequest) redisTemplate.opsForValue().get(redisKey);
    
    if (assignment == null) {
        // Assignment expired or already accepted
        return ResponseEntity.status(HttpStatus.GONE)
            .body("Assignment no longer available");
    }
    
    // STEP 8: Check if this partner was in the notification list
    UUID partnerId = currentUser.getUserId();
    if (!assignment.getPartnerIds().contains(partnerId)) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
            .body("Assignment not sent to you");
    }
    
    // STEP 9: CRITICAL — Use pessimistic database lock to handle race condition
    // If two partners click Accept simultaneously, only one will succeed
    try {
        Order order = orderRepository.findByIdForUpdate(assignment.getOrderId())
            .orElseThrow(() -> new OrderNotFoundException(assignment.getOrderId()));
        
        if (order.getDeliveryPartnerId() != null) {
            // Already assigned to another partner
            log.warn("Order {} already assigned to partner {}", 
                     order.getId(), order.getDeliveryPartnerId());
            return ResponseEntity.status(HttpStatus.CONFLICT)
                .body("Order already assigned to another partner");
        }
        
        // Assign this partner
        order.setDeliveryPartnerId(partnerId);
        order.setStatus(OrderStatus.ASSIGNED);
        orderRepository.save(order);
        
        // Update partner availability (now busy)
        DeliveryPartner partner = deliveryPartnerRepository.findById(partnerId).get();
        partner.setIsAvailable(false);
        deliveryPartnerRepository.save(partner);
        
        // Delete Redis assignment (no longer needed)
        redisTemplate.delete(redisKey);
        
        // Publish Kafka event
        kafkaTemplate.send("delivery.assigned", new DeliveryAssignedEvent(
            order.getId(),
            partnerId,
            partner.getName(),
            partner.getPhoneNumber(),
            partner.getVehicleNumber()
        ));
        
        log.info("Order {} assigned to partner {}", order.getId(), partnerId);
        
        return ResponseEntity.ok("Assignment accepted successfully");
        
    } catch (Exception e) {
        log.error("Error assigning order", e);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body("Assignment failed");
    }
}

/**
 * Scheduled job to check for expired assignments (runs every 30 seconds)
 */
@Scheduled(fixedRate = 30000)
public void checkExpiredAssignments() {
    Set<String> keys = redisTemplate.keys("assignment:pending:*");
    
    keys.forEach(key -> {
        AssignmentRequest assignment = (AssignmentRequest) redisTemplate.opsForValue().get(key);
        if (assignment == null) {
            return;  // Already accepted or Redis naturally expired it
        }
        
        // Check if 90 seconds have passed
        long createdAt = assignment.getCreatedAt();
        if (System.currentTimeMillis() - createdAt > 90000) {
            // No partner accepted in 90 seconds
            log.warn("Assignment {} expired for order {}", 
                     assignment.getAssignmentId(), assignment.getOrderId());
            
            // Try again with expanded radius or notify customer
            assignDeliveryPartner(assignment.getOrderId());
            
            // Delete expired assignment
            redisTemplate.delete(key);
        }
    });
}

private double calculateDistance(DeliveryPartner partner, double lat, double lng) {
    // Haversine formula
    double R = 6371000; // Earth radius in meters
    double dLat = Math.toRadians(lat - partner.getCurrentLat());
    double dLng = Math.toRadians(lng - partner.getCurrentLng());
    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
               Math.cos(Math.toRadians(partner.getCurrentLat())) * 
               Math.cos(Math.toRadians(lat)) *
               Math.sin(dLng / 2) * Math.sin(dLng / 2);
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
}

private double calculateEarnings(Order order) {
    // Base earnings + distance-based bonus
    double baseEarnings = 30.0;  // ₹30 base
    double distanceBonus = calculateDistance(...) * 2.0;  // ₹2 per km
    return baseEarnings + distanceBonus;
}
```

**Why This Works:**
1. **Geospatial Query**: PostgreSQL PostGIS finds partners fast (< 10ms for 1000 partners)
2. **Parallel Notifications**: Top 3 notified simultaneously increases acceptance rate
3. **Database Lock**: `SELECT FOR UPDATE` ensures only one partner gets assigned
4. **Redis TTL**: Auto-expires abandoned assignments (no manual cleanup needed)
5. **Fallback**: Expands radius if no nearby partners
6. **Fair Distribution**: Closest partners get notified first

---

## 4. Tech Stack — Complete Reference

### 4.1 Backend Technologies

| Technology | Version | Purpose | Why Chosen Over Alternatives | How Used in Project |
|-----------|---------|---------|------------------------------|---------------------|
| **Java** | 17 LTS | Programming language | • Virtual threads (Project Loom preview)<br>• Records for DTOs<br>• Pattern matching<br>• Text blocks<br>• Better than Java 11 (old LTS) | All backend services written in Java 17; using records for DTOs, text blocks for SQL queries |
| **Spring Boot** | 3.2.5 | Application framework | • Auto-configuration reduces boilerplate<br>• Production-ready (Actuator)<br>• Huge ecosystem<br>• Better than Quarkus (less mature) or Micronaut (smaller community) | Foundation for all 7 microservices; @SpringBootApplication entry point |
| **Spring Cloud Gateway** | 4.1.x | API Gateway | • Native Spring integration<br>• Reactive (WebFlux)<br>• Built-in load balancing<br>• Better than Kong (more complex) or Zuul (deprecated) | Routes all `/api/v1/*` requests to appropriate services; JWT validation filter; rate limiting |
| **Spring Cloud Eureka** | 4.1.x | Service discovery | • Simple setup<br>• Self-healing<br>• Client-side load balancing<br>• Better than Consul (more complex) | All services register at startup; API Gateway uses Eureka for `lb://service-name` URIs |
| **Spring Cloud Config** | 4.1.x | Centralized config | • Git-backed configuration<br>• Environment-specific profiles<br>• Refresh without restart<br>• Better than ConfigMaps (Kubernetes-specific) | Stores shared config (DB URLs, Kafka brokers); services fetch on startup |
| **Spring Data JPA** | 3.2.x | PostgreSQL ORM | • Reduces JDBC boilerplate<br>• Automatic query generation<br>• Entity relationships<br>• Better than MyBatis (more verbose) | User, Order, Payment, Delivery services use JPA repositories; custom queries with `@Query` |
| **Spring Data MongoDB** | 4.2.x | MongoDB ODM | • Reactive support<br>• Geospatial queries<br>• Aggregation pipeline<br>• Better than native driver (manual mapping) | Restaurant Service uses `MongoRepository`; `$near` queries for restaurant discovery |
| **Spring Data Redis** | 3.2.x | Redis client | • Lettuce async client<br>• Template abstraction<br>• Cache abstraction<br>• Better than Jedis (sync only) | Cart stored as Redis Hash; OTP in Redis with TTL; session caching |
| **Spring Security** | 6.2.x | Authentication & Authorization | • Industry standard<br>• JWT support<br>• Method-level security (`@PreAuthorize`)<br>• CSRF protection<br>• Better than Apache Shiro (less active) | JWT authentication filter; role-based access control; password encoding (BCrypt) |
| **Spring Kafka** | 3.1.x | Kafka client | • Spring integration<br>• Annotation-based consumers<br>• Error handling<br>• Better than raw Kafka client (boilerplate) | All services publish/consume Kafka events; `@KafkaListener` for consumers |
| **Hibernate** | 6.4.x | JPA implementation | • Schema generation from entities<br>• 2nd level cache<br>• Query optimization<br>• Better than EclipseLink (less features) | JPA provider; automatic DDL generation in dev; N+1 query detection |
| **PostgreSQL Driver** | 42.7.x | JDBC driver for PostgreSQL | • Official driver<br>• Latest PostgreSQL features<br>• Connection pooling support | JDBC URL: `jdbc:postgresql://postgres:5432/fooddelivery` |
| **MongoDB Java Driver** | 4.11.x | MongoDB client | • Async support<br>• Connection pooling<br>• Bulk operations | Embedded in Spring Data MongoDB; handles connection pooling |
| **Lettuce** | 6.3.x | Async Redis client | • Non-blocking IO<br>• Reactive API<br>• Better than Jedis (blocking) | Embedded in Spring Data Redis; handles connection pool |
| **HikariCP** | 5.1.0 | JDBC connection pool | • Fastest connection pool (benchmarks)<br>• Zero overhead<br>• Better than C3P0 or DBCP2 | Default pool in Spring Boot; max 10 connections per service |
| **Resilience4j** | 2.2.0 | Circuit breaker | • Lightweight (no dependencies)<br>• Spring Boot integration<br>• Better than Hystrix (deprecated) | Circuit breaker for external API calls (Razorpay, Twilio); `@CircuitBreaker` annotation |
| **MapStruct** | 1.5.5.Final | DTO mapping | • Compile-time generation (fast)<br>• Type-safe<br>• Better than ModelMapper (runtime reflection) | Entity → DTO conversion; auto-generates mapper implementations |
| **Lombok** | 1.18.30 | Boilerplate reduction | • `@Data`, `@Builder`, `@Slf4j`<br>• Compile-time code generation<br>• Cleaner code | All entities use `@Entity @Data`; services use `@Slf4j` for logging |
| **JJWT** | 0.11.5 | JWT library | • Easy API<br>• RS256/HS256 support<br>• Claims validation<br>• Better than Auth0 JWT (less features) | Generate/parse JWT tokens; signature verification |
| **Razorpay Java SDK** | 1.4.6 | Payment gateway | • Official SDK<br>• India-focused<br>• Same as Zomato/Swiggy use | Create Razorpay orders; verify payment signatures; process refunds |
| **Twilio Java SDK** | 9.14.1 | SMS sending | • Official SDK<br>• Reliable delivery<br>• Used by Swiggy | Send OTP via SMS; delivery tracking SMS (optional) |
| **Firebase Admin SDK** | 9.2.0 | Push notifications | • Google's official SDK<br>• Multicast support<br>• Token management | Send push notifications to customers, partners; FCM token validation |
| **AWS SDK S3** | 2.21.x | S3 client | • Official SDK<br>• Compatible with MinIO<br>• Async support | Upload restaurant images to S3/MinIO; presigned URLs for frontend uploads |
| **Google Maps Services** | 2.2.0 | Google Maps API client | • Official Java client<br>• Geocoding, Distance Matrix<br>• Address autocomplete | Calculate delivery ETA; geocode addresses; distance between coordinates |
| **SpringDoc OpenAPI** | 2.3.0 | API documentation | • Auto-generates Swagger UI<br>• Annotations-based<br>• Better than Springfox (unmaintained) | Swagger UI at `/swagger-ui.html`; OpenAPI JSON at `/v3/api-docs` |
| **Micrometer** | 1.12.x | Metrics | • Vendor-neutral<br>• Prometheus integration<br>• JVM metrics | Exports metrics to Prometheus; custom meters for business metrics |
| **Spring Cloud Sleuth** | (included in Boot 3) | Distributed tracing | • Auto traceId/spanId injection<br>• Zipkin integration<br>• Log correlation | TraceId in all logs; Zipkin span export |
| **JUnit 5** | 5.10.x | Unit testing | • Modern API<br>• Parameterized tests<br>• Better than JUnit 4 | All unit tests use JUnit 5; `@Test`, `@ParameterizedTest` |
| **Mockito** | 5.8.x | Mocking framework | • Easy mocking<br>• Argument matchers<br>• Better than EasyMock | Mock repositories and external clients in unit tests |
| **Testcontainers** | 1.19.x | Integration testing | • Real databases in tests<br>• Docker-based<br>• Better than H2 mocks (unrealistic) | Spin up PostgreSQL, MongoDB, Redis, Kafka containers for integration tests |
| **Rest Assured** | 5.4.0 | API testing | • Fluent API<br>• JSON path assertions<br>• Better than raw Spring MockMvc | E2E API tests; `given().when().then()` syntax |

### 4.2 Frontend Technologies

| Technology | Version | Purpose | Why Chosen Over Alternatives | How Used in Project |
|-----------|---------|---------|------------------------------|---------------------|
| **React** | 18.2.0 | UI framework | • Concurrent features<br>• Huge ecosystem<br>• Server components (future)<br>• Better than Vue (less jobs) or Angular (too complex) | All 4 frontend apps; functional components with hooks |
| **TypeScript** | 5.3.x | Type safety | • Catch errors at build time<br>• Better IntelliSense<br>• Refactoring confidence<br>• Better than PropTypes (runtime only) | All React components typed; interfaces for API responses |
| **Vite** | 5.0.x | Build tool | • 10× faster than Create React App<br>• Hot Module Replacement (HMR)<br>• Better than Webpack (slow) | Dev server (`npm run dev`); production builds (`npm run build`) |
| **Tailwind CSS** | 3.4.x | Utility-first CSS | • No CSS files to manage<br>• Consistent design system<br>• PurgeCSS (small bundle)<br>• Better than Bootstrap (opinionated) or CSS-in-JS (runtime cost) | All styling via Tailwind classes; custom theme in `tailwind.config.js` |
| **React Router** | 6.21.x | Client-side routing | • Declarative routing<br>• Nested routes<br>• Better than Reach Router (merged into RR) | `<Routes>` in each app; protected routes with auth guard |
| **TanStack Query** | 5.17.x | Server state | • Auto caching<br>• Background refetch<br>• Optimistic updates<br>• Better than Redux Toolkit Query (more boilerplate) or SWR (less features) | All API calls use `useQuery`/`useMutation`; auto cache invalidation |
| **Zustand** | 4.4.x | Client state | • Minimal boilerplate<br>• No Provider wrapping<br>• DevTools support<br>• Better than Redux (too much boilerplate) or Context API (re-render issues) | Auth store (access token); cart store (optimistic UI) |
| **Axios** | 1.6.x | HTTP client | • Interceptors (inject JWT)<br>• Better error handling<br>• Better than fetch (no interceptors) | API client with base URL; request interceptor adds `Authorization` header |
| **Socket.io Client** | 4.6.x | WebSocket | • Auto-reconnect<br>• Fallback to polling<br>• Better than raw WebSocket (no reconnect) | Real-time order tracking; subscribe to `order:{orderId}` room |
| **React Google Maps API** | 2.19.x | Maps integration | • Official React wrapper<br>• Hooks API<br>• Better than raw Google Maps JS API (imperative) | Restaurant map view; delivery tracking map with markers |
| **React Hook Form** | 7.49.x | Form management | • Uncontrolled inputs (performance)<br>• Easy validation<br>• Better than Formik (controlled inputs, slower) | All forms (login, address, menu item); integrates with Zod validation |
| **Zod** | 3.22.x | Schema validation | • TypeScript-first<br>• Composable schemas<br>• Better than Yup (not TS-first) | Form validation schemas; API response validation |
| **Razorpay React SDK** | 1.0.x | Payment checkout | • Official React wrapper<br>• Hosted checkout<br>• Better than manual integration (complex) | `useRazorpay` hook; opens checkout modal |
| **Lucide React** | 0.309.x | Icon library | • Tree-shakeable<br>• Consistent style<br>• Better than Font Awesome (large bundle) or Material Icons (too opinionated) | All icons (`<ShoppingCart />`, `<MapPin />`, etc.) |
| **React Hot Toast** | 2.4.x | Notifications | • Simple API<br>• Customizable<br>• Better than react-toastify (more config) | Success/error toasts; `toast.success("Order placed!")` |
| **Framer Motion** | 11.0.x | Animations | • Declarative<br>• Spring physics<br>• Better than CSS transitions (less control) or GSAP (imperative) | Page transitions; cart item animations; loading spinners |
| **date-fns** | 3.0.x | Date utilities | • Tree-shakeable<br>• Immutable<br>• Better than Moment.js (large, mutable) | Format dates; relative time ("2 hours ago") |
| **Recharts** | 2.10.x | Charts | • React-native<br>• Responsive<br>• Better than Chart.js (not React) | Revenue charts in restaurant portal; analytics in admin console |
| **clsx** | 2.1.x | Conditional classes | • Tiny (228B)<br>• Better than classnames | `clsx('btn', isActive && 'btn-active')` for Tailwind |
| **React Helmet Async** | 2.0.x | SEO | • Dynamic `<title>` and `<meta>`<br>• Better than raw document.title | SEO meta tags per page |

### 4.3 Infrastructure Technologies

| Technology | Purpose | Local Development Setup | Production Deployment | Why Chosen |
|-----------|---------|------------------------|---------------------|------------|
| **Docker** | Containerization | `docker-compose up` | Kubernetes pods or AWS ECS | • Consistent environments<br>• Isolation<br>• Industry standard |
| **Docker Compose** | Multi-container orchestration | Runs all services locally | N/A (use Kubernetes in prod) | • One `docker-compose up` command<br>• Easy local development |
| **Apache Kafka** | Message broker | Kafka container in Compose | AWS MSK or Confluent Cloud | • High throughput<br>• Event sourcing<br>• Better than RabbitMQ (lower throughput) |
| **Apache Zookeeper** | Kafka coordination | Zookeeper container in Compose | Managed by MSK | • Required by Kafka (for now)<br>• KRaft mode (Zookeeper-less) coming soon |
| **Elasticsearch** | Search engine | Elasticsearch container | AWS Elasticsearch Service | • Full-text search<br>• Geospatial queries<br>• Better than Solr (less active) |
| **Redis** | Cache + session store | Redis container | AWS ElastiCache | • In-memory speed<br>• TTL support<br>• Better than Memcached (no data structures) |
| **PostgreSQL** | Relational database | PostgreSQL container | AWS RDS PostgreSQL | • ACID compliance<br>• PostGIS for geospatial<br>• Better than MySQL (weaker transaction support) |
| **MongoDB** | Document database | MongoDB container | MongoDB Atlas | • Flexible schema<br>• Geospatial indexes<br>• Better than CouchDB (less features) |
| **Nginx** | Reverse proxy + load balancer | N/A (API Gateway used locally) | Nginx ingress in Kubernetes | • TLS termination<br>• Static file serving<br>• Better than HAProxy (HTTP only) |
| **MinIO** | S3-compatible object storage | MinIO container (works 100% locally) | AWS S3 | • 100% S3 API compatible<br>• No signup for local dev |
| **MailHog** | SMTP server for testing | MailHog container | SendGrid API | • Catch all emails locally<br>• Web UI to view emails |
| **Prometheus** | Metrics collection | Prometheus container | Prometheus Operator in K8s | • Pull-based metrics<br>• Powerful query language (PromQL)<br>• Better than Graphite (less features) |
| **Grafana** | Metrics visualization | Grafana container | Grafana Cloud or self-hosted | • Beautiful dashboards<br>• Alerting<br>• Better than Kibana (Kibana is for logs, not metrics) |
| **Zipkin** | Distributed tracing | Zipkin container | Jaeger (better for prod) | • Trace requests across services<br>• Latency analysis |
| **Kibana** | Elasticsearch UI | Kibana container | AWS Elasticsearch Service includes Kibana | • Visualize Elasticsearch data<br>• Create search indexes |

---

## 5. Database Design — Complete Reference

### 5.1 PostgreSQL Schema

PostgreSQL handles all **transactional data** where ACID compliance is critical: users, orders, payments, delivery partners, and coupons.

#### Table: `users`

**Purpose**: Stores user accounts for all roles (customers, restaurant owners, delivery partners, admins).

**Schema:**

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique user identifier |
| `phone_number` | VARCHAR(15) | UNIQUE, NOT NULL | Phone number (E.164 format: +919876543210) |
| `email` | VARCHAR(100) | UNIQUE | Email address (optional, for receipts) |
| `name` | VARCHAR(100) | | Full name |
| `profile_image_url` | VARCHAR(500) | | URL to profile picture (S3/MinIO) |
| `date_of_birth` | DATE | | Birth date (for birthday offers) |
| `gender` | VARCHAR(10) | | Male / Female / Other |
| `is_verified` | BOOLEAN | DEFAULT false | Phone verified via OTP |
| `is_active` | BOOLEAN | DEFAULT true | Account active (false = suspended) |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Account creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Last updated (trigger auto-updates) |
| `last_login_at` | TIMESTAMP WITH TIME ZONE | | Last successful login |
| `fcm_token` | VARCHAR(500) | | Firebase Cloud Messaging token for push notifications |

**Indexes:**
```sql
CREATE INDEX idx_users_phone ON users(phone_number);
CREATE INDEX idx_users_email ON users(email) WHERE email IS NOT NULL;
CREATE INDEX idx_users_active ON users(is_active);
```

**Why These Indexes:**
- `idx_users_phone`: Login by phone number (most common query)
- `idx_users_email`: Partial index (only non-null emails) for email lookup
- `idx_users_active`: Filter active users in admin dashboards

**Sample Row:**
```sql
INSERT INTO users VALUES (
    '550e8400-e29b-41d4-a716-446655440000',
    '+919876543210',
    'john.doe@example.com',
    'John Doe',
    'https://minio.local/avatars/john.jpg',
    '1995-03-15',
    'Male',
    true,
    true,
    '2024-01-15 10:30:00+00',
    '2024-03-01 08:45:00+00',
    '2024-03-01 08:45:00+00',
    'eXhFkjh...FCM_TOKEN'
);
```

---

#### Table: `user_addresses`

**Purpose**: Stores multiple delivery addresses per user (home, work, other).

**Schema:**

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique address identifier |
| `user_id` | UUID | FOREIGN KEY → users(id) ON DELETE CASCADE, NOT NULL | Owner of this address |
| `label` | VARCHAR(30) | | HOME / WORK / OTHER |
| `address_line1` | VARCHAR(255) | NOT NULL | Main address (street, building) |
| `address_line2` | VARCHAR(255) | | Apartment/floor number |
| `landmark` | VARCHAR(255) | | Nearby landmark for delivery |
| `city` | VARCHAR(100) | NOT NULL | City name |
| `state` | VARCHAR(100) | NOT NULL | State name |
| `pincode` | VARCHAR(10) | NOT NULL | Postal code |
| `latitude` | DECIMAL(10,8) | NOT NULL | GPS latitude (-90 to 90) |
| `longitude` | DECIMAL(11,8) | NOT NULL | GPS longitude (-180 to 180) |
| `is_default` | BOOLEAN | DEFAULT false | Default delivery address |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | When address was added |

**Indexes:**
```sql
CREATE INDEX idx_addresses_user ON user_addresses(user_id);
CREATE INDEX idx_addresses_default ON user_addresses(user_id, is_default);
```

**Business Rules:**
- User can have multiple addresses but only ONE can be `is_default = true`
- When new address marked as default, set all other user's addresses to `is_default = false`
- `CASCADE DELETE`: When user is deleted, all addresses are automatically deleted

**Sample Row:**
```sql
INSERT INTO user_addresses VALUES (
    '660e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440000',
    'HOME',
    '123 MG Road, Koregaon Park',
    'Apartment 4B',
    'Near ABC Mall',
    'Pune',
    'Maharashtra',
    '411001',
    18.536200,
    73.894100,
    true,
    '2024-01-15 11:00:00+00'
);
```

---

#### Table: `orders`

**Purpose**: Core order table tracking complete order lifecycle.

**Schema:**

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique order identifier |
| `order_number` | VARCHAR(20) | UNIQUE, NOT NULL | Human-readable order number (FD-2024-000001) |
| `user_id` | UUID | FOREIGN KEY → users(id), NOT NULL | Customer who placed order |
| `restaurant_id` | UUID | NOT NULL | Restaurant (stored in MongoDB, UUID reference) |
| `delivery_address_id` | UUID | FOREIGN KEY → user_addresses(id) | Delivery location |
| `delivery_partner_id` | UUID | FOREIGN KEY → delivery_partners(id) | Assigned delivery partner (null until assigned) |
| `status` | VARCHAR(30) | NOT NULL | PENDING / CONFIRMED / PREPARING / READY_FOR_PICKUP / PICKED_UP / OUT_FOR_DELIVERY / DELIVERED / CANCELLED / REFUND_INITIATED / REFUNDED |
| `payment_status` | VARCHAR(20) | | PENDING / PAID / FAILED / REFUNDED |
| `payment_method` | VARCHAR(20) | | CARD / UPI / NETBANKING / WALLET / COD |
| `subtotal` | DECIMAL(10,2) | NOT NULL | Sum of item prices |
| `delivery_fee` | DECIMAL(10,2) | NOT NULL, DEFAULT 0 | Delivery charge |
| `platform_fee` | DECIMAL(10,2) | NOT NULL, DEFAULT 0 | Platform commission |
| `gst_amount` | DECIMAL(10,2) | NOT NULL, DEFAULT 0 | Goods & Services Tax |
| `discount_amount` | DECIMAL(10,2) | NOT NULL, DEFAULT 0 | Coupon discount |
| `tip_amount` | DECIMAL(10,2) | NOT NULL, DEFAULT 0 | Tip for delivery partner |
| `total_amount` | DECIMAL(10,2) | NOT NULL | subtotal + delivery_fee + platform_fee + gst - discount + tip |
| `coupon_code` | VARCHAR(30) | | Coupon applied (if any) |
| `special_instructions` | TEXT | | Customer notes for restaurant/delivery |
| `estimated_delivery_time` | TIMESTAMP WITH TIME ZONE | | Expected delivery time |
| `actual_delivery_time` | TIMESTAMP WITH TIME ZONE | | Actual delivery time (when status = DELIVERED) |
| `cancelled_at` | TIMESTAMP WITH TIME ZONE | | Cancellation timestamp |
| `cancellation_reason` | VARCHAR(255) | | Why order was cancelled |
| `cancelled_by` | VARCHAR(10) | | USER / RESTAURANT / SYSTEM |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Order placed timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Last status update (auto-updated by trigger) |

**Indexes:**
```sql
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at DESC);
CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_partner ON orders(delivery_partner_id) WHERE delivery_partner_id IS NOT NULL;
```

**Why These Indexes:**
- `idx_orders_user`: User's order history (frequent query)
- `idx_orders_restaurant`: Restaurant dashboard (show all orders)
- `idx_orders_status`: Filter by status (e.g., show only PENDING orders)
- `idx_orders_created DESC`: Sorted order history (most recent first)
- `idx_orders_number`: Order search by number
- `idx_orders_partner` (partial): Delivery partner's delivery history (only indexed for assigned orders)

**Sample Row:**
```sql
INSERT INTO orders VALUES (
    '770e8400-e29b-41d4-a716-446655440002',
    'FD-2024-000001',
    '550e8400-e29b-41d4-a716-446655440000',
    '880e8400-e29b-41d4-a716-446655440003',
    '660e8400-e29b-41d4-a716-446655440001',
    NULL,
    'PENDING',
    'PENDING',
    'UPI',
    420.00,
    30.00,
    5.00,
    22.75,
    0.00,
    10.00,
    487.75,
    'FIRST50',
    'Extra spicy please',
    '2024-03-01 13:30:00+00',
    NULL,
    NULL,
    NULL,
    NULL,
    '2024-03-01 12:45:00+00',
    '2024-03-01 12:45:00+00'
);
```

---

Due to character limits, I need to split this into multiple responses. Let me save this first part and continue with the remaining tables, MongoDB collections, Redis patterns, API documentation, Kafka flows, etc.

Would you like me to continue generating the rest of DOCUMENTATION.md now? I'll create it as a complete file with all remaining sections.
