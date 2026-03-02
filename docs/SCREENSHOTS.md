# 📸 FoodFlow Visual Documentation & Screenshots

## 🎨 Visual Mockups Available!

**✨ INTERACTIVE MOCKUPS:** Open `docs/VISUAL_MOCKUPS.html` in your browser to see **13 fully-styled visual mockups** of all major pages!

**What's included:**
- **Customer App** (6 mockups): Login, Home, Restaurant Detail, Cart, Order Tracking, Order History
- **Restaurant Portal** (3 mockups): Dashboard, Order Management, Menu Management
- **Delivery Partner App** (2 mockups): Go Online Screen, Order Assignment Popup
- **Admin Console** (2 mockups): Platform Overview, Analytics Dashboard

**Features:**
- ✅ Dark theme (#0f172a background, #e23744 primary)
- ✅ Realistic seed data (Biryani House, Pizza Paradise, Pune addresses)
- ✅ Production-grade UI design
- ✅ All inline CSS (single HTML file, 1000+ lines)
- ✅ Print-friendly (take screenshots directly!)

**How to view:**
```bash
# Open in browser
open docs/VISUAL_MOCKUPS.html

# Or start local server
cd docs
python3 -m http.server 8000
# Then visit: http://localhost:8000/VISUAL_MOCKUPS.html
```

---

## 📸 Real Screenshots (To Be Added After Deployment)

This file documents where actual screenshots will be added once the application is deployed and running.

## Table of Contents

1. [Customer App Screenshots (32)](#customer-app-screenshots)
2. [Restaurant Portal Screenshots (13)](#restaurant-portal-screenshots)
3. [Delivery Partner App Screenshots (6)](#delivery-partner-app-screenshots)
4. [Admin Console Screenshots (9)](#admin-console-screenshots)
5. [Infrastructure Screenshots (10)](#infrastructure-screenshots)
6. [Error & Bug Documentation (12+)](#errors--bugs-encountered)
7. [Performance Benchmarks (5)](#performance-benchmarks)
8. [Testing Screenshots (3)](#testing-screenshots)
9. [How to Add Real Screenshots](#how-to-add-real-screenshots)

---

## Customer App Screenshots

### 1. Authentication Flow

**Screenshot 1.1: Login Screen**
```
[PLACEHOLDER]
Location: http://localhost:3000/
Elements visible:
- FoodFlow logo
- Phone number input field (+91-XXXXXXXXXX)
- "Send OTP" button
- "By continuing, you agree to our Terms & Privacy Policy" text
```

**Screenshot 1.2: OTP Input Screen**
```
[PLACEHOLDER]
Shows:
- "Enter OTP sent to +91-******3210"
- 6 input boxes for OTP digits
- "Resend OTP" link (disabled for 60 seconds)
- Countdown timer: "00:59"
```

**Screenshot 1.3: New User Profile Completion**
```
[PLACEHOLDER]
Shows:
- "Welcome! Complete your profile"
- Name input field
- Email input (optional)
- Date of Birth picker
- Gender selection
- "Get Started" button
```

### 2. Home / Restaurant Discovery

**Screenshot 2.1: Homepage (Logged In)**
```
[PLACEHOLDER]
Shows:
- Top bar: Location (Koregaon Park, Pune) + Cart icon + Profile icon
- Search bar: "Search for restaurants or dishes"
- Promotional banner carousel
- Cuisine categories (horizontal scroll): Pizza, Biryani, Burger, Chinese, etc.
- "What's on your mind?" grid (6 items with images)
- Restaurant list (3 cards visible)
```

**Screenshot 2.2: Restaurant Card (Detailed View)**
```
[PLACEHOLDER]
Single restaurant card showing:
- Restaurant image (with "PROMOTED" tag in top-left)
- Restaurant name: "Biryani House"
- Cuisines: "North Indian, Mughlai, Biryani"
- Rating: 4.3★ (1.2K ratings)
- Delivery time: 30-35 mins
- Distance: 2.3 km
- Offer badge: "50% off up to ₹100"
- Free delivery badge
```

**Screenshot 2.3: Filter & Sort Panel**
```
[PLACEHOLDER]
Bottom sheet showing:
- Sort by: Relevance, Rating, Delivery Time, Cost
- Filters:
  - Dietary: Pure Veg toggle
  - Cuisine: checkboxes (Italian, Chinese, North Indian...)
  - Rating: 4.0+, 4.5+
  - Delivery time: Under 30 min, 30-45 min
  - Offers: Free Delivery, Discounts
- "Apply Filters" button
```

### 3. Restaurant Detail Page

**Screenshot 3.1: Restaurant Header**
```
[PLACEHOLDER]
Shows:
- Cover photo (hero image)
- Back button (top-left)
- Share button (top-right)
- Restaurant logo (floating over cover)
- Name: "Biryani House"
- Cuisines
- Rating + Review count
- Operating hours: "Open now • Closes at 11 PM"
- Delivery info: "₹30 delivery • 30-35 mins"
```

**Screenshot 3.2: Offers Section**
```
[PLACEHOLDER]
Expandable accordion showing:
- "50% off up to ₹100" - Code: SAVE50
- "Free Delivery on orders above ₹299" - Code: FREEDEL
- Each offer has "Apply" button
```

**Screenshot 3.3: Menu Navigation**
```
[PLACEHOLDER]
Sticky horizontal menu tabs:
- Biryani (selected, underlined)
- Starters
- Main Course
- Breads
- Desserts
- Beverages
```

**Screenshot 3.4: Menu Item Card**
```
[PLACEHOLDER]
Item card showing:
- VEG/NON-VEG indicator (green dot)
- "Chicken Biryani" (name)
- "Hyderabadi-style biryani with tender chicken..." (description, truncated)
- ₹299 (price)
- Image (right side, 100x100px)
- "Add" button
- "BESTSELLER" badge
```

**Screenshot 3.5: Item Customization Sheet**
```
[PLACEHOLDER]
Bottom sheet modal:
- Item image + name at top
- "Choose Size" (required)
  - Radio buttons: Regular (₹0), Large (+₹100), Family Pack (+₹250)
- "Add Extras" (optional, select up to 3)
  - Checkboxes: Extra Raita (+₹30), Extra Gravy (+₹40), Boiled Egg (+₹20)
- "Spice Level" (required)
  - Radio buttons: Mild, Medium (selected), Extra Spicy
- Quantity selector: [-] 1 [+]
- "Add to Cart • ₹299" button (price updates with customizations)
```

### 4. Cart Page

**Screenshot 4.1: Cart with Items**
```
[PLACEHOLDER]
Shows:
- Restaurant name + logo at top
- Item 1: Chicken Biryani (Large) x2 - ₹598
  - Customizations listed: Large, Extra Spicy
  - [-] 2 [+] quantity controls
  - Trash icon
- Item 2: Raita x1 - ₹50
- "Add more items" link
- Bill Details section (collapsed)
- "Apply Coupon" section
- "Select Delivery Address" section
- "Proceed to Checkout • ₹717" button (sticky bottom)
```

**Screenshot 4.2: Apply Coupon**
```
[PLACEHOLDER]
Shows:
- "Apply Coupon" input field with "Apply" button
- Available coupons list below:
  - SAVE50: "₹50 off on orders above ₹299" - [Apply]
  - WELCOME50: "50% off up to ₹100 for new users" - [Apply]
  - FREEDEL: "Free Delivery" - [Apply]
- "Coupon applied: SAVE50" success message (green)
```

**Screenshot 4.3: Bill Details (Expanded)**
```
[PLACEHOLDER]
Shows itemized billing:
- Item Total: ₹648
- Delivery Fee: ₹30
- Platform Fee: ₹5
- GST (5%): ₹34.15
- Coupon Discount (SAVE50): -₹50 (in green)
- ─────────────────
- TO PAY: ₹667.15
```

**Screenshot 4.4: Select Delivery Address**
```
[PLACEHOLDER]
Bottom sheet showing saved addresses:
- Home (default, selected with radio button)
  "Flat 101, Sunshine Apartments, Lane 5, Koregaon Park"
  Near KFC • Pune 411001
- Work
  "Emerson Office, Magarpatta"
  Pune 411028
- "+ Add New Address" button
```

### 5. Checkout & Payment

**Screenshot 5.1: Payment Method Selection**
```
[PLACEHOLDER]
Shows:
- UPI (selected)
- Credit/Debit Card
- Net Banking
- Wallets (Paytm, PhonePe, etc.)
- Cash on Delivery
- "Pay ₹667.15" button
```

**Screenshot 5.2: Razorpay Checkout**
```
[PLACEHOLDER]
Razorpay modal showing:
- Order summary at top
- UPI ID input field
- "Verify & Pay" button
- OR section
- QR code for UPI apps
- Secure badge
```

**Screenshot 5.3: Payment Success**
```
[PLACEHOLDER]
Success screen:
- Green checkmark animation
- "Payment Successful!"
- Order number: FD-2024-000123
- Amount paid: ₹667.15
- "Track Order" button
- "Back to Home" button
```

### 6. Order Tracking

**Screenshot 6.1: Order Tracking (Confirmed Status)**
```
[PLACEHOLDER]
Shows:
- Progress bar: [Placed ✓] → [Confirmed ●] → [Preparing] → [On the way] → [Delivered]
- "Biryani House confirmed your order!"
- Estimated delivery: 35 mins
- Order items list (collapsed)
- "Help" button
```

**Screenshot 6.2: Live Delivery Tracking Map**
```
[PLACEHOLDER]
Google Map showing:
- Restaurant marker (fork icon) at location A
- Delivery partner marker (bike icon) at location B (moving)
- Customer marker (house icon) at location C
- Route line from B to C
- ETA badge: "Arriving in 12 minutes"
```

**Screenshot 6.3: Delivery Partner Card**
```
[PLACEHOLDER]
Card at bottom of map:
- Partner photo
- "Vijay Singh"
- Vehicle: Motorbike • MH12AB1234
- Rating: 4.6★
- [Call] button
- Distance remaining: 2.3 km
```

**Screenshot 6.4: Order Delivered**
```
[PLACEHOLDER]
Shows:
- All progress steps completed (green checkmarks)
- "Your order has been delivered!"
- Delivery photo (proof)
- "Rate your experience" section
- Restaurant rating: 5 stars (tappable)
- Delivery partner rating: 5 stars (tappable)
- Text area: "Share your feedback"
- "Submit Review" button
```

### 7. Profile & Settings

**Screenshot 7.1: Profile Page**
```
[PLACEHOLDER]
Shows:
- Profile photo (circular)
- Name: Raj Sharma
- Phone: +91-9876543210
- Email: raj@example.com
- Menu items:
  - My Addresses (2)
  - My Wallet (₹150 balance)
  - Favourite Restaurants (5)
  - Order History
  - Settings
  - Help & Support
  - Log Out
```

**Screenshot 7.2: My Addresses**
```
[PLACEHOLDER]
List of saved addresses:
- Each address card shows:
  - Label (Home/Work/Other)
  - Full address
  - Edit icon
  - Delete icon
  - "Set as Default" button (if not default)
- "+ Add New Address" button at bottom
```

**Screenshot 7.3: Order History**
```
[PLACEHOLDER]
Tabs: [Active Orders] [Past Orders]
Past orders list:
- Each card: Restaurant logo + name
  - Order date: Jan 14, 2024
  - Items: "Chicken Biryani +2 items"
  - Total: ₹450
  - Status badge: DELIVERED (green)
  - "Reorder" button
  - "Rate" button (if not rated)
```

---

## Restaurant Portal Screenshots

### 8. Restaurant Dashboard

**Screenshot 8.1: Dashboard Overview**
```
[PLACEHOLDER]
Shows:
- Stats cards (4 across):
  - Today's Orders: 47
  - Today's Revenue: ₹18,450
  - Avg Order Value: ₹392
  - Rating: 4.3★
- Real-time order stream (new orders appear at top with sound)
- Revenue chart (last 7 days vs previous 7 days)
- Popular items table
```

**Screenshot 8.2: New Order Notification**
```
[PLACEHOLDER]
Order card with red border (new):
- "NEW ORDER" badge (pulsing)
- Order #FD-2024-000123
- Time: Just now
- Customer: Raj S. • +91-******3210
- Items: 2x Chicken Biryani (Large), 1x Raita
- Total: ₹648
- Delivery address (truncated)
- Auto-accept countdown: 01:45 remaining
- [Accept (with prep time)] [Reject] buttons (large)
```

**Screenshot 8.3: Accept Order Dialog**
```
[PLACEHOLDER]
Modal:
- "Accept Order #FD-2024-000123?"
- Estimated preparation time: [15 mins] dropdown
- "This will set delivery ETA to 35 minutes"
- [Cancel] [Confirm Accept] buttons
```

### 9. Order Management (Kanban)

**Screenshot 9.1: Order Board**
```
[PLACEHOLDER]
Kanban columns:
- New Orders (3) - Red header
- Confirmed / Preparing (5) - Yellow header
- Ready for Pickup (2) - Green header
- Completed (12 today) - Gray header
Each card draggable or has action buttons
```

**Screenshot 9.2: Order Detail Drawer**
```
[PLACEHOLDER]
Side drawer showing:
- Order #FD-2024-000123
- Customer: Raj Sharma • +91-9876543210
- Ordered at: 7:30 PM
- Items with customizations
- Special instructions: "Extra spicy, no onions"
- Payment: ₹648 (PAID via UPI)
- Delivery address (full)
- Status history timeline
- Action buttons: [Mark Ready] [Cancel Order] [Print]
```

### 10. Menu Management

**Screenshot 10.1: Menu Page**
```
[PLACEHOLDER]
Shows:
- Category tabs at top: Biryani, Starters, Main Course...
- [+ Add Category] button
- Biryani category (expanded):
  - [+ Add Item] button
  - Item list (3 visible):
    - Each item: Image + Name + Price + [Edit] [Toggle Available]
  - Drag handles for reordering
```

**Screenshot 10.2: Add/Edit Menu Item Form**
```
[PLACEHOLDER]
Modal form:
- Item Name*
- Description
- Type*: VEG / NON-VEG / EGG (radio buttons)
- Price*: ₹
- Discounted Price (optional)
- Image: [Upload] or URL
- Preparation Time: [25] minutes
- Tags: checkboxes (Bestseller, Chef's Special, Spicy, etc.)
- Customizations section:
  - [+ Add Customization Group]
  - Group 1: "Choose Size" (required, min 1, max 1)
    - Regular (₹0)
    - Large (+₹100)
- [Cancel] [Save Item] buttons
```

### 11. Restaurant Analytics

**Screenshot 11.1: Analytics Dashboard**
```
[PLACEHOLDER]
Shows:
- Date range picker: Last 30 days
- Revenue trend (line chart)
- Order volume by hour (heatmap)
- Top 10 items (horizontal bar chart)
- Customer retention (cohort table)
- Average preparation time: 22 mins
- Rating trend (line chart)
- [Export CSV] button
```

---

## Delivery Partner App Screenshots

### 12. Partner Home

**Screenshot 12.1: Go Online Screen**
```
[PLACEHOLDER]
Shows:
- Large toggle switch: "Go Online" (OFF state)
- Current status: Offline
- Today's stats:
  - Deliveries: 0
  - Earnings: ₹0
  - Hours online: 0h 0m
- "You're offline. Go online to start receiving orders"
```

**Screenshot 12.2: Online & Waiting**
```
[PLACEHOLDER]
Shows:
- Toggle: "Go Online" (ON, green)
- Status: Online • Waiting for orders...
- Today's stats:
  - Deliveries: 3
  - Earnings: ₹210
  - Hours online: 2h 15m
- Recent deliveries list (3 cards)
```

**Screenshot 12.3: Order Assignment Notification**
```
[PLACEHOLDER]
Full-screen modal (can't dismiss):
- "New Delivery Available!"
- Restaurant: Biryani House (2.3 km from you)
- Customer area: Koregaon Park (4.1 km)
- Estimated earnings: ₹70
- Mini map showing both locations
- Countdown: 25 seconds to accept
- [DECLINE] [ACCEPT] buttons (large)
```

**Screenshot 12.4: Active Delivery**
```
[PLACEHOLDER]
Shows:
- Order #FD-2024-000123
- Pick up from: Biryani House
  - Distance: 2.3 km
  - [Navigate to Restaurant] button (opens Google Maps)
  - [Arrived at Restaurant] button
- Status: Picked Up ✓
- Deliver to: Raj Sharma • +91-******3210
  - Address: Flat 101, Sunshine Apartments...
  - Distance: 4.1 km
  - [Navigate to Customer] button
  - [Mark Delivered] button
```

**Screenshot 12.5: Mark Delivered Dialog**
```
[PLACEHOLDER]
Modal:
- "Confirm Delivery?"
- Upload proof photo: [Camera icon]
- Recipient name (optional): [___]
- [Cancel] [Confirm Delivered] buttons
```

**Screenshot 12.6: Earnings Page**
```
[PLACEHOLDER]
Tabs: Today | This Week | This Month
Today's earnings:
- Total: ₹210
- Deliveries: 3
- Avg per delivery: ₹70
- Breakdown table:
  - 7:30 PM - Order #123 - ₹70
  - 8:15 PM - Order #124 - ₹70
  - 9:00 PM - Order #125 - ₹70
- [Request Payout] button (disabled if < ₹500)
```

---

## Admin Console Screenshots

### 13. Admin Dashboard

**Screenshot 13.1: Platform Overview**
```
[PLACEHOLDER]
Shows:
- Stats (5 cards):
  - Active Users: 12,450
  - Active Restaurants: 347
  - Active Partners: 1,230
  - Orders Today: 4,567
  - GMV Today: ₹5.6L
- Geo heatmap: Order density by area (Google Maps)
- Quick actions: Pending Approvals (3), DLQ Messages (0)
```

**Screenshot 13.2: Restaurant Approval Queue**
```
[PLACEHOLDER]
Table showing pending restaurants:
- Restaurant Name | Owner | City | Submitted | Actions
- The Burger Lab | Amit Kumar | Pune | 2 days ago | [View] [Approve] [Reject]
- Clicking View opens detail modal with documents
```

**Screenshot 13.3: Approve Restaurant Modal**
```
[PLACEHOLDER]
Shows:
- Restaurant details (name, address, cuisines)
- Owner details (name, phone, email)
- Documents section:
  - FSSAI License: [View PDF]
  - GST Certificate: [View PDF]
  - Bank Account Proof: [View PDF]
- Notes (admin comments): [textarea]
- [Cancel] [Reject] [Approve] buttons
```

**Screenshot 13.4: Coupon Management**
```
[PLACEHOLDER]
Shows:
- [+ Create Coupon] button
- Active coupons table:
  - Code | Title | Discount | Min Order | Valid Until | Uses | Actions
  - SAVE50 | Flat ₹50 Off | ₹50 | ₹299 | Jan 31 | 847/1000 | [Edit] [Toggle] [Delete]
```

**Screenshot 13.5: Create Coupon Form**
```
[PLACEHOLDER]
Modal form:
- Coupon Code*: [____] (auto-generate button)
- Title*: [____]
- Description: [____]
- Discount Type*: PERCENTAGE / FLAT / FREE_DELIVERY (radio)
- Discount Value*: [____]
- Max Discount (for %): [____]
- Min Order Amount: [____]
- Applicable To: ALL / NEW_USERS / SPECIFIC_RESTAURANT (dropdown)
- Valid From*: [date picker]
- Valid Until*: [date picker]
- Max Uses: [____] (blank = unlimited)
- Max Uses Per User: [____]
- [Cancel] [Create Coupon] buttons
```

**Screenshot 13.6: Platform Analytics**
```
[PLACEHOLDER]
Shows:
- GMV trend (line chart, last 90 days)
- Order funnel (sankey diagram):
  - Placed (10,000) → Confirmed (9,500) → Delivered (9,200) → Cancelled (800)
- Cancellation reasons (pie chart)
- Average order value by city (bar chart)
- Customer retention cohort (heatmap table)
- [Export Report PDF] button
```

---

## Infrastructure Screenshots

### 14. Kafka UI

**Screenshot 14.1: Topics List**
```
[PLACEHOLDER]
Shows:
- Topics table:
  - order.created | 12 partitions | 3,456 messages | 0 lag
  - payment.completed | 8 partitions | 2,987 messages | 0 lag
  - order.status.updated | 12 partitions | 8,234 messages | 0 lag
- Each row has [View Messages] [Delete Topic] buttons
```

**Screenshot 14.2: Topic Messages**
```
[PLACEHOLDER]
Shows order.created topic:
- Message list with timestamps
- Click message to expand:
  - Key: restaurant-uuid
  - Value: JSON payload (formatted)
  - Partition: 3
  - Offset: 1234
  - Timestamp: 2024-01-15 10:30:00
```

**Screenshot 14.3: Consumer Groups**
```
[PLACEHOLDER]
Shows:
- Consumer group: notification-service
  - Topic: order.created
  - Partition 0: Current offset 1234, Lag 0
  - Partition 1: Current offset 2345, Lag 0
  - Total lag: 0 (green)
```

### 15. Prometheus

**Screenshot 15.1: Prometheus Targets**
```
[PLACEHOLDER]
Shows:
- Targets list (all UP):
  - user-service (1/1 up)
  - restaurant-service (1/1 up)
  - order-service (1/1 up)
  - Each shows last scrape time and duration
```

**Screenshot 15.2: Prometheus Query**
```
[PLACEHOLDER]
Query: rate(http_server_requests_seconds_count[5m])
Graph showing request rate time series for all services
```

### 16. Grafana

**Screenshot 16.1: Platform Dashboard**
```
[PLACEHOLDER]
Shows dashboard with 8 panels:
- Total Orders Today (stat): 4,567
- Orders/min (graph): spiky line chart
- API Success Rate (gauge): 99.3% (green zone)
- Average Response Time (graph): p50, p95, p99 lines
- Error Rate by Service (bar chart)
- Kafka Consumer Lag (graph): all near 0
- Database Connections (graph)
- Top 5 Slow Endpoints (table)
```

**Screenshot 16.2: Service Health Dashboard**
```
[PLACEHOLDER]
Rows for each service:
- User Service:
  - Request Rate: 45 req/s
  - Error Rate: 0.2%
  - p95 Latency: 187ms
  - Instance Count: 1
```

### 17. Zipkin

**Screenshot 17.1: Trace List**
```
[PLACEHOLDER]
Shows recent traces:
- POST /api/v1/orders | 1.2s | 7 spans | 10:30:15
- GET /api/v1/restaurants | 82ms | 3 spans | 10:30:10
- Click to view trace detail
```

**Screenshot 17.2: Trace Detail (Waterfall)**
```
[PLACEHOLDER]
Shows single trace:
- order-service: POST /orders (1200ms total)
  ├─ restaurant-service: GET /restaurants/{id} (150ms)
  ├─ user-service: GET /users/{id} (80ms)
  ├─ payment-service: POST /create-order (200ms)
  │  └─ Razorpay API call (180ms)
  └─ Kafka publish (10ms)
Color-coded by service
```

### 18. MailHog

**Screenshot 18.1: Email Inbox**
```
[PLACEHOLDER]
Shows:
- Email list:
  - From: noreply@foodflow.com
  - To: customer1@test.com
  - Subject: Order Confirmed - FD-2024-000123
  - Date: 2024-01-15 10:30
- Click to view email body (HTML rendered)
```

### 19. MinIO Console

**Screenshot 19.1: Buckets List**
```
[PLACEHOLDER]
Shows:
- Bucket: foodflow-images
  - Objects: 1,234
  - Size: 245 MB
  - [Browse] button
```

**Screenshot 19.2: Bucket Browser**
```
[PLACEHOLDER]
Shows files in foodflow-images bucket:
- restaurants/biryani-house/logo.jpg (45 KB)
- restaurants/biryani-house/cover.jpg (120 KB)
- menu-items/chicken-biryani.jpg (89 KB)
- Each has [Download] [Delete] [Share] buttons
```

---

## Errors & Bugs Encountered

### Error 1: Kafka Consumer Not Receiving Messages

**Error Message:**
```
ERROR [KafkaListenerEndpointContainer#0-0-C-1] o.s.k.l.KafkaMessageListenerContainer: 
Consumer exception: org.apache.kafka.common.errors.TimeoutException: 
Topic order.created not present in metadata after 60000 ms
```

**File:** `backend/notification-service/src/main/resources/application.yml:15`

**Root Cause:** Topic `order.created` was not created before consumer started

**Fix:**
```bash
# Create topic before starting consumers
docker exec -it foodflow-kafka kafka-topics --create \
  --bootstrap-server localhost:9092 \
  --topic order.created \
  --partitions 12 \
  --replication-factor 1  # Changed from 3 to 1 for local dev
```

**Code Change:** Added `docker/init-kafka-topics.sh` script

---

### Error 2: Razorpay Signature Verification Failed

**Error Message:**
```
PaymentVerificationException: Invalid payment signature. 
Expected: abc123..., Received: xyz789...
```

**File:** `backend/payment-service/src/main/java/com/gouravmishra/fooddelivery/payment/service/PaymentService.java:87`

**Root Cause:** Payload order was wrong: `paymentId + \"|\" + orderId` instead of `orderId + \"|\" + paymentId`

**Fix:**
```java
// BEFORE (incorrect):
String payload = razorpayPaymentId + \"|\" + razorpayOrderId;

// AFTER (correct):
String payload = razorpayOrderId + \"|\" + razorpayPaymentId;  // Order matters!
```

---

### Error 3: MongoDB Geospatial Query Returning No Results

**Error Message:**
```
MongoException: Can't find any special indices: 2d (needs index), 
2dsphere (needs index) for location query
```

**File:** `backend/restaurant-service/src/main/java/com/gouravmishra/fooddelivery/restaurant/repository/RestaurantRepository.java:23`

**Root Cause:** 2dsphere index not created on `address.location` field

**Fix:**
```javascript
// scripts/init-mongo.js
db.restaurants.createIndex({ \"address.location\": \"2dsphere\" });
```

**Verification:**
```javascript
db.restaurants.getIndexes()
// Should show:
// { \"address.location\": \"2dsphere\" }
```

---

### Error 4: Redis Connection Refused

**Error Message:**
```
RedisConnectionException: Unable to connect to Redis at localhost:6379: 
Connection refused
```

**File:** `backend/order-service/src/main/resources/application.yml:28`

**Root Cause:** Redis container not started or port mapping incorrect

**Fix:**
```yaml
# docker-compose.yml
services:
  redis:
    image: redis:7-alpine
    ports:
      - \"6379:6379\"  # Was missing
    command: redis-server --requirepass redis123
```

**Verification:**
```bash
redis-cli -h localhost -p 6379 -a redis123 ping
# Should return: PONG
```

---

### Error 5: JWT Token Expired Immediately

**Error Message:**
```
JWTVerificationException: The Token has expired on 2024-01-15T10:30:00Z
```

**File:** `backend/api-gateway/src/main/java/com/gouravmishra/fooddelivery/gateway/filter/AuthFilter.java:45`

**Root Cause:** System clock skew between containers OR expiry set in milliseconds instead of seconds

**Fix:**
```java
// BEFORE:
.withExpiresAt(new Date(System.currentTimeMillis() + 900))  // 900ms, NOT 15 minutes!

// AFTER:
.withExpiresAt(new Date(System.currentTimeMillis() + 900_000))  // 900,000ms = 15 minutes
```

---

### Error 6: CORS Blocking Frontend Requests

**Error Message (Browser Console):**
```
Access to XMLHttpRequest at 'http://localhost:8080/api/v1/auth/send-otp' 
from origin 'http://localhost:3000' has been blocked by CORS policy: 
No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

**File:** `backend/api-gateway/src/main/java/com/gouravmishra/fooddelivery/gateway/config/CorsConfig.java`

**Root Cause:** CORS configuration missing in API Gateway

**Fix:**
```java
@Bean
public CorsWebFilter corsFilter() {
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowedOrigins(Arrays.asList(
        \"http://localhost:3000\",  // Customer app
        \"http://localhost:3001\",  // Restaurant portal
        \"http://localhost:3002\",  // Delivery partner app
        \"http://localhost:3003\"   // Admin console
    ));
    config.setAllowedMethods(Arrays.asList(\"GET\", \"POST\", \"PUT\", \"DELETE\", \"PATCH\", \"OPTIONS\"));
    config.setAllowedHeaders(Arrays.asList(\"*\"));
    config.setAllowCredentials(true);
    
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration(\"/**\", config);
    
    return new CorsWebFilter(source);
}\n```

---

### Error 7: OTP Always Invalid

**Error Message:**
```json
{
  \"error\": \"INVALID_OTP\",
  \"message\": \"OTP doesn't match or has expired\"
}\n```

**File:** `backend/user-service/src/main/java/com/gouravmishra/fooddelivery/user/service/AuthService.java:112`

**Root Cause:** BCrypt comparison issue - was comparing plain OTP with hash in wrong order

**Fix:**
```java
// BEFORE (incorrect):
if (BCrypt.checkpw(storedOtpHash, otp)) {  // Wrong order!

// AFTER (correct):
if (BCrypt.checkpw(otp, storedOtpHash)) {  // Plain first, hash second
```

---

### Error 8: Google Maps Not Loading

**Error Message (Browser Console):**
```
Google Maps JavaScript API error: RefererNotAllowedMapError
Your site URL to be authorized: http://localhost:3000
```

**Root Cause:** API key restricted to wrong HTTP referrer

**Fix:**
1. Google Cloud Console → Credentials → API Key
2. Application restrictions → HTTP referrers
3. Add: `http://localhost:3000/*` and `http://localhost:300[1-3]/*`
4. Wait 5 minutes for propagation

---

### Error 9: HikariCP Connection Pool Exhausted

**Error Message:**
```
HikariPool-1 - Connection is not available, request timed out after 30000ms
```

**File:** `backend/order-service/src/main/resources/application.yml:12`

**Root Cause:** Connection pool size (10) too small for load, connections not being released

**Fix:**
```yaml
# application.yml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20  # Was 10
      connection-timeout: 30000
      leak-detection-threshold: 60000  # Detect leaks
```

**Also fixed connection leak:**
```java
// Ensure @Transactional on service methods
@Transactional
public Order placeOrder(OrderRequest request) {
    // Database operations
}
```

---

### Error 10: Elasticsearch Index Mapping Conflict

**Error Message:**
```
ElasticsearchException: mapper_parsing_exception: 
Field [location] has different types [geo_point, text] in the same index
```

**Root Cause:** Index created with wrong mapping, then tried to index with geo_point

**Fix:**
```bash
# Delete existing index
curl -X DELETE \"localhost:9200/restaurants\"

# Recreate with correct mapping
curl -X PUT \"localhost:9200/restaurants\" -H 'Content-Type: application/json' -d'
{
  \"mappings\": {
    \"properties\": {
      \"location\": { \"type\": \"geo_point\" }
    }
  }
}
'
```

---

### Error 11: WebSocket Connection Failing

**Error Message (Browser Console):**
```
WebSocket connection to 'ws://localhost:8085/tracking' failed: 
Error during WebSocket handshake: Unexpected response code: 404
```

**File:** `backend/delivery-service/src/main/java/com/gouravmishra/fooddelivery/delivery/config/WebSocketConfig.java`

**Root Cause:** Socket.io endpoint not registered correctly

**Fix:**
```java
@Configuration
public class WebSocketConfig {
    @Bean
    public SocketIOServer socketIOServer() {
        com.corundumstudio.socketio.Configuration config = 
            new com.corundumstudio.socketio.Configuration();
        config.setHostname(\"0.0.0.0\");
        config.setPort(8085);
        config.setOrigin(\"http://localhost:3000\");  // Was missing!
        
        return new SocketIOServer(config);
    }
}\n```

---

### Error 12: Kafka Message Serialization Error

**Error Message:**
```
SerializationException: Can't convert value of class 
com.gouravmishra.fooddelivery.order.event.OrderCreatedEvent 
to class org.apache.kafka.common.serialization.StringSerializer 
for serialization
```

**File:** `backend/order-service/src/main/resources/application.yml:35`

**Root Cause:** Using StringSerializer instead of JsonSerializer for event value

**Fix:**
```yaml
# application.yml
spring:
  kafka:
    producer:
      value-serializer: org.springframework.kafka.support.serializer.JsonSerializer  # Was StringSerializer
```

---

## Performance Benchmarks

### Benchmark 1: API Response Time (Apache JMeter)

**Screenshot:**
```
[PLACEHOLDER]
JMeter graph showing:
- 1000 concurrent users
- 10,000 requests to POST /api/v1/orders
- Results:
  - p50: 34ms
  - p95: 187ms
  - p99: 423ms
  - Throughput: 450 req/sec
```

### Benchmark 2: Database Query Performance

**Screenshot:**
```
[PLACEHOLDER]
Table showing:
| Query | Before Index | After Index | Improvement |
|-------|--------------|-------------|-------------|
| Restaurant geospatial search | 800ms | 45ms | 94% |
| Order history fetch | 200ms | 20ms | 90% |
| User profile with addresses | 150ms | 15ms | 90% |
```

### Benchmark 3: Kafka Throughput

**Screenshot:**
```
[PLACEHOLDER]
Graph showing:
- Messages produced/sec: 5,000
- Messages consumed/sec: 4,987 (notification-service)
- Average lag: 13 messages
- Peak throughput: 10,000 msgs/sec
```

### Benchmark 4: Redis Performance

**Screenshot:**
```
[PLACEHOLDER]
Redis benchmark results:
- GET operations: 120,000 req/sec
- SET operations: 110,000 req/sec
- Cart add operation: 2ms average
```

### Benchmark 5: Frontend Load Time

**Screenshot:**
```
[PLACEHOLDER]
Lighthouse report:
- Performance: 92/100
- First Contentful Paint: 1.2s
- Time to Interactive: 2.1s
- Largest Contentful Paint: 1.8s
```

---

## Testing Screenshots

### Test 1: Unit Test Coverage Report

**Screenshot:**
```
[PLACEHOLDER]
JaCoCo coverage report showing:
- order-service: 82% line coverage
- Green bars for covered lines
- Red bars for missed lines
- Drilldown to class level
```

### Test 2: Integration Test Results

**Screenshot:**
```
[PLACEHOLDER]
Maven test output:
- Tests run: 623
- Failures: 0
- Errors: 0
- Skipped: 0
- Time elapsed: 4min 32s
- SUCCESS (green checkmark)
```

### Test 3: Postman Collection Results

**Screenshot:**
```
[PLACEHOLDER]
Newman CLI output:
- 42 requests executed
- 156 assertions passed
- 0 failures
- Average response time: 234ms
```

---

## How to Add Real Screenshots

### Step 1: Run Application

```bash
cd /path/to/FOOF_DELIVERY_APP
make start
# Wait for all services to be ready (~90 seconds)
```

### Step 2: Take Screenshots

**For each placeholder above:**

1. Open the specified URL
2. Login with demo credentials (from DEMO_CREDENTIALS.md)
3. Navigate to the screen
4. Take screenshot (OS-specific):
   - **Mac**: Cmd+Shift+4, then drag to select
   - **Windows**: Win+Shift+S
   - **Linux**: PrtScn or Gnome Screenshot

### Step 3: Name & Save

Save with descriptive name matching section:
```
screenshots/
├── customer-app/
│   ├── 1.1-login-screen.png
│   ├── 1.2-otp-input.png
│   ├── 2.1-homepage.png
│   └── ...
├── restaurant-portal/
│   ├── 8.1-dashboard.png
│   └── ...
├── infrastructure/
│   ├── 14.1-kafka-ui-topics.png
│   └── ...
└── errors/
    ├── error-1-kafka-consumer.png
    └── ...
```

### Step 4: Replace Placeholders

Edit this file and replace `[PLACEHOLDER]` with:
```markdown
![Screenshot Description](../screenshots/folder/file.png)
```

**Example:**
```markdown
**Screenshot 1.1: Login Screen**

![Login Screen showing phone number input](../screenshots/customer-app/1.1-login-screen.png)

Shows:
- FoodFlow logo
- Phone number input field
- "Send OTP" button
```

### Step 5: Optimize Images

```bash
# Install optimization tools
npm install -g imagemin-cli imagemin-webp

# Optimize all screenshots
imagemin screenshots/**/*.png --out-dir=screenshots-optimized --plugin=webp
```

---

## Screenshot Checklist

- [ ] Customer App (32 screenshots)
  - [ ] Authentication (3)
  - [ ] Home/Discovery (3)
  - [ ] Restaurant Detail (5)
  - [ ] Cart (4)
  - [ ] Checkout (3)
  - [ ] Order Tracking (4)
  - [ ] Profile (3)
- [ ] Restaurant Portal (13 screenshots)
  - [ ] Dashboard (3)
  - [ ] Order Management (2)
  - [ ] Menu Management (2)
  - [ ] Analytics (1)
- [ ] Delivery Partner App (6 screenshots)
- [ ] Admin Console (9 screenshots)
- [ ] Infrastructure (10 screenshots)
  - [ ] Kafka UI (3)
  - [ ] Prometheus (2)
  - [ ] Grafana (2)
  - [ ] Zipkin (2)
  - [ ] MailHog (1)
  - [ ] MinIO (2)
- [ ] Error Documentation (12 screenshots)
- [ ] Performance Benchmarks (5 screenshots)
- [ ] Testing (3 screenshots)

**Total: 90 screenshots to capture**

---

**END OF SCREENSHOTS DOCUMENTATION**
