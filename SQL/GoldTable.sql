
--================
--DIMENSION VIEWS
--===============

CREATE OR ALTER VIEW gold.dim_customers AS
SELECT 
    customer_id,
    customer_name,
    city,
    segment
FROM silver.customers;

GO

CREATE OR ALTER VIEW gold.dim_warehouses AS
SELECT 
    warehouse_id,
    location,
    capacity
FROM silver.warehouses;

GO

CREATE OR ALTER VIEW gold.dim_suppliers AS
SELECT 
    supplier_id,
    supplier_name,
    country,
    lead_time_days AS agreed_lead_time_days
FROM silver.suppliers;

GO

CREATE OR ALTER VIEW gold.dim_products AS
SELECT 
    p.product_id,
    TRIM(p.product_name) AS product_name,
    TRIM(LOWER(p.category)) AS category,
    
    CASE 
        WHEN p.unit_price < 0 THEN NULL
        ELSE p.unit_price
    END AS unit_price,

    p.supplier_id,
    s.supplier_name,
    s.country AS supplier_country
FROM silver.products p
LEFT JOIN silver.suppliers s 
ON p.supplier_id = s.supplier_id;

GO

--FACT VIEWS

CREATE OR ALTER VIEW gold.fact_inventory AS
SELECT 
    inventory_id,
    product_id,
    warehouse_id,
    stock_level,
    CASE 
        WHEN stock_level IS NULL THEN 'UNKNOWN' 
        WHEN stock_level < 10 THEN 'LOW'
        WHEN stock_level BETWEEN 10 AND 100 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS stock_status,
    last_updated
FROM silver.inventory;

SELECT *
FROM gold.fact_inventory

DROP VIEW gold.fact_inventory

GO

CREATE OR ALTER VIEW gold.fact_returns AS
SELECT 
    return_id,
    order_id,
    return_reason,
    refund_amount
FROM silver.returns;

GO

CREATE OR ALTER VIEW gold.fact_shipments AS
SELECT 
    shipment_id,
    order_id,
    shipment_date,
    delivery_date,
    shipping_cost,
    
    -- Because Silver is now clean, this DATEDIFF will calculate realistic numbers!
    DATEDIFF(day, shipment_date, delivery_date) AS actual_transit_days
FROM silver.shipments;

GO

CREATE OR ALTER VIEW gold.fact_orders AS
SELECT 
    o.order_id,
    o.customer_id,
    o.product_id,
    o.warehouse_id,
    o.order_date,
    o.quantity,
    CASE WHEN o.order_status IS NULL THEN 'UNKNOWN'
         ELSE o.order_status
    END order_status,     
    p.unit_price,
    -- Calculate revenue on the fly
    (o.quantity * p.unit_price) AS total_order_value
FROM silver.orders o
LEFT JOIN silver.products p ON o.product_id = p.product_id;



