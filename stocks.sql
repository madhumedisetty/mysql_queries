create database stocks;
use stocks;
-- Create a sample table for stock prices
CREATE TABLE stock_prices (
    date DATE,
    stock_symbol VARCHAR(10),
    closing_price DECIMAL(10, 2)
);

-- Insert sample data
INSERT INTO stock_prices (date, stock_symbol, closing_price) VALUES
('2023-01-01', 'AAPL', 150.00),
('2023-01-02', 'AAPL', 152.50),
('2023-01-03', 'AAPL', 151.75),
('2023-01-04', 'AAPL', 153.00),
('2023-01-05', 'AAPL', 155.25),
('2023-01-01', 'GOOGL', 2800.00),
('2023-01-02', 'GOOGL', 2825.00),
('2023-01-03', 'GOOGL', 2815.50),
('2023-01-04', 'GOOGL', 2830.00),
('2023-01-05', 'GOOGL', 2850.75);

-- Example 1: Using LEAD to get the next day's price