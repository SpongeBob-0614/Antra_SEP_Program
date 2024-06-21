--1)      List all cities that have both Employees and Customers.

SELECT DISTINCT City FROM Employees WHERE CITY IN (SELECT City FROM Customers)

--2)      List all cities that have Customers but no Employee.
--a.      Use sub-query

SELECT DISTINCT City
FROM Customers
WHERE City NOT IN 
(SELECT City
FROM Employees
)

--b.      Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c
LEFT JOIN Employees e ON c.City=e.City
WHERE e.City IS NULL

--3)  List all products and their total order quantities throughout all orders.

SELECT p.ProductID, p.ProductName, SUM(Quantity) AS TotalQuantities
FROM [Order Details] od 
JOIN Products p 
ON od.ProductID=p.ProductID
GROUP BY p.ProductName, p.ProductID


--4) List all Customer Cities and total products ordered by that city.


SELECT ShipCity AS CustomerCities, COUNT(o.OrderID) AS TotalProducts
FROM [Order Details] od JOIN Orders o ON od.OrderID=o.OrderID
GROUP BY ShipCity
--5)    List all Customer Cities that have at least two customers.
--a.      Use union

SELECT DISTINCT c.City
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.City) >=2
UNION 
SELECT o.ShipCity
FROM Orders o
GROUP BY o.ShipCity
HAVING COUNT(o.ShipCity) >=2

SELECT * FROM Customers
SELECT * FROM Orders

--b.      Use sub-query and no union

SELECT DISTINCT city
FROM Customers
WHERE City IN
(SELECT ShipCity
FROM Orders
GROUP BY ShipCity
HAVING COUNT(ShipCity)>=2)

--6) List all Customer Cities that have ordered at least two different kinds of products.

SELECT c.City
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.City
HAVING COUNT(DISTINCT p.ProductID) >= 2;

--7)List all Customers who have ordered products, but have the 'ship city' on the order different from their own customer cities.
	
SELECT DISTINCT ContactName
FROM Customers c 
JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE c.City != o.ShipCity AND o.ShipCity IS NOT NULL

--8)List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

WITH ProductPopularity AS (
    SELECT TOP 5
        od.ProductID,
        p.ProductName,
        AVG(p.UnitPrice) AS AvgPrice,
        SUM(od.Quantity) AS TotalQuantity
    FROM [Order Details] od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY od.ProductID, p.ProductName
    ORDER BY TotalQuantity DESC
),
CityOrders AS (
    SELECT
        od.ProductID,
        c.City,
        SUM(od.Quantity) AS CityQuantity
    FROM [Order Details] od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Customers c ON o.CustomerID = c.CustomerID
    GROUP BY od.ProductID, c.City
)
SELECT
	pp.ProductID,
    pp.ProductName,
    pp.AvgPrice,
    co.City
FROM ProductPopularity pp
JOIN CityOrders co ON pp.ProductID = co.ProductID
WHERE co.CityQuantity = (
    SELECT MAX(co2.CityQuantity)
    FROM CityOrders co2
    WHERE co2.ProductID = pp.ProductID
)

--9) List all cities that have never ordered something but have employees there.
--a.      Use sub-query

SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN (
    SELECT DISTINCT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
)

--b.      Do not use sub-query

SELECT DISTINCT e.City
FROM Employees e
LEFT JOIN (
    SELECT DISTINCT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
) AS co ON e.City = co.City
WHERE co.City IS NULL

--10)List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

WITH EmployeeSales AS (
    SELECT e.City, COUNT(o.OrderID) AS OrderCount
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.City
),
CityOrders AS (
    SELECT c.City, SUM(od.Quantity) AS TotalQuantity
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.City
)
SELECT es.City
FROM EmployeeSales es
JOIN CityOrders co ON es.City = co.City
WHERE es.OrderCount = (
    SELECT MAX(OrderCount)
    FROM EmployeeSales
) AND co.TotalQuantity = (
    SELECT MAX(TotalQuantity)
    FROM CityOrders
)

--11)How do you remove the duplicates record of a table?

-- A: We can remove duplicates record by using Common Table Expressions CTE, ROW_NUMBER Function() or the RANK Function

--varchar vs nvarchar
--A: VARCHAR is suitable for non-Unicode character data. NVARCHAR is necessary for storing Unicode character data. It allows multilingual support but requires more storage space per character.