drop database test_db_poc;
create database test_db_poc;

use test_db_poc;
create table if not exists large_table(
id int auto_increment primary key,
name varchar(50),
value INT
);

DELIMITER //
CREATE procedure INSERT_MILLION_RECORDS()
BEGIN
  declare i int default 0;
  while i <100000 do
      insert into large_table(name,value) values(concat('Name',i),floor(1 + RAND()*1000000));
      set i=i+1;
  end while;
END //

DELIMITER ;

SHOW procedure status WHERE DB ='test_db_poc';
select count(*) from large_table;
CALL INSERT_MILLION_RECORDS();

select sql_no_cache sum(value) from large_table ;
select  sum(value) from large_table ;

create index idx_value on large_table(value);
alter table large_table drop index idx_value;
select * from large_table;

select a.value
from large_table a
cross join large_table b 
on a.value=b.value*100;

SHOW VARIABLES LIKE 'innodb_page_size';
SHOW VARIABLES;




-- index


-- Create the Customers table
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Registration DATE
);

-- Populate Customers table
INSERT INTO Customers (Customer_ID, Name, Email, Registration)
VALUES 
(1, 'John Doe', 'john.doe@email.com', '2024-09-15'),
(2, 'Jane Smith', 'jane.smith@email.com', '2024-09-20'),
(3, 'Bob Johnson', 'bob.johnson@email.com', '2024-09-25'),
(4, 'Alice Brown', 'alice.brown@email.com', '2024-09-30'),
(5, 'Charlie Davis', 'charlie.davis@email.com', '2024-10-01'),
(6, 'Eva Wilson', 'eva.wilson@email.com', '2024-10-02'),
(7, 'Frank Miller', 'frank.miller@email.com', '2024-10-03'),
(8, 'Grace Lee', 'grace.lee@email.com', '2024-10-04'),
(9, 'Henry Taylor', 'henry.taylor@email.com', '2024-10-05'),
(10, 'Ivy Clark', 'ivy.clark@email.com', '2024-10-06');

-- Insert 90 more customers with registration dates spread over the last 60 days
INSERT INTO Customers (Customer_ID, Name, Email, Registration)
SELECT 
    10 + num,
    CONCAT('Customer', num),
    CONCAT('customer', num, '@email.com'),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 60) DAY)
FROM (
    SELECT a.N + b.N * 10 + 1 AS num
    FROM 
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
         SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
         SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    ORDER BY num
    LIMIT 90
) numbers;

-- Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    Customer_ID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

-- Populate Orders table
INSERT INTO Orders (OrderID, Customer_ID, OrderDate, TotalAmount)
VALUES 
(1, 1, '2024-09-16', 150.00),
(2, 2, '2024-09-21', 200.50),
(3, 3, '2024-09-26', 75.25),
(4, 4, '2024-10-01', 300.75),
(5, 5, '2024-10-02', 50.00),
(6, 6, '2024-10-03', 125.50),
(7, 7, '2024-10-04', 80.00),
(8, 8, '2024-10-05', 220.25),
(9, 9, '2024-10-06', 175.00),
(10, 10, '2024-10-07', 90.50);

-- Insert 190 more orders with random customers and dates
INSERT INTO Orders (OrderID, Customer_ID, OrderDate, TotalAmount)
SELECT 
    10 + num,
    1 + FLOOR(RAND() * 100),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY),
    ROUND(50 + RAND() * 450, 2)
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + 1 AS num
    FROM 
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
         SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
         SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
        (SELECT 0 AS N UNION SELECT 1) c
    ORDER BY num
    LIMIT 190
) numbers;

-- Create an index on the registration date
CREATE INDEX idx_customer_reg_Date ON Customers(Registration);

-- Update the registration date for a customer
UPDATE Customers SET Registration = '2024-10-20' WHERE Customer_ID = 1;

-- Set session join buffer size
SET SESSION join_buffer_size = 4194304;

-- Explain the query using the index
EXPLAIN SELECT o.OrderID, o.OrderDate, o.TotalAmount, c.Name
FROM Orders o
JOIN Customers c USE INDEX(idx_customer_reg_Date) ON o.Customer_ID = c.Customer_ID
WHERE c.Registration >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
