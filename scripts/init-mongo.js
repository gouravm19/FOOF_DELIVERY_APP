// ════════════════════════════════════════════════════════════════
// FOOD DELIVERY PLATFORM - MONGODB INITIALIZATION
// ════════════════════════════════════════════════════════════════
// Database: fooddelivery
// Purpose: Restaurants, Menus, Reviews
// ════════════════════════════════════════════════════════════════

db = db.getSiblingDB('fooddelivery');

// ════════════════════════════════════════════════════════════════
// COLLECTION: restaurants
// ════════════════════════════════════════════════════════════════
db.createCollection('restaurants');

// Create indexes
db.restaurants.createIndex({ "restaurantId": 1 }, { unique: true });
db.restaurants.createIndex({ "slug": 1 }, { unique: true });
db.restaurants.createIndex({ "status": 1 });
db.restaurants.createIndex({ "isCurrentlyOpen": 1 });
db.restaurants.createIndex({ "address.location": "2dsphere" });
db.restaurants.createIndex(
  { "name": "text", "cuisines": "text", "categories": "text" },
  { weights: { name: 10, cuisines: 5, categories: 3 } }
);

// ════════════════════════════════════════════════════════════════
// COLLECTION: menu_categories
// ════════════════════════════════════════════════════════════════
db.createCollection('menu_categories');

db.menu_categories.createIndex({ "restaurantId": 1, "sortOrder": 1 });
db.menu_categories.createIndex({ "isActive": 1 });

// ════════════════════════════════════════════════════════════════
// COLLECTION: menu_items
// ════════════════════════════════════════════════════════════════
db.createCollection('menu_items');

db.menu_items.createIndex({ "menuItemId": 1 }, { unique: true });
db.menu_items.createIndex({ "restaurantId": 1, "categoryId": 1 });
db.menu_items.createIndex({ "isAvailable": 1 });
db.menu_items.createIndex({ "isBestSeller": 1 });
db.menu_items.createIndex({ "name": "text", "description": "text", "tags": "text" });

// ════════════════════════════════════════════════════════════════
// COLLECTION: reviews
// ════════════════════════════════════════════════════════════════
db.createCollection('reviews');

db.reviews.createIndex({ "orderId": 1 }, { unique: true });
db.reviews.createIndex({ "restaurantId": 1, "createdAt": -1 });
db.reviews.createIndex({ "userId": 1 });
db.reviews.createIndex({ "deliveryPartnerId": 1 });
db.reviews.createIndex({ "isVerified": 1 });

// ════════════════════════════════════════════════════════════════
// SUCCESS MESSAGE
// ════════════════════════════════════════════════════════════════
print('MongoDB schema initialized successfully!');
print('Collections created: restaurants, menu_categories, menu_items, reviews');
print('Indexes created successfully');