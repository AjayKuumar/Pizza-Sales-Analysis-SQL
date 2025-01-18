USE PizzaDB;

SELECT * FROM Sales.Orders;
SELECT * FROM Sales.Order_details;
SELECT * FROM Sales.Pizza_types;
SELECT * FROM Sales.Pizzas;


-- Checking for any null values in the required columns of orders and pizzas table
SELECT * FROM Sales.Orders WHERE time IS NULL OR date IS NULL;
SELECT * FROM Sales.Pizzas WHERE price IS NULL OR size IS NULL;
SELECT * FROM Sales.Order_details WHERE quantity IS NULL;
-- There are no null values present.

-- Let's check for any duplicates in the pizza type table
SELECT
	name,
	COUNT(*) AS TotalCount
FROM Sales.Pizza_types
GROUP BY name
ORDER BY TotalCount DESC;
-- There are no duplicate pizzas present.

-- Validating the data present in the columns
SELECT DISTINCT category FROM Sales.Pizza_types;
SELECT DISTINCT size FROM Sales.Pizzas

-- Defining foreign key constarints to the order details and pizza tables
ALTER TABLE Sales.Order_details
ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES Sales.Orders(order_id);

ALTER TABLE Sales.Order_details
ADD CONSTRAINT fk_pizza FOREIGN KEY (pizza_id) REFERENCES Sales.Pizzas(pizza_id);

-- Extracting required columns.
ALTER TABLE Sales.Orders ADD SaleMonth VARCHAR(10);
ALTER TABLE Sales.Orders ADD SaleDay VARCHAR(10);

UPDATE Sales.Orders SET SaleMonth = DATENAME(MONTH,date);
UPDATE Sales.Orders SET SaleDay = DATENAME(WEEKDAY,date);

-- Formatting the numerical values in the price column
UPDATE Sales.Pizzas SET price = ROUND(price,2);