const { calculatePrice } = require('../services/calculatePriceService');

async function calculatePriceController(req, res) {
  try {
    const { zone, organization_id, total_distance, item_type } = req.body;
    const totalPrice = await calculatePrice(organization_id, zone, total_distance, item_type);
    res.json({ total_price: totalPrice });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ error: 'Server error' });
  }
}

module.exports = { calculatePriceController };
