USE PizzaDB;

/*  **********Sales Analysis**********  */

-- Total revenue generated for the current year
SELECT
	ROUND(SUM(od.quantity * p.price),2) AS TotalRevenue
FROM Sales.Order_details AS od 
JOIN Sales.Pizzas AS p 
ON od.pizza_id = p.pizza_id;

-- Totals orders placed for the current year
SELECT COUNT(*) AS TotalOrdersPlaced FROM Sales.Orders;

-- Average pizzas Per order
SELECT (SELECT SUM(quantity) FROM Sales.Order_details )/(SELECT COUNT(*) FROM Sales.Orders) AS AveragePizzasPerOrder;

-- Average order value
SELECT ROUND(
	(SELECT ROUND(SUM(od.quantity * p.price),2) AS TotalRevenue
				FROM Sales.Order_details AS od JOIN Sales.Pizzas AS p
				ON od.pizza_id = p.pizza_id)
	/
	(SELECT COUNT(*) AS TotalOrdersPlaced 
			FROM Sales.Orders)
	,2) AS AverageOrderValue;

-- Most Ordered Pizzas (Top  5) and their revenue
SELECT 
	TOP 5 pt.name AS PizzaName, 
	COUNT(od.order_details_id) AS TotalOrders, 
	SUM(quantity*price) AS TotalRevenue
FROM Sales.Order_details AS od 
JOIN Sales.Pizzas AS p 
ON od.pizza_id = p.pizza_id
JOIN Sales.Pizza_types AS pt 
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name 
ORDER BY TotalOrders DESC;

-- Least Ordered Pizzas (Top 5) and their revenue
SELECT 
	TOP 5 pt.name AS PizzaName, 
	COUNT(od.order_details_id) AS TotalOrders, 
	ROUND(SUM(quantity*price),2) AS TotalRevenue
FROM Sales.Order_details AS od 
JOIN Sales.Pizzas AS p 
ON od.pizza_id = p.pizza_id
JOIN Sales.Pizza_types AS pt 
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name 
ORDER BY TotalOrders;

-- Total Ordered pizzas according to the sizes
SELECT 
	p.size AS PizzaSize, 
	COUNT(od.order_details_id) AS TotalOrders
FROM Sales.Order_details AS od	
JOIN Sales.Pizzas AS p 
ON od.pizza_id = p.pizza_id
JOIN Sales.Pizza_types AS pt 
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.size 
ORDER BY TotalOrders DESC;

-- Find the orders with more than 4 pizzas to find preferred pizzas while ordered in bulk.
WITH BulkOrderedPizzas AS (
	SELECT 
		name,
		size,
		category
	FROM Sales.Order_details AS od 
	JOIN Sales.Pizzas AS p 
	ON od.pizza_id = p.pizza_id
	JOIN Sales.Pizza_types AS pt 
	ON p.pizza_type_id = pt.pizza_type_id
	WHERE od.order_id IN (SELECT 
							order_id AS OrderMorethan6 
							FROM Sales.Order_details
							GROUP BY order_id 
							HAVING SUM(quantity) >= 6)
)SELECT 
	TOP 15 name,
	category,
	size,
	COUNT(*) AS TotalOrdered 
FROM BulkOrderedPizzas
GROUP BY name,category,size 
ORDER BY TotalOrdered DESC;

-- Peak Hours of the day.
SELECT 
	DATEPART(HOUR,time) AS Hour, 
	SUM(od.quantity) AS TotalOrders
FROM Sales.Orders AS o 
JOIN Sales.Order_details AS od 
ON o.order_id = od.order_id
GROUP BY DATEPART(HOUR,time) 
ORDER BY DATEPART(HOUR,time);

-- Most busiest days of the week
SELECT 
	SaleDay, 
	SUM(od.quantity) AS TotalOrders
FROM Sales.Orders AS o 
JOIN Sales.Order_details AS od 
ON o.order_id = od.order_id
GROUP BY SaleDay;

-- Find the revenue and orders placed according to the month. Comparing the sales with the previous month
-- How is the AOV behaving monthly and see if there are any patterns.
WITH MonthRevenue AS (
	SELECT 
		DATEPART(MONTH,date) AS MonthNumber ,
		SaleMonth, ROUND(SUM(od.quantity * p.price),2) AS TotalRevenue
	FROM Sales.Orders AS o 
	JOIN Sales.Order_details AS od 
	ON o.order_id = od.order_id
	JOIN Sales.Pizzas AS p 
	ON od.pizza_id = p.pizza_id
	GROUP BY DATEPART(MONTH,date),SaleMonth
), MonthlyOrders AS (
	SELECT 
		SaleMonth,
		COUNT(order_id) AS TotalOrders
	FROM Sales.Orders
	GROUP BY SaleMonth
)SELECT 
	MR.SaleMonth,
	TotalRevenue,
	TotalOrders,
	CONCAT(CAST(COALESCE(ROUND(((TotalRevenue - LAG(TotalRevenue) OVER(ORDER BY MonthNumber))*100)/TotalRevenue,0),'0') AS VARCHAR),'%') AS PercentageChange,
	ROUND(MR.TotalRevenue/MO.TotalOrders,2) AS AverageOrderValue
