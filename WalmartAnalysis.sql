CREATE DATABASE Walmart;
USE Walmart;

CREATE TABLE IF NOT EXISTS WalmartDA(
Invoice_ID VARCHAR(50),
Branch CHAR(50),
City CHAR(50),
Customer_Type CHAR(50),
Gender CHAR(50),
Product_Line VARCHAR(50),
Unit_Price VARCHAR(50),
Tax_5_Percentage VARCHAR(50),
Quantity INT,
Total VARCHAR(50),
Bill_Date DATE,
Bill_Time TIME,
Payment	CHAR(50),
cogs VARCHAR(50),
Gross_Margin_Percentage VARCHAR(50),
Gross_Income VARCHAR(50),
Rating VARCHAR(50));

set session sql_mode = ' ';
LOAD DATA INFILE
'F:/WalmartSalesData.csv.csv'
INTO TABLE WalmartDA
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM WalmartDA;

/* 1. Update time into Morning and Afternoon. */

SELECT Bill_Time,
		(CASE
			WHEN Bill_Time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
            WHEN Bill_Time BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
            ELSE "Evening"
		END) AS Time_Of_Day
FROM WalmartDA;

ALTER TABLE WalmartDA ADD COLUMN Time_Of_Day VARCHAR(50);

UPDATE WalmartDA
SET Time_Of_Day = (CASE
			WHEN Bill_Time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
            WHEN Bill_Time BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
            ELSE "Evening"
		END);

/* 2. Update time into Day name and Month name. */

SELECT Bill_Date, DAYNAME(Bill_Date) AS Day_Name,
MONTHNAME(Bill_Date) AS Month_Name
FROM WalmartDA
GROUP BY Bill_Date;

ALTER TABLE WalmartDA ADD COLUMN (Day_Name VARCHAR(50), Month_Name VARCHAR(50)); 

UPDATE WalmartDA SET Day_Name = DAYNAME(Bill_Date), Month_Name = MONTHNAME(Bill_Date);

/* 3. How many unique cities does the data have? */

SELECT DISTINCT City FROM WalmartDA;

/* 4. In which city is each branch? */

SELECT DISTINCT City, Branch FROM WalmartDA
ORDER BY Branch ASC;

/* 5. How many unique product lines does the data have? */

SELECT DISTINCT Product_Line FROM WalmartDA;

/* 6. What is the most selling product line. */

SELECT Product_Line,
COUNT(Product_Line) AS Most_Selling_Product_Line
FROM WalmartDA
GROUP BY Product_Line
ORDER BY Most_Selling_Product_Line DESC;

/* 7. What is the total revenue by month. */

SELECT DATE_FORMAT(Bill_Date,'%M') AS Month_Name,
SUM(Total) AS Revenue
FROM WalmartDA
GROUP BY DATE_FORMAT(Bill_Date,'%M')
ORDER BY Revenue DESC;

/* 8. What month had the largest COGS? */

SELECT DATE_FORMAT(Bill_Date,'%M') AS Month_Name,
SUM(cogs) AS Largest_COGS
FROM WalmartDA
GROUP BY Bill_Date ORDER BY Largest_COGS DESC;

/* 9. What product line had the largest revenue? */

SELECT Product_Line, SUM(Total) AS Revenue
FROM WalmartDA
GROUP BY Product_Line ORDER BY Revenue DESC;

/* 10. What is the city with the largest revenue? */

SELECT City, SUM(Total) AS Revenue
FROM WalmartDA
GROUP BY City ORDER BY Revenue DESC;

/* 11. Which branch sold more products than average product sold? */

SELECT Branch, SUM(Quantity) AS Qty
FROM WalmartDA
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM WalmartDA)
ORDER BY Qty DESC;

/* 12. What is the most common product line by gender? */

SELECT Gender, Product_Line, COUNT(Gender) AS CommonProductLine
FROM WalmartDA
GROUP BY Gender, Product_Line ORDER BY CommonProductLine DESC;

/* 13. What is the average rating of each product line? */

SELECT Product_Line, ROUND(AVG (Rating), 2) AS AverageRating
FROM WalmartDA
GROUP BY Product_Line ORDER BY AverageRating DESC;

/* 14. How many unique customer types does the data have? */

SELECT DISTINCT Customer_Type FROM WalmartDA;

/* 15. How many unique payment methods does the data have? */

SELECT DISTINCT Payment FROM WalmartDA;

/* 16. What is the most common customer type? */

SELECT Customer_Type, COUNT(Customer_Type) AS CommonCustomerType 
FROM WalmartDA
GROUP BY Customer_Type ORDER BY CommonCustomerType DESC;

/* 17. What is the gender distribution per branch? */

SELECT Branch, Gender, COUNT(Gender) AS GenderCount
FROM WalmartDA
GROUP BY Gender, Branch ORDER BY Branch ASC;

/* 18. Which time of the day do customers give most ratings? */

SELECT DATE_FORMAT(Bill_Time, '%p') AS TimeOfDay,
ROUND(AVG(Rating), 2) AS CustomerRatings
FROM WalmartDA
GROUP BY TimeOfDay
ORDER BY CustomerRatings DESC;

/* 19. Which time of the day do customers give most ratings per branch? */

SELECT Branch, DATE_FORMAT(Bill_Time, '%p') AS TimeOfDay, 
ROUND(AVG(Rating), 2) AS CustomerRatings
FROM WalmartDA
GROUP BY Branch, TimeOfDay
ORDER BY CustomerRatings DESC;

/* 20. Which day of the week has the best avg ratings? */

SELECT DATE_FORMAT(Bill_Date, '%W') AS DayOfTheWeek,
ROUND(AVG(Rating), 2) AS BestCustomerRatings
FROM WalmartDA
GROUP BY DayOfTheWeek
ORDER BY BestCustomerRatings DESC;

/* 21. Which day of the week has the best average ratings per branch? */

SELECT Branch, DATE_FORMAT(Bill_Date, '%W') AS DayOfTheWeek,
ROUND(AVG(Rating), 2) AS BestRatingsByBranch
FROM WalmartDA
GROUP BY Branch, DayOfTheWeek
ORDER BY BestCustomerRatings DESC;

/* 22. Number of sales made in each time of the day per weekday.  */

SELECT DATE_FORMAT(Bill_Time, '%p') AS TimeOfDay, 
COUNT(DATE_FORMAT(Bill_Time, '%p')) AS TimeOfSales
FROM WalmartDA
WHERE DATE_FORMAT(Bill_Date, '%W') NOT IN ("Sunday" , "Saturday")
GROUP BY TimeOfDay
ORDER BY TimeOfSales DESC;

/* 23. Which of the customer types brings the most revenue? */

SELECT Customer_Type, ROUND(SUM(Total), 2) AS MostRevenue
FROM WalmartDA
GROUP BY Customer_Type
ORDER BY MostRevenue DESC;

/* 24. Which city has the largest tax/VAT percent? */

SELECT City, ROUND(AVG(Tax_5_Percentage), 2) AS LargestTax
FROM WalmartDA
GROUP BY City ORDER BY LargestTax DESC;

/* 25. Which customer type pays the most in VAT? */

SELECT Customer_Type, ROUND(AVG(Tax_5_Percentage), 2) AS MostTaxPayees
FROM WalmartDA
GROUP BY Customer_Type ORDER BY MostTaxPayees DESC;
