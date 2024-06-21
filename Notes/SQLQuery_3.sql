--aggregation functions + group by 
--subquery 
--derived tables
--union vs. union all 
--window function 
--cte

--temp table: a special type of table to help us store the data temproraily; lifescope is limited to the connection that created the local temp table

--local temp table #

CREATE TABLE #LocalTemp(
    Num int
)
DECLARE @Variable int = 1
WHILE(@Variable <= 10)
BEGIN
INSERT INTO #LocalTemp(Num) VALUES(@Variable)
SET @Variable = @Variable +1 
END

SELECT *
FROM #LocalTemp

SELECT *
FROM tempdb.sys.tables

--global temp table ## : both local and global temp tables are stored in tempdb database 

CREATE TABLE ##GlobalTemp(
    Num int
)
DECLARE @Variable2 int = 1
WHILE(@Variable2 <= 10)
BEGIN
INSERT INTO ##GlobalTemp(Num) VALUES(@Variable2)
SET @Variable2 = @Variable2 +1 
END

SELECT *
FROM ##GlobalTemp

SELECT *
FROM tempdb.sys.tables

--table variable: type of variable which is of table type; lifescope is limited to the batch it got created at

declare @today DATETIME
set @today = getdate()
print @today

DECLARE @WeekDays TABLE(
    DayNum int,
    DayAbb varchar(20),
    WeekName varchar(20)
)
INSERT INTO @WeekDays VALUES
    (1, 'Mon', 'Monday'),
    (2, 'Tue', 'Tuesday')

SELECT *
FROM @WeekDays

SELECT *
FROM tempdb.sys.tables

--varchar vs nvarchar

--temp tables vs. table variables

--1. Both temp table and table variables are stored under tempdb database.
--2. Lifescope: local temp table/ global temp table , table variable: batch
--3. sizes: 100 rows> temp tables; 100 rows< table variables
--4. temp table can not be used in sp, udf but table varibales can be used in sp, udf.

--view: a virtual table that contains data from one or multiple tables

SELECT *
FROM Employee

INSERT INTO EMPLOYEE VALUES (1, 'Fred', 7000), (2, 'Laura', 8000)

CREATE VIEW vwEmp
AS
SELECT Id, EName, Salary
FROM Employee

SELECT *
FROM vwEmp

--stored procedure: it is a prepared sql query that we can save in our database and reuse it whenever we want to

BEGIN
PRINT 'Hello Anonymous Block'
END

CREATE PROC spHello
AS
BEGIN
PRINT 'Hello Anonymous Block'
END

EXEC spHello

--Advantages of sp: sp can be used to prevent sql injection becuase it can take parameters.

--sql injection: when hackers inject some malicious code into our sql queries there by destroying our database

SELECT Id, NAME
FROM User
WHERE Id= 1 UNION SELECT ID, PASSWORD FROM USER

SELECT Id, NAME
FROM User
WHERE Id = 1 DROP TABLE User

SELECT Id, NAME
FROM User
WHERE Id = 1 OR 1 =1

--input: default type

CREATE PROC spAddNumbers
@a int,
@b int
AS
PRINT @a + @b 

EXEC spAddNumbers 10, 20

--output

CREATE PROC spGetName
@id int,
@EName varchar(20) OUT 
AS
BEGIN
SELECT @EName = EName 
FROM Employee
WHERE Id = @id
END

BEGIN
DECLARE @en VARCHAR(20)
EXEC spGetName 2, @en OUT
PRINT @en
END

--sp can also return tables

CREATE PROC spGetAllEmp
AS
BEGIN
SELECT *
FROM Employee
END

EXEC spGetAllEmp 

--trigger: special type of sp that will automaically run when there is an event that occurs. 

--DML trigger
--DDL trigger
--LogON trigger

--lifescope sp and views: they are persisted in the database as long as you do not drop them

--FUNCTIONS:
--Biilt-in
--User defined functions: mainly used for calculations

CREATE FUNCTION GetTotalRevenue(@price money, @discount real, @quantity int)
RETURNS money
AS
BEGIN
DECLARE @revenue money
SET @revenue = @price * (1-@discount) * @quantity
RETURN @revenue
END

