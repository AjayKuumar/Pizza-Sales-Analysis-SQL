# Pizza Sales Optimization, Menu Reforming, and Inventory Management

![Image Alt Text](https://images3.alphacoders.com/104/thumb-1920-1041781.jpg)

## Table of Contents
1. [Introduction](#introduction)  
2. [Dataset Description](#dataset-description)
3. [Project Objectives](#project-objectives)
4. [Analysis Conducted](#analysis-conducted)
5. [Tools and Technologies](#tools-and-technologies)  
6. [Key Metrics and Insights](#key-metrics-and-insights)
7. [Recommendations](#recommendations)
8. [How to Use the Project](#how-to-use-the-project)  
9. [Conclusion](#conclusion)

## Introduction
This project involves analyzing historical sales data from a pizza shop to gain insights into customer preferences, operational performance, and revenue trends. The dataset, sourced from Maven Analytics, consists of four interconnected tables capturing order, product, and sales information.

The analysis aims to answer critical business questions such as identifying bestsellers, understanding seasonal trends, and evaluating customer preferences for pizza sizes and types.

## Dataset Description
The dataset contains the following four tables:

- ### 1. Orders Table
    - `order_id`: Unique identifier for each order.  
    - `date`: Date the order was placed.  
    - `time`: Time the order was placed.

- ### 2. Order Details Table
    - `order_details_id`: Unique identifier for each pizza in an order.  
    - `order_id`: Links to the Orders table.  
    - `pizza_id`: Links to the Pizzas table.  
    - `quantity`: Number of pizzas ordered.

- ### 3. Pizzas Table
    - `pizza_id`: Unique identifier for each pizza.  
    - `pizza_type_id`: Links to the Pizza Types table.  
    - `size`: Pizza size (e.g., Small, Medium, Large, XL, XXL).  
    - `price`: Price of the pizza in USD.

- ### 4. Pizza Types Table
    - `pizza_type_id`: Unique identifier for each pizza type.  
    - `name`: Name of the pizza as shown in the menu.  
    - `category`: Pizza category (e.g., Classic, Chicken, Supreme, Veggie).  
    - `ingredients`: List of ingredients for the pizza.

## Project Objectives
- Analyze sales trends to identify high and low-performing pizzas.
- Determine peak order times and days to optimize staffing and inventory.
- Evaluate the popularity of pizza sizes to inform menu and pricing strategies.
- Assess seasonal revenue trends and order volumes for strategic planning.

## Analysis Conducted
- **Sales Analysis**: Identified bestsellers, low performers, and the contribution of each pizza size and type.
- **Time-Based Analysis**: Examined hourly and daily order patterns to pinpoint peak sales periods.
- **Seasonal Trends**: Analyzed monthly revenue trends, highlighting peaks in July and declines in October.
- **Customer Preferences**: Explored category-wise performance, revealing the dominance of Classic pizzas and the strong showing of Chicken and Supreme categories.
- **Revenue Optimization**: Highlighted opportunities to improve sales during low-revenue months such as December and August.

## Tools and Technologies
- **SQL Server**: For querying and analyzing the dataset.

## Key Metrics and Insights
- **Revenue and Orders**: The pizza shop generated $817,860.05 in revenue from 21,350 orders, with an average order value of $38.31.
- **Best-Selling Pizzas**:
  - Classic Deluxe Pizza: 2,416 orders, $38,180.50 in revenue.
  - Barbecue Chicken Pizza: 2,372 orders, $42,768 in revenue.
  - Thai Chicken Pizza: 2,315 orders, $43,434.25 in revenue.
- **Least Popular Pizzas**:
  - Brie Carre Pizza: 480 orders, $11,588.50 in revenue.
  - Mediterranean Pizza: 923 orders, $15,360.50 in revenue.
- **Pizza Sizes**:
  - Large (L): Most popular with 18,526 pizzas sold (46% of sales).
  - XL and XXL sizes are the least popular, contributing only 1.17% of total orders.
- **Peak Order Times**:
  - Lunch hours (11 AM–1 PM) and dinner hours (6 PM–7 PM) have the highest order volumes.
  - Friday is the busiest day, followed by Saturday and Thursday.

## Recommendations

- To optimize sales and improve operational efficiency, focus on promoting best-selling pizzas through special offers and seasonal campaigns. Address underperforming pizzas by gathering customer feedback and considering recipe adjustments or removal from the menu. Simplify the menu by focusing on popular pizza sizes (Small, Medium, Large) and adjusting the availability of XL/XXL sizes based on demand.

- Enhance inventory management by negotiating better pricing for high-demand ingredients and ordering smaller batches for low-frequency items. Capitalize on peak order times (lunch and dinner) by ensuring adequate staffing and targeted promotions. Increase sales on slower days (Sunday and Monday) with special discounts.

- Additionally, prioritize bulk orders by offering party packs and volume discounts, and align promotional efforts with high-demand periods like holidays. These strategies, along with data-driven adjustments, can improve customer satisfaction, optimize resources, and increase overall revenue.


## How to Use the Project
1. **Dataset**: Load the dataset into a relational database management system (RDBMS) like SQL Server.
2. **SQL Queries**: Execute the provided SQL scripts to explore sales, revenue, and customer preferences.
3. **Analysis**: Use the insights to generate reports or dashboards for strategic decision-making.

## Conclusion
This project highlights the power of SQL in analyzing business data to derive meaningful insights. By identifying top-performing products, understanding customer preferences, and recognizing seasonal trends, the pizza shop can optimize its operations and maximize revenue.

Future analyses can focus on customer segmentation, promotional effectiveness, and the impact of new menu additions to further enhance business strategies.

