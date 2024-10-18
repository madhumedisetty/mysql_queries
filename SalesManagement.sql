create database SalesManagementDB;
use SalesManagementDB;

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    RegistrationDate DATE,
    Segment VARCHAR(20)
);

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Sales Table
CREATE TABLE Sales (
    SaleDate DATE,
    Amount DECIMAL(10, 2)
);

-- Insert data into Customers
INSERT INTO Customers (CustomerID, Name, Email, RegistrationDate, Segment)
VALUES 
(1, 'John Doe', 'john@example.com', '2022-01-15', 'Regular'),
(2, 'Jane Smith', 'jane@example.com', '2022-02-20', 'Premium'),
(3, 'Bob Johnson', 'bob@example.com', '2022-03-10', 'Regular'),
(4, 'Alice Brown', 'alice@example.com', '2022-04-05', 'Premium'),
(5, 'Charlie Davis', 'charlie@example.com', '2022-05-01', 'Regular');

-- Insert data into Products
INSERT INTO Products (ProductID, Name, Category, Price)
VALUES 
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 599.99),
(3, 'T-shirt', 'Clothing', 19.99),
(4, 'Jeans', 'Clothing', 49.99),
(5, 'Book', 'Books', 14.99);

-- Insert data into Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES 
(1, 1, '2023-01-10', 1019.98),
(2, 2, '2023-02-15', 649.98),
(3, 3, '2023-03-20', 34.98),
(4, 4, '2023-04-25', 1049.98),
(5, 5, '2023-05-30', 64.98),
(6, 1, '2023-06-05', 614.98),
(7, 2, '2023-07-10', 1014.98),
(8, 3, '2023-08-15', 599.99),
(9, 4, '2023-09-20', 69.98),
(10, 5, '2023-10-25', 999.99);

-- Insert data into OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES 
(1, 1, 1), (1, 3, 1),
(2, 2, 1), (2, 4, 1),
(3, 3, 1), (3, 5, 1),
(4, 1, 1), (4, 4, 1),
(5, 3, 1), (5, 5, 1),
(6, 2, 1), (6, 3, 1),
(7, 1, 1), (7, 5, 1),
(8, 2, 1),
(9, 3, 1), (9, 4, 1),
(10, 1, 1);

-- Insert data into Sales
INSERT INTO Sales (SaleDate, Amount)
VALUES
('2023-01-01', 100),
('2023-01-02', 150),
('2023-01-03', 200),
('2023-01-04', 120),
('2023-01-05', 180);

-- Top 5 Customers by Total Spending
SELECT 
    C.CustomerID, 
    C.Name, 
    SUM(O.TotalAmount) AS TotalSpent
FROM 
    Customers C
JOIN 
    Orders O ON C.CustomerID = O.CustomerID
GROUP BY 
    C.CustomerID, C.Name
ORDER BY 
    TotalSpent DESC
LIMIT 5;


-- Monthly Sales Trend for the Past 6 Months
SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
    SUM(TotalAmount) AS TotalSales
FROM 
    Orders
WHERE 
    OrderDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    Month
ORDER BY 
    Month;


-- Best-Selling Product Category in Each Month
WITH MonthlyCategorySales AS (
    SELECT 
        DATE_FORMAT(O.OrderDate, '%Y-%m') AS Month, 
        P.Category, 
        SUM(OD.Quantity) AS TotalQuantity
    FROM 
        Orders O
    JOIN 
        OrderDetails OD ON O.OrderID = OD.OrderID
    JOIN 
        Products P ON OD.ProductID = P.ProductID
    GROUP BY 
        Month, P.Category
)
SELECT 
    Month, 
    Category, 
    TotalQuantity
FROM 
    MonthlyCategorySales M
WHERE 
    TotalQuantity = (
        SELECT MAX(TotalQuantity)
        FROM MonthlyCategorySales M2
        WHERE M.Month = M2.Month
    );

--  Customers Who Haven't Made a Purchase in the Last 3 Months
SELECT 
    C.CustomerID, 
    C.Name, 
    C.Email
FROM 
    Customers C
LEFT JOIN 
    Orders O ON C.CustomerID = O.CustomerID
WHERE 
    O.OrderDate < DATE_SUB(CURDATE(), INTERVAL 3 MONTH) 
    OR O.OrderDate IS NULL;

-- Average Order Value and Number of Orders for Each Customer Segment
SELECT 
    C.Segment, 
    COUNT(O.OrderID) AS NumberOfOrders, 
    AVG(O.TotalAmount) AS AverageOrderValue
FROM 
    Customers C
LEFT JOIN 
    Orders O ON C.CustomerID = O.CustomerID
GROUP BY 
    C.Segment;