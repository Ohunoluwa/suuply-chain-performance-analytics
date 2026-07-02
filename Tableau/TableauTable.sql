IF OBJECT_ID ('gold.final_dashboard_table', 'U') IS NOT NULL 
DROP TABLE gold.final_dashboard_table;

SELECT
    --  Order Info
    o.order_id,
    o.order_date,
    o.order_status,
    o.quantity,

    --  Customer
    c.customer_id,
    c.customer_name,
    c.city,
    c.segment,

    --  Product
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,

    --  Supplier
    s.supplier_id,
    s.supplier_name,
    s.country,
    s.lead_time_days,

    --  Warehouse
    w.warehouse_id,
    w.location,
    w.capacity,

    --  Shipment
    sh.shipment_id,
    sh.shipment_date,

    --  FIXED delivery_date (replacing valid_delivery_date)
    CASE 
        WHEN sh.delivery_date >= sh.shipment_date THEN sh.delivery_date
        ELSE NULL
    END AS delivery_date,

    sh.shipping_cost,

    -- 🔁 Returns
    r.return_id,
    r.return_reason,
    r.refund_amount,

    -- 💰 Revenue (safe)
    ISNULL(o.quantity, 0) * ISNULL(p.unit_price, 0) AS revenue,

    --  Delivery Days
    CASE 
        WHEN sh.shipment_date IS NOT NULL 
             AND sh.delivery_date IS NOT NULL
        THEN DATEDIFF(day, sh.shipment_date, sh.delivery_date)
        ELSE NULL
    END AS delivery_days,

    -- 🚨 Late Delivery (robust)
    CASE 
        WHEN sh.shipment_date IS NOT NULL 
             AND sh.delivery_date IS NOT NULL
             AND s.lead_time_days IS NOT NULL
             AND DATEDIFF(day, sh.shipment_date, sh.delivery_date) > s.lead_time_days
        THEN 1
        ELSE 0
    END AS is_late_delivery,

    --  Return Flag
    CASE 
        WHEN r.return_id IS NOT NULL THEN 1
        ELSE 0
    END AS is_returned

INTO gold.final_dashboard_table

FROM silver.orders o

LEFT JOIN silver.customers c 
    ON o.customer_id = c.customer_id

LEFT JOIN silver.products p 
    ON o.product_id = p.product_id

LEFT JOIN silver.suppliers s 
    ON p.supplier_id = s.supplier_id

LEFT JOIN silver.warehouses w 
    ON o.warehouse_id = w.warehouse_id

--  FIX: Aggregate shipments to prevent duplicates
LEFT JOIN (
    SELECT 
        order_id,
        MIN(shipment_id) AS shipment_id,
        MIN(shipment_date) AS shipment_date,
        MIN(delivery_date) AS delivery_date,
        AVG(shipping_cost) AS shipping_cost
    FROM silver.shipments
    GROUP BY order_id
) sh 
    ON o.order_id = sh.order_id

--  FIX: Aggregate returns (prevents duplication)
LEFT JOIN (
    SELECT
        order_id,
        MIN(return_id) AS return_id,
        MIN(return_reason) AS return_reason,
        AVG(refund_amount) AS refund_amount
    FROM silver.returns
    GROUP BY order_id
) r
    ON o.order_id = r.order_id;

    SELECT *
    FROM gold.final_dashboard_table