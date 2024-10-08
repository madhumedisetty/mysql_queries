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

WITH total_salary AS (
    SELECT SUM(salary) as company_total
    FROM employees
)
SELECT 
    department,
    SUM(salary) as dept_total,
    (SUM(salary) * 100.0 / (SELECT company_total FROM total_salary)) as percentage
FROM 
    employees
GROUP BY 
    department
ORDER BY 
    percentage DESC;

-- 9. Identify employees who have a higher salary than their department's average, and show by what percentage their salary exceeds the average.

WITH dept_avg_salaries AS (
    SELECT 
        department,
        AVG(salary) as avg_salary
    FROM 
        employees
    GROUP BY 
        department
)
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department,
    e.salary,
    das.avg_salary,
    ((e.salary - das.avg_salary) * 100.0 / das.avg_salary) as percent_above_avg
FROM 
    employees e
JOIN 
    dept_avg_salaries das ON e.department = das.department
WHERE 
    e.salary > das.avg_salary
ORDER BY 
    percent_above_avg DESC;


-- 10. Create a query that shows a hierarchical view of employees and their projects, with multiple levels of projects if an employee is in more than one.
WITH RECURSIVE employee_projects_hierarchy AS (
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        p.project_id,
        p.project_name,
        ep.role,
        1 AS level,
        CAST(p.project_name AS CHAR(1000)) AS project_path
    FROM 
        employees e
    JOIN 
        employee_projects ep ON e.employee_id = ep.employee_id
    JOIN 
        projects p ON ep.project_id = p.project_id
    UNION ALL
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        p.project_id,
        p.project_name,
        ep.role,
        eph.level + 1,
        CONCAT(eph.project_path, ' > ', p.project_name) AS project_path
    FROM 
        employees e
    JOIN 
        employee_projects ep ON e.employee_id = ep.employee_id
    JOIN 
        projects p ON ep.project_id = p.project_id
    JOIN 
        employee_projects_hierarchy eph ON e.employee_id = eph.employee_id
    WHERE 
        p.project_id > eph.project_id
)
SELECT 
    employee_id,
    first_name,
    last_name,
    project_id,
    project_name,
    role,
    level,
    project_path
FROM 
    employee_projects_hierarchy
ORDER BY 
    employee_id, level, project_id;

-- Explanation:
-- 1. We use a recursive CTE to build the hierarchy of projects for each employee.
-- 2. The base case of the recursion selects all employee-project combinations.
-- 3. The recursive part joins this with additional projects for the same employee.
-- 4. We build a project_path string to show the hierarchy of projects.
-- 5. The level column keeps track of how deep in the hierarchy each row is.
-- 6. The final SELECT orders the results to group projects by employee and level.

-- Bonus Challenge:
-- 11. Implement a query to find the "Kevin Bacon Number" equivalent for projects.
WITH RECURSIVE project_connections AS (
    -- Base case: direct connections
    SELECT 
        ep1.employee_id as employee1,
        ep2.employee_id as employee2,
        1 as connection_level
    FROM 
        employee_projects ep1
    JOIN 
        employee_projects ep2 ON ep1.project_id = ep2.project_id AND ep1.employee_id < ep2.employee_id
    
    UNION
    
    -- Recursive case: indirect connections
    SELECT 
        pc.employee1,
        ep.employee_id as employee2,
        pc.connection_level + 1
    FROM 
        project_connections pc
    JOIN 
        employee_projects ep ON pc.employee2 = ep.employee_id
    WHERE 
        pc.employee1 < ep.employee_id AND pc.connection_level < 6
)
SELECT 
    e1.first_name || ' ' || e1.last_name as employee1,
    e2.first_name || ' ' || e2.last_name as employee2,
    MIN(connection_level) as shortest_connection
FROM 
    project_connections pc
JOIN 
    employees e1 ON pc.employee1 = e1.employee_id
JOIN 
    employees e2 ON pc.employee2 = e2.employee_id
GROUP BY 
    e1.employee_id, e1.first_name, e1.last_name,
    e2.employee_id, e2.first_name, e2.last_name
ORDER BY 
    e1.last_name, e1.first_name, shortest_connection