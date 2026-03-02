# 🛠️ Development Setup Guide

## Prerequisites

| Tool | Version | Check Command | Install Link |
|------|---------|---------------|-------------|
| Docker | 24.0+ | `docker --version` | https://docs.docker.com/get-docker/ |
| Docker Compose | 2.20+ | `docker-compose --version` | Included with Docker Desktop |
| Java | 17 (LTS) | `java -version` | https://adoptium.net/ |
| Maven | 3.8+ | `mvn -version` | https://maven.apache.org/download.cgi |
| Node.js | 20 LTS | `node --version` | https://nodejs.org/ |
| Git | 2.30+ | `git --version` | https://git-scm.com/downloads |

**Optional but Recommended:**
- **IDE**: IntelliJ IDEA (Java) + VS Code (React)
- **API Client**: Postman or Insomnia
- **Database Client**: DBeaver (PostgreSQL/MongoDB)

---

## Option A: Docker Compose (Recommended)

### Step 1: Clone Repository

```bash
git clone https://github.com/gouravm19/FOOF_DELIVERY_APP.git
cd FOOF_DELIVERY_APP
```

### Step 2: Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` and add your API keys:

```env
# Required for full functionality
RAZORPAY_KEY_ID=rzp_test_xxxxx
RAZORPAY_KEY_SECRET=xxxxx
TWILIO_ACCOUNT_SID=ACxxxxx
TWILIO_AUTH_TOKEN=xxxxx
TWILIO_PHONE_NUMBER=+12025551234
GOOGLE_MAPS_API_KEY=AIzaSyXXXXX

# Optional (mocked if not provided)
FIREBASE_SERVICE_ACCOUNT_PATH=./config/firebase-admin.json
```

### Step 3: Start All Services

```bash
make start
# Or manually:
docker-compose up --build -d
```

**Expected Output:**
```
Creating network "foodflow_default"
Creating volume "foodflow_postgres_data"
Creating volume "foodflow_mongo_data"
Creating volume "foodflow_redis_data"
...
Creating foodflow-postgres ... done
Creating foodflow-mongodb ... done
Creating foodflow-redis ... done
Creating foodflow-kafka ... done
...
Creating foodflow-user-service ... done
Creating foodflow-restaurant-service ... done
```

### Step 4: Verify Services

```bash
make status
# Or:
docker-compose ps
```

**All services should show "Up":**

| Service | Port | Status Check |
|---------|------|-------------|
| PostgreSQL | 5432 | `psql -h localhost -U fooddelivery -d fooddelivery -c "\\dt"` |
| MongoDB | 27017 | `mongosh mongodb://localhost:27017/fooddelivery` |
| Redis | 6379 | `redis-cli ping` (returns PONG) |
| Kafka | 9092 | `kafka-topics --list --bootstrap-server localhost:9092` |
| Eureka Server | 8761 | http://localhost:8761 |
| API Gateway | 8080 | http://localhost:8080/actuator/health |
| Customer App | 3000 | http://localhost:3000 |
| Restaurant Portal | 3001 | http://localhost:3001 |
| Delivery Partner App | 3002 | http://localhost:3002 |
| Admin Console | 3003 | http://localhost:3003 |
| Kafka UI | 8090 | http://localhost:8090 |
| MailHog | 8025 | http://localhost:8025 |
| MinIO | 9001 | http://localhost:9001 (minioadmin/minioadmin) |
| Prometheus | 9090 | http://localhost:9090 |
| Grafana | 3004 | http://localhost:3004 (admin/admin) |
| Zipkin | 9411 | http://localhost:9411 |

### Step 5: Run Database Migrations

```bash
# PostgreSQL schema
docker exec -i foodflow-postgres psql -U fooddelivery -d fooddelivery < scripts/init-postgres.sql

# MongoDB seed data
docker exec -i foodflow-mongodb mongosh fooddelivery < scripts/init-mongo.js
```

### Step 6: Create Kafka Topics

```bash
bash docker/init-kafka-topics.sh
```

**Output:**
```
Created topic order.created (12 partitions, 3 replicas)
Created topic payment.completed (8 partitions, 3 replicas)
...
```

### Startup Time

- **First time (with build):** ~5 minutes
- **Subsequent starts:** ~90 seconds

---

## Option B: Manual Setup (For Development)

### Step 1: Start Only Infrastructure

```bash
docker-compose up -d postgres mongodb redis kafka elasticsearch zookeeper
```

### Step 2: Run Backend Services Manually

**Terminal 1 - Eureka Server:**
```bash
cd backend/eureka-server
mvn spring-boot:run
```

**Terminal 2 - Config Server:**
```bash
cd backend/config-server
mvn spring-boot:run
```

