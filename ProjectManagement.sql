
show databases;
create database ProjectManagementDB;
use ProjectManagementDB;


-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    DepartmentID INT,
    StartDate DATE,
    EndDate DATE,
    EmployeeID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- Insert data into Departments Table
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

-- Insert data into Employees Table
INSERT INTO Employees (EmployeeID, EmployeeName, DepartmentID) VALUES
(1, 'Alice', 1),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2),
(5, 'Eve', 2),
(6, 'Frank', 3);

-- Insert data into Projects Table
INSERT INTO Projects (ProjectID, ProjectName, DepartmentID, StartDate, EndDate, EmployeeID) VALUES
(1, 'Website Redesign', 1, '2024-01-01', '2024-01-20', 1),
(2, 'Backend Optimization', 1, '2024-01-05', '2024-01-15', 1),
(3, 'Mobile App Launch', 1, '2024-02-01', '2024-02-25', 2),
(4, 'Cloud Migration', 1, '2024-03-01', '2024-03-20', 3),
(5, 'Employee Training', 2, '2024-01-10', '2024-01-20', 4),
(6, 'Recruitment Campaign', 2, '2024-02-01', '2024-02-18', 5),
(7, 'Payroll System Update', 3, '2024-01-15', '2024-01-30', 6),
(8, 'Tax Filing', 3, '2024-02-10', '2024-02-28', 6);


-- Rank employees by the number of projects they completed in each department

with EmployeeProjectCount as(
   select e.EmployeeID, e.EmployeeName, e.DepartmentID,
   count(p.ProjectID) as CompletedProjects
   from Employees e
   left join Projects p on e.EmployeeID=p.EmployeeID
   group by e.EmployeeID, e.DepartmentID
)
select DepartmentID, EmployeeID, EmployeeName, CompletedProjects,
      rank() over(partition by DepartmentID order by CompletedProjects DESC) as RankInDept
from EmployeeProjectCount;


-- Calculate the average project duration for each department
with ProjectDurations as(
   select DepartmentID, DATEDIFF(EndDate, StartDate) as Duration
   from Projects
)
select DepartmentID, avg(Duration) as AvgProjectDuration
from ProjectDurations
group by DepartmentID;
       

-- Identify projects that took longer than the department's average
with ProjectDurations as(
    select ProjectID, ProjectName, DepartmentID, DATEDIFF(EndDate, StartDate) as Duration
   from Projects
),
AvgDepartmentDurations AS (
    SELECT 
        DepartmentID,
        AVG(Duration) AS AvgProjectDuration
    FROM ProjectDurations
    GROUP BY DepartmentID
)
select pd.ProjectID, pd.ProjectName, pd.DepartmentID, pd.Duration,
       ad.AvgProjectDuration
from ProjectDurations pd
join AvgDepartmentDurations ad 
on pd.DepartmentID = ad.DepartmentID 
where pd.Duration > ad.AvgProjectDuration;

-- Find the top 3 most efficient employees in each department
WITH EmployeeEfficiency AS (
    SELECT 
        E.EmployeeID,
        E.EmployeeName,
        E.DepartmentID,
        AVG(DATEDIFF(P.EndDate, P.StartDate)) AS AvgProjectDuration
    FROM Employees E
    JOIN Projects P ON E.EmployeeID = P.EmployeeID
    GROUP BY E.EmployeeID, E.EmployeeName, E.DepartmentID
)
SELECT 
    DepartmentID,
    EmployeeID,
    EmployeeName,
    AvgProjectDuration,
    ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY AvgProjectDuration ASC) AS EfficiencyRank
FROM EmployeeEfficiency;


-- Compare each project's duration with the previous project in the same department
WITH ProjectDurations AS (
    SELECT 
        ProjectID,
        ProjectName,
        DepartmentID,
        DATEDIFF(EndDate, StartDate) AS Duration,
        LAG(DATEDIFF(EndDate, StartDate)) OVER (PARTITION BY DepartmentID ORDER BY StartDate) AS PreviousProjectDuration
    FROM Projects
)
SELECT 
    ProjectID,
    ProjectName,
    DepartmentID,
    Duration,
    PreviousProjectDuration,
    CASE 
        WHEN PreviousProjectDuration IS NULL THEN 'No previous project'
        WHEN Duration > PreviousProjectDuration THEN 'Longer than previous'
        WHEN Duration < PreviousProjectDuration THEN 'Shorter than previous'
        ELSE 'Same as previous'
    END AS ComparisonWithPrevious
FROM ProjectDurations;