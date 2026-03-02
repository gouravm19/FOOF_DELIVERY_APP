# 🔗 Third-Party Integration Guide

## 8.1 Razorpay Integration (Complete Setup)

### Account Setup
1. Visit https://dashboard.razorpay.com/signup
2. Register with email
3. Complete KYC (PAN, Aadhar, Bank Account)
4. Approval takes 24-48 hours

### Getting API Keys

**Test Mode:**
1. Dashboard → Settings → API Keys
2. Generate Test Key
3. Copy:
   - `Key ID`: rzp_test_xxxxx
   - `Key Secret`: xxxxxxxxxx (keep secret)

**Live Mode:**
1. Complete KYC + business verification
2. Activate account
3. Generate Live Key
4. Copy: `rzp_live_xxxxx`

### Test Cards

| Card Number | CVV | Expiry | Expected Result |
|-------------|-----|--------|----------------|
| 4111 1111 1111 1111 | Any | Future | SUCCESS |
| 4012 0010 3714 1112 | Any | Future | FAIL (insufficient funds) |
| 5104 0155 5555 5558 | Any | Future | SUCCESS (Mastercard) |

### Test UPI IDs

| UPI ID | Result |
|--------|--------|
| success@razorpay | SUCCESS |
| failure@razorpay | FAILED |

### Integration Code

```java
// application.yml
razorpay:
  key-id: ${RAZORPAY_KEY_ID}
  key-secret: ${RAZORPAY_KEY_SECRET}

// PaymentService.java
public RazorpayOrderResponse createOrder(Order order) {
    RazorpayClient client = new RazorpayClient(keyId, keySecret);
    
    JSONObject options = new JSONObject();
    options.put("amount", (int)(order.getTotalAmount() * 100));  // Paise
    options.put("currency", "INR");
    options.put("receipt", order.getOrderNumber());
    options.put("notes", Map.of(
        "orderId", order.getId().toString(),
        "customerId", order.getUserId().toString()
    ));
    
    Order razorpayOrder = client.Orders.create(options);
    
    return RazorpayOrderResponse.builder()
        .razorpayOrderId(razorpayOrder.get("id"))
        .amount(razorpayOrder.get("amount"))
        .currency(razorpayOrder.get("currency"))
        .build();
}

public boolean verifySignature(String orderId, String paymentId, String signature) {
    String payload = orderId + "|" + paymentId;
    String expectedSignature = HmacUtils.hmacSha256Hex(keySecret, payload);
    return expectedSignature.equals(signature);
}
```

### Webhook Configuration

1. Dashboard → Webhooks
2. Add URL: `https://yourdomain.com/api/v1/payments/webhook`
3. Select events:
   - payment.captured
   - payment.failed
   - refund.processed
4. Copy Webhook Secret
5. Verify webhook signature:

```java
@PostMapping("/webhook")
public ResponseEntity<Void> handleWebhook(
        @RequestBody String payload,
        @RequestHeader("X-Razorpay-Signature") String signature) {
    
    String expectedSignature = HmacUtils.hmacSha256Hex(webhookSecret, payload);
    if (!expectedSignature.equals(signature)) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
    
    // Process event
    return ResponseEntity.ok().build();
}
```

### Cost Structure

| Payment Method | Fee |
|----------------|-----|
| Domestic Cards | 2% + ₹0 |
| UPI | 0% (currently free) |
| Net Banking | 2% + ₹0 |
| Wallets | 2% + ₹0 |
| International Cards | 3% + ₹4 |

---

## 8.2 Twilio SMS Integration

### Account Setup
1. https://www.twilio.com/try-twilio
2. Verify email + phone
3. Free trial: $15.50 credit

### Getting Credentials

1. Console Dashboard
2. Copy:
   - Account SID: ACxxxxx
   - Auth Token: xxxxxxxxxx
   - Phone Number: +12025551234

### Trial Limitations

- Can only send to **verified numbers**
- All SMS have "Sent from your Twilio trial account" prefix
- 500 SMS limit

### Verify Test Numbers

1. Console → Phone Numbers → Verified Caller IDs
2. Add +91-9876543210
3. Enter verification code received

### Integration Code

