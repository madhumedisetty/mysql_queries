
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);
INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 699.99),
(3, 'Desk Chair', 'Furniture', 199.99);
(4, 'Coffee Maker', 'Appliances', 79.99);
(5, 'Smart Watch', 'Electronics', 249.99);

CREATE TABLE product_recommendations (
    product_id INT,
    recommended_product_id INT,
    strength DECIMAL(3, 2),
    PRIMARY KEY (product_id, recommended_product_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (recommended_product_id) REFERENCES products(product_id)
);
select * from product_recommendations;
INSERT INTO product_recommendations (product_id, recommended_product_id, strength) VALUES
(1, 2, 0.8),
(1, 3, 0.6),
(1, 4, 0.7),
(2, 1, 0.8),
(2, 3, 0.9),
(2, 5, 0.7),
(3, 1, 0.6),
(3, 2, 0.9),
(3, 4, 0.5);

-- print all the recommended products of laptop with strength
select p1.product_name,
p2.product_name,
pr.strength
from product_recommendations pr
join products p1 on p1.product_id = pr.product_id
join products p2 on pr.recommended_product_id = p2.product_id
where p1.product_id =1
order by pr.strength desc;