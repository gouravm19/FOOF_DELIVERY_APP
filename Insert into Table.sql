-- Insert sample data into Organization table
INSERT INTO Organization (id, name) VALUES
(4, 'Organization D'),
(5, 'Organization D'),
(6, 'Organization C'),
(7, 'Organization C'),
(8, 'Organization C'),
(9, 'Organization C');

-- Insert sample data into Item table
INSERT INTO Item (type, description) VALUES
('perishable', 'Perishable foods are those likely to spoil, decay or become unsafe to consume if not kept refrigerated at 40 °F or below, or frozen at 0 °F or below'),
('non-perishable', 'non-perishable foods are those that do not require immediate refrigeration and can be stored for a long time (generally a year or more) without spoiling');

-- Inserting sample data for pricing
INSERT INTO Pricing (organization_id, item_id, zone, base_distance_in_km, km_price, fix_price) VALUES
('001', 1, 'western', 5, 1.5, 10),     -- Organization A, Perishable, Central Zone
('002', 2, 'western', 5, 1, 10),     -- Organization A, Non-Perishable, Central Zone
('003', 1, 'central', 5, 1.5, 10),     -- Organization B, Perishable, Central Zone
('004', 2, 'central', 5, 1, 10),     -- Organization B, Non-Perishable, Central Zone
('005', 1, 'central', 5, 1.5, 10),     -- Organization C, Perishable, Central Zone
('006', 1, 'eastern', 5, 1, 10);     -- Organization C, Non-Perishable, Central Zone

