# 🔑 Demo Credentials & Test Data

## Customer Accounts

| Phone | OTP | Email | Password | Has Orders | Saved Addresses |
|-------|-----|-------|----------|------------|----------------|
| +91-9000000001 | 123456 | customer1@test.com | N/A | Yes (5 orders) | 2 (Home, Work) |
| +91-9000000002 | 123456 | customer2@test.com | N/A | Yes (2 orders) | 1 (Home) |
| +91-9000000003 | 123456 | customer3@test.com | N/A | No | 0 |
| +91-9000000004 | 123456 | customer4@test.com | N/A | Yes (10 orders) | 3 |
| +91-9000000005 | 123456 | customer5@test.com | N/A | Yes (1 order) | 1 |

**Test Flow:**
1. Open http://localhost:3000
2. Enter phone: `+91-9000000001`
3. Click "Send OTP"
4. Enter OTP: `123456`
5. Login successful

---

## Restaurant Owner Accounts

| Phone | OTP | Email | Restaurant Name | Status |
|-------|-----|-------|-----------------|--------|
| +91-9100000001 | 123456 | owner1@test.com | Biryani House | ACTIVE |
| +91-9100000002 | 123456 | owner2@test.com | Pizza Paradise | ACTIVE |
| +91-9100000003 | 123456 | owner3@test.com | Wok This Way | ACTIVE |
| +91-9100000004 | 123456 | owner4@test.com | The Burger Lab | PENDING_APPROVAL |

**Test Flow:**
1. Open http://localhost:3001
2. Login with `+91-9100000001` / OTP `123456`
3. View incoming orders in real-time

---

## Delivery Partner Accounts

| Phone | OTP | Email | Name | Vehicle | KYC Status | Total Deliveries |
|-------|-----|-------|------|---------|------------|------------------|
| +91-9200000001 | 123456 | partner1@test.com | Vijay Singh | MOTORBIKE | VERIFIED | 342 |
| +91-9200000002 | 123456 | partner2@test.com | Rahul Kumar | BICYCLE | VERIFIED | 156 |
| +91-9200000003 | 123456 | partner3@test.com | Amit Sharma | MOTORBIKE | PENDING | 0 |

**Test Flow:**
1. Open http://localhost:3002
2. Login with `+91-9200000001` / OTP `123456`
3. Toggle "Go Online"
4. Wait for order assignment notification

---

## Admin Account

| Phone | OTP | Email | Role |
|-------|-----|-------|------|
| +91-9300000001 | 123456 | admin@foodflow.com | ADMIN |

**Test Flow:**
1. Open http://localhost:3003
2. Login with `+91-9300000001` / OTP `123456`
3. Access:
   - Approve pending restaurants
   - Manage coupons
   - View platform analytics

---

## Razorpay Test Payment Methods

### Credit/Debit Cards

| Card Number | CVV | Expiry | Expected Result |
|-------------|-----|--------|----------------|
| 4111 1111 1111 1111 | 123 | 12/25 | SUCCESS |
| 5104 0155 5555 5558 | 123 | 12/25 | SUCCESS (Mastercard) |
| 4012 0010 3714 1112 | 123 | 12/25 | FAILED (Insufficient Funds) |

### UPI

| UPI ID | Result |
|--------|--------|
| success@razorpay | SUCCESS |
| failure@razorpay | FAILED |

### Net Banking

Select "ICICI Bank" → Use test credentials provided by Razorpay

---

## Infrastructure Service Credentials

| Service | URL | Username | Password | Notes |
|---------|-----|----------|----------|-------|
| Eureka Server | http://localhost:8761 | N/A | N/A | Service registry |
| Kafka UI | http://localhost:8090 | N/A | N/A | Topic management |
| MinIO Console | http://localhost:9001 | minioadmin | minioadmin | S3-compatible storage |
| MailHog | http://localhost:8025 | N/A | N/A | Email inbox |
| Prometheus | http://localhost:9090 | N/A | N/A | Metrics |
| Grafana | http://localhost:3004 | admin | admin | Dashboards |
| Zipkin | http://localhost:9411 | N/A | N/A | Distributed tracing |
| Kibana | http://localhost:5601 | N/A | N/A | Elasticsearch UI |

