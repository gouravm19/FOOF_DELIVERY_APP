# 🍕 Food Delivery Platform

[![Java](https://img.shields.io/badge/Java-17-orange)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-brightgreen)](https://spring.io/projects/spring-boot)
[![React](https://img.shields.io/badge/React-18-blue)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-blue)](https://www.typescriptlang.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **Production-grade food delivery platform built with microservices architecture, inspired by Zomato and Swiggy.**
>
> Developed by: **Gourav Mishra** | Senior Full Stack Developer @ Emerson, Pune  
> Email: gauravmishra19995@gmail.com  
> GitHub: [@gouravm19](https://github.com/gouravm19)

---

## ✨ Features

### For Customers 🛒
- **Phone OTP Authentication** (Like Zomato - no passwords!)
- **Restaurant Discovery** with geospatial search (find restaurants near you)
- **Advanced Search** with filters (cuisine, veg only, rating, delivery time)
- **Menu Browsing** with customizations (size, toppings, add-ons)
- **Real-time Cart** (Redis-powered, 24h expiry)
- **Multiple Payment Options** (Razorpay - UPI, Cards, Net Banking, Wallets, COD)
- **Live Order Tracking** with map (WebSocket + Google Maps)
- **Delivery ETA** (Google Maps Distance Matrix API)
- **Coupons & Offers**
- **Order History** with reorder option
- **Ratings & Reviews**
- **Multiple Saved Addresses** with geolocation

### For Restaurant Owners 🍽️
- **Real-time Order Dashboard** with sound notifications
- **Menu Management** (categories, items, customizations, pricing)
- **Availability Toggle** (mark items as sold out)
- **Order Accept/Reject** with preparation time
- **Analytics Dashboard** (revenue, popular items, ratings)
- **Operating Hours Management**
- **Review Management** with response capability

### For Delivery Partners 🏍️
- **Go Online/Offline** toggle
- **Smart Order Assignment** (nearest partner gets notified first)
- **Navigation Integration** (open in Google Maps)
- **Earnings Tracker** (today, week, month)
- **Delivery History**
- **Rating System**

### For Admins 👨‍💼
- **Restaurant Approval** workflow
- **User Management**
- **Delivery Partner KYC** verification
- **Coupon Management**
- **Platform Analytics** (GMV, orders, revenue, cancellation rates)
- **System Monitoring** (all services health)

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                              │
│  ┌─────────────┐ ┌──────────────┐ ┌──────────────┐ ┌─────────┐ │
│  │  Customer   │ │  Restaurant  │ │   Delivery   │ │  Admin  │ │
│  │  React App  │ │  React Portal│ │ Partner App  │ │ Console │ │
│  │  (port 3000)│ │  (port 3001) │ │  (port 3002) │ │(port 3003)│
│  └─────────────┘ └──────────────┘ └──────────────┘ └─────────┘ │
└────────────────────────────┬─────────────────────────────────────┘
                              │ HTTPS
┌────────────────────────────▼─────────────────────────────────────┐
│                     API GATEWAY (port 8080)                       │
│         Rate Limiting · JWT Validation · Load Balancing          │
└──────┬──────────┬──────────┬──────────┬──────────┬───────────────┘
       │          │          │          │          │
┌──────▼──┐ ┌────▼────┐ ┌───▼────┐ ┌───▼────┐ ┌───▼─────┐
│  User   │ │Restaurnt│ │ Order  │ │Payment │ │Delivery │
│Service  │ │ Service │ │Service │ │Service │ │ Service │
│:8081    │ │:8082    │ │:8083   │ │:8084   │ │:8085    │
└──────┬──┘ └────┬────┘ └───┬────┘ └───┬────┘ └───┬─────┘
       │         │           │          │           │
┌──────▼─────────▼───────────▼──────────▼───────────▼─────────────┐
│                    APACHE KAFKA (Message Bus)                     │
│  Topics: order.created | payment.completed | delivery.assigned   │
└──────────────────────────┬───────────────────────────────────────┘
                            │
       ┌────────────────────┼────────────────────┐
       │                    │                    │
┌──────▼──────┐  ┌──────────▼──────┐  ┌─────────▼───────┐
│Notification │  │  Search Service │  │Service Discovery│
│  Service    │  │  (Elasticsearch)│  │  (Eureka :8761) │
│  :8086      │  │  :8087          │  │                 │
└─────────────┘  └─────────────────┘  └─────────────────┘

DATA LAYER:
  PostgreSQL  — Users, Orders, Payments, Delivery Partners, Coupons
  MongoDB     — Restaurant data, Menus, Reviews
  Redis       — Sessions, OTP cache, Cart, Rate limiting
  Elasticsearch — Restaurant search, Menu search
```

---

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- 8GB RAM minimum
- Ports available: 3000-3003, 5432, 6379, 8080-8090, 9000-9001, 27017

### 1. Clone the Repository
```bash
git clone https://github.com/gouravm19/FOOF_DELIVERY_APP.git
cd FOOF_DELIVERY_APP
```

### 2. Set Up Environment
```bash
cp .env.example .env
# Edit .env if you have real API keys (optional for dev)
```

### 3. Start Everything
```bash
make start
# OR
docker-compose up --build -d
```

**⏳ Wait 2-3 minutes for all services to start...**

### 4. Access the Platform

| Service | URL | Purpose |
|---------|-----|---------|
| **Customer App** | http://localhost:3000 | Main food ordering app |
| **Restaurant Portal** | http://localhost:3001 | Restaurant management |
| **Delivery Partner App** | http://localhost:3002 | Delivery partner interface |
| **Admin Console** | http://localhost:3003 | Platform administration |
| **API Gateway** | http://localhost:8080 | Main API entry point |
| **Eureka Dashboard** | http://localhost:8761 | Service registry |
| **Swagger API Docs** | http://localhost:8080/swagger-ui.html | API documentation |
| **Kafka UI** | http://localhost:8090 | Message broker dashboard |
| **MailHog** | http://localhost:8025 | Email testing |
| **MinIO Console** | http://localhost:9001 | File storage |
| **Zipkin** | http://localhost:9411 | Distributed tracing |
| **Kibana** | http://localhost:5601 | Elasticsearch UI |
| **Grafana** | http://localhost:3004 | Monitoring dashboards |

---

## 🔑 Demo Credentials

All demo accounts use **OTP: `123456`** in development mode.

### Customers
| Phone | Name | Email |
|-------|------|-------|
| +91-9000000001 | John Doe | customer1@test.com |
| +91-9000000002 | Jane Smith | customer2@test.com |
| +91-9000000003 | Bob Johnson | customer3@test.com |
| +91-9000000004 | Alice Brown | customer4@test.com |
| +91-9000000005 | Charlie Davis | customer5@test.com |

### Restaurant Owners
| Phone | Restaurant | Email |
|-------|-----------|-------|
| +91-9100000001 | Biryani House | restaurant1@test.com |
| +91-9100000002 | Pizza Paradise | restaurant2@test.com |
| +91-9100000003 | Wok This Way | restaurant3@test.com |

### Delivery Partners
| Phone | Name | Email |
|-------|------|-------|
| +91-9200000001 | Delivery Partner 1 | delivery1@test.com |
| +91-9200000002 | Delivery Partner 2 | delivery2@test.com |

### Admin
| Phone | Email |
|-------|-------|
| +91-9300000001 | admin@fooddelivery.local |

---

## 🧪 Testing Payments (Razorpay Test Mode)

The platform uses **Razorpay** for payments. In test mode, use these cards:

### Test Credit Cards
```
Card Number: 4111 1111 1111 1111
CVV: Any 3 digits
Expiry: Any future date
Name: Any name
```

### Test UPI
```
UPI ID: success@razorpay
Status: Payment succeeds
```

```
UPI ID: failure@razorpay
Status: Payment fails (to test failure handling)
```

### Test Netbanking
- Select any bank from the dropdown
- It will simulate successful payment

---

## 💻 Tech Stack

### Backend Microservices
| Technology | Version | Purpose |
|-----------|---------|---------|
| Java | 17 | Programming language |
| Spring Boot | 3.2.5 | Application framework |
| Spring Cloud | 2023.0.1 | Microservices infrastructure |
| Spring Security | 6.x | Authentication & authorization |
| PostgreSQL | 15 | Relational database |
| MongoDB | 7 | Document database |
| Redis | 7 | Caching & sessions |
| Apache Kafka | 7.5.0 | Message broker |
| Elasticsearch | 8.11.0 | Search engine |
| Spring Data JPA | - | ORM |
| Hibernate | - | JPA implementation |
| JWT (jjwt) | 0.11.5 | Token-based auth |
| MapStruct | 1.5.5 | DTO mapping |
| Lombok | - | Boilerplate reduction |
| SpringDoc OpenAPI | 2.3.0 | API documentation |
| Micrometer | - | Metrics |
| Zipkin | - | Distributed tracing |
| Maven | 3.9.6 | Build tool |

### Frontend Applications
| Technology | Version | Purpose |
|-----------|---------|---------|
| React | 18 | UI framework |
| TypeScript | 5 | Type safety |
| Vite | 5 | Build tool |
| Tailwind CSS | 3 | Styling |
| React Router | 6 | Routing |
| TanStack Query | - | Server state management |
| Zustand | - | Client state management |
| React Hook Form | - | Form management |
| Zod | - | Validation |
| Axios | - | HTTP client |
| Socket.io Client | - | WebSockets |
| Google Maps API | - | Maps & geolocation |
| Razorpay React | - | Payment integration |
| Lucide React | - | Icons |
| React Hot Toast | - | Notifications |
| Framer Motion | - | Animations |
| Recharts | - | Charts (admin) |

### Infrastructure & DevOps
| Technology | Purpose |
|-----------|---------|
| Docker | Containerization |
| Docker Compose | Multi-container orchestration |
| Kafka + Zookeeper | Event streaming |
| MinIO | S3-compatible storage |
| MailHog | Email testing |
| Prometheus | Monitoring |
| Grafana | Dashboards |
| GitHub Actions | CI/CD |

### Third-Party Integrations
| Service | Purpose |
|---------|---------|
| **Razorpay** | Payment gateway (UPI, cards, wallets) |
| **Twilio** | SMS OTP (mocked in dev) |
| **Google Maps** | Geocoding, distance calculation, maps |
| **Firebase FCM** | Push notifications (mocked in dev) |

---

## 📡 API Endpoints

### Authentication (User Service - 8081)
```http
POST   /api/v1/auth/send-otp           # Send OTP to phone
POST   /api/v1/auth/verify-otp         # Verify OTP & login
POST   /api/v1/auth/refresh-token      # Refresh access token
POST   /api/v1/auth/logout             # Logout user
```

### Users (User Service - 8081)
```http
GET    /api/v1/users/me                # Get current user profile
PUT    /api/v1/users/me                # Update profile
PUT    /api/v1/users/me/fcm-token      # Update FCM token
GET    /api/v1/users/me/addresses      # List addresses
POST   /api/v1/users/me/addresses      # Add address
PUT    /api/v1/users/me/addresses/{id} # Update address
DELETE /api/v1/users/me/addresses/{id} # Delete address
```

### Restaurants (Restaurant Service - 8082)
```http
GET    /api/v1/restaurants              # Discover restaurants (with lat/lng)
GET    /api/v1/restaurants/{id}         # Restaurant details + menu
GET    /api/v1/restaurants/{id}/menu    # Full menu
GET    /api/v1/restaurants/{id}/reviews # Reviews
POST   /api/v1/restaurants/{id}/reviews # Submit review
```

### Cart & Orders (Order Service - 8083)
```http
GET    /api/v1/cart                     # Get cart
POST   /api/v1/cart/items               # Add to cart
PUT    /api/v1/cart/items/{id}          # Update cart item
DELETE /api/v1/cart/items/{id}          # Remove from cart
DELETE /api/v1/cart                     # Clear cart
POST   /api/v1/cart/coupon              # Apply coupon
POST   /api/v1/orders                   # Place order
GET    /api/v1/orders                   # Order history
GET    /api/v1/orders/{id}              # Order details
GET    /api/v1/orders/{id}/track        # Live tracking
POST   /api/v1/orders/{id}/cancel       # Cancel order
```

### Payments (Payment Service - 8084)
```http
POST   /api/v1/payments/create-order    # Create Razorpay order
POST   /api/v1/payments/verify          # Verify payment signature
POST   /api/v1/payments/webhook         # Razorpay webhook
```

### Search (Search Service - 8087)
```http
GET    /api/v1/search                   # Search restaurants & dishes
GET    /api/v1/search/suggestions       # Autocomplete suggestions
GET    /api/v1/search/trending          # Trending searches
```

**Full API documentation**: http://localhost:8080/swagger-ui.html

---

## 🗃️ Database Design

### PostgreSQL Tables
- `users` - User accounts
- `user_addresses` - Delivery addresses with geolocation
- `orders` - Order transactions
- `order_items` - Order line items (snapshot of menu items)
- `order_status_history` - Order lifecycle tracking
- `payments` - Payment records (Razorpay integration)
- `delivery_partners` - Delivery partner profiles
- `coupons` - Discount coupons
- `coupon_usages` - Coupon redemption tracking
- `refresh_tokens` - JWT refresh tokens
- `otp_logs` - OTP verification logs

### MongoDB Collections
- `restaurants` - Restaurant profiles with geospatial data
- `menu_categories` - Menu categories
- `menu_items` - Menu items with customizations
- `reviews` - Customer reviews & ratings

### Redis Keys
- `cart:{userId}` - Shopping cart (24h TTL)
- `otp:{phoneNumber}` - OTP verification (10min TTL)
- `rate_limit:*` - API rate limiting
- `session:{userId}` - User sessions
- `partner:location:{partnerId}` - Live delivery partner location

---

## 🔧 Configuration

### Adding Real API Keys

Edit `.env` file:

```bash
# Razorpay (get from https://dashboard.razorpay.com)
RAZORPAY_KEY_ID=rzp_live_your_key_id
RAZORPAY_KEY_SECRET=your_key_secret

# Twilio (get from https://console.twilio.com)
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+1234567890
TWILIO_ENABLED=true

# Google Maps (get from https://console.cloud.google.com)
GOOGLE_MAPS_API_KEY=your_maps_api_key

# Firebase (download google-services.json)
FIREBASE_ENABLED=true
FIREBASE_PROJECT_ID=your_project_id
```

After adding keys:
```bash
make restart
```

---

## 🛠️ Development

### Prerequisites
- Java 17+
- Maven 3.9+
- Node.js 20+
- Docker & Docker Compose

### Run Backend Services Locally
```bash
cd backend/user-service
mvn spring-boot:run
```

### Run Frontend Locally
```bash
cd frontend/customer-app
npm install
npm run dev
```

### Run Tests
```bash
# All tests
make test

# Single service
cd backend/user-service
mvn test
```

### View Logs
```bash
make logs                # All services
make logs-backend        # All backend services
make logs-user          # User service only
```

### Database Access
```bash
make db-shell           # PostgreSQL
make mongo-shell        # MongoDB
make redis-cli          # Redis
```

---

## 📊 Monitoring & Observability

### Prometheus Metrics
- Service health
- HTTP request rates
- Response times
- Database connection pools
- JVM metrics

Access: http://localhost:9090

### Grafana Dashboards
Pre-configured dashboards for:
- Service overview
- JVM metrics
- Database performance
- Kafka lag

Access: http://localhost:3004  
Login: `admin` / `admin123`

### Zipkin Distributed Tracing
View request traces across services:
- Request path visualization
- Service dependency graph
- Performance bottlenecks

Access: http://localhost:9411

### Kafka UI
Monitor Kafka topics:
- Message throughput
- Consumer lag
- Topic configurations

Access: http://localhost:8090

---

## 🧹 Maintenance

### Stop Services
```bash
make stop
```

### Restart Services
```bash
make restart
```

### Clean Everything (⚠️ Deletes all data)
```bash
make clean
```

### Prune Docker Resources
```bash
make prune
```

---

## 🏢 Production Deployment

### Build for Production
```bash
# Build all services
docker-compose -f docker-compose.prod.yml build

# Deploy
docker-compose -f docker-compose.prod.yml up -d
```

### Environment Variables for Production
```bash
ENVIRONMENT=production
DEBUG_MODE=false
JWT_SECRET=<generate-strong-256-bit-secret>
POSTGRES_PASSWORD=<strong-password>
MONGO_INITDB_ROOT_PASSWORD=<strong-password>
REDIS_PASSWORD=<strong-password>
```

### Health Checks
All services expose health endpoints:
```
http://service:port/actuator/health
```

---

## 🤝 Contributing

This is a portfolio project by Gourav Mishra. For collaboration:
- **Email**: gauravmishra19995@gmail.com
- **LinkedIn**: [Gourav Mishra](https://www.linkedin.com/in/gourav-mishra)
- **Portfolio**: [gouravmishra.is-a.dev](https://gouravmishra.is-a.dev)

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file

---

## 🙏 Acknowledgments

- **Zomato & Swiggy** for design inspiration
- **Spring Boot Team** for amazing framework
- **React Team** for powerful UI library
- **Razorpay** for payment gateway
- **Google Maps** for geolocation services

---

## 📞 Support

For issues or questions:
- **GitHub Issues**: [Create an issue](https://github.com/gouravm19/FOOF_DELIVERY_APP/issues)
- **Email**: gauravmishra19995@gmail.com

---

**Built with ❤️ by Gourav Mishra | Senior Full Stack Developer**

*Demonstrating enterprise-grade microservices architecture, event-driven design, and production-ready code quality.*
