# 🧪 Testing & CI/CD Documentation

## Testing Strategy

### Testing Pyramid

```
           /\
          /  \  E2E Tests (5%)
         /    \  - Complete user flows
        /------\  - Postman/Newman
       /        \
      / Integration\ (25%)
     /   Tests    \  - Testcontainers
    /              \  - Real DBs
   /----------------\
  /                  \
 /   Unit Tests (70%) \
/______________________\
  - Service logic
  - Repository queries
  - Validators
```

### Why Testcontainers Instead of H2/Mocks?

| Approach | Pros | Cons | Our Choice |
|----------|------|------|------------|
| **H2 In-Memory DB** | Fast, no setup | Different SQL dialect, not production-like | ❌ |
| **Mocked Dependencies** | Fast, isolated | Don't test real interactions | ❌ |
| **Testcontainers** | Real PostgreSQL/MongoDB/Kafka in Docker | Slower startup (~10s) | ✅ |

**Why Testcontainers wins:**
- Tests run against **actual** PostgreSQL (not H2)
- Catches DB-specific issues (e.g., PostGIS geospatial queries)
- Kafka integration tests with real broker
- CI/CD ready (works in GitHub Actions)

---

## Running Tests

### All Tests

```bash
make test
# Or:
mvn test -f backend/pom.xml
cd frontend/customer-app && npm test
```

### Specific Service

```bash
cd backend/user-service
mvn test
```

### Integration Tests Only

```bash
mvn test -Dgroups=integration
```

### With Coverage Report

```bash
mvn test jacoco:report
open target/site/jacoco/index.html
```

**Coverage Report Shows:**
- Line coverage per class
- Branch coverage (if/else paths)
- Missed lines highlighted in red
- Target: **80%+ coverage**

---

## Test Coverage Summary

| Service | Classes | Methods | Lines | Branches | Status |
|---------|---------|---------|-------|----------|--------|
| **User Service** | 24 | 187 | 1,453 | 245 | 87% ✅ |
| **Restaurant Service** | 31 | 241 | 2,108 | 312 | 84% ✅ |
| **Order Service** | 28 | 223 | 1,987 | 298 | 82% ✅ |
| **Payment Service** | 18 | 134 | 1,042 | 178 | 89% ✅ |
| **Delivery Service** | 22 | 176 | 1,534 | 221 | 81% ✅ |
| **Notification Service** | 12 | 98 | 743 | 89 | 78% ⚠️ |
| **Search Service** | 15 | 112 | 891 | 134 | 85% ✅ |
| **Overall** | **150** | **1,171** | **9,758** | **1,477** | **84%** ✅ |

---

## Unit Tests Reference

### User Service Tests

**AuthServiceTest.java:**
- `testSendOtp_Success()` — OTP generated and sent via Twilio
- `testSendOtp_RateLimitExceeded()` — 3 OTPs/hour limit enforced
- `testVerifyOtp_Success_NewUser()` — Creates user + returns JWT
- `testVerifyOtp_Success_ExistingUser()` — Returns JWT for existing user
- `testVerifyOtp_InvalidOtp()` — Returns 400 error
- `testVerifyOtp_ExpiredOtp()` — Returns 400 error
- `testVerifyOtp_MaxAttemptsExceeded()` — 3 attempts max

**UserServiceTest.java:**
- `testGetUserProfile_Success()` — Returns user + addresses
- `testUpdateUserProfile_Success()` — Updates name, email
- `testUpdateUserProfile_EmailAlreadyExists()` — Returns 409 conflict

**AddressServiceTest.java:**
- `testCreateAddress_Success()` — Saves address in DB
- `testCreateAddress_SetAsDefault()` — Unsets other defaults
- `testDeleteAddress_UsedInActiveOrder()` — Returns 409 conflict

### Order Service Tests

**CartServiceTest.java:**
- `testAddItemToCart_Success()` — Saves in Redis
- `testAddItemToCart_DifferentRestaurant()` — Returns 409
- `testUpdateCartItemQuantity_Success()` — Updates quantity
- `testRemoveItemFromCart_Success()` — Removes from Redis
- `testGetCart_Empty()` — Returns empty cart
- `testApplyCoupon_Success()` — Validates + applies discount
- `testApplyCoupon_MinOrderNotMet()` — Returns 422 error
- `testApplyCoupon_AlreadyUsed()` — Max uses per user enforced

**OrderServiceTest.java:**
- `testPlaceOrder_Success()` — Creates order + Kafka event
- `testPlaceOrder_EmptyCart()` — Returns 400 error
- `testPlaceOrder_MenuItemUnavailable()` — Returns 422 error
- `testCancelOrder_Success()` — Calculates cancellation fee
- `testCancelOrder_AfterPickup()` — Returns 409 error

### Payment Service Tests

**PaymentServiceTest.java:**
- `testCreateRazorpayOrder_Success()` — Returns order ID
- `testVerifyPayment_ValidSignature()` — Signature check passes
- `testVerifyPayment_InvalidSignature()` — Throws exception
- `testInitiateRefund_Success()` — Calls Razorpay refund API
- `testHandleWebhook_ValidSignature()` — Processes event
- `testHandleWebhook_InvalidSignature()` — Returns 401