---

## Seed Data

### Restaurants

**10 restaurants** pre-seeded in Pune:

1. **Biryani House** (Koregaon Park) - North Indian, 4.3⭐, ₹299 avg
2. **Pizza Paradise** (Baner) - Italian, 4.5⭐, ₹399 avg
3. **Wok This Way** (Viman Nagar) - Chinese, 4.0⭐, ₹249 avg
4. **The Burger Lab** (Aundh) - American, 4.3⭐, ₹199 avg
5. **South Spice** (Kothrud) - South Indian, 4.4⭐, ₹149 avg
6. **Sushi Sensei** (Kalyani Nagar) - Japanese, 4.6⭐, ₹799 avg
7. **Thali House** (Pimpri) - Gujarati (Pure Veg), 4.1⭐, ₹179 avg
8. **Cafe Mocha** (FC Road) - Cafe, 4.7⭐, ₹249 avg
9. **Street Bites** (Hadapsar) - Fast Food, 3.9⭐, ₹129 avg
10. **Continental Kitchen** (Magarpatta) - Continental, 4.5⭐, ₹449 avg

### Active Coupons

| Code | Discount | Min Order | Valid Until | Uses Left |
|------|----------|-----------|-------------|----------|
| WELCOME50 | 50% off up to ₹100 | ₹199 | 30 days | Unlimited |
| SAVE50 | Flat ₹50 off | ₹299 | 7 days | 1000 |
| FREEDEL | Free Delivery | ₹0 | 14 days | Unlimited |
| FIRST100 | Flat ₹100 off | ₹399 | 60 days | 1 per user |

### Sample Orders

**20 orders** across various statuses for testing order tracking:

- 5 DELIVERED orders (with reviews)
- 3 CANCELLED orders (different cancellation reasons)
- 2 OUT_FOR_DELIVERY orders (for live tracking test)
- 5 PREPARING orders
- 5 PENDING orders

---

## Testing Scenarios

### Scenario 1: Complete Order Flow

1. Login as Customer 1
2. Search "Biryani"
3. Select "Biryani House"
4. Add "Chicken Biryani" to cart (customizations: Large, Extra Spicy)
5. Apply coupon: `SAVE50`
6. Place order
7. Pay with card: `4111 1111 1111 1111`
8. Track order in real-time

### Scenario 2: Restaurant Management

1. Login as Restaurant Owner 1 (Biryani House)
2. View new incoming order
3. Accept order (prep time: 20 mins)
4. Mark as "Preparing"
5. Mark as "Ready for Pickup"
6. See delivery partner assigned

### Scenario 3: Delivery Partner

1. Login as Delivery Partner 1
2. Go online
3. Receive order assignment notification
4. Accept order
5. Navigate to restaurant (click "Navigate")
6. Mark "Picked Up"
7. Navigate to customer
8. Mark "Delivered"
9. View earnings updated

### Scenario 4: Admin Actions

1. Login as Admin
2. View pending restaurant (The Burger Lab)
3. Review documents
4. Approve restaurant
5. Create new coupon: `WEEKEND20`
6. View platform analytics

---

## Reset Test Data

```bash
# Reset all databases to seed state
make reset-db

# Or manually:
docker exec -i foodflow-postgres psql -U fooddelivery -d fooddelivery -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
docker exec -i foodflow-postgres psql -U fooddelivery -d fooddelivery < scripts/init-postgres.sql

docker exec -i foodflow-mongodb mongosh fooddelivery --eval "db.dropDatabase()"
docker exec -i foodflow-mongodb mongosh fooddelivery < scripts/init-mongo.js

docker exec -i foodflow-redis redis-cli FLUSHALL
```

---

**Next:** See API_REFERENCE.md for testing endpoints with curl/Postman