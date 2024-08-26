# Inserting the Records 
LOAD DATA INFILE 'D:/Sandesh/Data Analyst/Project/Project 6 - E-Commerce (6 PM - 7 PM)/Dataset/olist_customers_dataset.csv'
INTO TABLE olist_cust
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

use olist_store;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 1) Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics  

SELECT round(SUM(CASE WHEN WEEKDAY(a.order_purchase_timestamp) < 5 THEN b.payment_value END),2) AS WeekDay_Payment,
round(SUM(CASE WHEN WEEKDAY(a.order_purchase_timestamp) >= 5 THEN b.payment_value END),2) AS WeekEnd_Payment,
round(AVG(CASE WHEN WEEKDAY(a.order_purchase_timestamp) < 5 THEN b.payment_value END),2) AS Avg_WeekDay_Payment,
round(AVG(CASE WHEN WEEKDAY(a.order_purchase_timestamp) >= 5 THEN b.payment_value END),2) AS Avg_WeekEnd_Payment
from olist_orders as A 
INNER JOIN olist_payment as b 
using (order_id) ;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 2) Number of Orders with review score 5 and payment type as credit card.

select review_score,payment_type,count(distinct(a.order_id)) as total_no_of_orders 
from olist_order_review as a 
INNER JOIN olist_payment as b
using (order_id) group by a.review_score having b.payment_type='credit_card';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

##3) Average number of days taken for order_delivered_customer_date for pet_shop -  

Select c.product_category_name,concat(round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp))),' days') as Avg_days_taken_to_deliver_Product 
from olist_orders as a INNER JOIN olist_order_items as b  
using (order_id)
INNER JOIN olist_product as c 
using (product_id)
where c.product_category_name='pet_shop';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 4) Average price and payment values from customers of sao paulo city

Select count(distinct(a.customer_id)) as total_customers ,
round(avg(price),2) as avg_price ,round(avg(payment_value),2) as avg_payment_value,a.customer_city
from olist_cust as a 
INNER JOIN olist_orders as b using (customer_id) 
INNER JOIN olist_order_items as c  using (order_id) 
INNER JOIN olist_payment as d  using (order_id)
where a.customer_city='sao paulo';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 5) Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select b.review_score as review_score ,concat(round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),0),' days') as Avg_days_taken_to_deliver_Product 
from olist_orders as a INNER JOIN olist_order_review as b
using (order_id)
group by review_score order by review_score ;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
