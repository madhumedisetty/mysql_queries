CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO employees VALUES
(1, 'John', 'Doe', 'IT', 75000, '2020-01-15'),
(2, 'Jane', 'Smith', 'HR', 65000, '2019-05-11'),
(3, 'Bob', 'Johnson', 'IT', 80000, '2018-03-23'),
(4, 'Alice', 'Williams', 'Finance', 72000, '2021-09-30'),
(5, 'Charlie', 'Brown', 'IT', 68000, '2022-02-14'),
(6, 'Eva', 'Davis', 'HR', 61000, '2020-11-18'),
(7, 'Frank', 'Miller', 'Finance', 79000, '2017-07-12'),
(8, 'Grace', 'Taylor', 'IT', 77000, '2019-04-22'),
(9, 'Henry', 'Anderson', 'Finance', 71000, '2021-01-05'),
(10, 'Ivy', 'Thomas', 'HR', 63000, '2022-06-30');

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE
);

INSERT INTO projects VALUES
(1, 'Database Migration', '2023-01-01', '2023-06-30'),
(2, 'New HR System', '2023-03-15', '2023-12-31'),
(3, 'Financial Reporting Tool', '2023-02-01', '2023-11-30'),
(4, 'IT Infrastructure Upgrade', '2023-05-01', '2024-04-30');

CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO employee_projects VALUES
(1, 1, 'Project Lead'),
(2, 2, 'Project Manager'),
(3, 1, 'Database Admin'),
(4, 3, 'Financial Analyst'),
(5, 4, 'Network Engineer'),
(6, 2, 'HR Specialist'),
(7, 3, 'Data Analyst'),
(8, 4, 'Systems Architect'),
(1, 4, 'Security Consultant'),
(3, 4, 'Software Developer');

-- Questions

-- 1. Write a query to find the top 3 highest paid employees in each department.


SELECT employee_id, first_name, last_name, department, salary, ranks
FROM (SELECT employee_id, first_name, last_name, department, salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS ranks
    FROM employees
) RankedSalaries
WHERE ranks <= 3;

-- 2. Calculate the running total of salaries in each department, ordered by hire date.

SELECT *,
       SUM(salary) OVER (PARTITION BY department ORDER BY hire_date) AS running_total
FROM employees;

-- 3. Find employees who are working on more than one project, along with the count of projects they're involved in.

select e.employee_id, e.first_name, e.department, count(ep.project_id) as no_of_projects
from employees e
inner join employee_projects ep on e.employee_id = ep.employee_id
group by e.employee_id
having count(ep.project_id)>1
order by no_of_projects desc;

-- 4. Identify projects that have team members from all departments.

SELECT p.project_id, p.project_name
FROM projects p
JOIN employee_projects ep ON p.project_id = ep.project_id
JOIN employees e ON ep.employee_id = e.employee_id
GROUP BY p.project_id, p.project_name
HAVING COUNT(DISTINCT e.department) = (SELECT COUNT(DISTINCT department) FROM employees);

-- 5. Calculate the average salary for each department, but only include employees hired in the last 3 years.

select department, avg(salary) as avg_salary
from employees
where hire_date > CURRENT_DATE - INTERVAL 3 YEAR
group by department
order by avg_salary desc;

-- 6. Create a pivot table showing the count of employees in each department, with columns for different salary ranges (e.g., <65000, 65000-75000, >75000).
select department,
COUNT(CASE WHEN salary<65000 THEN 1 END) as "<65000" , 
COUNT(CASE WHEN salary between 65000 and 75000 THEN 1 END) as "65000-75000" ,
COUNT(CASE WHEN salary>75000 THEN 1 END) as "<75000" 
from employees
group by department;

-- 7. Find the employee(s) with the highest salary in their respective departments, who are also working on the longest-running project.

WITH dept_max_salaries AS (
    SELECT 
        department,
        MAX(salary) as max_salary
    FROM 
        employees
    GROUP BY 
        department
),
longest_project AS (
    SELECT 
        project_id,
        end_date - start_date as duration
    FROM 
        projects
    ORDER BY 
        duration DESC
    LIMIT 1
)
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department,
    e.salary,
    p.project_name
FROM 
    employees e
JOIN 
    dept_max_salaries dms ON e.department = dms.department AND e.salary = dms.max_salary
JOIN 
    employee_projects ep ON e.employee_id = ep.employee_id
JOIN 
    projects p ON ep.project_id = p.project_id
JOIN 
    longest_project lp ON p.project_id = lp.project_id;


-- 8. Calculate the percentage of each department's salary compared to the total salary of the company.



-- 9. Identify employees who have a higher salary than their department's average, and show by what percentage their salary exceeds the average.

-- 10. Create a query that shows a hierarchical view of employees and their projects, with multiple levels of projects if an employee is in more than one.



-- Bonus Challenge:
-- 11. Implement a query to find the "Kevin Bacon Number" equivalent for projects. 
--     (i.e., for each pair of employees, find the shortest connection through shared projects)