```java
// application.yml
twilio:
  account-sid: ${TWILIO_ACCOUNT_SID}
  auth-token: ${TWILIO_AUTH_TOKEN}
  phone-number: ${TWILIO_PHONE_NUMBER}

// SmsService.java
public void sendOtp(String phoneNumber, String otp) {
    Twilio.init(accountSid, authToken);
    
    Message message = Message.creator(
        new PhoneNumber(phoneNumber),
        new PhoneNumber(twilioPhoneNumber),
        "Your FoodFlow OTP is: " + otp + ". Valid for 10 minutes."
    ).create();
    
    log.info("SMS sent: SID={}, Status={}", message.getSid(), message.getStatus());
}
```

### Cost (Production)

- India SMS: $0.0084 per message (~₹0.70)
- US SMS: $0.0075 per message

---

## 8.3 Google Maps APIs

### APIs Required

1. **Maps JavaScript API** — Display maps on frontend
2. **Geocoding API** — Convert address → lat/lng
3. **Distance Matrix API** — Calculate delivery time + distance
4. **Places API** — Address autocomplete

### Setup Steps

1. https://console.cloud.google.com
2. Create Project: "FoodFlow"
3. Enable APIs:
   - APIs & Services → Enable APIs
   - Search "Maps JavaScript API" → Enable
   - Repeat for other 3 APIs
4. Create Credentials:
   - Credentials → Create Credentials → API Key
   - Copy: AIzaSyXXXXXXXXXXXXXXXXXX

### Restrict API Key (Security)

1. Click API Key → Edit
2. **Application Restrictions:**
   - HTTP referrers
   - Add: `https://yourdomain.com/*` and `http://localhost:3000/*`
3. **API Restrictions:**
   - Restrict key
   - Select: Maps JavaScript API, Geocoding API, Distance Matrix API, Places API
4. Save

### Billing Setup

1. Billing → Link billing account
2. Free tier: $200/month credit
3. After free tier:
   - Maps loads: $7 per 1000 loads
   - Geocoding: $5 per 1000 requests
   - Distance Matrix: $5 per 1000 requests

### Integration Code

**Frontend (React):**

```javascript
// .env
REACT_APP_GOOGLE_MAPS_KEY=AIzaSyXXXXXXXXXXXXXXXXXX

// Map.jsx
import { GoogleMap, LoadScript, Marker } from '@react-google-maps/api';

function RestaurantMap({ lat, lng }) {
  return (
    <LoadScript googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_KEY}>
      <GoogleMap
        mapContainerStyle={{ width: '100%', height: '400px' }}
        center={{ lat, lng }}
        zoom={15}
      >
        <Marker position={{ lat, lng }} />
      </GoogleMap>
    </LoadScript>
  );
}
```

**Backend (Java):**

```java
// Calculate ETA using Distance Matrix API
public DeliveryEta calculateEta(LatLng origin, LatLng destination) {
    String url = "https://maps.googleapis.com/maps/api/distancematrix/json" +
        "?origins=" + origin.getLat() + "," + origin.getLng() +
        "&destinations=" + destination.getLat() + "," + destination.getLng() +
        "&key=" + googleMapsApiKey +
        "&mode=driving" +
        "&traffic_model=best_guess" +
        "&departure_time=now";
    
    RestTemplate restTemplate = new RestTemplate();
    DistanceMatrixResponse response = restTemplate.getForObject(url, DistanceMatrixResponse.class);
    
    Element element = response.getRows().get(0).getElements().get(0);
    
    return DeliveryEta.builder()
        .distanceMeters(element.getDistance().getValue())
        .durationSeconds(element.getDuration().getValue())
        .durationInTrafficSeconds(element.getDurationInTraffic().getValue())
        .build();
}
```

### Error Handling

**OVER_QUERY_LIMIT:**
```java
if (response.getStatus().equals("OVER_QUERY_LIMIT")) {
    // Cache previous result or use fallback
    return getCachedEta(origin, destination);
}
```

---

## 8.4 Firebase Cloud Messaging

### Setup

1. https://console.firebase.google.com
2. Create Project: "FoodFlow"
3. Add Android/iOS/Web App
4. Download `google-services.json` (Android) or `firebase-config.js` (Web)
5. Enable Cloud Messaging

### Service Account Key (Backend)

1. Project Settings → Service Accounts
2. Generate New Private Key
3. Download JSON: `foodflow-firebase-adminsdk.json`
4. Place in `backend/config/`

### Integration Code

**Backend:**

