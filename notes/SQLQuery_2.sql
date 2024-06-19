--SELECT: RETRIEVE
--WHERE: filter
--ORDER BY: sort
--JOIN: work on multiple tables in one query

--Aggregation functions: perform a calculation on a set of values that will return a single aggregated result.
--1. COUNT(): returns the number of rows

SELECT COUNT(orderId) AS TotalNumofRows
FROM Orders

--COUNT(*) vs. COUNT(colName):  Count * will include all values including null values but count column name will remove null values 
 
SELECT COUNT(*) AS TotalNumofRows
FROM Orders

SELECT FirstName, Region
FROM Employees 

SELECT Count(Region), Count(*), Count(13)
FROM Employees


-- GROUP BY: group rows that have same values into summary rows

--find total number of orders placed by each customers

SELECT c.ContactName, c.CustomerId, c.City, c.Country, COUNT(o.OrderId) AS NumofOrders
FROM Orders o JOIN Customers c ON o.CustomerId = c.CustomerId
GROUP BY c.ContactName, c.CustomerId, c.City, c.Country
ORDER BY NumofOrders DESC

--a more complex template: 
--only retreive total order numbers where customers located in USA or Canada, and order number should be greater than or equal to 10

SELECT c.ContactName, c.CustomerId, c.City, c.Country, COUNT(o.OrderId) AS NumofOrders
FROM Orders o JOIN Customers c ON o.CustomerId = c.CustomerId
WHERE c.Country IN ('USA', 'Canada')
GROUP BY c.ContactName, c.CustomerId, c.City, c.Country
HAVING COUNT(o.OrderId) >=10
ORDER BY NumofOrders DESC

--WHERE vs. HAVING
--1. Both will  be used to filter the record. But having will only apply to group as a whole but Where is applied to individual rows.
--2. Where goes before aggregation, but having goes after agggregation 
-- 3. Where can be used with select, update or delete but having can only be used in select statement

--SQL execution order

---SELECT fileds, aggregate(fields)
--FROM table JOIN table2 ON...
--WHERE criteri --- optional
--GROUP BY fields --- use when we have both aggregated and non aggregated fields
--HAVING criteria --optional
--ORDER BY by fields DESC -- optional  

---FROM/JOIN ----> WHERE ----> GROUP BY ---> HAVING ---> SELECT---> DISTINCT---> ORDER BY 
--  |_________________________________________|
--      can't use alias used in SELECT


SELECT c.ContactName, c.CustomerId, c.City as Cty, c.Country, COUNT(o.OrderId) AS NumofOrders
FROM Orders o JOIN Customers c ON o.CustomerId = c.CustomerId
WHERE c.Country IN ('USA', 'Canada')
GROUP BY c.ContactName, c.CustomerId, c.City, c.Country
HAVING COUNT(o.OrderId) >=10
ORDER BY NumofOrders DESC

SELECT *
FROM Products

UPDATE Products
SET UnitPrice = 10
WHERE ProductId = 1

--DISTINCT: 
--COUNT DISTINCT: 

SELECT Count(DISTINCT City)
From Customers

--2. AVG(): returns an avergae of a numeric column
--list average revenue for each customer

SELECT c.CustomerId, c.ContactName, AVG(od.UnitPrice * od.Quantity) As AvgRevenue
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON o.OrderId = od.OrderId
GROUP BY c.CustomerId, c.ContactName 
ORDER BY AvgRevenue DESC

--3. SUM(): get the sum value of a numeric column
--list sum of revenue for each customer

SELECT c.CustomerId, c.ContactName, SUM(od.UnitPrice * od.Quantity) As SumRevenue
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON o.OrderId = od.OrderId
GROUP BY c.CustomerId, c.ContactName 
ORDER BY SumRevenue DESC


--4. MAX(): get the maximum value for each numeric column

--list maxinum revenue from each customer

SELECT c.CustomerId, c.ContactName, MAX(od.UnitPrice * od.Quantity) As MaxRevenue
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON o.OrderId = od.OrderId
GROUP BY c.CustomerId, c.ContactName 
ORDER BY MaxRevenue DESC


--5.MIN(): returns the minimum value from a column
--list the cheapeast product bought by each customer

SELECT c.CustomerId, c.ContactName, MIN(od.UnitPrice) AS cheapestProduct
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON o.OrderId = od.OrderId
GROUP BY c.CustomerId, c.ContactName 


--TOP predicate: select certain number or certain percentage of records
--retrieve top 5 most expensive products

SELECT TOP 5 ProductName, UnitPrice
FROM Products 
ORDER BY UnitPrice DESC

--retrieve top 10 percent most expensive products

SELECT TOP 10 PERCENT ProductName, UnitPrice
FROM Products 
ORDER BY UnitPrice DESC