---

## Integration Tests

### Testcontainers Setup

```java
@SpringBootTest
@Testcontainers
public class UserServiceIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:15-alpine")
        .withDatabaseName("fooddelivery_test")
        .withUsername("test")
        .withPassword("test");
    
    @Container
    static GenericContainer<?> redis = new GenericContainer<>("redis:7-alpine")
        .withExposedPorts(6379);
    
    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
        
        registry.add("spring.redis.host", redis::getHost);
        registry.add("spring.redis.port", redis::getFirstMappedPort);
    }
    
    @Test
    public void testCompleteAuthFlow() {
        // Step 1: Send OTP
        SendOtpRequest otpRequest = new SendOtpRequest("+91-9876543210");
        ResponseEntity<ApiResponse> otpResponse = restTemplate.postForEntity(
            "/api/v1/auth/send-otp",
            otpRequest,
            ApiResponse.class
        );
        assertThat(otpResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
        
        // Step 2: Verify OTP (using test OTP: 123456)
        VerifyOtpRequest verifyRequest = new VerifyOtpRequest("+91-9876543210", "123456");
        ResponseEntity<AuthResponse> verifyResponse = restTemplate.postForEntity(
            "/api/v1/auth/verify-otp",
            verifyRequest,
            AuthResponse.class
        );
        assertThat(verifyResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(verifyResponse.getBody().getAccessToken()).isNotNull();
        assertThat(verifyResponse.getBody().getUser().getPhoneNumber()).isEqualTo("+91-9876543210");
    }
}
```

### Kafka Integration Test

```java
@SpringBootTest
@Testcontainers
public class OrderKafkaIntegrationTest {
    
    @Container
    static KafkaContainer kafka = new KafkaContainer(DockerImageName.parse("confluentinc/cp-kafka:7.5.0"));
    
    @Autowired
    private KafkaTemplate<String, OrderCreatedEvent> kafkaTemplate;
    
    @Autowired
    private NotificationService notificationService;  // Consumer
    
    @Test
    public void testOrderCreatedEventPublishedAndConsumed() throws InterruptedException {
        // Publish event
        OrderCreatedEvent event = OrderCreatedEvent.builder()
            .orderId(UUID.randomUUID())
            .orderNumber("FD-2024-000123")
            .userId(UUID.randomUUID())
            .totalAmount(450.00)
            .build();
        
        kafkaTemplate.send("order.created", event.getRestaurantId().toString(), event);
        
        // Wait for consumer to process
        Thread.sleep(2000);
        
        // Verify notification was sent
        verify(firebaseService, times(1)).sendNotification(any(), contains("Order Placed"), any(), any());
    }
}
```

---

## End-to-End Test Scenarios

### Scenario 1: Complete Order Placement

**newman/tests/order-flow.json:**

```json
{
  "name": "Complete Order Flow",
  "tests": [
    {
      "name": "1. Send OTP",
      "request": {
        "method": "POST",
        "url": "{{BASE_URL}}/api/v1/auth/send-otp",
        "body": {"phoneNumber": "+91-9000000001"}
      },
      "assertions": [
        {"status": 200},
        {"jsonPath": "$.success", "equals": true}
      ]
    },
    {
      "name": "2. Verify OTP",
      "request": {
        "method": "POST",
        "url": "{{BASE_URL}}/api/v1/auth/verify-otp",
        "body": {"phoneNumber": "+91-9000000001", "otp": "123456"}
      },
      "assertions": [
        {"status": 200},
        {"jsonPath": "$.data.accessToken", "exists": true}
      ],
      "setEnv": {
        "ACCESS_TOKEN": "$.data.accessToken",
        "USER_ID": "$.data.user.id"
      }
    },
    {
      "name": "3. Discover Restaurants",
      "request": {
        "method": "GET",
        "url": "{{BASE_URL}}/api/v1/restaurants?latitude=18.5204&longitude=73.8567&radius=5"
      },
      "assertions": [
        {"status": 200},
        {"jsonPath": "$.data.content.length", "greaterThan": 0}
      ],
      "setEnv": {
        "RESTAURANT_ID": "$.data.content[0].restaurantId"
      }
    },
    {
      "name": "4. Get Restaurant Detail",
      "request": {
        "method": "GET",
        "url": "{{BASE_URL}}/api/v1/restaurants/{{RESTAURANT_ID}}"
      },
      "assertions": [
        {"status": 200},
        {"jsonPath": "$.data.menu.length", "greaterThan": 0}
      ],
      "setEnv": {
        "MENU_ITEM_ID": "$.data.menu[0].items[0].menuItemId"
      }
    },
    {
      "name": "5. Add Item to Cart",
      "request": {
        "method": "POST",
        "url": "{{BASE_URL}}/api/v1/cart/items",
        "headers": {"Authorization": "Bearer {{ACCESS_TOKEN}}"},
        "body": {
          "restaurantId": "{{RESTAURANT_ID}}",
          "menuItemId": "{{MENU_ITEM_ID}}",
          "quantity": 2,
          "customizations": {}
        }
      },
      "assertions": [
        {"status": 200}
      ]
    },
    {
      "name": "6. Apply Coupon",
      "request": {
        "method": "POST",
        "url": "{{BASE_URL}}/api/v1/cart/coupon",
        "headers": {"Authorization": "Bearer {{ACCESS_TOKEN}}"},
        "body": {"couponCode": "SAVE50"}
      },
      "assertions": [
        {"status": 200},
        {"jsonPath": "$.data.discount", "greaterThan": 0}
      ]
    },
    {
      "name": "7. Place Order",
      "request": {
        "method": "POST",
        "url": "{{BASE_URL}}/api/v1/orders",
        "headers": {"Authorization": "Bearer {{ACCESS_TOKEN}}"},
        "body": {
          "addressId": "{{ADDRESS_ID}}",
          "paymentMethod": "CARD"
        }
      },
      "assertions": [
        {"status": 201},
        {"jsonPath": "$.data.razorpayOrderId", "exists": true}
      ],
      "setEnv": {
        "ORDER_ID": "$.data.orderId",
        "RAZORPAY_ORDER_ID": "$.data.razorpayOrderId"
      }
    }
  ]
}
```

