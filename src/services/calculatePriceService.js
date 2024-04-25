
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'food_delivery_db',
  password: 'AllforOne@1912',
  port: 5432,
});
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
    let totalDistance = distance - base_distance_in_km;
    totalDistance = totalDistance > 0 ? totalDistance : 0;

    let totalPrice = fix_price + (totalDistance * km_price);

    
    return totalPrice;
  } catch (error) {
    throw new Error(`Failed to calculate price: ${error.message}`);
  }
}

module.exports = { calculatePrice };


module.exports = { calculatePrice };*/
