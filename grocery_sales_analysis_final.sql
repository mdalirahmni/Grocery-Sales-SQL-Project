-- =============================================================
-- GROCERY SALES SQL PORTFOLIO PROJECT
-- Author: Md Ali Rahmani
-- Purpose: Data cleaning + business analysis
-- Concepts: SELECT, WHERE, LIKE, GROUP BY, HAVING, ORDER BY,
--           JOIN, aggregate functions, CASE, CTE, window functions
--
-- IMPORTANT:
-- 1) Import the CSV into a table named grocery_sales.
-- 2) Column names assumed below:
--    Transaction_ID, Transaction_Date, Customer_ID, City, Category,
--    Product, Quantity, Unit_Price, Discount, Gross_Amount,
--    Payment_Method, Final_Amount
-- =============================================================

-- SECTION 1: SELECT
-- Preview the data.
SELECT *
FROM grocery_sales
LIMIT 10;

-- Select only useful columns.
SELECT Transaction_ID, Transaction_Date, Customer_ID, City,
       Category, Product, Final_Amount
FROM grocery_sales
LIMIT 20;

-- SECTION 2: WHERE
-- Find high-value transactions.
SELECT Transaction_ID, City, Product, Final_Amount
FROM grocery_sales
WHERE Final_Amount > 3000
ORDER BY Final_Amount DESC;

-- Find transactions from Patna.
SELECT Transaction_ID, Transaction_Date, Product, Final_Amount
FROM grocery_sales
WHERE City = 'Patna'
ORDER BY Final_Amount DESC;

-- SECTION 3: LIKE
-- Find tea products.
SELECT Transaction_ID, Product, Category, Final_Amount
FROM grocery_sales
WHERE Product LIKE '%Tea%'
ORDER BY Final_Amount DESC;

-- Find products beginning with Amul.
SELECT Transaction_ID, Product, Quantity, Final_Amount
FROM grocery_sales
WHERE Product LIKE 'Amul%';

-- SECTION 4: DATA QUALITY AND CLEANING
SELECT COUNT(*) AS total_rows
FROM grocery_sales;

SELECT
    SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS missing_discount,
    SUM(CASE WHEN Product IS NULL OR TRIM(Product) = '' THEN 1 ELSE 0 END) AS missing_product,
    SUM(CASE WHEN City IS NULL OR TRIM(City) = '' THEN 1 ELSE 0 END) AS missing_city
FROM grocery_sales;

-- Treat a missing discount as zero.
UPDATE grocery_sales
SET Discount = 0
WHERE Discount IS NULL;

-- Check duplicate transaction IDs.
SELECT Transaction_ID, COUNT(*) AS duplicate_count
FROM grocery_sales
GROUP BY Transaction_ID
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Validate gross amount.
SELECT Transaction_ID, Quantity, Unit_Price, Gross_Amount
FROM grocery_sales
WHERE ABS(ROUND(Quantity * Unit_Price, 2) - ROUND(Gross_Amount, 2)) > 0.01;

-- Validate final amount after discount.
SELECT Transaction_ID, Gross_Amount, Discount, Final_Amount
FROM grocery_sales
WHERE ABS(ROUND(Gross_Amount * (1 - Discount), 2) - ROUND(Final_Amount, 2)) > 0.01;

-- SECTION 5: AGGREGATE FUNCTIONS
-- COUNT, COUNT DISTINCT, SUM and AVG.
SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    SUM(Quantity) AS total_units_sold,
    ROUND(SUM(Gross_Amount), 2) AS gross_sales,
    ROUND(SUM(Final_Amount), 2) AS net_sales,
    ROUND(AVG(Final_Amount), 2) AS average_transaction_value,
    ROUND(MIN(Final_Amount), 2) AS minimum_transaction,
    ROUND(MAX(Final_Amount), 2) AS maximum_transaction
FROM grocery_sales;

-- SECTION 6: GROUP BY + ORDER BY
-- City-wise sales.
SELECT City,
       COUNT(*) AS transactions,
       SUM(Quantity) AS units_sold,
       ROUND(SUM(Final_Amount), 2) AS net_sales
FROM grocery_sales
GROUP BY City
ORDER BY net_sales DESC;

-- Category-wise sales.
SELECT Category,
       COUNT(*) AS transactions,
       SUM(Quantity) AS units_sold,
       ROUND(AVG(Final_Amount), 2) AS avg_transaction_value,
       ROUND(SUM(Final_Amount), 2) AS net_sales
FROM grocery_sales
GROUP BY Category
ORDER BY net_sales DESC;

-- Top 10 products.
SELECT Product,
       SUM(Quantity) AS units_sold,
       ROUND(SUM(Final_Amount), 2) AS net_sales
FROM grocery_sales
GROUP BY Product
ORDER BY net_sales DESC
LIMIT 10;

