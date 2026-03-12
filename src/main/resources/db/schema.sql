-- =========================================
-- RX Control Pharmacy Management System
-- Database Initialization
-- =========================================

CREATE DATABASE IF NOT EXISTS rx_control
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE rx_control;

-- ==============================
-- USERS
-- ==============================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN','PHARMACIST','CASHIER') NOT NULL,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- CUSTOMERS
-- ==============================
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- SUPPLIERS
-- ==============================
CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- MEDICINE CATEGORIES
-- ==============================
CREATE TABLE medicine_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- ==============================
-- MEDICINES (PRODUCT MASTER)
-- ==============================
CREATE TABLE medicines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    brand VARCHAR(100),
    category_id INT,
    dosage_form VARCHAR(50),
    strength VARCHAR(50),
    manufacturer VARCHAR(150),
    barcode VARCHAR(100) UNIQUE,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_medicine_category
        FOREIGN KEY (category_id)
        REFERENCES medicine_categories(id)
        ON DELETE SET NULL
);

-- ==============================
-- MEDICINE BATCHES (INVENTORY)
-- ==============================
CREATE TABLE medicine_batches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    supplier_id INT,
    batch_number VARCHAR(100) NOT NULL,
    expiry_date DATE NOT NULL,
    buy_price DECIMAL(10,2) NOT NULL,
    sell_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    received_date DATE,
    status ENUM('ACTIVE','EXPIRED','OUT_OF_STOCK') DEFAULT 'ACTIVE',

    CONSTRAINT fk_batch_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_batch_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(id)
        ON DELETE SET NULL
);

-- ==============================
-- PURCHASES
-- ==============================
CREATE TABLE purchases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    invoice_number VARCHAR(100),
    purchase_date DATE NOT NULL,
    total_amount DECIMAL(12,2),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_purchase_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(id),

    CONSTRAINT fk_purchase_user
        FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON DELETE SET NULL
);

-- ==============================
-- PURCHASE ITEMS
-- ==============================
CREATE TABLE purchase_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_id INT NOT NULL,
    medicine_id INT NOT NULL,
    batch_number VARCHAR(100),
    expiry_date DATE,
    buy_price DECIMAL(10,2),
    quantity INT,
    subtotal DECIMAL(12,2),

    CONSTRAINT fk_purchase_item_purchase
        FOREIGN KEY (purchase_id)
        REFERENCES purchases(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_item_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(id)
);

-- ==============================
-- SALES
-- ==============================
CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    customer_id INT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,
    payment_method ENUM('CASH','CARD','TRANSFER') DEFAULT 'CASH',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sale_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_sale_user
        FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON DELETE SET NULL
);

-- ==============================
-- SALE ITEMS
-- ==============================
CREATE TABLE sale_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    medicine_id INT NOT NULL,
    batch_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_sale_item_sale
        FOREIGN KEY (sale_id)
        REFERENCES sales(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_sale_item_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(id),

    CONSTRAINT fk_sale_item_batch
        FOREIGN KEY (batch_id)
        REFERENCES medicine_batches(id)
);

-- ==============================
-- STOCK TRANSACTIONS (AUDIT TRAIL)
-- ==============================
CREATE TABLE stock_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    batch_id INT,
    transaction_type ENUM('PURCHASE','SALE','RETURN','ADJUSTMENT','EXPIRED'),
    quantity INT NOT NULL,
    reference_id INT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,

    CONSTRAINT fk_stock_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(id),

    CONSTRAINT fk_stock_batch
        FOREIGN KEY (batch_id)
        REFERENCES medicine_batches(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_stock_user
        FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON DELETE SET NULL
);

