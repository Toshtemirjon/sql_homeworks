--Nematov
--hw(advanced) Northwind database

--1
select * from orders
select * from customers
select * from orderdetails

select c.customerid, c.CompanyName, o.orderid, sum((d.unitprice*d.quantity)) as totalPurch from customers c
join orders o on c.customerid=o.customerid
join orderdetails d on d.orderid=o.orderid 
where year(orderdate)='2016' 
group by c.customerid, c.CompanyName, o.orderid
having sum((d.unitprice*d.quantity))>10000

--2
select c.customerid, c.CompanyName,  sum((d.unitprice*d.quantity)) as totalPurch from customers c
join orders o on c.customerid=o.customerid
join orderdetails d on d.orderid=o.orderid 
where year(orderdate)='2016' 
group by c.customerid, c.CompanyName
having sum((d.unitprice*d.quantity))>=15000

--3
select c.customerid, c.CompanyName,  Totalwithdiscount=sum(Unitprice*quantity*(1-discount)) from orderdetails d
join orders o on o.orderid=d.orderid
join customers c on c.customerid=o.customerid
where year(orderdate)='2016' 
group by  c.customerid, c.CompanyName
having  sum(Unitprice*quantity*(1-discount))>15000
order by totalwithdiscount desc

--4
SELECT * FROM orders
WHERE DAY(orderdate) = DAY(EOMONTH(orderdate))
order by employeeid, orderid

--5
select top 10 o.orderid, count(*) as totallines from orders o
join orderdetails d on o.orderid=d.orderid
group by o.orderid
order by totallines desc

--6
 Select	top	2	percent
 OrderID
 From	Orders
 Order	By	NewID()


--7
SELECT o.OrderID
FROM Orders o
JOIN OrderDetails od1 ON o.OrderID = od1.OrderID
JOIN OrderDetails od2 ON o.OrderID = od2.OrderID
WHERE od1.ProductID <> od2.ProductID
AND od1.Quantity = od2.Quantity
AND od1.Quantity >= 60
group by o.orderid, od1.quantity
ORDER BY o.OrderID

--8
select * from orderdetails
where orderid in (
SELECT o.OrderID
FROM Orders o
JOIN OrderDetails od1 ON o.OrderID = od1.OrderID
JOIN OrderDetails od2 ON o.OrderID = od2.OrderID
WHERE od1.ProductID <> od2.ProductID
AND od1.Quantity = od2.Quantity
AND od1.Quantity >= 60
group by o.orderid, od1.quantity)

--9
/*Select	OrderDetails.OrderID
 ,ProductID
 ,UnitPrice	,Quantity	,Discount	From	OrderDetails	Join	(
 Select	OrderID
 From	OrderDetails	Where	Quantity	>=	60
 Group	By	OrderID,	Quantity	Having	Count(*)	>	1
 )		PotentialProblemOrders	on	PotentialProblemOrders.OrderID	=
 OrderDetails.OrderID
 Order	by	OrderID,	ProductID*/


with cte as (select orderid from orderdetails where quantity>=60 group by orderid, quantity having count(*)>1)
select orderid, productid, unitprice, quantity, discount from orderdetails where orderid in
(select orderid from cte) order by orderid, quantity

--10
 select * from orders

 select * from orders
 where shippeddate>=requireddate 

 --11