**Terminal 3 - API Gateway:**
```bash
cd backend/api-gateway
mvn spring-boot:run
```

**Terminal 4-10 - Microservices:**
```bash
cd backend/user-service && mvn spring-boot:run
cd backend/restaurant-service && mvn spring-boot:run
cd backend/order-service && mvn spring-boot:run
# ... and so on
```

### Step 3: Run Frontend Apps

**Terminal 11 - Customer App:**
```bash
cd frontend/customer-app
npm install
npm run dev
```

**Terminal 12-14 - Other Apps:**
```bash
cd frontend/restaurant-portal && npm install && npm run dev
cd frontend/delivery-partner-app && npm install && npm run dev
cd frontend/admin-console && npm install && npm run dev
```

---

## Development Workflow

### Making Code Changes

**Backend (Hot Reload Enabled):**

1. Edit Java file in `backend/user-service/src/main/java/...`
2. Save file
3. Spring Boot DevTools auto-reloads (~2 seconds)
4. Test: `curl http://localhost:8080/api/v1/users/me -H "Authorization: Bearer {token}"`

**Frontend (Vite Hot Module Replacement):**

1. Edit React component in `frontend/customer-app/src/App.jsx`
2. Save file
3. Browser auto-refreshes (<1 second)

### Viewing Logs

**All services:**
```bash
make logs
# Or:
docker-compose logs -f
```

**Specific service:**
```bash
docker-compose logs -f user-service
docker-compose logs -f customer-app
```

**Backend service logs:**
```bash
tail -f backend/user-service/logs/application.log
```

### Debugging

**Backend (IntelliJ IDEA):**

1. Run → Edit Configurations
2. Add Remote JVM Debug
3. Port: 5005
4. Start service with debug:
   ```bash
   mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"
   ```
5. Attach debugger

**Frontend (VS Code):**

1. Install "Debugger for Chrome" extension
2. F5 → Select "Chrome"
3. Set breakpoints in `.jsx` files

### Running Tests

**Backend:**
```bash
cd backend/user-service
mvn test
```

**Frontend:**
```bash
cd frontend/customer-app
npm test
```

**Coverage Report:**
```bash
mvn test jacoco:report
open target/site/jacoco/index.html
```

---

## Environment Variables Reference

**Complete .env file:**

```env
# === Database ===
POSTGRES_DB=fooddelivery
POSTGRES_USER=fooddelivery
POSTGRES_PASSWORD=fooddelivery123

MONGO_INITDB_DATABASE=fooddelivery

REDIS_PASSWORD=redis123

# === Razorpay (Payment Gateway) ===
RAZORPAY_KEY_ID=rzp_test_xxxxx
RAZORPAY_KEY_SECRET=xxxxx
RAZORPAY_WEBHOOK_SECRET=whsec_xxxxx

# === Twilio (SMS OTP) ===
TWILIO_ACCOUNT_SID=ACxxxxx
TWILIO_AUTH_TOKEN=xxxxx
TWILIO_PHONE_NUMBER=+12025551234

# === Google Maps ===
GOOGLE_MAPS_API_KEY=AIzaSyXXXXX

# === Firebase (Push Notifications) ===
FIREBASE_SERVICE_ACCOUNT_PATH=./config/firebase-admin.json

# === SendGrid (Production Email) ===
SENDGRID_API_KEY=SG.xxxxx  # Optional, uses MailHog in dev

# === AWS S3 (Production Images) ===
AWS_ACCESS_KEY_ID=AKIAXXXXX  # Optional, uses MinIO in dev
AWS_SECRET_ACCESS_KEY=xxxxx
AWS_S3_BUCKET=foodflow-images

# === MinIO (Local S3) ===
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin

# === JWT ===
JWT_SECRET=your-256-bit-secret-key-change-in-production
JWT_ACCESS_EXPIRY=900  # 15 minutes
JWT_REFRESH_EXPIRY=2592000  # 30 days

# === Application ===
SPRING_PROFILES_ACTIVE=dev
LOG_LEVEL=INFO
```

---

## Troubleshooting Common Issues

**Port already in use:**
```bash
# Find process using port 8080
lsof -ti:8080 | xargs kill -9

# Or change port in docker-compose.yml
```

**Out of disk space:**
```bash
# Clean up Docker
docker system prune -a --volumes
```

**Services not starting:**
```bash
# Check logs
docker-compose logs user-service

# Restart specific service
docker-compose restart user-service
```

**Database connection refused:**
```bash
# Wait for database to be ready
docker-compose logs postgres | grep "ready to accept connections"
```

---

**Next:** See DEMO_CREDENTIALS.md for test accounts