create database project1;
use project1;
drop table if exists retail_sale;

CREATE TABLE retail_sale
		(
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category VARCHAR(20),
			quantiy	INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT 
		);
        
SELECT * from retail_sale;  

-- Data Exploration
-- How many sales we have
SELECT COUNT(*) as retail_sales FROM retail_sale;

-- How many customer we have
SELECT COUNT(distinct customer_id) FROM retail_sale;

-- How many categories we have
SELECT distinct category FROM retail_sale;

-- Data Analysis and Business problems ans answer --
-- My Analysis and findings
-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**
SELECT * FROM retail_sale
WHERE sale_date ="2022-11-05";


-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the 
-- quantity sold is more than 4 in the month of Nov-2022**

SELECT * 
FROM retail_sale
WHERE category = "Clothing" 
AND 
quantity >=4
AND
sale_date BETWEEN "2022-11-01" AND "2022-11-30";

-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**

SELECT 
category, SUM(total_sale) as net_sale,
COUNT(transactions_id) as total_order
FROM retail_sale
GROUP BY category;

-- 4.**Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**

SELECT 
	ROUND(AVG(age)) as average_age, category
FROM retail_sale
WHERE category = 'Beauty';

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**

SELECT * 
FROM retail_sale
WHERE total_sale>1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender
-- in each category.**

SELECT gender, category, COUNT(transactions_id) as total_transaction
FROM retail_sale
GROUP BY gender, category
ORDER BY category;


-- 7.**Write a SQL query to calc the avg sale for each month. Find out best selling month in each year**
  
SELECT * FROM
(SELECT 
	YEAR(sale_date) as year,
	MONTHNAME(sale_date) as month_name,
    ROUND(avg(total_sale)) as avg_sale,
    DENSE_RANK() 
    OVER (partition by year(sale_date) order by ROUND(avg(total_sale)) desc) as ranka
FROM retail_sale
GROUP BY year, month_name)
AS table_1
WHERE ranka =1;
  
-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **  

SELECT 
	customer_id,
    SUM(total_sale) as total_sales
FROM 
retail_sale
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**

SELECT 
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM
retail_sale
GROUP BY category;


-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12,
-- Afternoon Between 12 & 17, Evening >17)**

WITH hourly_sale
AS
(SELECT *,
	CASE
		WHEN HOUR(sale_time)<12 THEN 'Morning' 
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift
FROM retail_sale)
SELECT 
	COUNT(DISTINCT transactions_id) as total_number_order, 
    shift
FROM 
hourly_sale
GROUP BY shift;

-- End of Project








