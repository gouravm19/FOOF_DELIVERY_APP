const { calculatePrice } = require('../src/services/calculatePriceService');

describe('calculatePrice', () => {
  it('should calculate the price for a given organization, zone, distance, and item type', async () => {
    const totalPrice = await calculatePrice('005', 'central', 12, 'perishable');
    expect(totalPrice).toBe(20.5); // Price in cents
  });

  it('should handle edge cases like zero distance or invalid organization', async () => {
      // Edge case: Zero distance
      let totalPrice = await calculatePrice('001', 'western', 0, 'perishable');
      expect(totalPrice).toBe(10); // Base price for perishable items
    // Edge case: Invalid organization
    await expect(calculatePrice('999', 'central', 10, 'perishable')).rejects.toThrow('Pricing not found for the given organization and zone');
  });
});