select e.employeeid, lastname, count(lastname) totalorders from employees e
 join orders o on e.employeeid=o.employeeid
 where shippeddate>=requireddate 
  group by lastname, e.employeeid
  order by totalorders desc

  --12
  with cte as (select e.employeeid, lastname, count(lastname) totalorders from employees e
 join orders o on e.employeeid=o.employeeid
 where shippeddate>=requireddate 
  group by lastname, e.employeeid)
  select o.employeeid, cte.lastname, cte.totalorders as totallates, count (o.employeeid) as totalorders from orders o
  join cte on cte.employeeid=o.employeeid
  group by o.employeeid, cte.lastname, cte.totalorders

  --13
 with cte as (select e.employeeid, lastname, count(lastname) totalorders from employees e
 join orders o on e.employeeid=o.employeeid
 where shippeddate>=requireddate 
  group by lastname, e.employeeid)
  select o.employeeid, employees.lastname, cte.totalorders as totallates, count (o.employeeid) as totalorders from orders o
  join employees on employees.employeeid=o.employeeid
 left join cte on cte.employeeid=o.employeeid
  group by o.employeeid, employees.lastname, cte.totalorders
  order by o.employeeid

  --14
 with cte as (select e.employeeid, lastname, count(lastname) totalorders from employees e
 join orders o on e.employeeid=o.employeeid
 where shippeddate>=requireddate 
  group by lastname, e.employeeid)
  select o.employeeid, employees.lastname, coalesce(cte.totalorders, '0') as totallates, count (o.employeeid) as totalorders from orders o
  join employees on employees.employeeid=o.employeeid
 left join cte on cte.employeeid=o.employeeid
  group by o.employeeid, employees.lastname, cte.totalorders
  order by o.employeeid

  --15
with lateorders as (select employeeid, count(orderid) as totalorders from orders where requireddate <= shippeddate group by employeeid),
allorders as (select employeeid, totalorders = count(*)  from orders group by employeeid)
select e.employeeid, e.lastname, allorders = a.totalorders, lateorders = isnull(l.totalorders, 0), 
percentlateorders = (isnull(l.totalorders, 0) * 1.00) / a.totalorders
from employees e join allorders a on a.employeeid = e.employeeid
left join lateorders l on l.employeeid = e.employeeid

--16
with lateorders as (select employeeid, count(orderid) as totalorders from orders where requireddate <= shippeddate group by employeeid),
allorders as (select employeeid, totalorders = count(*)  from orders group by employeeid)
select e.employeeid, e.lastname, allorders = a.totalorders, lateorders = isnull(l.totalorders, 0), 
cast((isnull(l.totalorders, 0) * 1.00) / a.totalorders as decimal(4, 2)) as percentlateorders
from employees e join allorders a on a.employeeid = e.employeeid
left join lateorders l on l.employeeid = e.employeeid

--17
WITH CTE AS ( Select	Customers.CustomerID
 ,Customers.CompanyName	,TotalOrderAmount	=	SUM(Quantity	*	UnitPrice)
 From	Customers	Join	Orders	on	Orders.CustomerID	=	Customers.CustomerID
 Join	OrderDetails	on	Orders.OrderID	=	OrderDetails.OrderID
 Where	OrderDate	>=	'20160101'
 and	OrderDate		<	'20170101'
 Group	By	Customers.CustomerID
 ,Customers.CompanyName	)

 select *, 
case when totalorderamount between 0 and 999 then 'low'   when totalorderamount between 1000 and 4999 then 'medium' 
when totalorderamount between 5000 and 9999 then 'high' 
when totalorderamount >= 10000 then 'more'  else 'unknown' end as ordercategory
from cte;

--18
WITH CTE AS ( Select	Customers.CustomerID
 ,Customers.CompanyName	,TotalOrderAmount	=	SUM(Quantity	*	UnitPrice)
 From	Customers	Join	Orders	on	Orders.CustomerID	=	Customers.CustomerID
 Join	OrderDetails	on	Orders.OrderID	=	OrderDetails.OrderID
 Where	OrderDate	>=	'20160101'
 and	OrderDate		<	'20170101'
 Group	By	Customers.CustomerID
 ,Customers.CompanyName	)

 select *, 
case when totalorderamount between 0 and 999 then 'low'   when totalorderamount between 1000 and 4999 then 'medium' 
when totalorderamount between 5000 and 9999 then 'high' 
when totalorderamount >= 10000 then 'more'  else 'unknown' end as ordercategory
from cte;

