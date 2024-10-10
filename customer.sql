CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

INSERT INTO customers (customer_id, customer_name, email) VALUES
(1, 'Acme Corp', 'contact@acmecorp.com'),
(2, 'GlobalTech', 'info@globaltech.com'),
(3, 'Local Shop', 'owner@localshop.com');
(4, 'Big Industries', 'sales@bigindustries.com'),
(5, 'Small Startup', 'hello@smallstartup.com');

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-01-15'),
(2, 1, '2023-02-20'),
(3, 2, '2023-02-22');
(4, 3, '2023-03-01'),
(5, 2, '2023-03-15');

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 699.99),
(3, 'Desk Chair', 'Furniture', 199.99);
(4, 'Coffee Maker', 'Appliances', 79.99);
(5, 'Smart Watch', 'Electronics', 249.99);

-- customer with order count and total order value
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS order_count,
    COALESCE(SUM(p.price), 0) AS total_order_value
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
LEFT JOIN 
    order_items oi ON oi.order_id = o.order_id
LEFT JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    c.customer_id, c.customer_name
HAVING 
    COUNT(o.order_id) > 0
ORDER BY 
    total_order_value DESC;


-- All customer order and products with when did he ordered weekday or weeknd and category
select c.customer_name,
o.order_date,
case 
  when DAYOFWEEK(o.order_date) in (1,7) Then 'Weekend'
  else 'Weekday'
end as order_day_type,
p.product_name,
p.price,
case
  when p.price<100 then 'Budget'
  when p.price between 100 and 500 then 'mid range'
  else 'premium'
end as price_category
from customers c
inner join 
orders o on  c.customer_id =o.customer_id
inner join products p on p.product_id in (select product_id from orders where order_id =o.order_id)
where 
o.order_date <= DATE_SUB(CURDATE(),INTERVAL 1 YEAR)
order by 
o.order_date desc;

-- CASE 2

create database hackathon;
use hackathon;

-- Create tables
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_date DATE,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 599.99),
(3, 'Tablet', 'Electronics', 399.99),
(4, 'Desk Chair', 'Furniture', 149.99),
(5, 'Coffee Table', 'Furniture', 199.99),
(6, 'Bookshelf', 'Furniture', 89.99),
(7, 'Running Shoes', 'Apparel', 79.99),
(8, 'T-shirt', 'Apparel', 19.99),
(9, 'Jeans', 'Apparel', 59.99);

INSERT INTO sales (sale_id, product_id, sale_date, quantity) VALUES
(1, 1, '2023-01-15', 2),
(2, 2, '2023-01-16', 3),
(3, 4, '2023-01-17', 1),
(4, 7, '2023-01-18', 4),
(5, 3, '2023-02-01', 2),
(6, 5, '2023-02-02', 1),
(7, 8, '2023-02-03', 5),
(8, 1, '2023-02-15', 1),
(9, 6, '2023-02-16', 2),
(10, 2, '2023-02-17', 2),
(11, 9, '2023-03-01', 3),
(12, 4, '2023-03-02', 2),
(13, 7, '2023-03-03', 3),
(14, 3, '2023-03-15', 1),
(15, 5, '2023-03-16', 1);

-- Problem Statement:
-- Analyze the sales data to find the top-performing product category for each month of 2023.
-- The performance should be based on total revenue (quantity sold * unit price).
-- Your query should return the month, the top-performing category, and its total revenue.
-- In case of a tie, include all categories with the same top performance.

-- Expected output format:
-- | month | top_category | total_revenue |
-- |-------|--------------|---------------|
-- | 2023-01 | Electronics | 2799.97      |
-- | 2023-02 | Furniture   | 399.98       |
-- | 2023-03 | Electronics | 999.98       |

explain with monthly_revenue as(
   select date_format(s.sale_date, '%Y-%m') as sale_month,
   p.category,
   sum(s.quantity * p.unit_price) as tot_revenue
   from sales s
   join products p on s.product_id=p.product_id
   group by sale_month, p.category
),
categories_ranking as(
   select sale_month,
   category,
   tot_revenue
   from monthly_revenue
)
select 
   sale_month,
   category as top,
   tot_revenue
from categories_ranking
where ranks = 1;

-- Note: The actual values may differ based on the sample data provided.