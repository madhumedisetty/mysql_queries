-- Create Tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    registration_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    stock_quantity INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME,
    total_amount DECIMAL(10, 2),
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


INSERT INTO customers (first_name, last_name, email, registration_date)
VALUES 
('John', 'Doe', 'john.doe@example.com', '2024-01-10'),
('Jane', 'Smith', 'jane.smith@example.com', '2024-02-15'),
('Alice', 'Johnson', 'alice.johnson@example.com', '2024-03-05'),
('Bob', 'Brown', 'bob.brown@example.com', '2024-04-12');

INSERT INTO products (product_name, category, price, stock_quantity)
VALUES 
('Laptop', 'Electronics', 999.99, 50),
('Smartphone', 'Electronics', 699.99, 120),
('Tablet', 'Electronics', 399.99, 75),
('Headphones', 'Accessories', 89.99, 200),
('Chair', 'Furniture', 149.99, 30);

INSERT INTO orders (customer_id, order_date, total_amount)
VALUES 
(1, '2024-08-01 10:30:00', 1699.98),
(2, '2024-08-02 12:45:00', 399.99),
(3, '2024-08-05 09:15:00', 699.99),
(4, '2024-08-10 11:10:00', 89.99);

INSERT INTO order_items (order_id, product_id, quantity, price_per_unit)
VALUES 
(1, 1, 1, 999.99),
(1, 2, 1, 699.99),
(2, 3, 1, 399.99),
(3, 2, 1, 699.99),
(4, 4, 1, 89.99);

INSERT INTO product_reviews (product_id, customer_id, rating, review_text, review_date)
VALUES 
(1, 1, 5, 'Excellent laptop with great performance.', '2024-08-05'),
(2, 1, 4, 'Smartphone works well but could have better battery life.', '2024-08-07'),
(3, 2, 5, 'Tablet is very smooth and responsive.', '2024-08-10'),
(4, 4, 4, 'Good quality headphones, comfortable to wear.', '2024-08-15');