SELECT UnitPrice, Quantity, Discount, dbo.GetTotalRevenue(UnitPrice, Discount, Quantity) AS Revenue 
FROM [order details]

--benefit of using udf:

CREATE FUNCTION Expensive_Product(@threshold money)
RETURNS TABLE
AS
RETURN SELECT * 
    FROM PRODUCTS
    WHERE UnitPrice > @threshold

SELECT *
FROM dbo.ExpensiveProduct(10)

--sp vs. udf
--1. Usuage: use sp for DML statements and udf for calculations
--2. How to call: exec sp, udf are used in sql statements
--3. input/output: sp may or may not have input or output params but for udf, it may or may not have input params but it must have output 
--4. you can use sp to call a udf, but you can not use udf to call sp.

--pagination: a process that we use to divide a large data set into smaller discrete pages. It is commonly used by web application.

--OFFSET: skip 
--FETCH NEXT x ROWS: Select


SELECT CustomerId, ContactName, City
FROM Customers 
ORDER BY CustomerId
OFFSET 92 ROWS

SELECT CustomerId, ContactName, City
FROM Customers 
ORDER BY CustomerId
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY 

--TOP vs offset, fetch next
--1. top can be used with/without order by but offset and fetch  next has to be used with order by 
--2. top can be used to fetch top several rows but offset and fetch next can be used to fetch several rows in the middle as well. 


DECLARE @PageNum INT = 2 
DECLARE @RowsOfPage INT 
SET @RowsOfPage = 10
SELECT CustomerId, ContactName, City
FROM Customers 
ORDER BY CustomerId
OFFSET (@PageNum - 1) * @RowsOfPage ROWS
FETCH NEXT @RowsOfPage Rows ONLY 


DECLARE @PageNum INT = 1 
DECLARE @RowsOfPage INT 
DECLARE @MaxTablePage FLOAT 
SET @RowsOfPage = 10
SELECT @MaxTablePage = COUNT(*) From Customers
SET @MaxTablePage = CEILING(@MaxTablePage/@RowsOfPage) 
WHILE @PageNum<=@MaxTablePage
BEGIN
SELECT CustomerId, ContactName, City
FROM Customers 
ORDER BY CustomerId
OFFSET (@PageNum - 1) * @RowsOfPage ROWS
FETCH NEXT @RowsOfPage Rows ONLY 
SET @PageNum = @PageNum + 1
END

--Normalization
 
 --How can we build one to many and many to many relationship?
--one to many relationship
--eg: employee table and department table 

--many to many relationship: create a conjunction table in between 
--eg: student table and class table: create an enrollment table 

-- student  enrollment  class 


--Constraints

DROP TABLE Employee

CREATE TABLE Employee(
    Id int,
    EName varchar(20),
    Age int
)

SELECT *
FROM Employee

INSERT INTO EMPLOYEE VALUES (1, 'Sam', 45)

INSERT INTO EMPLOYEE VALUES (null, null, null)

DROP TABLE Employee

CREATE TABLE Employee(
    Id int unique ,
    EName varchar(20) not null,
    Age int
)

INSERT INTO EMPLOYEE VALUES (null, 'Sam', 45)

CREATE TABLE Employee(
    Id int PRIMARY KEY ,
    EName varchar(20) not null,
    Age int
)

--primary key vs. unique constraint
--1. unique key can accept one and only null value but primary key can not accept any null value
--2. One table can have multiple unique keys but only one primary key
--3. Primary key will sort the data by default in ascending order but unique key will not. 
--4. pk will create a clustered index and unique key will create a non clustered index


DELETE FROM Employee

INSERT INTO EMPLOYEE VALUES(4, 'Fred', 25)
INSERT INTO EMPLOYEE VALUES (3, 'Peter', 19)
INSERT INTO EMPLOYEE VALUES (5, 'Fiona', 55)
INSERT INTO EMPLOYEE VALUES (1, 'Sam', 45)

SELECT *
FROM Employee