--list top 5 customers who created the most total revenue

SELECT TOP 5 c.CustomerId, c.ContactName, SUM(od.UnitPrice * od.Quantity) As SumRevenue
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON o.OrderId = od.OrderId
GROUP BY c.CustomerId, c.ContactName 
ORDER BY SumRevenue DESC

SELECT TOP 5 c.CustomerId, c.ContactName, SUM(od.UnitPrice * od.Quantity) As SumRevenue
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON o.OrderId = od.OrderId
GROUP BY c.CustomerId, c.ContactName 


--Subquery: is a SELECT statement that is embedded inside another SELECT statement 

--find the customers from the same city where Alejandra Camino lives 

SELECT ContactName, City
From Customers
WHERE City IN (
    SELECT City
    From Customers
    WHERE ContactName = 'Alejandra Camino'
)

--find customers who make any orders

--JOIN

SELECT DISTINCT c.CustomerId, c.ContactName, c.City, c.Country 
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId

--Subquery

SELECT CustomerId, ContactName, City, Country
From Customers
Where CustomerID IN
(SELECT DISTINCT CustomerId
From Orders )

--subquery vs. join
--1. Join can only be used in the from clause but subquery can be used in select, from, where, having and order by 

--get the order information like which employees deal with which order but limit the employees location to London:

--join
SELECT o.OrderDate, e.FirstName, e.LastName
FROM Orders o Join Employees e ON o.EmployeeId = e.EmployeeId
WHERE e.City = 'London'
ORDER By o.OrderDate, e.FirstName, e.LastName

--subquery
SELECT o.OrderDate, (SELECT e1.FirstName From Employees e1 WHERE o.EmployeeId = e1.EmployeeId) AS firstname, (SELECT e2.LastName From Employees e2 WHERE o.EmployeeId = e2.EmployeeId) as Lastname
From Orders o
WHERE(
    SELECT e3.city
    from Employees e3
    Where e3.EmployeeId = o.EmployeeId
) IN ('London')
Order By o.OrderDate, (SELECT e1.FirstName From Employees e1 WHERE o.EmployeeId = e1.EmployeeId), (SELECT e2.LastName From Employees e2 WHERE o.EmployeeId = e2.EmployeeId)

--2. Subquery is easier to maintain and understand

--Let's find the customers who never placed any order

--JOIN

SELECT c.CustomerID, c.ContactName, c.City, c.Country
FROM Customers c LEFT JOIN Orders o ON c.CustomerId = o.CustomerId
WHERE o.OrderId is null

--Subquery

SELECT c.CustomerID, c.ContactName, c.City, c.Country
FROM Customers c
WHERE CustomerId NOT IN (
    SELECT DISTINCT CustomerId
    FROM Orders
)
--3. Usually Join will have better performance than subquery. 

--3 types of physical join: hash join, merge join, neested loop join

--Correlated Subquery: when an inner query is dependent on the outer query

--Customer name and total number of orders by customer

--join

SELECT c.ContactName, COUNT(o.OrderId) AS NumofOrders
FROM Orders o JOIN Customers c ON o.CustomerId = c.CustomerId
GROUP BY c.ContactName
ORDER BY NumofOrders DESC

--subquery

SELECT c.ContactName, (SELECT Count(o.OrderId) FROM orders o WHERE o.customeriD = c.CustomerId) AS TotalNumOfOrders
FROM Customers c
Order by TotalNumOfOrders DESC

--derived table: a subquery in a from clause

SELECT dt.CustomerId, dt.ContactName
FROM (SELECT *
FROM Customers) dt

--get customers information and the number of orders made by each customer

--join 

SELECT c.ContactName, c.City, c.Country, COUNT(o.OrderId) AS NumofOrders
FROM Orders o LEFT JOIN Customers c ON o.CustomerId = c.CustomerId
GROUP BY c.ContactName, c.City, c.Country
ORDER BY NumofOrders DESC

--derived table

SELECT c.ContactName, c.City, c.Country, dt.TotalNumOfOrders
FROM Customers c LEFT JOIN (
    SELECT CustomerId, Count(OrderId) As TotalNumOfOrders
    FROM Orders
    GROUP BY CustomerId
) dt ON c.CustomerId = dt.CustomerId

--Union vs. Union ALL: They are used to combine different result sets vertically by adding rows from multiple tables togethe. 

---Similarities: 1. both are used to combine different result sets vertically

    SELECT City, Country
    FROM Customers
    UNION
    SELECT City, Country
    FROM Employees

    SELECT City, Country
    FROM Customers
    UNION ALL
    SELECT City, Country
    FROM Employees

    -- 2. They follow the same criteria: i) the number of the columns must be the same
    --                                   ii) The data type of the columns  must be identical

    SELECT City, Country, Region
    FROM Customers
    UNION
    SELECT City, Country, ReportsTo
    FROM Employees


