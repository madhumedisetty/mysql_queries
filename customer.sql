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