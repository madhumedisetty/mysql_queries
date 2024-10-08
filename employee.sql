CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id VARCHAR(10),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, department_id) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '515.123.4567', '2019-06-17', 'AD_PRES', 24000.00, 10),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '515.123.4568', '2020-02-20', 'AD_VP', 17000.00, 10),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '515.123.4569', '2020-08-11', 'MK_MAN', 9000.00, 20),
(4, 'Bob', 'Brown', 'bob.brown@example.com', '515.123.4560', '2021-03-05', 'HR_REP', 6000.00, 40),
(5, 'Charlie', 'Davis', 'charlie.davis@example.com', '515.123.4561', '2021-11-30', 'SH_CLERK', 3000.00, 50);

-- selecting dets of employee who has more than avg salary of his dept. 
select first_name,last_name, salary
from employees e
where salary > 
(select avg(salary) from employees e2 
where e.department_id= e2.department_id);

-- selecting dets of employee and avg salary of his dept, who has more than avg salary of all the employees. 
select 
d.department_name,
e.first_name,
e.last_name,
e.salary,
(select avg(salary) from employees where department_id = e.department_id) as dept_avg_salary
from 
employees e
inner join
departments d
on e.department_id =d.department_id
where e.salary > (select avg(salary) from employees where department_id=e.department_id)
order by d.department_name , e.salary desc;

-- pairs of employees who share the same job and ensures that each pair appears only once
SELECT 
    e1.first_name AS employee1_first_name,
    e1.last_name AS employee1_last_name,
    e2.first_name AS employee2_first_name,
    e2.last_name AS employee2_last_name,
    e1.job_id                
FROM 
    employees e1                         
INNER JOIN 
    employees e2                 
ON 
    e1.job_id = e2.job_id                   
    AND e1.employee_id < e2.employee_id;    

select * from order_details;
-- retrieves the department names, employee details (first name, last name, and salary), 

-- the average salary per department, and the rank of each employee's salary within their department
SELECT 
    d.department_name,    
    e.first_name,                                   
    e.last_name,    
    e.salary,                                         
    AVG(e.salary) OVER (PARTITION BY d.department_id) AS dept_avg_salary, 
    e.salary-AVG(e.salary) OVER (PARTITION BY d.department_id) AS salary_difference,
    RANK() OVER (PARTITION BY d.department_id ORDER BY e.salary DESC) AS salary_rank
                                                   
FROM 
    departments d                         
LEFT OUTER JOIN 
    employees e                                      
ON 
    d.department_id = e.department_id                
ORDER BY 
    d.department_name,                                
    e.salary DESC;          
    