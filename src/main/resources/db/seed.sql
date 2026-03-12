-- ==========================
-- SAMPLE DATA
-- ==========================

-- USERS
INSERT INTO users (username, password_hash, full_name, role) VALUES
('admin', 'admin123', 'System Administrator', 'ADMIN'),
('pharma01', 'pass123', 'Pharmacist One', 'PHARMACIST'),
('cashier01', 'pass123', 'Cashier One', 'CASHIER');

-- CUSTOMERS
INSERT INTO customers (name, phone, address) VALUES
('John Silva', '0771234567', 'Colombo'),
('Mary Perera', '0719876543', 'Kandy');

-- SUPPLIERS
INSERT INTO suppliers (name, contact_person, phone, email, address) VALUES
('Health Distributors', 'Mr. Kumar', '0112233445', 'kumar@healthdist.lk', 'Colombo'),
('Pharma Supply Ltd', 'Mrs. Nimal', '0115566778', 'nimal@pharmasupply.lk', 'Galle');

-- MEDICINE CATEGORIES
INSERT INTO medicine_categories (name, description) VALUES
('Painkillers', 'Pain relief medicines'),
('Antibiotics', 'Bacterial infection treatment');

-- MEDICINES
INSERT INTO medicines (name, generic_name, brand, category_id, dosage_form, strength, manufacturer, barcode) VALUES
('Panadol', 'Paracetamol', 'Panadol', 1, 'Tablet', '500mg', 'GSK', '1234567890123'),
('Amoxil', 'Amoxicillin', 'Amoxil', 2, 'Capsule', '250mg', 'Pfizer', '9876543210987');

-- MEDICINE BATCHES
INSERT INTO medicine_batches (medicine_id, supplier_id, batch_number, expiry_date, buy_price, sell_price, quantity, received_date) VALUES
(1, 1, 'B001', '2026-01-15', 20.00, 35.00, 100, '2025-01-01'),
(1, 2, 'B002', '2025-12-01', 19.50, 34.50, 50, '2025-02-10'),
(2, 1, 'A001', '2025-11-20', 50.00, 80.00, 200, '2025-03-01');

-- PURCHASES
INSERT INTO purchases (supplier_id, invoice_number, purchase_date, total_amount, created_by) VALUES
(1, 'PUR-001', '2025-01-01', 2000.00, 1);

-- PURCHASE ITEMS
INSERT INTO purchase_items (purchase_id, medicine_id, batch_number, expiry_date, buy_price, quantity, subtotal) VALUES
(1, 1, 'B001', '2026-01-15', 20.00, 100, 2000.00);

-- SALES
INSERT INTO sales (invoice_number, customer_id, total_amount, discount, payment_method, created_by) VALUES
('INV-001', NULL, 1050.00, 0, 'CASH', 3),
('INV-002', 1, 350.00, 0, 'CARD', 2);

-- SALE ITEMS
INSERT INTO sale_items (sale_id, medicine_id, batch_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 30, 35.00, 1050.00),
(2, 2, 3, 5, 70.00, 350.00);

-- STOCK TRANSACTIONS
INSERT INTO stock_transactions (medicine_id, batch_id, transaction_type, quantity, reference_id, created_by) VALUES
(1, 1, 'SALE', 30, 1, 3),
(2, 3, 'SALE', 5, 2, 2);