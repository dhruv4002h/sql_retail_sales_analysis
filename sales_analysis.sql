-- SQL Retail Analysis Project1
CREATE DATABASE project1;
USE projects;


-- Create Table
CREATE TABLE retail_sales(
transaction_id INT PRIMARY KEY ,
sale_date DATE ,
sale_time TIME ,
customer_id INT ,
gender VARCHAR(255) ,
age INT ,
category VARCHAR(255) ,
quantity INT ,
price_per_unit FLOAT ,
cogs FLOAT ,
total_sale FLOAT
)

-- Cleaning Data 
SELECT * FROM projects.retail_sales
WHERE 
transaction_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL

-- DATA Analysis & Buisness Analysis key problems

-- 1) Retrieve all colums for sales made on '2022-11-05' .
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2) Retrieve all transaction where the category is 'clothing' and the quantity sold is more than 3in the month of Nov-2022 .
SELECT transaction_id,sale_date,category
 FROM projects.retail_sales
WHERE category = 'Clothing' 
AND
 quantity > 3
 AND 
 DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- write sql query to calculate the total sales of each category .
SELECT  category,SUM(quantity) AS  total_sales
FROM retail_sales 
GROUP BY category
ORDER BY total_sales DESC;

-- write a sql query to find the average age of customers who purchased item from 'beauty' category .
SELECT ROUND(AVG(age)) AS av_age FROM retail_sales
WHERE category = 'Beauty';

-- write a sql query to find all transactions where total_sales is gretaer than 1000 .
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- write a sql query to find total no. of transactions (transaction_id) made by each gender in each category
SELECT gender,COUNT(transaction_id),category 
FROM retail_sales
GROUP BY category,gender

-- write a sql query to calculate average sale of each month. Find out best selling month in each year .
SELECT *
FROM (
  SELECT
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    SUM(total_sale) AS total_sales,
    ROW_NUMBER() OVER (PARTITION BY YEAR(sale_date) ORDER BY SUM(total_sale) DESC) AS rn
  FROM retail_sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_months
WHERE rn = 1;

-- write a sql query to find top 5 customers based on highest total sales .
SELECT  DISTINCT customer_id AS customers_id,SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC LIMIT 5;

-- write a sql query to find the number of unique customers who purchased items from each category .
SELECT COUNT(DISTINCT customer_id),category
FROM retail_sales
GROUP BY category;


-- write a sql query to create each shift and numbers of orders (EXAMPLE morning <= 12, afternoon between 12 & 17, evening >17) .
WITH hourly_sale
AS
(
SELECT *,
CASE 
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT shift,COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift
