--19
WITH CTE AS ( Select	Customers.CustomerID
 ,Customers.CompanyName	,TotalOrderAmount	=	SUM(Quantity	*	UnitPrice)
 From	Customers	Join	Orders	on	Orders.CustomerID	=	Customers.CustomerID
 Join	OrderDetails	on	Orders.OrderID	=	OrderDetails.OrderID
 Where	OrderDate	>=	'20160101'
 and	OrderDate		<	'20170101'
 Group	By	Customers.CustomerID
 ,Customers.CompanyName	),

 cte2 as (select *, 
case when totalorderamount between 0 and 999 then 'low'   when totalorderamount between 1000 and 4999 then 'medium' 
when totalorderamount between 5000 and 9999 then 'high' 
when totalorderamount >= 10000 then 'more'  else 'unknown' end as ordercategory
from cte),

 cte3 as(select ordercategory,  count( ordercategory) counte from cte2
group by ordercategory)

select  *, cast(counte*1.00/sum(counte) over() as decimal(4, 2)) as total from cte3
group by ordercategory, counte
order by total desc


--20
with cte as( Select	Customers.CustomerID
 ,Customers.CompanyName	,TotalOrderAmount	=	SUM(Quantity	*	UnitPrice)
 From	Customers	join	Orders	on	Orders.CustomerID	=	Customers.CustomerID
 join	OrderDetails	on	Orders.OrderID	=	OrderDetails.OrderID
 Where	OrderDate	>=	'20160101'
 and	OrderDate		<	'20170101'
 Group	By	Customers.CustomerID
 ,Customers.CompanyName)

 select c.customerid, c.companyname, c.totalorderamount, CustomerGroupName from cte c
 join customergroupthresholds g on g.RangeBottom<=c.totalorderamount and c.TotalOrderAmount<=g.rangetop

 --21
select distinct country from customers
union
select distinct country from suppliers

--22
WITH CTE8 AS (SELECT DISTINCT Country AS CustomerCountry FROM Customers)
SELECT DISTINCT s.Country AS SupplierCountry, cte8.CustomerCountry
FROM Suppliers s
FULL OUTER JOIN CTE8 ON s.Country = cte8.CustomerCountry

--23
select * from customers
select * from suppliers

WITH CTE8 AS (SELECT Country AS CustomerCountry, count(customerid) as totalcustomers FROM Customers group by country),
cte3 as (SELECT  Country AS SupplierCountry, count(supplierid) as totalsuppliers FROM Suppliers group by country)
select coalesce(cte8.customercountry, cte3.suppliercountry) as country,
isnull(cte3.totalsuppliers, 0) as Totalsuppliers,
isnull(cte8.totalcustomers, 0) as Totalcustomers
from cte8
full outer join cte3 on cte8.customercountry=cte3.suppliercountry
order by country

--24
with cte as (Select								
ShipCountry
 ,CustomerID
 ,OrderID
 ,OrderDate	=	convert(date,	OrderDate), ROW_NUMBER() over(partition by shipcountry order by orderdate) as ordere
 From	orders)
 select shipcountry, customerid, orderid, orderdate from cte
 where cte.ordere=1


 --25
 Select	InitialOrder.CustomerID
 ,InitialOrderID	=	InitialOrder.OrderID
 ,InitialOrderDate	=	InitialOrder.OrderDate	,
 NextOrderID	= NextOrder.OrderID
 ,NextOrderDate	=	NextOrder.OrderDate, 
  DaysBetween=datediff(dd,	InitialOrder.OrderDate,	NextOrder.OrderDate)
  from	Orders	InitialOrder	join	Orders NextOrder	on	InitialOrder.CustomerID	=	NextOrder.CustomerID
 where	InitialOrder.OrderID	<	NextOrder.OrderID and datediff(dd,	InitialOrder.OrderDate,	NextOrder.OrderDate)<=5
 Order	by	InitialOrder.CustomerID, InitialOrder.OrderID


 --26
 with cte as (Select	CustomerID,
 OrderDate	=	convert(date,	OrderDate),
 convert(date	,Lead(OrderDate,1)	OVER	(Partition	by	CustomerID	order	by  CustomerID,	OrderDate) ) as Nextorderdate
From	Orders	)
 select customerid, orderdate, nextorderdate, 
  datediff (dd, orderdate, NextOrderDate) as daysbetween
  from cte
  where datediff (dd, orderdate, NextOrderDate)<=5



