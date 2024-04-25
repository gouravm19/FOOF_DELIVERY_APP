CREATE TABLE Organization (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
CREATE TABLE Item (
    id SERIAL PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    description TEXT
);
CREATE TABLE Pricing (
  organization_id INTEGER NOT NULL,
  item_id INTEGER NOT NULL,
  zone VARCHAR(255) NOT NULL,
  base_distance_in_km INTEGER NOT NULL,
  km_price FLOAT NOT NULL,
  fix_price INTEGER NOT NULL,
  FOREIGN KEY (organization_id) REFERENCES Organization(id),
  FOREIGN KEY (item_id) REFERENCES Item(id)
);