show databases;
create database customers;
use customers;



CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    registration_date DATE
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10, 2),
    stock_quantity INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    customer_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Inserting sample data into Customers table
INSERT INTO customers (first_name, last_name, email, registration_date)
VALUES 
('John', 'Doe', 'john.doe@example.com', '2023-01-10'),
('Jane', 'Smith', 'jane.smith@example.com', '2023-02-15'),
('Alice', 'Johnson', 'alice.johnson@example.com', '2023-03-20'),
('Bob', 'Brown', 'bob.brown@example.com', '2023-04-01'),
('Charlie', 'Davis', 'charlie.davis@example.com', '2023-05-05'),
('David', 'Miller', 'david.miller@example.com', '2023-06-10'),
('Eve', 'Taylor', 'eve.taylor@example.com', '2023-07-15'),
('Frank', 'Wilson', 'frank.wilson@example.com', '2023-08-20'),
('Grace', 'Moore', 'grace.moore@example.com', '2023-09-01'),
('Henry', 'Anderson', 'henry.anderson@example.com', '2023-10-05');

-- Inserting sample data into Categories table
INSERT INTO categories (category_name)
VALUES 
('Fiction'),
('Non-Fiction'),
('Children'),
('History'),
('Science'),
('Biography'),
('Fantasy'),
('Mystery'),
('Romance'),
('Technology');

-- Inserting sample data into Products table
INSERT INTO products (product_name, category_id, price, stock_quantity)
VALUES 
('The Great Gatsby', 1, 15.99, 100),
('Sapiens: A Brief History of Humankind', 2, 19.99, 80),
('Harry Potter and the Sorcerers Stone', 7, 25.50, 50),
('The Catcher in the Rye', 1, 10.99, 120),
('A Brief History of Time', 5, 18.50, 60),
('The Diary of a Young Girl', 6, 12.99, 90),
('To Kill a Mockingbird', 1, 14.99, 110),
('The History of the World', 4, 22.00, 70),
('Goodnight Moon', 3, 9.50, 200),
('The Lean Startup', 10, 29.99, 40);

-- Inserting sample data into Orders table
INSERT INTO orders (customer_id, order_date)
VALUES 
(1, '2023-10-01 12:30:00'),
(2, '2023-10-02 14:15:00'),
(3, '2023-10-03 16:00:00'),
(4, '2023-10-04 18:45:00'),
(5, '2023-10-05 10:30:00'),
(6, '2023-10-06 11:00:00'),
(7, '2023-10-07 15:15:00'),
(8, '2023-10-08 17:30:00'),
(9, '2023-10-09 13:00:00'),
(10, '2023-10-10 14:45:00');

-- Inserting sample data into OrderItems table
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit)
VALUES 
(1, 1, 2, 15.99),
(1, 2, 1, 19.99),
(2, 3, 1, 25.50),
(3, 4, 1, 10.99),
(3, 5, 1, 18.50),
(4, 6, 1, 12.99),
(5, 7, 2, 14.99),
(6, 8, 1, 22.00),
(7, 9, 3, 9.50),
(8, 10, 1, 29.99);

-- Inserting sample data into ProductReviews table
INSERT INTO product_reviews (product_id, customer_id, rating, review_text, review_date)
VALUES 
(1, 1, 5, 'Amazing book!', '2023-10-02'),
(2, 2, 4, 'Very insightful.', '2023-10-03'),
(3, 3, 5, 'A must-read for fans of fantasy.', '2023-10-04'),
(4, 4, 3, 'Good, but a bit overrated.', '2023-10-05'),
(5, 5, 4, 'Great science book.', '2023-10-06'),
(6, 6, 5, 'Truly moving story.', '2023-10-07'),
(7, 7, 4, 'Fantastic book, but slow at times.', '2023-10-08'),
(8, 8, 4, 'Interesting historical perspective.', '2023-10-09'),
(9, 9, 5, 'My child loves it!', '2023-10-10'),
(10, 10, 5, 'A great guide for startups.', '2023-10-11');

-- Question 1: Find the top 3 customers who have spent the most money, 
-- along with their total spend and the number of orders they've made.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.price_per_unit) AS total_spend
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    total_spend DESC
LIMIT 3;

