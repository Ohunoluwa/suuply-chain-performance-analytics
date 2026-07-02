

--========================
-- CREATING SILVER TABLES
--========================

-- 1. Customers

IF OBJECT_ID ('U', 'silver.customers') IS NOT NULL
DROP TABLE silver.customers;

CREATE TABLE silver.customers(
   customer_id INT,
   customer_name NVARCHAR(50),
   city NVARCHAR(50),
   segment NVARCHAR(50)
);

GO

-- 2. Inventory

IF OBJECT_ID ('U', 'silver.inventory') IS NOT NULL
DROP TABLE silver.inventory;

CREATE TABLE silver.inventory (
  inventory_id INT,
  product_id INT,
  warehouse_id INT,
  stock_level INT,
  last_updated DATE
);

GO

-- 3. Orders

IF OBJECT_ID ('U', 'silver.orders') IS NOT NULL
DROP TABLE silver.orders;

CREATE TABLE silver.orders(
  order_id INT,
  customer_id INT,
  product_id INT,
  warehouse_id INT,
  order_date DATE,
  quantity INT,
  order_status NVARCHAR(50)
);

GO

-- 4. Products

IF OBJECT_ID ('U', 'silver.products') IS NOT NULL
DROP TABLE silver.products;

CREATE TABLE silver.products(
    product_id INT,
    product_name NVARCHAR(50),
    category NVARCHAR(50),
    unit_price DECIMAL(18,2),
    supplier_id INT
);

GO

-- 5. Returns

IF OBJECT_ID ('U', 'silver.returns') IS NOT NULL
DROP TABLE silver.returns;

CREATE TABLE silver.returns(
  return_id INT,
  order_id INT,
  return_reason NVARCHAR(50),
  refund_amount DECIMAL(18,2)
);

GO

-- 6. Shipments

IF OBJECT_ID ('U', 'silver.shipments') IS NOT NULL
DROP TABLE silver.shipments;

CREATE TABLE silver.shipments(
    shipment_id INT,
    order_id INT,
    shipment_date DATE,
    delivery_date DATE,
    shipping_cost DECIMAL(18,2)
);

GO

-- 7. Suppliers

IF OBJECT_ID ('U', 'silver.suppliers') IS NOT NULL
DROP TABLE silver.suppliers;

CREATE TABLE silver.suppliers(
   supplier_id INT,
   supplier_name NVARCHAR(50),
   country NVARCHAR(50),
   lead_time_days INT
);

GO

-- 8. Warehouses

IF OBJECT_ID ('U', 'silver.warehouses') IS NOT NULL
DROP TABLE silver.warehouses;

CREATE TABLE silver.warehouses(
   warehouse_id INT,
   location NVARCHAR(50),
   capacity INT
);

GO