```java
// Initialize Firebase Admin SDK
@PostConstruct
public void initialize() {
    try {
        FileInputStream serviceAccount = new FileInputStream(
            "config/foodflow-firebase-adminsdk.json"
        );
        
        FirebaseOptions options = FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
            .build();
        
        FirebaseApp.initializeApp(options);
    } catch (IOException e) {
        log.error("Failed to initialize Firebase", e);
    }
}

// Send notification
public void sendNotification(String fcmToken, String title, String body, Map<String, String> data) {
    Message message = Message.builder()
        .setToken(fcmToken)
        .setNotification(Notification.builder()
            .setTitle(title)
            .setBody(body)
            .build())
        .putAllData(data)
        .setAndroidConfig(AndroidConfig.builder()
            .setPriority(AndroidConfig.Priority.HIGH)
            .build())
        .build();
    
    try {
        String response = FirebaseMessaging.getInstance().send(message);
        log.info("Successfully sent message: {}", response);
    } catch (FirebaseMessagingException e) {
        log.error("Failed to send notification to {}", fcmToken, e);
    }
}
```

**Frontend:**

```javascript
// firebase.js
import { initializeApp } from 'firebase/app';
import { getMessaging, getToken } from 'firebase/messaging';

const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXX",
  authDomain: "foodflow.firebaseapp.com",
  projectId: "foodflow",
  storageBucket: "foodflow.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:xxxxx"
};

const app = initializeApp(firebaseConfig);
const messaging = getMessaging(app);

export async function requestNotificationPermission() {
  const permission = await Notification.requestPermission();
  if (permission === 'granted') {
    const token = await getToken(messaging, {
      vapidKey: 'BExxxxxxxxxxxxxxxxxxxxxxxxx'
    });
    return token;  // Send to backend
  }
}
```

---

## 8.5 MinIO (Local S3)

### Already Configured

MinIO is included in `docker-compose.yml`, no setup needed!

**Access:**
- Console: http://localhost:9001
- Credentials: `minioadmin` / `minioadmin`

### Create Bucket

1. Open console
2. Buckets → Create Bucket
3. Name: `foodflow-images`
4. Create
5. Set Policy to Public Read:
   - Bucket → Manage → Access Rules
   - Add: `prefix: * | access: readonly`

### Upload Image

```java
public String uploadImage(MultipartFile file) {
    MinioClient client = MinioClient.builder()
        .endpoint("http://localhost:9000")
        .credentials("minioadmin", "minioadmin")
        .build();
    
    String filename = UUID.randomUUID() + "-" + file.getOriginalFilename();
    
    client.putObject(
        PutObjectArgs.builder()
            .bucket("foodflow-images")
            .object(filename)
            .stream(file.getInputStream(), file.getSize(), -1)
            .contentType(file.getContentType())
            .build()
    );
    
    return "http://localhost:9000/foodflow-images/" + filename;
}
```

### Switch to AWS S3 (Production)

```java
// Change endpoint
AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
    .withRegion(Regions.AP_SOUTH_1)
    .withCredentials(new AWSStaticCredentialsProvider(
        new BasicAWSCredentials(awsAccessKey, awsSecretKey)
    ))
    .build();
```

---

## 8.6 MailHog (Local Email Testing)

### Already Configured

MailHog is in `docker-compose.yml`, running at:
- SMTP: localhost:1025
- Web UI: http://localhost:8025

### View Emails

1. Open http://localhost:8025
2. All emails sent appear here (not actually delivered)

### Send Email (Spring Boot)

```java
@Autowired
private JavaMailSender mailSender;

public void sendOrderConfirmation(Order order) {
    MimeMessage message = mailSender.createMimeMessage();
    MimeMessageHelper helper = new MimeMessageHelper(message, true);
    
    helper.setFrom("noreply@foodflow.com");
    helper.setTo(order.getUser().getEmail());
    helper.setSubject("Order Confirmed - " + order.getOrderNumber());
    helper.setText(buildEmailHtml(order), true);  // HTML email
    
    mailSender.send(message);
}
```

### Switch to SendGrid (Production)

1. https://sendgrid.com/pricing (Free: 100 emails/day)
2. Get API Key
3. Update `application.yml`:

```yaml
spring:
  mail:
    host: smtp.sendgrid.net
    port: 587
    username: apikey
    password: ${SENDGRID_API_KEY}
```

---

**END OF INTEGRATION GUIDE**