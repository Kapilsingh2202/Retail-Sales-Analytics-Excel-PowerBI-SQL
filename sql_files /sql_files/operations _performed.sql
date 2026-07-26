-- 1 Total no of orders
SELECT 
    COUNT(DISTINCT Order_ID) AS Total_Orders 
    FROM Fact_Sales;
    
    --  Total revenue generated
SELECT     
    ROUND(SUM(Sales_Amount), 2) AS Total_Revenue
     FROM Fact_Sales;
     
     -- 3 total profit
  SELECT    
    ROUND(SUM(Profit), 2) AS Total_Profit
     FROM Fact_Sales;
  
  -- Profit Margin
 SELECT     
    ROUND((SUM(Profit) / SUM(Sales_Amount)) * 100, 2) AS Profit_Margin
FROM Fact_Sales;

-- Top 5 Best Selling Product

select 
p.product_name,
p.category ,
sum(f.Sales_Amount) as total_sale
from fact_sales f
join product_master p
on p.product_id = f.product_id
group by p.product_name, p.category
order by total_sale desc limit 5;

-- category wise sale 

select
p.category ,
sum(f.quantity) as total_quantity,
sum(f.sales_amount) as total_revenue
from
fact_sales f
inner join 
product_master p
on f.product_id = p.product_id
group by p.category
order by total_revenue desc limit 5;

-- category where sale is above 50 m

SELECT
    p.Category,
    SUM(f.Sales_Amount) AS Total_Sales
FROM fact_sales f
JOIN product_master p
ON f.Product_ID = p.Product_ID
GROUP BY p.Category
HAVING SUM(f.Sales_Amount) > 50000000;

-- region wise sale performance

SELECT 
    s.Region,
    COUNT(DISTINCT s.Store_ID) AS Total_Stores,
    SUM(f.Sales_Amount)AS Total_Sales,
    AVG(f.Sales_Amount)AS Avg_Order_Value
FROM Fact_Sales f
JOIN Store_Master s ON f.Store_ID = s.Store_ID
GROUP BY s.Region
ORDER BY Total_Sales DESC;

-- MOM (Month Over Month Sale Trend )


SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Year_Month_Sale,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales_Amount), 2) AS Monthly_Revenue
FROM Fact_Sales
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Year_Month_Sale;


-- Which month/year having maximum sale

SELECT 
    YEAR(Order_Date) AS Sales_Year,
    MONTHNAME(Order_Date) AS Sales_Month,
    ROUND(SUM(Sales_Amount), 2) AS Total_Sales
FROM Fact_Sales
GROUP BY YEAR(Order_Date), MONTHNAME(Order_Date)
ORDER BY Total_Sales DESC
LIMIT 1;

--  which day the sale was maximu


SELECT 
    DATE(Order_Date) AS Sales_Date,
    DAYNAME(Order_Date) AS Day_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales_Amount), 2) AS Highest_Daily_Sales
FROM Fact_Sales
GROUP BY DATE(Order_Date), DAYNAME(Order_Date)
ORDER BY Highest_Daily_Sales DESC
LIMIT 1;

-- Top Customer From Each Region 

WITH Customer_Regional_Sales AS (
    SELECT 
        s.Region,
        c.Customer_Name,
        SUM(f.Sales_Amount) AS Total_Spent,
        DENSE_RANK() OVER(PARTITION BY s.Region ORDER BY SUM(f.Sales_Amount) DESC) AS Rank_Num
    FROM Fact_Sales f
    JOIN Customer_Master c ON f.Customer_ID = c.Customer_ID
    JOIN Store_Master s ON f.Store_ID = s.Store_ID
    GROUP BY s.Region, c.Customer_Name
)
SELECT Region, Customer_Name, ROUND(Total_Spent, 2) AS Total_Spent
FROM Customer_Regional_Sales
WHERE Rank_Num = 1;

-- Products Sold Above Average Price in Their Category

WITH Category_Avg AS (
    SELECT 
        Product_ID,
        Product_Name,
        Category,
        Price,
        AVG(Price) OVER(PARTITION BY Category) AS Avg_Category_Price
    FROM Product_Master
)
SELECT 
    Product_Name, 
    Category, 
    Price, 
    ROUND(Avg_Category_Price, 2) AS Category_Avg_Price
FROM Category_Avg
WHERE Price > Avg_Category_Price;

-- payment analysis view

CREATE VIEW vw_paymentanalysis AS
SELECT
    Payment_Mode,
    COUNT(*) AS Total_Orders,
    SUM(Sales_Amount) AS Total_Sales
FROM Fact_Sales
GROUP BY Payment_Mode;

SELECT * FROM vw_paymentanalysis ;

-- Store Sale view

CREATE VIEW vw_StorePerformance AS
SELECT
    s.Store_Name,
    SUM(f.Sales_Amount) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM Fact_Sales f
JOIN Store_Master s
ON f.Store_ID = s.Store_ID
GROUP BY s.Store_Name;

select * from vw_StorePerformance ;

-- TOP 10 CUSTOMER WHO PLACED MODE THAN 10 ORDER

SELECT
    c.Customer_Name,
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,
    ROUND(SUM(f.Sales_Amount),2) AS Total_Sales
FROM Fact_Sales f
INNER JOIN Customer_Master c
ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
HAVING COUNT(DISTINCT f.Order_ID) > 10
ORDER BY Total_Sales DESC
LIMIT 10;

-- top cities by sales

SELECT
    c.City,
    ROUND(SUM(f.Sales_Amount),2) AS Total_Sales
FROM Fact_Sales f
INNER JOIN Customer_Master c
ON f.Customer_ID = c.Customer_ID
GROUP BY c.City
ORDER BY Total_Sales DESC
LIMIT 5;

-- Combine 3 tables

SELECT
    f.Order_ID,
    c.Customer_Name,
    p.Product_Name,
    s.Store_Name,
    f.Quantity,
    f.Sales_Amount
FROM Fact_Sales f
INNER JOIN Customer_Master c
    ON f.Customer_ID = c.Customer_ID
INNER JOIN Product_Master p
    ON f.Product_ID = p.Product_ID
INNER JOIN Store_Master s
    ON f.Store_ID = s.Store_ID;
