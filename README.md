# E-Commerce Supply Chain & Executive Dashboard

# Project Overview

Online stores generate huge amounts of data every day, but raw numbers on their own don't tell leaders what to do. This project takes messy, raw sales data and turns it into a clear, easy-to-read dashboard that helps executives understand how the business is doing.

The goal was to track three things: how much money the company is making, how fast orders are being delivered, and how often customers are returning products. I built a pipeline that cleans and organizes the raw data using SQL, then connected it to Tableau to create an interactive dashboard that helps leadership spot problems in the supply chain and track growth from year to year.


# Tech Stack

* SQL Server (T-SQL) → Data cleaning and transformation
* Tableau Public → Dashboard development and visualization
* Excel / CSV → Data storage
* Python (Pandas) → Sample data generation


# About the Data

The data used in this project isn't real — it's a made-up e-commerce dataset that I built myself using Python to look and behave like real sales data. I deliberately added common problems you'd see in real-world data, like missing information, incorrectly formatted numbers, messy dates, and delivery times that don't make sense. This let me test whether my cleaning process could actually catch and fix these kinds of issues.


# How the Data Was Cleaned and Organized (Medallion Approach)

I used a well-known method for organizing data called the "Medallion Architecture."

# 1. Raw Data (Bronze Layer)


Loaded the raw CSV files straight into the database.
Kept everything as plain text at first, so the process wouldn't break due to formatting issues in the original files.


# 2. Cleaned Data (Silver Layer)


Fixed broken or oddly formatted numbers and converted them to the right format.
Cleaned up text so things like spacing and capitalization were consistent.
Built rules to catch and correct negative numbers that shouldn't exist (like negative prices).
Fixed unrealistic delivery times and other date-related errors.


# 3. Business-Ready Data (Gold Layer)


Combined everything into one clean, well-organized table so Tableau could load it quickly.
Pre-calculated totals for shipments and returns before combining them with order data, to avoid inflated or duplicated numbers.
Added simple yes/no flags (like "was this returned?" or "was this late?") directly in the database so the dashboard wouldn't have to calculate them itself.


# What Makes It Useful


Easy year-over-year comparisons — The dashboard can automatically compare this year to last year, without needing separate filters for each year.
Fair delivery-time tracking — Delivery speed is measured based on when the order was placed, not when it was delivered. This gives a more honest picture of performance instead of making numbers look better or worse just because of seasonal timing.
Clean, easy-to-read design — I used a simple color scheme so the important numbers stand out. Deep navy blue highlights key metrics, and muted red flags problem areas like cancellations or returns, so nothing gets lost in a wall of color.

# Key Metrics


Revenue Growth — Total revenue hit over $4.34 billion in 2024, up 6.73% from the year before — even though the number of orders only grew by 1.46%. This means the growth mostly came from customers spending more per order, not just more orders coming in.
Faster Delivery, Fewer Returns — Average delivery time dropped 6.73%, down to 15.40 days, and product returns fell by 7.44% compared to last year — a sign that both shipping and product quality improved.
Top Product — Product_4673 was the best-selling item of the year, bringing in over $108 million and outselling every other product in the top five by a wide margin.
