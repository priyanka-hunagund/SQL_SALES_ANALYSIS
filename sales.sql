-- SQL REATAIL ANALYSIS --
create database sales_analysis;

-- CREAT TABLE --
DROP TABLE IF exists SALES;
CREATE table SALES 
(
transactions_id	  INT PRIMARY KEY,
sale_date	      DATE,
sale_time	      TIME,
customer_id	      INT,
gender	          VARCHAR(15),
age	              INT,
category	      VARCHAR(15),
quantiy	          INT,
price_per_unit    float,	
cogs	          FLOAT,
total_sale        float
);

SELECT * FROM SALES;
SELECT COUNT(*) FROM SALES;
SELECT * FROM SALES
WHERE sale_time IS NULL
OR customer_id IS NULL 
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

DELETE  FROM SALES 
WHERE sale_time IS NULL 
OR customer_id IS NULL 
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;


-- DATA  EXPORATION --
-- HOW MANY SALES WE HAVE ---
SELECT COUNT(*) AS TOTAL_SALES FROM SALES;

-- HOW MANY COUSTOMERS WE HAVE --
SELECT COUNT(DISTINCT(customer_id)) AS COUNTOFCUSTOMER FROM SALES;

-- HOW MANY CATEGORY WE HAVE --
SELECT COUNT(DISTINCT(category)) AS COUNTOFCATEGORY FROM SALES;


-- DATA ANALYSIS AND BUSINESS KEY PROBLEM AND ANSWER --
 -- Q.1  Write a SQL query to retrieve all columns for sales made on '2022-11-05 --
 SELECT *
 FROM SALES 
 WHERE sale_date = '2022-11-05';
 
 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022 --
SELECT *
FROM SALES
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%m-%Y') = '11-2022'
  AND  quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category --
SELECT category,SUM(total_sale) AS TOTALSLES,COUNT(*) AS TOTALCOUNT FROM SALES 
GROUP BY category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category--

SELECT avg(age) AS AVERAGE_AGE 
FROM SALES 
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000. --
SELECT * FROM SALES 
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category. -- 
SELECT category,gender,count(transactions_id) FROM SALES
GROUP BY category,gender
ORDER BY category,gender ;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year --
WITH  X AS  
(SELECT *,
rank() OVER(PARTITION BY YEARS ORDER BY AVERAGE_SALES DESC) AS RN FROM 
(SELECT YEAR(sale_date) AS YEARS , MONTH(sale_date) AS MONTHS,
ROUND(avg(total_sale),2) AS AVERAGE_SALES 
FROM SALES
GROUP BY MONTHS,YEARS) AS A
ORDER BY YEARS)

SELECT YEARS,MONTHS,AVERAGE_SALES FROM X
WHERE RN = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales --

SELECT customer_id,SUM(total_sale) AS TOTALSALES FROM SALES 
GROUP BY customer_id
ORDER BY TOTALSALES DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.--
SELECT category, count(DISTINCT(customer_id)) AS NUMBER_OF_CUSTOMERS
FROM SALES 
GROUP BY category
ORDER BY NUMBER_OF_CUSTOMERS DESC;

-- Q.5 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) --

SELECT 
CASE
WHEN  HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS SHIFT ,
COUNT(transactions_id) AS ORDERS
FROM SALES 
GROUP BY SHIFT
ORDER BY ORDERS ;


