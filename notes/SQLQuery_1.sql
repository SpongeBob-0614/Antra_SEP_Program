USE Northwind
GO

--SELECT statement: identify which columns we want to retrieve
--1. SELECT all columns and rows

SELECT *
FROM Employees

--2. SELECT a list of columns

SELECT EmployeeId, FirstName, LastName, City, Country
FROM Employees

SELECT e.EmployeeId, e.FirstName, e.LastName, e.City, e.Country
FROM Employees AS e

--avoid using SELECT *
--1. unnecessary data
--2. Naming conflicts

SELECT *
FROM Employees

SELECT *
FROM Customers

SELECT *
FROM Employees e JOIN Orders o ON e.EmployeeId = o.EmployeeId JOIN Customers c ON o.CustomerId = c.CustomerId

--3. SELECT DISTINCT Value: 
--list all the cities that employees are located at

SELECT DISTINCT City
From Employees

--4. SELECT combined with plain text: retrieve the full name of employees

SELECT FirstName + ' ' + LastName AS FullName
FROM Employees 

--identifiers: are names given to the db, tables, sp, views, functions and so on. 
--1.Regular Identifier: i) first charcter: lowercase A-z, uppercase A-z, @, #
                       -- @: defining or declaring a variable. 
                       DECLARE @today DATETIME
                       SELECT @today = GETDATE()
                       PRINT @today

                       --#: temp tables
                        --#: local temp table
                        --##: global temp table 

                      --ii) Subsequent character: a-z, A-Z, 0-9, @, #, $
                      --iii) must not be a sql reserve word
                      --iv) embedded space is not allowed 

--2. Delimited Identifier: [] or " "

SELECT FirstName + ' ' + LastName AS [Full Name]
FROM Employees 

--WHERE statement: filter the records row by row 
--1. equal =
--Customers who are from Germany

SELECT CustomerId, ContactName, Country
FROM Customers
WHERE Country = 'Germany'

SELECT CustomerId, ContactName, Country
FROM Customers
WHERE Country != 'Germany'



--Product which price is $18

SELECT ProductId, ProductName, UnitPrice
FROM Products
WHERE UnitPrice = 18

--2. Customers who are not from UK

SELECT CustomerId, ContactName, Country
FROM Customers
WHERE Country <> 'UK'

--IN Operator: retrieve a data among a list of values
--E.g: Orders that ship to USA AND Canada

SELECT OrderID, CustomerId, ShipCountry
FROM Orders 
WHERE ShipCountry = 'USA' OR ShipCountry = 'Canada'

SELECT OrderID, CustomerId, ShipCountry
FROM Orders 
WHERE ShipCountry IN ('USA', 'Canada')

--BETWEEN Operator: retrive a data in a consecutive range
--1. retreive products whose price is between 20 and 30.

SELECT ProductId, ProductName, UnitPrice
FROM Products
WHERE UnitPrice>=20 AND UnitPrice<=30

SELECT ProductId, ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 20 AND 30

--NOT Operator: display a record if a condition is not true
-- list orders that does not ship to USA or Canada

SELECT OrderID, CustomerId, ShipCountry
FROM Orders 
WHERE NOT ShipCountry  IN ('USA', 'Canada')

SELECT ProductId, ProductName, UnitPrice
FROM Products
WHERE UnitPrice NOT BETWEEN 20 AND 30

--NULL Value: 
--check which employees' region information is empty

SELECT FirstName + ' ' + LastName AS [Employee Name], Region
FROM Employees
WHERE Region IS NULL

--exclude the employees whose region is null

SELECT FirstName + ' ' + LastName AS [Employee Name], Region
FROM Employees
WHERE Region IS NOT NULL

--Null in numerical operation

SELECT  *
From TestSalary

SELECT EId, Salary, Comm, Salary + Comm AS TotalCompensation
FROM TestSalary 

SELECT EId, Salary, Comm, IsNull(Salary, 0) + IsNull(Comm, 0) AS TotalCompensation
FROM TestSalary 

--LIKE Operator: used to create a search expressions

--1. Work with % wildcard character: 

--retrieve all the employees whose last name starts with D

SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE 'D%'

--2. Work with [] and % to search in ranges: 

--find customers whose postal code starts with number between 0 and 3

SELECT ContactName, PostalCode
FROM Customers 
WHERE PostalCode LIKE '[0-3]%'

--3. Work with NOT: 

SELECT ContactName, PostalCode
FROM Customers 
WHERE PostalCode NOT LIKE '[0-3]%'

--4. Work with ^: 

