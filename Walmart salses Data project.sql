-- Project : Walmart Sales Data Analysis

SELECT *
FROM WalmartSalesData;


-- Generic Question 
--1.  How many unique cities does the data have?

SELECT COUNT(DISTINCT city) AS unique_cities
FROM WalmartSalesData;
-- answer : 
-- the number of unique city is 3 

-- 2. In which city is each branch located?

SELECT DISTINCT branch, city
FROM WalmartSalesData;

-- Product 

--1 How many unique product lines does the data have?

SELECT COUNT(DISTINCT product_line) AS unique_product_lines
FROM WalmartSalesData;

-- Answer : 6 

-- 2. What is the most common payment method? 

SELECT TOP 1 payment, COUNT(*) AS payment_count
FROM WalmartSalesData
GROUP BY payment
ORDER BY payment_count DESC;
 -- answer:  Ewallet : payment count 345 

 -- 3. what is the most common  product line ?

SELECT TOP 1 product_line, SUM(quantity) AS total_quantity_sold
FROM WalmartSalesData
GROUP BY product_line
ORDER BY total_quantity_sold DESC;

-- 4. What is the total revenue by month?

SELECT 
    MONTH(date) AS month,
    YEAR(date) AS year,
    SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

-- 5. What month had the largest COGS?

SELECT TOP 1 
    MONTH(date) AS month, 
    YEAR(date) AS year, 
    SUM(cogs) AS total_cogs
FROM WalmartSalesData
GROUP BY YEAR(date), MONTH(date)
ORDER BY total_cogs DESC;

-- 6. What product line had the largest revenue? 

SELECT TOP 1 
    product_line, 
    SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?


SELECT TOP 1 
    city, 
    SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY city
ORDER BY total_revenue DESC;
-- 7. What product line had the largest VAT?


SELECT TOP 1 
    product_line, 
    SUM(VAT) AS total_vat
FROM WalmartSalesData
GROUP BY product_line
ORDER BY total_vat DESC;

-- 8. Fetch each product line and add a column to those product line showing
-- "Good", "Bad". Good if its greater than average sales



SELECT 
    product_line, 
    SUM(total) AS total_sales,
    CASE 
        WHEN SUM(total) > (SELECT AVG(total_sales) 
                            FROM (SELECT SUM(total) AS total_sales 
                                  FROM WalmartSalesData
                                  GROUP BY product_line) AS avg_sales) 
        THEN 'Good' 
        ELSE 'Bad' 
    END AS performance
FROM WalmartSalesData
GROUP BY product_line;

-- 9. Which branch sold more products than average product sold?

SELECT 
    branch, 
    SUM(quantity) AS total_quantity_sold
FROM WalmartSalesData
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(total_quantity)
                        FROM (SELECT SUM(quantity) AS total_quantity 
                              FROM WalmartSalesData
                              GROUP BY branch) AS avg_quantity);

-- 10 . What is the most common product line by gender?


WITH ProductLineCount AS (
    SELECT 
        gender, 
        product_line, 
        COUNT(*) AS count
    FROM WalmartSalesData
    GROUP BY gender, product_line
)

SELECT 
    plc.gender, 
    plc.product_line, 
    plc.count
FROM ProductLineCount plc
JOIN (
    SELECT gender, MAX(count) AS max_count
    FROM ProductLineCount
    GROUP BY gender
) AS maxCounts ON plc.gender = maxCounts.gender AND plc.count = maxCounts.max_count;

-- What is the average rating of each product line?

SELECT 
    product_line, 
    AVG(rating) AS average_rating
FROM WalmartSalesData
GROUP BY product_line;

-- Sales
-- 1. Number of sales made in each time of the day per weekday


SELECT 
    DATENAME(WEEKDAY, date) AS weekday,
    COUNT(*) AS number_of_sales
FROM WalmartSalesData
GROUP BY DATENAME(WEEKDAY, date)
ORDER BY weekday;

-- 2 . Which of the customer types brings the most revenue?

SELECT 
    customer_type, 
    SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY total_revenue DESC;

--3. Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT TOP 1 
    city, 
    AVG(VAT) AS average_vat