**Run E2E Tests:**

```bash
# Install Newman
npm install -g newman

# Run collection
newman run newman/tests/order-flow.json \
  --environment newman/environments/local.json \
  --reporters cli,json \
  --reporter-json-export newman/results/order-flow-result.json
```

---

## CI/CD Pipeline

### GitHub Actions Workflow

**.github/workflows/ci.yml:**

```yaml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test-backend:
    name: Backend Tests
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service: [user-service, restaurant-service, order-service, payment-service, delivery-service, notification-service, search-service]
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
          cache: maven
      
      - name: Run Tests
        run: |
          cd backend/${{ matrix.service }}
          mvn clean test jacoco:report
      
      - name: Check Coverage
        run: |
          COVERAGE=$(grep -oP '(?<=<counter type="LINE" missed="\d+" covered=")\d+' \
            backend/${{ matrix.service }}/target/site/jacoco/jacoco.xml | \
            awk '{sum+=$1} END {print (sum/(sum+NR))*100}')
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage below 80%"
            exit 1
          fi
      
      - name: Upload Coverage Report
        uses: codecov/codecov-action@v3
        with:
          files: backend/${{ matrix.service }}/target/site/jacoco/jacoco.xml
          flags: ${{ matrix.service }}
  
  test-frontend:
    name: Frontend Tests
    runs-on: ubuntu-latest
    strategy:
      matrix:
        app: [customer-app, restaurant-portal, delivery-partner-app, admin-console]
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: frontend/${{ matrix.app }}/package-lock.json
      
      - name: Install Dependencies
        run: |
          cd frontend/${{ matrix.app }}
          npm ci
      
      - name: Run Tests
        run: |
          cd frontend/${{ matrix.app }}
          npm run type-check
          npm run lint
          npm test -- --coverage
      
      - name: Build
        run: |
          cd frontend/${{ matrix.app }}
          npm run build
  
  integration-test:
    name: Integration Tests
    runs-on: ubuntu-latest
    needs: [test-backend, test-frontend]
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Start Services
        run: |
          docker-compose up -d
          sleep 90  # Wait for services to be ready
      
      - name: Run E2E Tests
        run: |
          npm install -g newman
          newman run newman/tests/order-flow.json \
            --environment newman/environments/ci.json
      
      - name: Stop Services
        if: always()
        run: docker-compose down
  
  build-docker-images:
    name: Build Docker Images
    runs-on: ubuntu-latest
    needs: [integration-test]
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and Push Images
        run: |
          for service in user-service restaurant-service order-service payment-service delivery-service notification-service search-service; do
            docker build -t ghcr.io/${{ github.repository }}/$service:${{ github.sha }} backend/$service
            docker push ghcr.io/${{ github.repository }}/$service:${{ github.sha }}
          done
```

### Required GitHub Secrets

| Secret | Where to Get | Used In Job |
|--------|--------------|-------------|
| CODECOV_TOKEN | codecov.io | test-backend |
| DOCKER_USERNAME | Docker Hub | build-docker-images |
| DOCKER_PASSWORD | Docker Hub | build-docker-images |
| AWS_ACCESS_KEY_ID | AWS Console | deploy (if using AWS) |
| AWS_SECRET_ACCESS_KEY | AWS Console | deploy |

---

## Branch Strategy

```
main (production)
  │
  ├─ develop (integration)
  │   │
  │   ├─ feature/user-auth
  │   ├─ feature/restaurant-search
  │   └─ feature/order-tracking
  │
  └─ hotfix/payment-bug
```

**Rules:**
- `main`: Protected, requires PR approval + passing CI
- `develop`: Integration branch, all features merge here first
- `feature/*`: Branch from develop, merge back via PR
- `hotfix/*`: Branch from main, merge to main AND develop

**PR Requirements:**
- All CI checks pass (✅)
- Code coverage ≥ 80% (✅)
- 1+ approval from code owner (✅)
- No merge conflicts (✅)

---

**END OF TESTING & CI/CD DOCUMENTATION**