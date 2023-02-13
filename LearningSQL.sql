/* 
inner joins, full/left/right outer joins 
*/

select * 
from EmployeeDemographics

select *
from EmployeeSalary 

select JobTitle, AVG(Salary)
from EmployeeDemographics
Inner Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Where JobTitle = 'Salesman'
Group BY JobTitle

/* Unions */

Select *
from EmployeeDemographics
/* add in Union here to combine employee demographics table with employee salary table*/
select *
from EmployeeSalary


/*Case Statements */
--Example #1
select FirstName, LastName, Age, 
Case
	When Age > 30 THEN 'Old'
	When Age Between 270 and 30 THEN 'Baby'
	Else 'Young'
END
From EmployeeDemographics
Where Age is NOT NULL 
Order  by Age

--Example #2
select FirstName, LastName, JobTitle, Salary,
Case	
	When JobTitle = 'Salesman' Then Salary + (Salary * .10)
	When JobTitle = 'Accountant' Then Salary + (Salary * .05)
	When JobTitle = 'HR' Then Salary + (Salary *.000001)
	Else Salary + (Salary + .03)
END AS SalaryAfterRaised
from EmployeeDemographics
Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--Having Clause 
--Example #1
select JobTitle, AVG(Salary)
from EmployeeDemographics
Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Group BY JobTitle
Having AVG(Salary) > 45000				
Order BY AVG(Salary)


--Updating/Deleting Data-- 
select *
From EmployeeDemographics

Update EmployeeDemographics
SET Age =31, Gender = 'Female'
Where FirstName = 'Holly' and LastName = 'Flax'

--How to Delete data
-- Delete FROM EmployeeDemographics
-- Where EmployeeID = 1003 

--Helpful hint for deleting, use the select statement to make sure your data is the one you want to delete

/* Aliasing */
/* doesn't require AS, could just use space in between for naming column*/
select AVG(AGE) AS AVGAge 					
from EmployeeDemographics

select Demo.EmployeeID, Sal.Salary
from EmployeeDemographics AS Demo 
Join EmployeeSalary AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID
--Use better names for new alias because single letters can lead to confusion on where columns come from which tables


/* Partition By */
select FirstName, LastName, Gender, Salary
, Count(Gender) OVER (Partition BY Gender) AS TotalGender
from EmployeeDemographics AS demo
Join EmployeeSalary AS Sal
	On demo.EmployeeID = Sal.EmployeeID
--Total Gender column represents how many total female/males work alongside the person


--Video 1: Common Table Expression (CTE)--

WITH CTE_Employee AS 
(Select FirstName, LastName, Gender, Salary
, Count(Gender) OVER (Partition by Gender) AS TotalGender
, AVG(Salary) OVER (Partition BY Gender) AS AvgSalary
From EmployeeDemographics AS EMP
Join EmployeeSalary AS SAL
	ON EMP.EmployeeID = SAL.EmployeeID
Where Salary > '45000')
Select FirstName, AvgSalary
From CTE_Employee


--Video 2: Temp Tables--
--Basic Syntax... First step below goes before everything else --
Create Table #temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int) 

Select *
from #temp_Employee

Insert INTO #temp_Employee Values (
'1001', 'HR', '45000') 

Insert into #temp_Employee
Select *
From EmployeeSalary


--More intermediate temp table--
--Add in Code "Drop Table if Exists _____" to make sure table can rerun every time need to refresh--
Create Table #temp_Employee2 (
JobTitle varchar(50),
EmployeePerJob int, 
AvgAge int,
AvgSalary int)

Insert into #temp_Employee2
Select JobTitle, Count(JobTitle), AVG(Age), AVG(Salary)
From EmployeeDemographics AS EMP
Join EmployeeSalary AS SAL
	ON EMP.EmployeeID = SAL.EmployeeID
Group BY JobTitle

Select *
From #temp_Employee2

--Video 3: String Functions + Use Cases
-- String Functions: TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower
Drop Table if Exists Employee_Errors
Create Table Employee_Errors (
EmployeeID varchar(50), 
FirstName varchar (50),
LastName varchar(50)
)

Insert into Employee_Errors Values
('1001', 'Jimbo', 'Halbert'),
(' 1002', 'Pamela', 'Beasely'),
('1005', 'TOby', 'Flenderson - Fired')

Select *
From Employee_Errors

--Using Trim, Ltrim, Rtrim
Select EmployeeID, Trim(EmployeeID) AS IDTRIM
From Employee_Errors

Select EmployeeID, LTrim(EmployeeID) AS IDTRIM
From Employee_Errors

Select EmployeeID, RTrim(EmployeeID) AS IDTRIM
From Employee_Errors

--Using Replace
Select LastName, Replace(LastName, '- Fired', '') AS LastNameFixed
From Employee_Errors

--Using Substring (Use Gender, Lastname, Age, DOB)
Select err.FirstName, dem.FirstName
From Employee_Errors as err
Join EmployeeDemographics as dem
	ON Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)



--Using Upper and Lower
Select FirstName, Lower(FirstName), LastName, Upper(LastName)
From Employee_Errors


--Video 4: Stored Procedures + Use Cases

CREATE PROCEDURE TEST
AS
Select *
From EmployeeDemographics

EXEC TEST

Drop Table if exists #temp_employee

CREATE PROCEDURE temp_Employee
AS
Create Table #temp_employee (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int, 
AvgSalary int) 

Insert into #temp_employee
Select JobTitle, Count(JobTitle), Avg(Age), Avg(Salary)
From EmployeeDemographics AS emp
Join EmployeeSalary AS sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle


--Video 5: Subqueries
select *
From EmployeeSalary
--Example #1: Subquery in Select
select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) AS AllAvgSalary
From EmployeeSalary

--Example #2: How to do it with Partition BY
select EmployeeID, Salary, AVG(Salary) over () AS AllAvgSalary
From EmployeeSalary
Group by EmployeeID, Salary
Order BY 1,2

--Example #3: Why Group By doesn't work ??
select EmployeeID, Salary, AVG(Salary) AS AllAvgSalary
From EmployeeSalary


--Example #4: Subquery in From




--Example #5: Subquery in Where
--Can only select one column from table instead of multiple
Select EmployeeID, JobTitle, Salary
From EmployeeSalary
Where EmployeeID in (
		Select EmployeeID
		From EmployeeDemographics
		Where Age > 30)