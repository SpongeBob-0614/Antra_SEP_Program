--basic queries: select, where, order by,join, aggregation functions, group by, having
--advanced topics: subquery, CTE, window function, pagination, top
--temp tables
--table variables
--stored procedures
--user defined fucntions

--check constraint: limit the value range that can be placed in a column

SELECT *
FROM Employee

INSERT INTO Employee VALUES(6, 'Monster', 6000)
INSERT INTO Employee VALUES(7, 'Monster', -6000)

DELETE Employee

ALTER TABLE Employee
ADD CONSTRAINT Chk_Age_Employee CHECK (Age BETWEEN 18 AND 60)

INSERT INTO EMPLOYEE VALUES (1, 'Fred', 30)

--identity property

CREATE TABLE Product(
    id int PRIMARY KEY IDENTITY(1,1),
    ProductName varchar(20) UNIQUE NOT NULL,
    UnitPrice Money
)

SELECT * FROM Product

INSERT INTO Product VALUES('Green Tea', 2)
INSERT INTO Product VALUES('Latte', 3)
INSERT INTO Product VALUES('Cold Brew', 4)

--truncate vs. delete
--1.Delete is a DML. So it will not reset the property value. Truncate is DDL so it will reset the property value. 
--2. DELETE can be used with WHERE clause but TRUNCATE can not be
SELECT * FROM Product

TRUNCATE TABLE Product

DELETE FROM Product 

DELETE Product
WHERE id = 4

SET IDENTITY_INSERT Product ON insert into product(id, ProductName, UnitPrice) VALUES(4, 'Green tea', 3)

--DROP: is a DDL statement that will delete the wholw table. 

--referential integrity: is implemented with the help of a foreign key

--department table and employee table 

CREATE TABLE Department(
    id INT PRIMARY KEY,
    DepartmentName VARCHAR(20),
    Location varchar(20)
)

CREATE TABLE Employee(
    Id INT PRIMARY KEY, 
    EmployeeName varchar(20),
    Age int CHECK(Age BETWEEN 18 and 65),
    DepartmentId INT FOREIGN KEY REFERENCES Department(id)
)

SELECT *
FROM Employee

SELECT *
FROM Department

INSERT INTO DEPARTMENT VALUES(1,'IT', 'Chicago')
INSERT INTO DEPARTMENT VALUES(2,'HR', 'Sterling')
INSERT INTO DEPARTMENT VALUES(3,'QA', 'New York')

INSERT INTO EMPLOYEE VALUES(1, 'Fred', 30, 1)

DELETE FROM DEPARTMENT
WHERE ID = 3


CREATE TABLE Employee(
    Id INT PRIMARY KEY, 
    EmployeeName varchar(20),
    Age int CHECK(Age BETWEEN 18 and 65),
    DepartmentId INT FOREIGN KEY REFERENCES Department(id) ON DELETE SET NULL
)

CREATE TABLE Employee(
    Id INT PRIMARY KEY, 
    EmployeeName varchar(20),
    Age int CHECK(Age BETWEEN 18 and 65),
    DepartmentId INT FOREIGN KEY REFERENCES Department(id) ON DELETE CASCADE
)

DROP TABLE Employee

select * from employee

SELECT * FROM DEPARTMENT

DELETE FROM DEPARTMENT
WHERE ID=1

--Composite primary key
--student table
--class table
--enrollment table


CREATE TABLE Student(
    Id int PRIMARY KEY,
    StudentName VARCHAR(20)
)

CREATE TABLE CLASS(
    ID INT PRIMARY KEY,
    ClassName varchar(20)
)

CREATE TABLE Enrollment(
    StudentId int NOT NULL  ,
    ClassId int NOT NULL,
    CONSTRAINT PK_Enrollment PRIMARY KEY(StudentId, ClassId),
    CONSTRAINT FK_Enrollement_Student FOREIGN KEY(StudentId) REFERENCES Student(Id),
    CONSTRAINT FK_Enrollement_Class FOREIGN KEY(ClassId) REFERENCES Class(Id)
)

--student ---> Enrollment table -----> class table

--transaction: logically related DML statements that will suceed together or fail together

--3 modes:
--Autocommit transaction:
--Implicit transaction
--Explicit transaction: you have to explicitly specify the starting and ending points of the trasaction. 

CREATE TABLE Product(
    id int PRIMARY KEY IDENTITY(1,1),
    ProductName varchar(20) UNIQUE NOT NULL,
    UnitPrice Money,
    Quantity int
)

select * from product

INSERT INTO Product VALUES('Green Tea', 2, 100)
INSERT INTO Product VALUES('Latte', 3, 100)
INSERT INTO Product VALUES('Cold Brew', 4, 100)


--Properties
--ACID
--1.Atomictiy: work most be atomic
--2.Consistency: a databse is transformed from one consistent state to another consistent state
--3.Isolation: two tranasactions will be isolated from each other by locking the resource
--4.Durability: once the transaction is completed, the changes that we make to database will be permanent. 

--concurrency problem: when two or more than two users are trying to access the same data concurrently. 

--1. Dirty read: if transaction 1 allows transaction 2 to read the uncommited data but transaction 1 rolls back. happens when isolation level is read committed and is solved by updating isolation level to read committed
--2. Lost update: when tran1 and tran 2 are trying to read and update the dame data but tran 2 finished its work earlier even though tran 1 starteed the transaction first and as a result the update from tran2 will be missing. 
                 --happens when isolation level is read committed and is solved by updating the isolation level to repeatable read
--3. Non repeatable read: happens when t1 reads the same data twice but t2 is updating the data; happens when isolation level is read commited and is solved by updating the isolation level to repeatable read
--4. Phantom read: happens when t1 read the same data twice while t2 is inserting the data; happens when isolation level is set to repeatable read and is solved by updating the isolation level to serializable 



--index: a on-disk structure that increases a data retrieval speed from a table; increase spped of SELECT statement; B+ tree--> organize data in sorted order

--clustered index: sort the record; primary key automatically genrates clustered index that is why primary key column data are sorted; can only have one clustered index because data can only be sorted one way 
--non-clustered index: it will not sort the data; it will be stored separately; unique key will generate a non-clustered index.

CREATE TABLE Customer(
    Id int,
    FullName varchar(20),
    City varchar(20),
    Country varchar(20)
)

SELECT *
FROM Customer

CREATE CLUSTERED INDEX Cluster_IX_Customer_ID ON Customer(Id)

INSERT INTO CUSTOMER VALUES(3, 'David', 'Chicago', 'USA')
INSERT INTO CUSTOMER VALUES(1, 'Fred', 'Sterling', 'USA')

CREATE INDEX Noncluster_IX_Customer_City ON Customer(City)

--when should you create a clustered index and non-clusterd index?
-- ==> use non-clusted index on frequently accessed column, columnns that are used frequently on join, where, aggregation and so on; use clustered index with primary key

--disadvantages:
--1. cost extra space 
--2. it will slow down other DML statements such as UPDATE/INSERT/DELETE

--PERFORMANCE TUNING 
--1. You need to look at the execution plan; sql profiler
--2. create an index wisely. 
--3. avoid unnecessary joins. 
--4. Avoid using select * 
--5. use a derived table to avoid grouping of lots of non-aggreagted fields. 
--6. replace subquery with join if needed. 