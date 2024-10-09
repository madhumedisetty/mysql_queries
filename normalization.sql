CREATE TABLE BookOrders (
    OrderID INT,
    CustomerName VARCHAR(100),
    CustomerEmail VARCHAR(100),
    BookTitle VARCHAR(200),
    Author VARCHAR(100),
    Price DECIMAL(10, 2),
    OrderDate DATE,
    ShippingAddress VARCHAR(200)
);

-- Inserting sample data into the unnormalized BookOrders table
INSERT INTO BookOrders (OrderID, CustomerName, CustomerEmail, BookTitle, Author, Price, OrderDate, ShippingAddress) VALUES
(1, 'Alice Smith', 'alice@example.com', 'The Great Gatsby', 'F. Scott Fitzgerald', 10.99, '2024-10-01', '123 Elm St, Cityville'),
(1, 'Alice Smith', 'alice@example.com', 'To Kill a Mockingbird', 'Harper Lee', 7.99, '2024-10-01', '123 Elm St, Cityville'),
(2, 'Bob Johnson', 'bob@example.com', '1984', 'George Orwell', 8.99, '2024-10-02', '456 Maple Ave, Townsville'),
(3, 'Charlie Brown', 'charlie@example.com', 'Moby Dick', 'Herman Melville', 12.50, '2024-10-03', '789 Oak Rd, Villageburg');



-- 1NF
-- Split into two tables: Orders and OrderDetails to eliminate repeating groups.

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerEmail VARCHAR(100),
    OrderDate DATE,
    ShippingAddress VARCHAR(200)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    BookTitle VARCHAR(200),
    Author VARCHAR(100),
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Inserting data into Orders table
INSERT INTO Orders (OrderID, CustomerName, CustomerEmail, OrderDate, ShippingAddress) VALUES
(1, 'Alice Smith', 'alice@example.com', '2024-10-01', '123 Elm St, Cityville'),
(2, 'Bob Johnson', 'bob@example.com', '2024-10-02', '456 Maple Ave, Townsville'),
(3, 'Charlie Brown', 'charlie@example.com', '2024-10-03', '789 Oak Rd, Villageburg');

-- Inserting data into OrderDetails table
INSERT INTO OrderDetails (OrderID, BookTitle, Author, Price) VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 10.99),
(1, 'To Kill a Mockingbird', 'Harper Lee', 7.99),
(2, '1984', 'George Orwell', 8.99),
(3, 'Moby Dick', 'Herman Melville', 12.50);



-- 2NF
-- Created a Books table to eliminate partial dependencies in OrderDetails.

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    BookTitle VARCHAR(200),
    Author VARCHAR(100),
    Price DECIMAL(10, 2)
);

-- Inserting data into Books table
INSERT INTO Books (BookTitle, Author, Price) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 10.99),
('To Kill a Mockingbird', 'Harper Lee', 7.99),
('1984', 'George Orwell', 8.99),
('Moby Dick', 'Herman Melville', 12.50);

-- Update OrderDetails to reference BookID
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    BookID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Inserting data into OrderDetails table with BookID
INSERT INTO OrderDetails (OrderID, BookID, Quantity) VALUES
(1, 1, 1),  -- 'The Great Gatsby'
(1, 2, 1),  -- 'To Kill a Mockingbird'
(2, 3, 1),  -- '1984'
(3, 4, 1);  -- 'Moby Dick'



-- Third Normal Form (3NF)
-- Created a Customers table to eliminate transitive dependencies in the Orders table.

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    CustomerEmail VARCHAR(100)
);

-- Inserting data into Customers table
INSERT INTO Customers (CustomerName, CustomerEmail) VALUES
('Alice Smith', 'alice@example.com'),
('Bob Johnson', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com');

-- Update Orders to reference CustomerID
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    ShippingAddress VARCHAR(200),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Inserting data into Orders table with CustomerID
INSERT INTO Orders (OrderID, CustomerID, OrderDate, ShippingAddress) VALUES
(1, 1, '2024-10-01', '123 Elm St, Cityville'),
(2, 2, '2024-10-02', '456 Maple Ave, Townsville'),
(3, 3, '2024-10-03', '789 Oak Rd, Villageburg');
