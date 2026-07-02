
-- =========================================
-- PROJECT: SUPPLY CHAIN ANALYTICS
-- AUTHOR: Oba Ohunoluwa Elias
-- =========================================
-- DESCRIPTION:
-- This script analyzes key business metrics across
-- sales, logistics, inventory.
--
-- DATA MODEL:
-- Fact Tables:
--   - gold.fact_orders
--   - gold.fact_shipments
--   - gold.fact_returns
--   - gold.fact_inventory
--
-- Dimension Tables:
--   - gold.dim_customers
--   - gold.dim_products
--   - gold.dim_suppliers
--   - gold.dim_warehouses
-- =========================================

-- =========================================
-- SECTION: SALES PERFORMANCE ANALYSIS
-- =========================================

-- BUSINESS QUESTION:
-- Which product categories generate the highest revenue?

-- LOGIC:
-- Join orders with product data and aggregate revenue by category

SELECT 
    p.category,
    SUM(o.total_order_value) AS total_revenue
FROM gold.fact_orders AS o
INNER JOIN gold.dim_products AS p
    ON o.product_id = p.product_id
GROUP BY 
    p.category
ORDER BY 
    total_revenue DESC;

--========================================================================
--CONCLUSION: Electronics generated the highest revenue with over 8,406M
--=======================================================================

-- =========================================
-- SECTION: LOGISTICS PERFORMANCE
-- =========================================

-- BUSINESS QUESTION:
-- What is the average delivery time and shipping cost?

-- LOGIC:
-- Use shipment data to calculate operational efficiency

SELECT 
    AVG(actual_transit_days) AS avg_delivery_days,
    AVG(shipping_cost) AS avg_shipping_cost
FROM gold.fact_shipments;



-- =========================================
-- SECTION: RETURNS ANALYSIS
-- =========================================

-- BUSINESS QUESTION:
-- What percentage of orders are returned?

-- LOGIC:
-- Compare total orders to returned orders using LEFT JOIN

SELECT 
    COUNT(r.return_id) * 1.0 / COUNT(o.order_id) AS return_rate
FROM gold.fact_orders AS o
LEFT JOIN gold.fact_returns AS r
    ON o.order_id = r.order_id;

--================================================
--CONCLUSION: Return rate is approximately 0.19%
--===============================================

-- =========================================
-- SECTION: INVENTORY HEALTH
-- =========================================

-- BUSINESS QUESTION:
-- How is stock distributed across inventory levels?

-- LOGIC:
-- Group inventory records by stock status

SELECT 
    stock_status,
    COUNT(*) AS total_items
FROM gold.fact_inventory
GROUP BY 
    stock_status
ORDER BY 
    total_items DESC;