-- 2. Calculate the average rating for each product category, 
-- but only include categories with at least 2 reviews.

SELECT 
    c.category_name,
    AVG(pr.rating) AS avg_rating,
    COUNT(pr.review_id) AS review_count
FROM 
    categories c
JOIN 
    products p ON c.category_id = p.category_id
JOIN 
    product_reviews pr ON p.product_id = pr.product_id
GROUP BY 
    c.category_id, c.category_name
HAVING 
    COUNT(pr.review_id) >= 2
ORDER BY 
    avg_rating DESC;

-- 3. Find products that have never been ordered.

SELECT 
    p.product_id,
    p.product_name
FROM 
    products p
LEFT JOIN 
    order_items oi ON p.product_id = oi.product_id
WHERE 
    oi.order_item_id IS NULL;

-- 4. For each customer, find the time difference between their 
-- registration date and their first order date.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.registration_date,
    MIN(o.order_date) AS first_order_date,
    DATEDIFF(MIN(o.order_date), c.registration_date) AS days_to_first_order
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.registration_date
ORDER BY 
    days_to_first_order;

-- 5. Create a report showing the total revenue for each month, 
-- along with a running total of revenue throughout the year.

SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.price_per_unit) AS monthly_revenue,
    SUM(SUM(oi.quantity * oi.price_per_unit)) OVER (
        ORDER BY DATE_FORMAT(o.order_date, '%Y-%m')
    ) AS running_total
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY 
    month;

-- 6. Identify customers who have made a purchase but have never left a product review.

SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
LEFT JOIN 
    product_reviews pr ON c.customer_id = pr.customer_id
WHERE 
    pr.review_id IS NULL;

-- 7. Find the product that has been ordered the most times (by quantity).

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_ordered
FROM 
    products p
JOIN 
    order_items oi ON p.product_id = oi.product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_quantity_ordered DESC
LIMIT 1;

-- 8. Calculate the percentage of total revenue that each product category contributes.

WITH category_revenue AS (
    SELECT 
        c.category_id,
        c.category_name,
        SUM(oi.quantity * oi.price_per_unit) AS revenue
    FROM 
        categories c
    JOIN 
        products p ON c.category_id = p.category_id
    JOIN 
        order_items oi ON p.product_id = oi.product_id
    GROUP BY 
        c.category_id, c.category_name
),
total_revenue AS (
    SELECT SUM(revenue) AS total FROM category_revenue
)
SELECT 
    cr.category_name,
    cr.revenue,
    (cr.revenue / tr.total) * 100 AS percentage_of_total
FROM 
    category_revenue cr
CROSS JOIN 
    total_revenue tr
ORDER BY 
    percentage_of_total DESC;

-- 9. For each customer, find their most frequently purchased product category.

WITH customer_category_purchases AS (
    SELECT 
        o.customer_id,
        p.category_id,
        COUNT(*) AS purchase_count,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id 
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM 
        orders o
    JOIN 
        order_items oi ON o.order_id = oi.order_id
    JOIN 
        products p ON oi.product_id = p.product_id
    GROUP BY 
        o.customer_id, p.category_id
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    cat.category_name AS most_frequent_category,
    ccp.purchase_count
FROM 
    customer_category_purchases ccp
JOIN 
    customers c ON ccp.customer_id = c.customer_id
JOIN 
    categories cat ON ccp.category_id = cat.category_id
WHERE 
    ccp.rn = 1;

-- 10. Create a query to show the distribution of ratings (count of 1-star, 2-star, etc.) for each product.

SELECT 
    p.product_id,
    p.product_name,
    SUM(CASE WHEN pr.rating = 1 THEN 1 ELSE 0 END) AS one_star,
    SUM(CASE WHEN pr.rating = 2 THEN 1 ELSE 0 END) AS two_star,
    SUM(CASE WHEN pr.rating = 3 THEN 1 ELSE 0 END) AS three_star,
    SUM(CASE WHEN pr.rating = 4 THEN 1 ELSE 0 END) AS four_star,
    SUM(CASE WHEN pr.rating = 5 THEN 1 ELSE 0 END) AS five_star
FROM 
    products p
LEFT JOIN 
    product_reviews pr ON p.product_id = pr.product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    p.product_id;