-- SECTION 7: HAVING
-- Cities whose sales exceed 10,000,000.
SELECT City,
       ROUND(SUM(Final_Amount), 2) AS net_sales
FROM grocery_sales
GROUP BY City
HAVING SUM(Final_Amount) > 10000000
ORDER BY net_sales DESC;

-- Customers with at least 10 transactions.
SELECT Customer_ID,
       COUNT(*) AS transactions,
       ROUND(SUM(Final_Amount), 2) AS total_spend
FROM grocery_sales
GROUP BY Customer_ID
HAVING COUNT(*) >= 10
ORDER BY total_spend DESC;

-- SECTION 8: PAYMENT METHOD ANALYSIS
SELECT Payment_Method,
       COUNT(*) AS transactions,
       ROUND(AVG(Final_Amount), 2) AS avg_transaction_value,
       ROUND(SUM(Final_Amount), 2) AS net_sales
FROM grocery_sales
GROUP BY Payment_Method
ORDER BY net_sales DESC;

-- SECTION 9: TIME ANALYSIS
-- Yearly trend.
SELECT YEAR(Transaction_Date) AS sales_year,
       COUNT(*) AS transactions,
       ROUND(SUM(Final_Amount), 2) AS net_sales
FROM grocery_sales
GROUP BY YEAR(Transaction_Date)
ORDER BY sales_year;

-- Monthly trend.
SELECT DATE_FORMAT(Transaction_Date, '%Y-%m') AS sales_month,
       COUNT(*) AS transactions,
       ROUND(SUM(Final_Amount), 2) AS net_sales
FROM grocery_sales
GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m')
ORDER BY sales_month;

-- SECTION 10: DISCOUNT ANALYSIS
SELECT Discount,
       COUNT(*) AS transactions,
       ROUND(SUM(Gross_Amount), 2) AS gross_sales,
       ROUND(SUM(Final_Amount), 2) AS net_sales,
       ROUND(AVG(Final_Amount), 2) AS avg_transaction_value
FROM grocery_sales
GROUP BY Discount
ORDER BY Discount;

-- SECTION 11: CUSTOMER ANALYSIS
SELECT Customer_ID,
       COUNT(*) AS transactions,
       SUM(Quantity) AS units_purchased,
       ROUND(SUM(Final_Amount), 2) AS total_spend
FROM grocery_sales
GROUP BY Customer_ID
ORDER BY total_spend DESC
LIMIT 10;

-- SECTION 12: JOIN
-- Create small reusable dimension tables from the transaction data.
DROP TABLE IF EXISTS dim_customer;
CREATE TABLE dim_customer AS
SELECT DISTINCT Customer_ID
FROM grocery_sales;

DROP TABLE IF EXISTS dim_product;
CREATE TABLE dim_product AS
SELECT DISTINCT Product, Category
FROM grocery_sales;

-- INNER JOIN: customer transaction summary.
SELECT c.Customer_ID,
       COUNT(g.Transaction_ID) AS transactions,
       ROUND(SUM(g.Final_Amount), 2) AS total_spend
FROM dim_customer AS c
INNER JOIN grocery_sales AS g
    ON c.Customer_ID = g.Customer_ID
GROUP BY c.Customer_ID
ORDER BY total_spend DESC
LIMIT 10;

-- LEFT JOIN: product performance.
SELECT p.Category,
       p.Product,
       COALESCE(SUM(g.Quantity), 0) AS units_sold,
       ROUND(COALESCE(SUM(g.Final_Amount), 0), 2) AS net_sales
FROM dim_product AS p
LEFT JOIN grocery_sales AS g
    ON p.Product = g.Product
   AND p.Category = g.Category
GROUP BY p.Category, p.Product
ORDER BY net_sales DESC;

-- SECTION 13: CTE + WINDOW FUNCTION
-- Top 3 products by sales inside each category.
WITH product_sales AS (
    SELECT Category,
           Product,
           SUM(Final_Amount) AS net_sales
    FROM grocery_sales
    GROUP BY Category, Product
),
ranked_products AS (
    SELECT Category,
           Product,
           ROUND(net_sales, 2) AS net_sales,
           DENSE_RANK() OVER (
               PARTITION BY Category
               ORDER BY net_sales DESC
           ) AS sales_rank
    FROM product_sales
)
SELECT Category, Product, net_sales, sales_rank
FROM ranked_products
WHERE sales_rank <= 3
ORDER BY Category, sales_rank, Product;

-- SECTION 14: CATEGORY SALES CONTRIBUTION
WITH category_sales AS (
    SELECT Category, SUM(Final_Amount) AS net_sales
    FROM grocery_sales
    GROUP BY Category
)
SELECT Category,
       ROUND(net_sales, 2) AS net_sales,
       ROUND(100 * net_sales / SUM(net_sales) OVER (), 2) AS sales_share_pct
FROM category_sales
ORDER BY net_sales DESC;

-- END OF PROJECT
