
const { pool } = require('../db');
async function calculatePrice(organizationId, zone, distance, itemType) {
  try {
    const pricingQuery = {
      text: `SELECT base_distance_in_km, km_price, fix_price FROM Pricing
             WHERE organization_id = $1 AND zone = $2`,
      values: [organizationId, zone],
    };

    const pricingResult = await pool.query(pricingQuery);

    if (pricingResult.rows.length === 0) {
      throw new Error('Pricing not found for the given organization and zone');
    }

    const { base_distance_in_km, km_price, fix_price } = pricingResult.rows[0];
    let totalPrice = 0;
  if (distance <= base_distance_in_km) {
    totalPrice = fix_price;
  } else {
    totalPrice = fix_price + (distance - base_distance_in_km) * km_price;
  }

  return totalPrice;
  } catch (error) {
    throw new Error(`Failed to calculate price: ${error.message}`);
  }
}
const result = calculatePrice('005', 'central', 12, 'perishable');
console.log(result);
module.exports = { calculatePrice };
