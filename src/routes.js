const express = require('express');
const { calculatePriceController } = require('./controllers/calculatePriceController');

const router = express.Router();

// Define the default route handler for the root path ("/")
router.get('/', (req, res) => {
  res.send('Food Delivery App API');
});

router.post('/calculatePrice', calculatePriceController);

module.exports = router;