SELECT ContactName, PostalCode
FROM Customers 
WHERE PostalCode LIKE '[^0-3]%'

--Customer name starting from letter A but not followed by l-n

SELECT ContactName, PostalCode
FROM Customers 
WHERE ContactName LIKE 'A[^l-n]%'

--ORDER BY statement: is used to sort the resut set ascendingly or descendingly

--1. retrieve all customers except those in Boston and sort by Name

SELECT ContactName,  City
FROM Customers 
WHERE City != 'Boston'
ORDER BY ContactName

--2. retrieve product name and unit price, and sort by unit price in descending order

SELECT ProductId, ProductName, UnitPrice
FROM Products
Order BY UnitPrice DESC

--3. Order by multiple columns

SELECT ProductId, ProductName, UnitPrice
FROM Products
Order BY UnitPrice DESC, ProductName DESC

SELECT ProductId, ProductName, UnitPrice
FROM Products
Order BY 3 DESC, 2 DESC


--JOIN: used to combine rows from two or more tables based on the related column between them. 

--1. INNER JOIN: return the records that has matching value in both tables

--find employees who have deal with any orders

SELECT e.EmployeeId, e.FirstName + ' ' + e.LastName AS FullName, o.OrderDate
FROM Employees AS e INNER JOIN Orders AS o ON e.EmployeeID = o.EmployeeID

--get cusotmers information and corresponding order date

SELECT c.CustomerId, c.ContactName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID= o.CustomerID


--join multiple tables:
--get customer name, the corresponding employee who is responsible for this order, and the order date

SELECT e.EmployeeId, e.FirstName + ' ' + e.LastName AS FullName, o.OrderDate, c.ContactName
FROM Employees AS e INNER JOIN Orders AS o ON e.EmployeeID = o.EmployeeID JOIN Customers c ON c.CustomerId = o.CustomerID  

--add detailed information about quantity and price, join Order details

SELECT e.EmployeeId, e.FirstName + ' ' + e.LastName AS FullName, o.OrderDate, c.ContactName, od.UnitPrice, od.Quantity
FROM Employees AS e INNER JOIN Orders AS o ON e.EmployeeID = o.EmployeeID JOIN Customers c ON c.CustomerId = o.CustomerID JOIN [Order Details] od ON o.OrderId = od.OrderId


--2. OUTER JOIN: 

--1) LEFT OUTER JOIN: return all the records from the left table and matching records form the right table and if we can not find any
--matching records, then it will reutn null. 

--list all customers whether they have made any purchase or not

SELECT c.ContactName, o.OrderID
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerId
Order by O.OrderId Desc

--JOIN with WHERE: 
--customers who never placed any order

SELECT c.ContactName, o.OrderID
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerId
WHERE o.OrderId is NULL
Order by O.OrderId Desc

--2) RIGHT OUTER JOIN: return all the records from the right table and matching records form the left table and if we can not find any
--matching records, then it will reutrn null. 

--list all customers whether they have made any purchase or not

SELECT c.ContactName, o.OrderID
FROM Orders o RIGHT JOIN Customers c  ON c.CustomerID = o.CustomerId
Order by O.OrderId Desc

--3) FULL OUTER JOIN: 

--Match all customers and suppliers by country.

SELECT c.ContactName As Customer, c.Country as CustomerCountry, s.Country As SupplierCountry, s.ContactName as Supplier
FROM Customers c FULL JOIN Suppliers s ON c.Country = s.Country
Order by CustomerCountry, SupplierCountry

--3. CROSS JOIN: cartesian product of two tables 

Select *
From Customers

Select *
From Orders

SELECT *
FROM Customers CROSS JOIN Orders


--* SELF JOIN：joins a table with itself


--find emloyees with the their manager name

Select employeeid, firstname, lastname, reportsto
From Employees

--CEO: Andrew
--Managers: Nancy, Janet, Margaret, Steven, Laura
--Employees: Michael, Robert, Anne

SELECT e.FirstName+ ' ' + e.Lastname as Employee, m.FirstName+ ' ' + m.LastName AS manager
FROM Employees e join Employees m ON e.ReportsTo = m.EmployeeId

SELECT e.FirstName+ ' ' + e.Lastname as Employee, m.FirstName+ ' ' + m.LastName AS manager
FROM Employees e Left join Employees m ON e.ReportsTo = m.EmployeeId

--Batch Directives

USE Northwind
GO --> batch directive 


CREATE DATABASE JunBatch
GO
USE JunBatch
GO
CREATE TABLE Employee(Id INT, EName varchar(20), Salary money)