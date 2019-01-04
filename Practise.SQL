use TSQLV4

Create Table Employees
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10),
    Salary int,
    Country nvarchar(10)
)
Go

Insert Into Employees Values (1, 'Mark', 'Male', 5000, 'USA')
Insert Into Employees Values (2, 'John', 'Male', 4500, 'India')
Insert Into Employees Values (3, 'Pam', 'Female', 5500, 'USA')
Insert Into Employees Values (4, 'Sara', 'Female', 4000, 'India')
Insert Into Employees Values (5, 'Todd', 'Male', 3500, 'India')
Insert Into Employees Values (6, 'Mary', 'Female', 5000, 'UK')
Insert Into Employees Values (7, 'Ben', 'Male', 6500, 'UK')
Insert Into Employees Values (8, 'Elizabeth', 'Female', 7000, 'USA')
Insert Into Employees Values (9, 'Tom', 'Male', 5500, 'UK')
Insert Into Employees Values (11, 'Harry', 'Male', 5000, NULL)
Go

select * from Employees

select grouping(country) , gender , SUM(Salary) as TotalSalary
  from Employees
  group by country, gender with cube


  select country, gender , SUM(Salary) as TotalSalary
  from Employees
  group by grouping sets ((country, gender),())

    select country, gender , SUM(Salary) as TotalSalary
  from Employees
  group by Country, gender

  union all
      select null, null , SUM(Salary) as TotalSalary
  from Employees

  Create table Sales
(
    Id int primary key identity,
    Continent nvarchar(50),
    Country nvarchar(50),
    City nvarchar(50),
    SaleAmount int
)
Go

-------

use tsqlv4

select * from sales.orders

with Sales 
as
(

select custid,  --Grouping
       shipperid , -- Spreading
	   freight --Aggregating
  from sales.orders

)
select custid, isnull([1],-1) as [1],isnull([2],-1) as [2],isnull([3],-1) as [3] 
    --into sales.freightTotal
  from Sales
  pivot
       (
	     sum(freight)
		 for shipperid in ([1],[2],[3])
	   ) as P

select * 
  from sales.freightTotal

  
select custid, freight, shipperid 
  from sales.freightTotal
  unpivot 
  (
  freight for shipperid in ([1],[2],[3])

  ) as p

Insert into Sales values('Asia','India','Bangalore',1000)
Insert into Sales values('Asia','India','Chennai',2000)
Insert into Sales values('Asia','Japan','Tokyo',4000)
Insert into Sales values('Asia','Japan','Hiroshima',5000)
Insert into Sales values('Europe','United Kingdom','London',1000)
Insert into Sales values('Europe','United Kingdom','Manchester',2000)
Insert into Sales values('Europe','France','Paris',4000)
Insert into Sales values('Europe','France','Cannes',5000)
Go

select * from Sales

-- Windowing functions
use TSQLV4

select custid,
       OrderID,
       sum(val) over() as GrandTotal,
	   sum(val) over(Partition by custid) as CustTotal,
	   Val,
	   sum(val) over (partition by custid order by orderid,orderdate range between unbounded preceding and current row) as RunningTotal,
	   sum(val) over (partition by custid order by orderid,orderdate rows between 1 preceding and current row) as RunningTotal1
  from sales.OrderValues




  select custid,
         val,
	  (lead(val) over(partition by custid order by orderdate, orderid ) -val) as lead,
	  (lag(val) over (partition by custid order by orderdate, orderid ) - val)as lag ,
	  lag(val,2,0) over (partition by custid order by orderdate, orderid ) as lag1
    from  sales.OrderValues

	  select custid,
         val,
	     first_Value(val) over(partition by custid order by orderdate, orderid rows between unbounded preceding and current row),
		 first_Value(val) over(partition by custid order by orderdate, orderid ),
		 last_Value(val) over(partition by custid order by orderdate, orderid rows between current row and unbounded following)
    from  sales.OrderValues

	--System Versioned Tables

	select * from dbo.ProductsHistory

	--XML

	use NashHouse

	select * from sys.tables


	select * 
	  from tb_EmployeeInfo as Emp
	  for xml path('')

	select * 
	  from tb_EmployeeInfo --as Emp
	  for xml auto ,elements, root('Employee')

	  with xmlnamespaces('NashTest' as co)
	  select [co:Em].ID, [co:Em].FirstName, [co:Em].LastName
	  from tb_EmployeeInfo as [co:Em]
	  where [co:Em].id=2
	  for xml path ,elements, root('Employee')


	  --

	  DECLARE @DocHandle AS INT;
DECLARE @XmlDocument AS NVARCHAR(1000);
SET @XmlDocument = N'
<CustomersOrders>
  <Customer custid="1">
    <companyname>Customer NRZBB</companyname>
    <Order orderid="10692">
      <orderdate>2015-10-03</orderdate>
    </Order>
    <Order orderid="10702">
      <orderdate>2015-10-13T00:00:00</orderdate>
    </Order>
    <Order orderid="10952">
      <orderdate>2016-03-16T00:00:00</orderdate>
    </Order>
  </Customer>
  <Customer custid="2">
    <companyname>Customer MLTDN</companyname>
    <Order orderid="10308">
      <orderdate>2014-09-18T00:00:00</orderdate>
    </Order>
    <Order orderid="10926">
      <orderdate>2016-03-04T00:00:00</orderdate>
    </Order>
  </Customer>
</CustomersOrders>';
-- Create an internal representation
EXEC sys.sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument;
-- Attribute- and element-centric mapping
-- Combining flag 8 with flags 1 and 2
SELECT *
FROM OPENXML (@DocHandle, '/CustomersOrders/Customer/Order',11)
     WITH (custid INT,
           companyname NVARCHAR(40),
		   orderid int,
		   orderdate date);
-- Remove the DOM
EXEC sys.sp_xml_removedocument @DocHandle;
GO


declare @XMLd xml ='<xml>
    <Response>
        <ResponseID>R_a4yThVvKXzVyftz</ResponseID>
        <ResponseSet>Default Response Set</ResponseSet>
        <Name>Doe, John</Name>
        <ExternalDataReference>0</ExternalDataReference>
        <EmailAddress>jdoe@gmail.com</EmailAddress>
        <IPAddress>140.123.12.123</IPAddress>
        <Status>0</Status>
        <StartDate>2014-09-18 09:21:11</StartDate>
        <EndDate>2014-09-23 16:09:58</EndDate>
        <Finished>1</Finished>
     </Response>
</xml>'

--declare @DocHandle int;

--exec sys.sp_xml_preparedocument @DocHandle output, @XMLd


--select *
--from openxml(@DocHandle,'/xml/Response',11)
--with (ResponseID varchar(100),
--      Finished bit)

--	  EXEC sys.sp_xml_removedocument @DocHandle;
--GO

SELECT
  R.X.value('(ResponseID/text())[1]', 'varchar(50)') as RESPONSEID,
  R.X.value('(ResponseSet/text())[1]', 'varchar(50)') as RESPONSESET,
  R.X.value('(Name/text())[1]', 'varchar(50)') as NAME
into nashtable
FROM   @XMLd.nodes('/xml/Response') AS R(X)

select * from nashtable


select * from Production.Products
SELECT categoryname 
   FROM Production.Categories
   WHERE categoryid = 