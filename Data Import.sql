-- Creating the Database 
DROP DATABASE IF EXISTS PizzaDB;
CREATE DATABASE PizzaDB;
GO

USE PizzaDB;

-- Creating a schema Sales
CREATE SCHEMA Sales;

-- The dataset is about the pizza sales. 
-- The task is to improve sales performance, enhance menu offerings, and streamline inventory management.

/*
It contain four tables:
	Order table - which contains date and time of the order
	Order details table - which contains details about each order like pizza quantity and its size.
	Pizzas table - which contains various pizzas, its size and price of the pizza.
	Pizzatypes table - which contains the ingredients of each pizza and its category.
*/

-- Importing the Order table
SELECT * FROM Sales.Orders;

-- Importing the pizza types table
SELECT * FROM Sales.Pizza_types;

-- Importing the pizza table
SELECT * FROM Sales.Pizzas;

-- Importing the order details table
SELECT * FROM Sales.Order_details;