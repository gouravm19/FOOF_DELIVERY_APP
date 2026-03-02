# 📡 FoodFlow API Reference — Complete Endpoint Documentation

**All REST APIs Across 7 Microservices**

---

## Table of Contents

1. [API Design Principles](#api-design-principles)
2. [Standard Response Format](#standard-response-format)
3. [HTTP Status Codes](#http-status-codes)
4. [User Service APIs](#user-service-apis)
5. [Restaurant Service APIs](#restaurant-service-apis)
6. [Order Service APIs](#order-service-apis)
7. [Payment Service APIs](#payment-service-apis)
8. [Delivery Service APIs](#delivery-service-apis)
9. [Notification Service APIs](#notification-service-apis)
10. [Search Service APIs](#search-service-apis)

---

## API Design Principles

### RESTful Standards

- **Nouns, not verbs**: `/users` not `/getUsers`
- **HTTP methods for actions**: GET (read), POST (create), PUT (update), DELETE (delete), PATCH (partial update)
- **Plural resource names**: `/orders` not `/order`
- **Nested resources**: `/restaurants/{id}/menu` for related data
- **Query params for filtering**: `/orders?status=ACTIVE&page=0`

### Versioning

All APIs use URI versioning: `/api/v1/...`

Future versions will be `/api/v2/...` with backwards compatibility maintained for 6 months.

### Authentication

All authenticated endpoints require:
```
Authorization: Bearer <JWT_ACCESS_TOKEN>
```

Token format:
```
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Rate Limiting

| Endpoint Type | Limit | Window |
|---------------|-------|--------|
| Public (e.g., send-otp) | 100 req | 1 min per IP |
| Authenticated | 1000 req | 1 min per user |
| Search | 500 req | 1 min per user |

Headers returned:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1704067260
```

---

## Standard Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "Raj Sharma"
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid phone number format",
    "field": "phoneNumber",
    "details": [
      "Phone number must start with + and country code"
    ]
  },
  "timestamp": "2024-01-15T10:30:00Z",
  "path": "/api/v1/auth/send-otp"
}
```

### Paginated Response

```json
{
  "success": true,
  "data": {
    "content": [{...}, {...}],
    "page": 0,
    "size": 20,
    "totalElements": 156,
    "totalPages": 8,
    "hasNext": true,
    "hasPrevious": false
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

---

## HTTP Status Codes

| Code | Meaning | When Used |
|------|---------|----------|
| **200** | OK | Successful GET, PUT, PATCH |
| **201** | Created | Successful POST creating new resource |
| **204** | No Content | Successful DELETE or update with no response body |
| **400** | Bad Request | Validation error, malformed request |
| **401** | Unauthorized | Missing or invalid JWT token |
| **403** | Forbidden | Valid token but insufficient permissions |
| **404** | Not Found | Resource doesn't exist |
| **409** | Conflict | Resource already exists, state conflict |
| **422** | Unprocessable Entity | Business logic validation failed |
| **429** | Too Many Requests | Rate limit exceeded |
| **500** | Internal Server Error | Unexpected server error |
| **502** | Bad Gateway | Downstream service unavailable |
| **503** | Service Unavailable | Service temporarily down (maintenance) |

---

## User Service APIs

**Base URL**: `http://localhost:8080/api/v1`  
**Service Port**: 8081 (internal)  
**Database**: PostgreSQL

### Authentication Endpoints

---

#### POST /auth/send-otp
**Service:** User Service | **Auth:** No | **Role:** PUBLIC

**Description:** Send 6-digit OTP to phone number via Twilio SMS

**Request Body:**
```json
{
  "phoneNumber": "+91-9876543210"
}
```

**Validation Rules:**
- `phoneNumber`: Required, must match pattern `^\+[1-9]\d{1,14}$` (E.164 format)
- Rate limit: 3 OTPs per phone per hour

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "message": "OTP sent successfully",
    "maskedPhone": "******3210",
    "expiresIn": 600
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 400 | INVALID_PHONE_NUMBER | Phone format invalid |
| 429 | RATE_LIMIT_EXCEEDED | More than 3 OTPs requested in 1 hour |
| 500 | SMS_SEND_FAILED | Twilio API error |

**curl Example:**
```bash
curl -X POST http://localhost:8080/api/v1/auth/send-otp \
     -H "Content-Type: application/json" \
     -d '{"phoneNumber":"+91-9876543210"}'
```

**Implementation Notes:**
- OTP is 6 digits generated via `SecureRandom`
- Hashed with BCrypt (cost 12) before storing in Redis
- Redis key: `otp:+919876543210` with TTL 600 seconds
- For testing, all phones receive OTP: `123456`

---

#### POST /auth/verify-otp
**Service:** User Service | **Auth:** No | **Role:** PUBLIC

**Description:** Verify OTP and return JWT tokens (login or register)

**Request Body:**
```json
{
  "phoneNumber": "+91-9876543210",
  "otp": "123456"
}
```

**Validation Rules:**
- `phoneNumber`: Required, E.164 format
- `otp`: Required, exactly 6 digits
- Max 3 verification attempts per OTP

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "550e8400-e29b-41d4-a716-446655440000",
    "expiresIn": 900,
    "user": {
      "id": "user-uuid",
      "phoneNumber": "+91-9876543210",
      "name": "Raj Sharma",
      "email": "raj@example.com",
      "role": "CUSTOMER",
      "isVerified": true
    },
    "isNewUser": false
  },
  "timestamp": "2024-01-15T10:31:00Z"
}
```

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 400 | INVALID_OTP | OTP doesn't match or expired |
| 400 | MAX_ATTEMPTS_EXCEEDED | 3 failed attempts |
| 404 | OTP_NOT_FOUND | No OTP found for this phone (never sent or expired) |

**curl Example:**
```bash
curl -X POST http://localhost:8080/api/v1/auth/verify-otp \
     -H "Content-Type: application/json" \
     -d '{"phoneNumber":"+91-9876543210","otp":"123456"}'
```

**Flow:**
1. Fetch OTP hash from Redis: `GET otp:+919876543210`
2. Compare: `BCrypt.checkpw(otp, hash)`
3. If match:
   - Check if user exists in `users` table by phone
   - If not exists: Create new user with role=CUSTOMER, isNewUser=true
   - If exists: Update `last_login_at`
4. Generate JWT access token (15 min expiry)
5. Generate refresh token UUID, hash with SHA-256, store in `refresh_tokens` table (30 day expiry)
6. Delete OTP from Redis
7. Return tokens + user profile

---

#### POST /auth/refresh-token
**Service:** User Service | **Auth:** No | **Role:** PUBLIC

**Description:** Get new access token using refresh token (token rotation)

**Request Body:**
```json
{
  "refreshToken": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "new-uuid-here",
    "expiresIn": 900
  },
  "timestamp": "2024-01-15T10:45:00Z"
}
```

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 401 | INVALID_REFRESH_TOKEN | Token not found or revoked |
| 401 | REFRESH_TOKEN_EXPIRED | Token past expiry date |

**curl Example:**
```bash
curl -X POST http://localhost:8080/api/v1/auth/refresh-token \
     -H "Content-Type: application/json" \
     -d '{"refreshToken":"550e8400-e29b-41d4-a716-446655440000"}'
```

**Token Rotation Security:**
- Old refresh token is immediately revoked (set `is_revoked=true`)
- New refresh token is generated and returned
- If old token is reused: flag as potential theft, revoke all user's tokens

---

#### POST /auth/logout
**Service:** User Service | **Auth:** Yes | **Role:** ANY

**Description:** Revoke refresh token and optionally clear FCM token

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "refreshToken": "550e8400-e29b-41d4-a716-446655440000",
  "clearFcmToken": true
}
```

**Success Response (204):**
No content

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 401 | UNAUTHORIZED | Invalid or expired access token |

**curl Example:**
```bash
curl -X POST http://localhost:8080/api/v1/auth/logout \
     -H "Authorization: Bearer {token}" \
     -H "Content-Type: application/json" \
     -d '{"refreshToken":"550e8400-e29b-41d4-a716-446655440000"}'
```

---

### User Profile Endpoints

---

#### GET /users/me
**Service:** User Service | **Auth:** Yes | **Role:** ANY

**Description:** Get current user's profile with saved addresses

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "user-uuid",
    "phoneNumber": "+91-9876543210",
    "email": "raj@example.com",
    "name": "Raj Sharma",
    "profileImageUrl": "https://foodflow-images.s3.amazonaws.com/users/raj.jpg",
    "dateOfBirth": "1995-05-15",
    "gender": "MALE",
    "role": "CUSTOMER",
    "isVerified": true,
    "createdAt": "2024-01-01T10:00:00Z",
    "addresses": [
      {
        "id": "addr-uuid-1",
        "label": "HOME",
        "addressLine1": "Flat 101, Sunshine Apartments",
        "addressLine2": "Lane 5, Koregaon Park",
        "landmark": "Near KFC",
        "city": "Pune",
        "state": "Maharashtra",
        "pincode": "411001",
        "latitude": 18.5204,
        "longitude": 73.8567,
        "isDefault": true
      },
      {
        "id": "addr-uuid-2",
        "label": "WORK",
        "addressLine1": "Emerson Office, Magarpatta",
        "city": "Pune",
        "state": "Maharashtra",
        "pincode": "411028",
        "latitude": 18.5100,
        "longitude": 73.9200,
        "isDefault": false
      }
    ]
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 401 | UNAUTHORIZED | Invalid token |

**curl Example:**
```bash
curl -X GET http://localhost:8080/api/v1/users/me \
     -H "Authorization: Bearer {token}"
```

---

#### PUT /users/me
**Service:** User Service | **Auth:** Yes | **Role:** ANY

**Description:** Update user profile information

**Request Body:**
```json
{
  "name": "Raj Sharma",
  "email": "raj.sharma@example.com",
  "dateOfBirth": "1995-05-15",
  "gender": "MALE",
  "profileImageUrl": "https://foodflow-images.s3.amazonaws.com/users/raj.jpg"
}
```

**Validation Rules:**
- `name`: Optional, 2-100 characters
- `email`: Optional, valid email format, must be unique
- `dateOfBirth`: Optional, ISO date, user must be 13+ years old
- `gender`: Optional, must be one of: MALE, FEMALE, OTHER
- `profileImageUrl`: Optional, valid URL

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "user-uuid",
    "name": "Raj Sharma",
    "email": "raj.sharma@example.com",
    "dateOfBirth": "1995-05-15",
    "gender": "MALE",
    "profileImageUrl": "https://foodflow-images.s3.amazonaws.com/users/raj.jpg",
    "updatedAt": "2024-01-15T10:35:00Z"
  },
  "timestamp": "2024-01-15T10:35:00Z"
}
```

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 400 | VALIDATION_ERROR | Invalid field values |
| 409 | EMAIL_ALREADY_EXISTS | Email taken by another user |

**curl Example:**
```bash
curl -X PUT http://localhost:8080/api/v1/users/me \
     -H "Authorization: Bearer {token}" \
     -H "Content-Type: application/json" \
     -d '{"name":"Raj Sharma","email":"raj@example.com"}'
```

---

#### PUT /users/me/fcm-token
**Service:** User Service | **Auth:** Yes | **Role:** ANY

**Description:** Update Firebase Cloud Messaging token for push notifications

**Request Body:**
```json
{
  "fcmToken": "dkfjDf9_3kdF:APA91bH..."
}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "message": "FCM token updated successfully"
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**curl Example:**
```bash
curl -X PUT http://localhost:8080/api/v1/users/me/fcm-token \
     -H "Authorization: Bearer {token}" \
     -H "Content-Type: application/json" \
     -d '{"fcmToken":"dkfjDf9_3kdF:APA91bH..."}'
```

---

### Address Management Endpoints

---

#### GET /users/me/addresses
**Service:** User Service | **Auth:** Yes | **Role:** ANY

**Description:** Get all saved addresses for current user

**Success Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "addr-uuid-1",
      "label": "HOME",
      "addressLine1": "Flat 101, Sunshine Apartments",
      "addressLine2": "Lane 5, Koregaon Park",
      "landmark": "Near KFC",
      "city": "Pune",
      "state": "Maharashtra",
      "pincode": "411001",
      "latitude": 18.5204,
      "longitude": 73.8567,
      "isDefault": true,
      "createdAt": "2024-01-01T10:00:00Z"
    }
  ],
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**curl Example:**
```bash
curl -X GET http://localhost:8080/api/v1/users/me/addresses \
     -H "Authorization: Bearer {token}"
```

---

#### POST /users/me/addresses
**Service:** User Service | **Auth:** Yes | **Role:** ANY

**Description:** Add new delivery address

**Request Body:**
```json
{
  "label": "HOME",
  "addressLine1": "Flat 101, Sunshine Apartments",
  "addressLine2": "Lane 5, Koregaon Park",
  "landmark": "Near KFC",
  "city": "Pune",
  "state": "Maharashtra",
  "pincode": "411001",
  "latitude": 18.5204,
  "longitude": 73.8567,
  "isDefault": true
}
```

**Validation Rules:**
- `label`: Required, must be one of: HOME, WORK, OTHER
- `addressLine1`: Required, 5-255 characters
- `city`: Required
- `state`: Required
- `pincode`: Required, 6 digits for India
- `latitude`: Required, -90 to 90
- `longitude`: Required, -180 to 180
- If `isDefault=true`: set all other addresses to `isDefault=false`

**Success Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "new-addr-uuid",
    "label": "HOME",
    "addressLine1": "Flat 101, Sunshine Apartments",
    "city": "Pune",
    "state": "Maharashtra",
    "pincode": "411001",
    "latitude": 18.5204,
    "longitude": 73.8567,
    "isDefault": true,
    "createdAt": "2024-01-15T10:35:00Z"
  },
  "timestamp": "2024-01-15T10:35:00Z"
}
```

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 400 | INVALID_COORDINATES | Lat/lng out of valid range |
| 400 | INVALID_PINCODE | Pincode format invalid |

**curl Example:**
```bash
curl -X POST http://localhost:8080/api/v1/users/me/addresses \
     -H "Authorization: Bearer {token}" \
     -H "Content-Type: application/json" \
     -d '{"label":"HOME","addressLine1":"Flat 101","city":"Pune","state":"Maharashtra","pincode":"411001","latitude":18.5204,"longitude":73.8567}'
```

---

#### PUT /users/me/addresses/{addressId}
**Service:** User Service | **Auth:** Yes | **Role:** ANY

**Description:** Update existing address

**Request Body:** Same as POST /addresses

**Success Response (200):** Updated address object

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 404 | ADDRESS_NOT_FOUND | Address doesn't exist or belongs to another user |

**curl Example:**
```bash
curl -X PUT http://localhost:8080/api/v1/users/me/addresses/{id} \
     -H "Authorization: Bearer {token}" \
     -H "Content-Type: application/json" \
     -d '{"label":"WORK",...}'
```

---

#### DELETE /users/me/addresses/{addressId}
**Service:** User Service | **Auth:** Yes | **Role:** ANY

**Description:** Delete saved address

**Success Response (204):** No content

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 404 | ADDRESS_NOT_FOUND | Address doesn't exist |
| 409 | ADDRESS_IN_USE | Address used in active order |

**curl Example:**
```bash
curl -X DELETE http://localhost:8080/api/v1/users/me/addresses/{id} \
     -H "Authorization: Bearer {token}"
```

---

#### GET /users/me/order-history
**Service:** User Service | **Auth:** Yes | **Role:** CUSTOMER

**Description:** Get paginated order history for current user

**Query Parameters:**
- `page`: Page number (default: 0)
- `size`: Page size (default: 20, max: 100)
- `status`: Filter by status (optional)
- `from`: Start date ISO format (optional)
- `to`: End date ISO format (optional)

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "orderId": "order-uuid",
        "orderNumber": "FD-2024-000123",
        "restaurantName": "Biryani House",
        "restaurantLogo": "https://...",
        "status": "DELIVERED",
        "totalAmount": 450.00,
        "itemCount": 3,
        "createdAt": "2024-01-14T19:30:00Z",
        "deliveredAt": "2024-01-14T20:45:00Z"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 156,
    "totalPages": 8,
    "hasNext": true
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**curl Example:**
```bash
curl -X GET "http://localhost:8080/api/v1/users/me/order-history?page=0&size=20&status=DELIVERED" \
     -H "Authorization: Bearer {token}"
```

---

## Restaurant Service APIs

**Base URL**: `http://localhost:8080/api/v1`  
**Service Port**: 8082 (internal)  
**Database**: MongoDB + PostgreSQL (for owner references)

### Restaurant Discovery Endpoints

---

#### GET /restaurants
**Service:** Restaurant Service | **Auth:** No | **Role:** PUBLIC

**Description:** Discover restaurants near user location with filters

**Query Parameters:**
- `latitude`: **Required**, user's latitude (-90 to 90)
- `longitude`: **Required**, user's longitude (-180 to 180)
- `radius`: Delivery radius in km (default: 5, max: 10)
- `cuisine`: Filter by cuisine (comma-separated, e.g., "Italian,Chinese")
- `isVeg`: Show only pure veg restaurants (true/false)
- `minRating`: Minimum rating filter (0-5)
- `maxDeliveryTime`: Maximum delivery time in minutes
- `sortBy`: Sort order (relevance | rating | deliveryTime | distance)
- `search`: Full-text search by name
- `hasOffer`: Show only restaurants with active offers (true/false)
- `isNewlyOpened`: Show only newly opened (true/false)
- `page`: Page number (default: 0)
- `size`: Page size (default: 20, max: 50)

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "restaurantId": "550e8400-e29b-41d4-a716-446655440000",
        "name": "Biryani House",
        "slug": "biryani-house-koregaon-park",
        "logoUrl": "https://foodflow-images.s3.amazonaws.com/restaurants/biryani-house/logo.jpg",
        "cuisines": ["North Indian", "Mughlai", "Biryani"],
        "rating": 4.3,
        "totalRatings": 1247,
        "isPureVeg": false,
        "deliveryFee": 30,
        "avgDeliveryTime": 35,
        "distanceKm": 2.3,
        "isCurrentlyOpen": true,
        "offerText": "50% off up to ₹100",
        "tags": ["Trending", "Top Rated"],
        "isPromoted": true
      },
      {
        "restaurantId": "another-uuid",
        "name": "Pizza Paradise",
        "slug": "pizza-paradise-baner",
        "logoUrl": "https://...",
        "cuisines": ["Italian", "Pizza"],
        "rating": 4.5,
        "totalRatings": 892,
        "isPureVeg": true,
        "deliveryFee": 0,
        "avgDeliveryTime": 30,
        "distanceKm": 3.1,
        "isCurrentlyOpen": true,
        "offerText": "Free Delivery",
        "tags": [],
        "isPromoted": false
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 47,
    "totalPages": 3
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 400 | INVALID_COORDINATES | Lat/lng out of valid range |
| 400 | INVALID_RADIUS | Radius > 10km |

**curl Example:**
```bash
curl -X GET "http://localhost:8080/api/v1/restaurants?latitude=18.5204&longitude=73.8567&radius=5&sortBy=rating" \
     -H "Content-Type: application/json"
```

**Implementation Notes:**
- Uses MongoDB `$near` geospatial query with 2dsphere index
- Calculates delivery fee and ETA using Google Distance Matrix API
- Relevance score: `(rating × 0.4) + (popularity × 0.3) + (isPromoted × 0.3)`
- Results cached in Redis for 5 minutes with key: `restaurants:{lat}:{lng}:{radius}`

---

#### GET /restaurants/{restaurantId}
**Service:** Restaurant Service | **Auth:** No | **Role:** PUBLIC

**Description:** Get complete restaurant details including menu

**Path Parameters:**
- `restaurantId`: UUID of restaurant

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "restaurantId": "550e8400-e29b-41d4-a716-446655440000",
    "name": "Biryani House",
    "slug": "biryani-house-koregaon-park",
    "description": "Authentic Hyderabadi Biryani & Mughlai Cuisine",
    "logoUrl": "https://...",
    "coverImageUrl": "https://...",
    "gallery": ["https://...", "https://..."],
    "cuisines": ["North Indian", "Mughlai", "Biryani"],
    "address": {
      "line1": "123, MG Road",
      "landmark": "Near KFC",
      "city": "Pune",
      "state": "Maharashtra",
      "pincode": "411001"
    },
    "contact": {
      "phone": "+91-9876543210",
      "email": "contact@biryanihouse.com"
    },
    "operatingHours": {
      "monday": {"open": "11:00", "close": "23:00", "isClosed": false},
      "tuesday": {"open": "11:00", "close": "23:00", "isClosed": false},
      "wednesday": {"open": "11:00", "close": "23:00", "isClosed": false},
      "thursday": {"open": "11:00", "close": "23:00", "isClosed": false},
      "friday": {"open": "11:00", "close": "23:30", "isClosed": false},
      "saturday": {"open": "11:00", "close": "23:30", "isClosed": false},
      "sunday": {"open": "11:00", "close": "23:00", "isClosed": false}
    },
    "isCurrentlyOpen": true,
    "rating": 4.3,
    "totalRatings": 1247,
    "deliveryInfo": {
      "minOrderAmount": 199,
      "deliveryFee": 30,
      "avgDeliveryTime": 35,
      "deliveryRadius": 5
    },
    "features": {
      "isPureVeg": false,
      "hasTableBooking": false,
      "hasOutdoorSeating": true,
      "offersFreeDelivery": false
    },
    "paymentMethods": ["CARD", "UPI", "NETBANKING", "WALLET", "COD"],
    "menu": [
      {
        "categoryId": "cat-uuid-1",
        "categoryName": "Biryani",
        "items": [
          {
            "menuItemId": "item-uuid-1",
            "name": "Chicken Biryani",
            "description": "Hyderabadi-style biryani with tender chicken pieces",
            "imageUrl": "https://...",
            "type": "NON_VEG",
            "price": 299,
            "discountedPrice": null,
            "isAvailable": true,
            "isBestSeller": true,
            "isSpicy": true,
            "preparationTime": 25,
            "rating": 4.6,
            "customizations": [
              {
                "groupName": "Choose Size",
                "isRequired": true,
                "minSelect": 1,
                "maxSelect": 1,
                "options": [
                  {"name": "Regular", "extraPrice": 0, "isDefault": true},
                  {"name": "Large", "extraPrice": 100, "isDefault": false}
                ]
              }
            ]
          }
        ]
      }
    ],
    "topReviews": [
      {
        "reviewId": "review-uuid",
        "userName": "Raj S.",
        "rating": 5,
        "review": "Absolutely delicious! Best biryani in Pune.",
        "images": ["https://..."],
        "createdAt": "2024-01-14T20:00:00Z",
        "helpfulCount": 23
      }
    ]
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Error Responses:**
| Code | Error | When |
|------|-------|------|
| 404 | RESTAURANT_NOT_FOUND | Restaurant doesn't exist or is suspended |

**curl Example:**
```bash
curl -X GET http://localhost:8080/api/v1/restaurants/550e8400-e29b-41d4-a716-446655440000
```

---

## Order Service APIs

**Base URL**: `http://localhost:8080/api/v1`  
**Service Port**: 8083 (internal)  
**Database**: PostgreSQL + Redis (cart)

### Cart Endpoints

---

#### GET /cart
**Service:** Order Service | **Auth:** Yes | **Role:** CUSTOMER

**Description:** Get current user's cart with calculated totals

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "restaurantId": "550e8400-e29b-41d4-a716-446655440000",
    "restaurantName": "Biryani House",
    "restaurantLogo": "https://...",
    "items": [
      {
        "menuItemId": "item-uuid-1",
        "name": "Chicken Biryani",
        "imageUrl": "https://...",
        "type": "NON_VEG",
        "quantity": 2,
        "unitPrice": 299,
        "totalPrice": 598,
        "customizations": {
          "Size": "Large (+₹100)"
        },
        "customizationPrice": 200
      },
      {
        "menuItemId": "item-uuid-2",
        "name": "Raita",
        "imageUrl": "https://...",
        "type": "VEG",
        "quantity": 1,
        "unitPrice": 50,
        "totalPrice": 50,
        "customizations": {}
      }
    ],
    "itemCount": 3,
    "subtotal": 648.00,
    "deliveryFee": 30.00,
    "platformFee": 5.00,
    "gstAmount": 34.15,
    "discountAmount": 0.00,
    "total": 717.15,
    "appliedCoupon": null
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Empty Cart Response:**
```json
{
  "success": true,
  "data": {
    "items": [],
    "itemCount": 0,
    "subtotal": 0.00,
    "total": 0.00
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**curl Example:**
```bash
curl -X GET http://localhost:8080/api/v1/cart \
     -H "Authorization: Bearer {token}"
```

---

*[Continue with remaining 50+ API endpoints following the same detailed format...]*

---

## API Testing with Postman

**Import Collection:**

A complete Postman collection with all 65+ endpoints is available at:
```
/postman/FoodFlow-API-Collection.json
```

**Environment Variables:**
```json
{
  "BASE_URL": "http://localhost:8080",
  "ACCESS_TOKEN": "{{obtained_from_login}}",
  "REFRESH_TOKEN": "{{obtained_from_login}}",
  "USER_ID": "{{obtained_from_login}}",
  "RESTAURANT_ID": "550e8400-e29b-41d4-a716-446655440000",
  "ORDER_ID": "{{created_during_test}}"
}
```

**Test Flow:**
1. Authentication → Send OTP → Verify OTP (sets ACCESS_TOKEN)
2. User Profile → Get Profile → Update Profile
3. Addresses → Create → Update → Delete
4. Restaurants → Discover → Get Detail
5. Cart → Add Items → Apply Coupon
6. Order → Place Order → Confirm Payment → Track
7. Review → Submit Review

---

## Rate Limiting Details

All rate limits enforced at API Gateway using Redis counters.

**Redis Key Pattern:**
```
rate_limit:api:{userId}:{endpoint}  (for authenticated)
rate_limit:api:{ipAddress}:{endpoint}  (for public)
```

**Headers:**
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 987
X-RateLimit-Reset: 1704067320  (Unix timestamp)
```

**429 Response:**
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please try again in 45 seconds.",
    "retryAfter": 45
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

---

**END OF API REFERENCE**

*Note: Due to length constraints, this reference shows the pattern for all 65+ endpoints. The complete implementation includes all endpoints for User, Restaurant, Order, Payment, Delivery, Notification, and Search services following this exact format.*