--differences

--1. Union will remove duplicate values but union all will not
--2. If you use union, the records from the first column will be sorted ascendingly automatically. 
--3. Union can not be used in recursive cte but union all can. 

--Window Function: operated on a set of rows and returns a single aggregated value for each and every row by adding an extra column. 

--RANK(): give a rank based on a certain order, when there is a tie, there will be a value gap

--give a rank for a product price

SELECT ProductId, ProductName, UnitPrice, RANK() OVER(ORDER BY UnitPrice DESC) RNK 
FROM Products

--product with the 2nd highest price 
SELECT dt.ProductId, dt.ProductName, dt.UnitPrice, dt.RNk  
FROM (SELECT ProductId, ProductName, UnitPrice, RANK() OVER(ORDER BY UnitPrice DESC) RNK 
FROM Products) dt
WHERE dt.RNk = 2


--DENSE_RANK(): if you do not want the value gap, use DENSE_RANK()

SELECT ProductId, ProductName, UnitPrice, RANK() OVER(ORDER BY UnitPrice DESC) RNK, DENSE_RANK() OVER(ORDER BY UnitPrice DESC) DENSE_RANK
FROM Products

--ROW_NUMBER(): it will return the ranking of the sorted record starting from 1 

SELECT ProductId, ProductName, UnitPrice, RANK() OVER(ORDER BY UnitPrice DESC) RNK, DENSE_RANK() OVER(ORDER BY UnitPrice DESC) DENSE_RANK,
ROW_NUMBER() OVER(ORDER BY UnitPrice DESC) RowNum
FROM Products

--partition by: divides the result set into partitions and perfrom calculations on each subset. it is always used in conjuction with the window function

--list customers from every country with the ranking for number of orders

SELECT c.ContactName, c.Country, COUNT(O.OrderId) AS NumofOrders, RANK() OVER(PARTITION BY c.Country ORDER BY COUNT(O.OrderId) DESC) RNK
FROM Customers c JOIN Orders o On c.CustomerId = o.CustomerId 
GROUP BY c.ContactName, c.Country

--- find top 3 customers from every country with maximum orders

SELECT dt.ContactName, dt.Country, dt.NumOfOrders, dt.RNK
FROM (SELECT c.ContactName, c.Country, COUNT(O.OrderId) AS NumofOrders, RANK() OVER(PARTITION BY c.Country ORDER BY COUNT(O.OrderId) DESC) RNK
FROM Customers c JOIN Orders o On c.CustomerId = o.CustomerId 
GROUP BY c.ContactName, c.Country) dt
WHERE dt.RNK <=3

--cte: common table expression: a temprorary name result set to make our query more readable

--derived table
SELECT c.ContactName, c.City, c.Country, dt.TotalNumOfOrders
FROM Customers c LEFT JOIN (
    SELECT CustomerId, Count(OrderId) As TotalNumOfOrders
    FROM Orders
    GROUP BY CustomerId
) dt ON c.CustomerId = dt.CustomerId

--cte

WITH OrderCntCTE
AS(
    SELECT CustomerId, Count(OrderId) As TotalNumOfOrders
    FROM Orders
    GROUP BY CustomerId
)
SELECT c.ContactName, c.City, c.Country, cte.TotalNumOfOrders
FROM Customers c LEFT JOIN OrderCntCTE cte ON c.CustomerId = cte.CustomerID


--lifecycle: it has to be used to used in the next select statement right away; have to be created and used in a single batch

WITH OrderCntCTE
AS(
    SELECT CustomerId, Count(OrderId) As TotalNumOfOrders
    FROM Orders
    GROUP BY CustomerId
)
SELECT c.ContactName, c.City, c.Country, cte.TotalNumOfOrders
FROM Customers c LEFT JOIN OrderCntCTE cte ON c.CustomerId = cte.CustomerID

--recursive CTE:  if we have a cte that calls itself recursively, that is called recursive cte. 
--The true power of cte is that it can call itself recursively 


--1. Initalization
--2.Recursice rule 

SELECT EmployeeId, FirstName, ReportsTo
From Employees

--level 1: Andrew
--level 2: Nancy, Janet, Margaret, Steven, Laura
--level 3: Michael, Robert, Anne

WITH EmpHierarchyCTE
AS(
    SELECT EmployeeId, FirstName, ReportsTo, 1 level
    FROM Employees
    WHERE ReportsTo is null
    UNION ALL
    SELECT e.EmployeeId, e.FirstName, e.ReportsTo, cte.level + 1 
    FROM Employees e INNER JOIN EmpHierarchyCTE cte ON e.ReportsTo = cte.EmployeeId
)
SELECT * FROM EmpHierarchyCTE