FROM MonthRevenue AS MR 
JOIN MonthlyOrders AS MO 
ON MR.SaleMonth = MO.SaleMonth


-- Category wise revenue distribution
SELECT 
	pt.category, 
	ROUND(SUM(od.quantity * p.price),2) AS TotalRevenue
FROM Sales.Order_details AS od 
JOIN Sales.Pizzas AS p 
ON od.pizza_id = p.pizza_id
JOIN Sales.Pizza_types AS pt 
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category 
ORDER BY TotalRevenue DESC;

-- Top Revenue generated pizza types in each category
WITH PizzaRanks AS(
	SELECT	
		category,name,
		ROUND(SUM(od.quantity * p.price),2) AS TotalRevenue,
		ROW_NUMBER() OVER(PARTITION BY category ORDER BY ROUND(SUM(od.quantity * p.price),2) DESC) AS PizzaRank
	FROM Sales.Order_details AS od 
	JOIN Sales.Pizzas AS p 
	ON od.pizza_id = p.pizza_id
	JOIN Sales.Pizza_types AS pt 
	ON p.pizza_type_id = pt.pizza_type_id
	GROUP BY category,name
)SELECT 
	category,
	name AS Top3Pizzas,
	TotalRevenue
FROM PizzaRanks 
WHERE PizzaRank <= 3;

-- Most Ordered Pizza Combinations
WITH PizzasCombination AS (
	SELECT 
		name,
		size,
		category
	FROM Sales.Order_details AS od 
	JOIN Sales.Pizzas AS p 
	ON od.pizza_id = p.pizza_id
	JOIN Sales.Pizza_types AS pt 
	ON p.pizza_type_id = pt.pizza_type_id
	WHERE od.order_id IN (SELECT 
								order_id AS OrderMorethan6 
								FROM Sales.Order_details
								GROUP BY order_id 
								HAVING SUM(quantity) > 1)
) SELECT 
	TOP 10 name,
	category,
	size,
	COUNT(*) AS TotalOrdered 
FROM PizzasCombination
GROUP BY name,category,size 
ORDER BY TotalOrdered DESC;



/*  ***********Inventory Management*********** */

-- Displaying the ingredients frequency of the High ordered pizza types
WITH HighOrderedPizzas AS(
	SELECT * FROM Sales.Pizza_types 
	WHERE name IN (SELECT TOP 20 pt.name
					FROM Sales.Order_details AS od JOIN Sales.Pizzas AS p ON od.pizza_id = p.pizza_id
					JOIN Sales.Pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
					GROUP BY pt.name ORDER BY COUNT(od.order_details_id) DESC)
),Ingredients AS(
	SELECT name,VALUE AS Ingredients 
	FROM HighOrderedPizzas CROSS APPLY STRING_SPLIT(ingredients, ',')
) SELECT TRIM(Ingredients) AS Ingredients, COUNT(*) AS Frequency
FROM Ingredients
GROUP BY TRIM(Ingredients) ORDER BY Frequency DESC;



-- Displaying the ingredients of the low ordered pizzas according to size 
WITH LowOrderedPizzaSizes AS(
	SELECT * FROM Sales.Pizza_types
	WHERE pizza_type_id IN (SELECT DISTINCT pizza_type_id FROM Sales.Pizzas WHERE size IN ('XL', 'XXL'))
)
SELECT pizza_type_id,name,VALUE AS Ingredients 
FROM LowOrderedPizzaSizes CROSS APPLY STRING_SPLIT(ingredients, ',');

-- Comparing the other size sales of the low ordered pizzas to check if pricing is the factor in less sales.
WITH LowOrderedPizzaSizes AS(
	SELECT pizza_type_id FROM Sales.Pizza_types
	WHERE pizza_type_id IN (SELECT DISTINCT pizza_type_id FROM Sales.Pizzas WHERE size IN ('XL', 'XXL'))
), CompareSizeOrdersPrices AS(
	SELECT p.pizza_type_id,size,SUM(quantity) AS TotalOrders 
	FROM Sales.Order_details AS od JOIN Sales.Pizzas AS p ON od.pizza_id = p.pizza_id
	GROUP BY p.pizza_type_id,size
	HAVING p.pizza_type_id IN (SELECT DISTINCT pizza_type_id FROM LowOrderedPizzaSizes)
)
SELECT * FROM CompareSizeOrdersPrices;
