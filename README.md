# Grocery Sales SQL Analysis Project

## Project Overview
This SQL portfolio project analyses a grocery sales transaction dataset to demonstrate practical data cleaning, data-quality validation and business analysis skills.

The project focuses on answering business questions related to sales performance, customers, cities, product categories, individual products, payment methods and discounts.

## SQL Skills Demonstrated
- `SELECT`
- `WHERE`
- `LIKE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `INNER JOIN`
- `LEFT JOIN`
- Aggregate functions: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `CASE`
- Date functions
- Common Table Expressions (CTEs)
- Window functions
- `DENSE_RANK()`

## Dataset Fields Used
The analysis is designed around transaction-level fields including:
- Transaction ID
- Transaction date
- Customer ID
- City
- Category
- Product
- Quantity
- Unit price
- Discount
- Gross amount
- Payment method
- Final amount

## Project Workflow
### 1. Data Understanding
Preview the imported table and select important business fields.

### 2. Data Cleaning and Validation
- Check missing values
- Replace missing discounts with zero
- Detect duplicate transaction IDs
- Validate gross amount against quantity and unit price
- Validate final amount after discount

### 3. Business Analysis
- Overall sales KPIs
- City-wise sales
- Category-wise sales
- Top products
- Payment method performance
- Yearly and monthly trends
- Discount analysis
- Top customers

### 4. JOIN Analysis
Small customer and product dimension tables are created from the source data so that the project demonstrates practical `INNER JOIN` and `LEFT JOIN` queries.

### 5. Advanced SQL
CTEs and `DENSE_RANK()` are used to identify the top three products within each category. A window calculation is also used to calculate category contribution to total sales.

## Business Questions
1. What are the overall transaction, customer, unit and sales KPIs?
2. Which transactions have high sales values?
3. Which sales occurred in a selected city?
4. Which products match a keyword such as Tea or Amul?
5. Which cities generate the highest sales?
6. Which product categories generate the highest sales?
7. Which products are the top performers?
8. Which groups meet a specified transaction or sales threshold?
9. Which payment methods contribute the most sales?
10. How do sales change over time?
11. How do discount levels relate to transaction value?
12. Which customers spend the most?
13. What are the top three products within every category?
14. What percentage of total sales comes from each category?

## Repository Files
- `grocery_sales_analysis_final.sql` - Complete SQL cleaning and analysis project
- `grocery_sales_1lakh_underscores.csv` - Source dataset
- `README.md` - GitHub project documentation

## How to Use
1. Import the source CSV into MySQL.
2. Name the imported table `grocery_sales` or update the SQL script to match the actual table name.
3. Confirm that the imported column names match the names documented in the SQL file.
4. Run the queries section by section in MySQL Workbench.
5. Review the returned results and use them to explain business findings during portfolio reviews or interviews.

## Author
**Md Ali Rahmani**

Aspiring Data Analyst | SQL | Excel | Power BI | Python
