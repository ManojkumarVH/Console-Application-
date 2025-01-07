CREATE DATABASE task1;
USE task1;

CREATE TABLE Departments (DepartmentID INT PRIMARY KEY,DepartmentName VARCHAR(100));

CREATE TABLE Employees (EmployeeID INT PRIMARY KEY,Name VARCHAR(100),DepartmentID INT,HireDate DATE,
FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID));

CREATE TABLE Salaries (EmployeeID INT PRIMARY KEY,BaseSalary DECIMAL(10, 2),Bonus DECIMAL(10, 2),
    Deductions DECIMAL(10, 2),FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID));

SELECT 
    Employees.EmployeeID,
    Employees.Name,
    Departments.DepartmentName
FROM 
    Employees
INNER JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID;


SELECT 
    Employees.EmployeeID,
    Employees.Name,
    Salaries.BaseSalary,
    Salaries.Bonus,
    Salaries.Deductions,
    (Salaries.BaseSalary + Salaries.Bonus - Salaries.Deductions) AS NetSalary
FROM 
    Employees
INNER JOIN 
    Salaries ON Employees.EmployeeID = Salaries.EmployeeID;


SELECT TOP 1
    Departments.DepartmentName,
    AVG(Salaries.BaseSalary + Salaries.Bonus - Salaries.Deductions) AS AverageSalary
FROM 
    Employees
INNER JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID
INNER JOIN 
    Salaries ON Employees.EmployeeID = Salaries.EmployeeID
GROUP BY 
    Departments.DepartmentName
ORDER BY 
    AverageSalary DESC;



CREATE PROCEDURE AddEmployee
    @Name NVARCHAR(100),
    @DepartmentID INT,
    @HireDate DATE,
    @BaseSalary DECIMAL(10, 2),
    @Bonus DECIMAL(10, 2),
    @Deductions DECIMAL(10, 2)
AS
BEGIN
    DECLARE @NewEmployeeID INT;

    -- Insert into Employees table
    INSERT INTO Employees (Name, DepartmentID, HireDate)
    VALUES (@Name, @DepartmentID, @HireDate);

    SET @NewEmployeeID = SCOPE_IDENTITY();

    -- Insert into Salaries table
    INSERT INTO Salaries (EmployeeID, BaseSalary, Bonus, Deductions)
    VALUES (@NewEmployeeID, @BaseSalary, @Bonus, @Deductions);
END;


CREATE PROCEDURE UpdateSalary
    @EmployeeID INT,
    @NewBaseSalary DECIMAL(10, 2),
    @NewBonus DECIMAL(10, 2),
    @NewDeductions DECIMAL(10, 2)
AS
BEGIN
    UPDATE Salaries
    SET 
        BaseSalary = @NewBaseSalary,
        Bonus = @NewBonus,
        Deductions = @NewDeductions
    WHERE 
        EmployeeID = @EmployeeID;
END;


CREATE PROCEDURE CalculatePayroll
AS
BEGIN
    SELECT 
        SUM(BaseSalary + Bonus - Deductions) AS TotalPayroll
    FROM 
        Salaries;
END;


CREATE VIEW EmployeeSalaryView AS
SELECT 
    Employees.EmployeeID,
    Employees.Name,
    Departments.DepartmentName,
    Salaries.BaseSalary,
    Salaries.Bonus,
    Salaries.Deductions,
    (Salaries.BaseSalary + Salaries.Bonus - Salaries.Deductions) AS NetSalary
FROM 
    Employees
INNER JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID
INNER JOIN 
    Salaries ON Employees.EmployeeID = Salaries.EmployeeID;


CREATE VIEW HighEarnerView AS
SELECT 
    Employees.EmployeeID,
    Employees.Name,
    (Salaries.BaseSalary + Salaries.Bonus - Salaries.Deductions) AS NetSalary
FROM 
    Employees
INNER JOIN 
    Salaries ON Employees.EmployeeID = Salaries.EmployeeID
WHERE 
    (Salaries.BaseSalary + Salaries.Bonus - Salaries.Deductions) > 5000; -- Adjust threshold as needed

