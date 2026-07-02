
--========================
--CREATING BRONZE TABLES
--=======================


--1. Customers

IF OBJECT_ID ('U', 'bronze.customers') IS NOT NULL
DROP TABLE bronze.customers;

CREATE TABLE bronze.customers(
   customer_id NVARCHAR(50),
   customer_name NVARCHAR(50),
   city NVARCHAR(50),
   segment NVARCHAR(50)
);

GO


--2. Inventory

IF OBJECT_ID ('U', 'bronze.inventory') IS NOT NULL
DROP TABLE bronze.inventory;

CREATE TABLE bronze.inventory (
  inventory_id NVARCHAR(50),
  product_id NVARCHAR(50),
  warehouse_id NVARCHAR(50),
  stock_level NVARCHAR(50),
  last_updated DATE
);

GO

--3.  Orders

IF OBJECT_ID ('U', 'bronze.orders') IS NOT NULL
DROP TABLE bronze.orders;

CREATE TABLE bronze.orders(
  order_id NVARCHAR(50),
  customer_id NVARCHAR(50),
  product_id NVARCHAR(50),
  warehouse_id NVARCHAR(50),
  order_date DATE,
  quantity NVARCHAR(50),
  order_status NVARCHAR(50)
);

GO

--4. Products


IF OBJECT_ID ('U', 'bronze.products') IS NOT NULL
DROP TABLE bronze.products;

CREATE TABLE bronze.products(
    product_id NVARCHAR(50),
    product_name NVARCHAR(50),
    category NVARCHAR(50),
    unit_price NVARCHAR(50),
    supplier_id NVARCHAR(50)
);

GO

--5.Returns

IF OBJECT_ID ('U', 'bronze.returns') IS NOT NULL
DROP TABLE bronze.returns;

CREATE TABLE bronze.returns(
  return_id NVARCHAR(50),
  order_id NVARCHAR(50),
  return_reason NVARCHAR(50),
  refund_amount NVARCHAR(50)
);


GO

--6. Shipments

IF OBJECT_ID ('U', 'bronze.shipments') IS NOT NULL
DROP TABLE bronze.shipments;

CREATE TABLE bronze.shipments(
    shipment_id NVARCHAR(50),
    order_id NVARCHAR(50),
    shipment_date DATE,
    delivery_date DATE,
    shipping_cost NVARCHAR(50)
);

GO

--7.Suppliers

IF OBJECT_ID ('U', 'bronze.suppliers') IS NOT NULL
DROP TABLE bronze.suppliers;

CREATE TABLE bronze.suppliers(
   supplier_id NVARCHAR(50),
   supplier_name NVARCHAR(50),
   country NVARCHAR(50),
   lead_time_days NVARCHAR(50)
);

GO


--8. Warehouses

IF OBJECT_ID ('U', 'bronze.warehouses') IS NOT NULL
DROP TABLE bronze.warehouses;

CREATE TABLE bronze.warehouses(
   warehouse_id NVARCHAR(50),
   location NVARCHAR(50),
   capacity NVARCHAR(50)
);


--=============
--BULK INSERT
--=============

BULK INSERT  bronze.customers
FROM 'C:\Users\Ohunoluwa\Desktop\NSC\Datasets\customers.csv'
WITH (
    FORMAT = 'CSV',         
    FIRSTROW = 2,          
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    CODEPAGE = '65001'      
);

GO

BULK INSERT  bronze.inventory
FROM 'C:\Users\Ohunoluwa\Desktop\NSC\Datasets\inventory.csv'
WITH (
    FORMAT = 'CSV',         
    FIRSTROW = 2,          
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    CODEPAGE = '65001'      
);

GO

BULK INSERT  bronze.orders
FROM 'C:\Users\Ohunoluwa\Desktop\NSC\Datasets\orders.csv'
WITH (
    FORMAT = 'CSV',         
    FIRSTROW = 2,          
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    CODEPAGE = '65001'      
);

GO

BULK INSERT  bronze.products
FROM 'C:\Users\Ohunoluwa\Desktop\NSC\Datasets\products.csv'
WITH (
    FORMAT = 'CSV',         
    FIRSTROW = 2,          
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    CODEPAGE = '65001'      
);

GO

BULK INSERT  bronze.returns
FROM 'C:\Users\Ohunoluwa\Desktop\NSC\Datasets\returns.csv'
WITH (
    FORMAT = 'CSV',         
    FIRSTROW = 2,          
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    CODEPAGE = '65001'      
);

GO

BULK INSERT  bronze.shipments
FROM 'C:\Users\Ohunoluwa\Desktop\NSC\Datasets\shipments.csv'
WITH (
    FORMAT = 'CSV',         
    FIRSTROW = 2,          
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    CODEPAGE = '65001'      
);

GO

BULK INSERT  bronze.suppliers
FROM 'C:\Users\Ohunoluwa\Desktop\NSC\Datasets\suppliers.csv'
WITH (
    FORMAT = 'CSV',         
    FIRSTROW = 2,          
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    CODEPAGE = '65001'      
);

GO

BULK INSERT  bronze.warehouses
FROM 'C:\Users\Ohunoluwa\Desktop\NSC\Datasets\warehouses.csv'
WITH (
    FORMAT = 'CSV',         
    FIRSTROW = 2,          
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    CODEPAGE = '65001'      
);

