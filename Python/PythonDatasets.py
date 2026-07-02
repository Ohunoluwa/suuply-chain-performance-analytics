import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

np.random.seed(42)

# -----------------------------
# Helpers
# -----------------------------
def random_date(start, end):
    return start + timedelta(days=random.randint(0, (end - start).days))

def introduce_nulls(df, pct=0.1):
    df_copy = df.copy()
    for col in df_copy.columns:
        df_copy.loc[df_copy.sample(frac=pct).index, col] = np.nan
    return df_copy

def introduce_duplicates(df, pct=0.1):
    return pd.concat([df, df.sample(frac=pct)], ignore_index=True)

def messy_text(val):
    if pd.isna(val):
        return val
    return random.choice([
        str(val).lower(),
        str(val).upper(),
        str(val).title(),
        f" {val}",
        f"{val} ",
    ])

# -----------------------------
# SUPPLIERS (~300)
# -----------------------------
suppliers = pd.DataFrame({
    "supplier_id": range(1000, 1300),
    "supplier_name": [f"Supplier_{i}" for i in range(300)],
    "country": [random.choice(["USA", "China", "Germany", "India", "Nigeria", "UAE"]) for _ in range(300)],
    "lead_time_days": np.random.randint(-10, 90, 300)
})

suppliers["country"] = suppliers["country"].apply(messy_text)
suppliers = introduce_nulls(suppliers)
suppliers = introduce_duplicates(suppliers)

# -----------------------------
# PRODUCTS (~5000)
# -----------------------------
products = pd.DataFrame({
    "product_id": range(2000, 7000),
    "product_name": [f"Product_{i}" for i in range(5000)],
    "category": [random.choice(["Electronics","Furniture","Clothing","Food","electronics","FOOD"]) for _ in range(5000)],
    "unit_price": np.round(np.random.uniform(-50, 2000, 5000),2),
    "supplier_id": [random.choice(suppliers["supplier_id"]) for _ in range(5000)]
})

products["category"] = products["category"].apply(messy_text)
products = introduce_nulls(products)
products = introduce_duplicates(products)

# -----------------------------
# WAREHOUSES (~100)
# -----------------------------
warehouses = pd.DataFrame({
    "warehouse_id": range(300, 400),
    "location": [random.choice(["Lagos","Abuja","Kano","Ibadan","PH","lagos"," ABUJA"]) for _ in range(100)],
    "capacity": np.random.randint(-2000, 20000, 100)
})

warehouses["location"] = warehouses["location"].apply(messy_text)
warehouses = introduce_nulls(warehouses)

# -----------------------------
# CUSTOMERS (~4000)
# -----------------------------
customers = pd.DataFrame({
    "customer_id": range(9000, 13000),
    "customer_name": [f"Customer_{i}" for i in range(4000)],
    "city": [random.choice(["Lagos","Abuja","Kano","PH","Ibadan"]) for _ in range(4000)],
    "segment": [random.choice(["Retail","Corporate","SME","retail","CORPORATE "]) for _ in range(4000)]
})

customers["segment"] = customers["segment"].apply(messy_text)
customers = introduce_nulls(customers)
customers = introduce_duplicates(customers)

# -----------------------------
# ORDERS (~50,000)
# -----------------------------
orders = []

for i in range(50000, 100000):
    orders.append({
        "order_id": i,
        "customer_id": random.choice(list(customers["customer_id"]) + [999999]),
        "product_id": random.choice(list(products["product_id"]) + [888888]),
        "warehouse_id": random.choice(list(warehouses["warehouse_id"]) + [777]),
        "order_date": random_date(datetime(2021,1,1), datetime(2025,12,31)),
        "quantity": np.random.randint(-20, 1000),
        "order_status": random.choice(["Delivered","Pending","Cancelled","delivered","PENDING "])
    })

orders = pd.DataFrame(orders)
orders["order_status"] = orders["order_status"].apply(messy_text)
orders = introduce_nulls(orders)
orders = introduce_duplicates(orders)

# -----------------------------
# SHIPMENTS (~60,000)
# -----------------------------
shipments = []

for i in range(200000, 260000):
    shipments.append({
        "shipment_id": i,
        "order_id": random.choice(list(orders["order_id"]) + [123456]),
        "shipment_date": random_date(datetime(2021,1,1), datetime(2025,12,31)),
        "delivery_date": random_date(datetime(2021,1,1), datetime(2025,12,31)),
        "shipping_cost": round(np.random.uniform(-200, 5000),2)
    })

shipments = pd.DataFrame(shipments)
shipments = introduce_nulls(shipments)
shipments = introduce_duplicates(shipments)

# -----------------------------
# INVENTORY (~30,000)
# -----------------------------
inventory = []

for i in range(30000):
    inventory.append({
        "inventory_id": i,
        "product_id": random.choice(products["product_id"]),
        "warehouse_id": random.choice(warehouses["warehouse_id"]),
        "stock_level": np.random.randint(-100, 5000),
        "last_updated": random_date(datetime(2021,1,1), datetime(2025,12,31))
    })

inventory = pd.DataFrame(inventory)
inventory = introduce_nulls(inventory)

# -----------------------------
# RETURNS (~10,000)
# -----------------------------
returns = []

for i in range(10000):
    returns.append({
        "return_id": i,
        "order_id": random.choice(list(orders["order_id"]) + [555555]),
        "return_reason": random.choice(["Damaged","Late","Wrong Item","damaged","LATE "]),
        "refund_amount": round(np.random.uniform(-100, 2000),2)
    })

returns = pd.DataFrame(returns)
returns["return_reason"] = returns["return_reason"].apply(messy_text)
returns = introduce_nulls(returns)
returns = introduce_duplicates(returns)

# -----------------------------
# SAVE FILES
# -----------------------------
suppliers.to_csv("suppliers.csv", index=False)
products.to_csv("products.csv", index=False)
warehouses.to_csv("warehouses.csv", index=False)
customers.to_csv("customers.csv", index=False)
orders.to_csv("orders.csv", index=False)
shipments.to_csv("shipments.csv", index=False)
inventory.to_csv("inventory.csv", index=False)
returns.to_csv("returns.csv", index=False)

print("🔥 ENTERPRISE DATASET GENERATED")