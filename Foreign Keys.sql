-- Add foreign key constraints to Pricing table
ALTER TABLE Pricing
ADD CONSTRAINT fk_organization
FOREIGN KEY (organization_id)
REFERENCES Organization(id);

ALTER TABLE Pricing
ADD CONSTRAINT fk_item
FOREIGN KEY (item_id)
REFERENCES Item(id);
