-- total sales, total profit, number of unique orders, and number of unique customers
select round(sum(sales),0) as total_sales,
       round(sum(profit),0) as total_profit,
       count(distinct order_id) as unique_orders,
	   count(distinct customer_id) as unique_customers
 from mytable;
 

 
 
 -- monthly sales and profits change over time
 select   date_format(Order_Date, '%Y-%m') as yearmonth,
          count(distinct order_id)         as order_count,
          round(sum(sales),0) as total_sales,
          round(sum(profit),0) as total_profit
 from mytable
 group by yearmonth
 order by yearmonth;
 
 
 
 

 
 
 -- customer segments performance
 select  segment,
         round(sum(sales),0) as total_sales,
         round(sum(profit),0) as total_profit,
         round(sum(profit)/sum(sales)*100,2) as profit_margin
 from mytable
 group by segment
 order by profit_margin desc;
 
 
 
 -- Regional Performance
select region,
	   round(sum(sales),0) as total_sales,
	   round(sum(profit),0) as total_profit,
       round(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
from mytable
group by region
order by  profit_margin desc
;


-- sales by state
select
  state,
  ROUND(SUM(sales), 0) as total_sales,
  ROUND(SUM(profit), 0) as total_profit,
  ROUND(SUM(profit)/SUM(sales)*100, 2) as profit_margin
from mytable
group by state
order by total_profit desc;


-- product insights
-- top 10 by total sales
select rank() over(order by sum(sales) desc) as ranking,
      Product_Name,
      round(sum(sales),0) as total_sales,
      round(sum(profit),0) as total_profit,
      round(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
 from mytable
 group by Product_Name
 order by total_sales desc
 limit 10;
 
 
 
 
 
 --  products have high sales but low or negative profits
 
 select rank() over(order by sum(sales) desc) as ranking,
      Product_Name,
      round(sum(sales),0) as total_sales,
      round(sum(profit),0) as total_profit,
      round(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
 from mytable
 group by Product_Name
 HAVING profit_margin <= 15
 order by total_sales desc
 limit 10;
 
 
 
 
 
 -- top 10 by total profit
select rank() over(order by sum(profit) desc) as ranking,
      Product_Name,
      round(sum(profit),0) as total_profit,
      round(sum(sales),0) as total_sales,
      round(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
     
 from mytable
 group by Product_Name
 order by total_profit desc
 limit 10;
 
 
 
 
  -- top 10 by profit margin
select dense_rank() over(order by SUM(profit)/SUM(sales)*100 desc) as ranking,
      Product_Name,
      round(sum(profit),0) as total_profit,
      round(sum(sales),0) as total_sales,
      round(SUM(profit)/SUM(sales)*100, 2) AS profit_margin
     
 from mytable
 group by Product_Name
 order by profit_margin desc
 limit 10;
 
 
 --  Shipping & Delivery

 -- average delivery time for orders
 select round(avg(datediff( ship_date, order_date)),0) as avg_delivery_time
 from mytable;
 
 -- fastest and slowest shipping mode 
 select ship_mode,
 round(avg(datediff( ship_date, order_date)),0) as avg_delivery_time,
 count(*) as order_count
 from mytable
 group by ship_mode
 order by avg_delivery_time;
 
 
 
 -- Customer Insights--
 
 -- top 10 customers by total sales
 
 select customer_name,
        round(sum(sales),0) as total_sales
from mytable
group by customer_name
order by total_sales desc
limit 10;
 
 
 -- average number of orders per customer
  select 
      round(count(distinct order_id) *1.0 / count(distinct customer_id),2) as avg_orders_per_customer
from mytable;

-- by reigon
 select region,
      round(count(distinct order_id) *1.0 / count(distinct customer_id),2) as avg_orders_per_customer
from mytable
group by region
order by avg_orders_per_customer desc;


-- Discount Impact

 
-- How do different discount levels affect profit?
select  discount,
round(sum(profit),0) as total_profit,
round(sum(profit)/sum(sales)*100, 2) as avg_profit_margin
from mytable
group by discount
order by discount;

-- what discount ranges do we start losing profit?
select  discount,
round(sum(profit),0) as total_profit
from mytable
group by discount
having total_profit < 0
order by discount;







--  Category-Level Analysis

--  total sales and profits by category 

select category,
   round(sum(sales),0) as total_sales,
   round(sum(profit),0) as total_profit,
   round(sum(profit)/sum(sales)*100, 2) as profit_margin

from mytable
group by category
order by total_profit desc;

-- Year-over-year category trends
select category,
   year(Order_Date) as year,
   round(sum(sales),0) as total_sales,
   round(sum(profit),0) as total_profit,
   round(sum(profit)/sum(sales)*100, 2) as profit_margin

from mytable
group by category,year
order by category,year;






--  total sales and profits by  sub-category
select category, subcategory,
   round(sum(sales),0) as total_sales,
   round(sum(profit),0) as total_profit,
   round(sum(profit)/sum(sales)*100, 2) as profit_margin
from mytable
group by category, subcategory
order by category, total_profit desc;