FROM WalmartSalesData
GROUP BY city
ORDER BY average_vat DESC;

-- 4. Which customer type pays the most in VAT?


SELECT 
    customer_type, 
    SUM(VAT) AS total_vat
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY total_vat DESC;


-- Customer

--How many unique customer types does the data have?

SELECT COUNT(DISTINCT customer_type) AS unique_customer_types
FROM WalmartSalesData;

-- 2. How many unique payment methods does the data have?

SELECT COUNT(DISTINCT payment) AS unique_payment_methods
FROM WalmartSalesData;

-- 3 What is the most common customer type?


SELECT TOP 1 
    customer_type, 
    COUNT(*) AS count
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY count DESC;

--4 Which customer type buys the most?

SELECT 
    customer_type, 
    SUM(quantity) AS total_quantity
FROM WalmartSalesData
GROUP BY customer_type
ORDER BY total_quantity DESC;

-- 5 What is the gender of most of the customers?

SELECT TOP 1 
    gender, 
    COUNT(*) AS count
FROM WalmartSalesData
GROUP BY gender
ORDER BY count DESC;

-- 6 . What is the gender distribution per branch?

SELECT 
    branch, 
    gender, 
    COUNT(*) AS count
FROM WalmartSalesData
GROUP BY branch, gender
ORDER BY branch, gender;

-- 6. Which time of the day do customers give most ratings?


SELECT 
    CAST(SUBSTRING(time, 1, 2) AS VARCHAR(2)) + 
    CASE 
        WHEN RIGHT(time, 2) = 'pm' AND SUBSTRING(time, 1, 2) != '12' THEN '12' 
        WHEN RIGHT(time, 2) = 'am' AND SUBSTRING(time, 1, 2) = '12' THEN '0' 
        ELSE '' 
    END AS rating_hour,
    COUNT(rating) AS rating_count
FROM WalmartSalesData
WHERE rating IS NOT NULL
GROUP BY 
    CAST(SUBSTRING(time, 1, 2) AS VARCHAR(2)) + 
    CASE 
        WHEN RIGHT(time, 2) = 'pm' AND SUBSTRING(time, 1, 2) != '12' THEN '12' 
        WHEN RIGHT(time, 2) = 'am' AND SUBSTRING(time, 1, 2) = '12' THEN '0' 
        ELSE '' 
    END
ORDER BY rating_count DESC;

--8 Which time of the day do customers give most ratings per branch?



SELECT 
    branch,
    CAST(SUBSTRING(time, 1, 2) AS VARCHAR(2)) + 
    CASE 
        WHEN RIGHT(time, 2) = 'pm' AND SUBSTRING(time, 1, 2) != '12' THEN '12' 
        WHEN RIGHT(time, 2) = 'am' AND SUBSTRING(time, 1, 2) = '12' THEN '0' 
        ELSE '' 
    END AS rating_hour,
    COUNT(rating) AS rating_count
FROM WalmartSalesData
WHERE rating IS NOT NULL
GROUP BY 
    branch,
    CAST(SUBSTRING(time, 1, 2) AS VARCHAR(2)) + 
    CASE 
        WHEN RIGHT(time, 2) = 'pm' AND SUBSTRING(time, 1, 2) != '12' THEN '12' 
        WHEN RIGHT(time, 2) = 'am' AND SUBSTRING(time, 1, 2) = '12' THEN '0' 
        ELSE '' 
    END
ORDER BY 
    branch,
    rating_count DESC;

-- 9 Which day fo the week has the best avg ratings?


SELECT 
    DATENAME(WEEKDAY, date) AS day_of_week,
    AVG(rating) AS average_rating
FROM WalmartSalesData
WHERE rating IS NOT NULL
GROUP BY DATENAME(WEEKDAY, date)
ORDER BY average_rating DESC;

--10. Which day of the week has the best average ratings per branch?

SELECT 
    branch,
    DATENAME(WEEKDAY, date) AS day_of_week,
    AVG(rating) AS average_rating
FROM WalmartSalesData
WHERE rating IS NOT NULL
GROUP BY 
    branch,
    DATENAME(WEEKDAY, date)
ORDER BY 
    branch,
    average_rating DESC;







