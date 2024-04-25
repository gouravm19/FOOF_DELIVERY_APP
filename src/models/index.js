class Organization {
    constructor(id, name) {
      this.id = id;
      this.name = name;
    }
  }
  
  class Item {
    constructor(id, type, description) {
      this.id = id;
      this.type = type;
      this.description = description;
    }
  }
  
  class Pricing {
    constructor(organizationId, itemId, zone, baseDistance, kmPrice, fixPrice) {
      this.organizationId = organizationId;
      this.itemId = itemId;
      this.zone = zone;
      this.baseDistance = baseDistance;
      this.kmPrice = kmPrice;
      this.fixPrice = fixPrice;
    }
  }
  
  module.exports = { Organization, Item, Pricing };
  