create database retail;
use retail;

CREATE TABLE employee_sales (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    sales_amount DECIMAL(10, 2),
    sales_date DATE
);

INSERT INTO employee_sales (employee_id, employee_name, department, sales_amount, sales_date) VALUES
(1, 'John Doe', 'Electronics', 1500.00, '2023-01-15'),
(2, 'Jane Smith', 'Clothing', 2000.00, '2023-01-16'),
(3, 'Mike Johnson', 'Electronics', 1800.00, '2023-01-17'),
(4, 'Emily Brown', 'Home Goods', 1200.00, '2023-01-18'),
(5, 'David Lee', 'Clothing', 2200.00, '2023-01-19'),
(6, 'Sarah Wilson', 'Electronics', 1600.00, '2023-01-20'),
(7, 'Tom Harris', 'Home Goods', 1300.00, '2023-01-21'),
(8, 'Lisa Chen', 'Clothing', 1900.00, '2023-01-22');

-- Calculate the total sales, average sales, and number of employees for each department.
-- Rank the departments based on their total sales.
-- Display this information in a single result set, ordered by total sales descending.

with deptAvgsales as(
 select department,
        sum(sales_amount) as tot_sales, 
		count(employee_id) as no_of_employees,
        round(sum(sales_amount)/count(distinct sales_date), 2) as avg_daily_sales
 from employee_sales
 group by department
)
select department, tot_sales, no_of_employees, avg_daily_sales ,
     rank() over (order by tot_sales DESC) as ranking
from deptAvgsales;
