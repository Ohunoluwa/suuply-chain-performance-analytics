--=================================================
-- POPULATING SILVER TABLES (INSERT DATA PIPELINE)
--=================================================

-- 1. CUSTOMERS
INSERT INTO silver.customers (
    customer_id, 
    customer_name, 
    city, 
    segment)
SELECT 
    CAST(TRY_CAST(customer_id AS FLOAT) AS INT) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(UPPER(city)) AS city,
    TRIM(LOWER(segment)) AS segment
FROM bronze.customers
WHERE customer_id IS NOT NULL 
  AND customer_id <> '';
GO


-- 2. INVENTORY

INSERT INTO silver.inventory (
    inventory_id, 
    product_id, 
    warehouse_id, 
    stock_level, 
    last_updated)
SELECT 
    CAST(TRY_CAST(inventory_id AS FLOAT) AS INT) AS inventory_id,
    CAST(TRY_CAST(product_id AS FLOAT) AS INT) AS product_id,
    CAST(TRY_CAST(warehouse_id AS FLOAT) AS INT) AS warehouse_id,
    CASE 
        WHEN CAST(TRY_CAST(stock_level AS FLOAT) AS INT) < 0 THEN NULL
        ELSE CAST(TRY_CAST(stock_level AS FLOAT) AS INT)
    END AS stock_level,
     last_updated
FROM bronze.inventory
WHERE inventory_id IS NOT NULL 
  AND inventory_id <> '';
GO


-- 3. ORDERS

INSERT INTO silver.orders (
    order_id, 
    customer_id, 
    product_id, 
    warehouse_id,
     order_date, 
     quantity, 
     order_status)
SELECT 
    CAST(TRY_CAST(order_id AS FLOAT) AS INT) AS order_id,
    CAST(TRY_CAST(customer_id AS FLOAT) AS INT) AS customer_id,
    CAST(TRY_CAST(product_id AS FLOAT) AS INT) AS product_id,
    CAST(TRY_CAST(warehouse_id AS FLOAT) AS INT) AS warehouse_id,
    order_date,
    ABS(CAST(TRY_CAST(quantity AS FLOAT) AS INT)) AS quantity,
    CASE  WHEN order_status IS NULL 
           OR TRIM(order_status) = '' THEN 'UNKNOWN'
          ELSE UPPER(TRIM(order_status))
    END AS order_status
FROM bronze.orders
WHERE order_id IS NOT NULL 
  AND order_id <> '';

  SELECT *
  FROM silver.orders
GO


-- 4. PRODUCTS

INSERT INTO silver.products (
    product_id, 
    product_name, 
    category, 
    unit_price,
     supplier_id)
SELECT 
    CAST(TRY_CAST(product_id AS FLOAT) AS INT) AS product_id,
    TRIM(product_name) AS product_name,
    TRIM(UPPER(category)) AS category,
    CASE 
        WHEN CAST(TRY_CAST(unit_price AS FLOAT) AS DECIMAL(18,2)) < 0 THEN NULL
        ELSE CAST(TRY_CAST(unit_price AS FLOAT) AS DECIMAL(18,2))
    END AS unit_price,
    
    CAST(TRY_CAST(supplier_id AS FLOAT) AS INT) AS supplier_id
FROM bronze.products
WHERE product_id IS NOT NULL 
  AND product_id <> '';
GO


-- 5. RETURNS

INSERT INTO silver.returns (
    return_id, 
    order_id, 
    return_reason, 
    refund_amount)
SELECT 
    CAST(TRY_CAST(return_id AS FLOAT) AS INT) AS return_id,
    CAST(TRY_CAST(order_id AS FLOAT) AS INT) AS order_id,
    
    TRIM(LOWER(return_reason)) AS return_reason,
    
    CASE 
        WHEN CAST(TRY_CAST(refund_amount AS FLOAT) AS DECIMAL(18,2)) < 0 THEN NULL
        ELSE CAST(TRY_CAST(refund_amount AS FLOAT) AS DECIMAL(18,2))
    END AS refund_amount
FROM bronze.returns
WHERE return_id IS NOT NULL 
  AND return_id <> '';
GO


-- 6. SHIPMENTS

INSERT INTO silver.shipments (
    shipment_id, 
    order_id, 
    shipment_date, 
    delivery_date, 
    shipping_cost)
SELECT 
    CAST(TRY_CAST(shipment_id AS FLOAT) AS INT) AS shipment_id,
    CAST(TRY_CAST(order_id AS FLOAT) AS INT) AS order_id,
    shipment_date,
    DATEADD(day, (CAST(TRY_CAST(shipment_id AS FLOAT) AS INT) % 10) + 2, shipment_date) AS delivery_date,
      CASE 
        WHEN CAST(TRY_CAST(shipping_cost AS FLOAT) AS DECIMAL(18,2)) < 0 THEN NULL
        ELSE CAST(TRY_CAST(shipping_cost AS FLOAT) AS DECIMAL(18,2))
    END AS shipping_cost
FROM bronze.shipments
WHERE shipment_id IS NOT NULL 
  AND shipment_id <> '';

GO

-- 7. SUPPLIERS

INSERT INTO silver.suppliers (
     supplier_id,
     supplier_name, 
     country, 
     lead_time_days)
SELECT 
    CAST(TRY_CAST(supplier_id AS FLOAT) AS INT) AS supplier_id,
    TRIM(UPPER(supplier_name)) AS supplier_name,
    TRIM(UPPER(country)) AS country,
    CASE 
        WHEN CAST(TRY_CAST(lead_time_days AS FLOAT) AS INT) < 0 THEN NULL
        ELSE CAST(TRY_CAST(lead_time_days AS FLOAT) AS INT)
    END AS lead_time_days
FROM bronze.suppliers
WHERE supplier_id IS NOT NULL 
  AND supplier_id <> '';
GO


-- 8. WAREHOUSES

INSERT INTO silver.warehouses (
     warehouse_id, 
     location,
      capacity)
SELECT 
    CAST(TRY_CAST(warehouse_id AS FLOAT) AS INT) AS warehouse_id,
    TRIM(UPPER(location)) AS location,
    CASE 
        WHEN CAST(TRY_CAST(capacity AS FLOAT) AS INT) < 0 THEN NULL
        ELSE CAST(TRY_CAST(capacity AS FLOAT) AS INT)
    END AS capacity
FROM bronze.warehouses
WHERE warehouse_id IS NOT NULL 
  AND warehouse_id <> '';
  
GO