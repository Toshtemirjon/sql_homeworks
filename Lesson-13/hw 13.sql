use W3Resource
--hw 13
--Nematov Toshtemir

--1
select * from inventory.Salesman
select * from inventory.Orders

select ord_no, purch_amt, ord_date, customer_id, s.salesman_id
from inventory.salesman s
join inventory.orders o on o.salesman_id=s.salesman_id 
where s.name='Paul Adam'

select * from inventory.orders
where salesman_id= (select salesman_id from inventory.salesman where name='paul adam')

--2
select ord_no, purch_amt, ord_date, customer_id, s.salesman_id
from inventory.salesman s
join inventory.orders o on o.salesman_id=s.salesman_id 
where s.city='london'

select * from inventory.orders
where salesman_id in ( select salesman_id from inventory.salesman where city='london')

--3
select * from inventory.orders o
where salesman_id=(select salesman_id from inventory.orders r where customer_id=3007)

--4
select * from inventory.orders
where purch_amt>(select avg(purch_amt) from inventory.orders where ord_date='2012-10-10')

--5
select * from inventory.orders
where salesman_id in (select salesman_id from inventory.salesman where city='new york')

--6
SELECT commission
FROM inventory.salesman
WHERE salesman_id In
 (SELECT salesman_id FROM inventory.customer WHERE city = 'Paris')

 --7
 select * from inventory.customer
 where customer_id=(select salesman_id-2001 from inventory.salesman where name='mc lyon')

 --8
 select * from inventory.customer
 select count(*) as count, grade 
 from inventory.customer
 group by grade
 having grade>(select avg(grade) from inventory.Customer where city='new york')

 --9
 select ord_no, purch_amt, ord_date, salesman_id
 from inventory.orders
 where salesman_id in ( select salesman_id from inventory.Salesman where commission=(select max(commission) from inventory.salesman))

 --10
 select * from Inventory.Customer
 select o.*, c.cust_name 
 from inventory.orders o  join inventory.customer c on o.salesman_id=c.salesman_id
 where ord_date='2012-08-17'

 select o.*, c.cust_name
 from inventory.orders o, inventory.customer c
 where o.customer_ID=c.customer_id and ord_date='2012-08-17'
 
 --11
 select salesman_id, name
 from inventory.salesman s
where  1<(select count(salesman_id) from inventory.customer c where c.salesman_id=s.salesman_id)

--12
select * from inventory.orders o
where o.purch_amt> (SELECT AVG(purch_amt) FROM inventory.orders r 
WHERE r.customer_id = o.customer_id)

--13
select * from inventory.orders o
where o.purch_amt>= (SELECT AVG(purch_amt) FROM inventory.orders r 
WHERE r.customer_id = o.customer_id)

--14
select sum(purch_amt), ord_date
from inventory.orders o 
group by ord_date 
having sum(purch_amt)>(SELECT 1000.00 + MAX(purch_amt) FROM inventory.orders r WHERE o.ord_date = r.ord_date)

--15
select customer_id, cust_name, city
from inventory.customer
where exists (select * from inventory.orders where city='london')

--16
select * from inventory.salesman s
where 1<(select count(c.salesman_id) from inventory.customer c where s.salesman_id=c.salesman_id)


SELECT * FROM inventory.salesman 
WHERE salesman_id IN ( SELECT DISTINCT salesman_id 
FROM inventory.customer a 
WHERE EXISTS ( SELECT * FROM inventory.customer b 
WHERE b.salesman_id = a.salesman_id 
AND b.cust_name <> a.cust_name))

--17
SELECT * FROM inventory.salesman 
WHERE salesman_id IN ( SELECT DISTINCT salesman_id 
FROM inventory.customer a 
WHERE NOT EXISTS ( SELECT * FROM inventory.customer b 
WHERE b.salesman_id = a.salesman_id 
AND b.cust_name <> a.cust_name))

--18
select * from inventory.salesman s
where 1<(select count(ord_no) from inventory.orders o where s.salesman_id=o.salesman_id)

select * from inventory.salesman s
where exists (select * from inventory.customer c where s.salesman_id=c.salesman_id
and 1<(select count(ord_no) from inventory.orders o where o.customer_id=c.customer_id))

--19
select * from inventory.salesman s
where city=any( select city from inventory.customer)

--20
select * from inventory.salesman s
where city in (select city from inventory.customer)

--21
select * from inventory.salesman s
where exists (select * from inventory.customer c where s.name < c.cust_name )

--22
select * from inventory.customer c
where grade>any(select grade from inventory.customer c where city<'new york')

--23
select * from inventory.orders
where purch_amt>any(select purch_amt from inventory.orders where ord_date='2012-09-10')

--24
select * from inventory.orders o
where purch_amt<any(select purch_amt from inventory.orders o, inventory.customer c
WHERE  o.customer_id = c.customer_id AND c.city = 'London')

--25
select * from inventory.orders o
where purch_amt<(select max(purch_amt) from inventory.orders o, inventory.customer c where o.customer_id=c.customer_id and c.city='london')

--26
select * from inventory.customer c
where grade>all(select grade from inventory.customer where city='new york')

--27
select s.name, s.city, subquery.total
from inventory.salesman s, (select salesman_id, sum(purch_amt) as Total from inventory.orders group by salesman_id) subquery
where subquery.salesman_id=s.salesman_id 
and s.city in ( select city from inventory.customer)

--28
select * from inventory.customer
where grade<> all(select grade from inventory.customer where city='london' and not grade is null)

--29
select * from inventory.customer
where grade <> all(select grade from inventory.customer where city='paris')

select * from inventory.customer
where grade not in (select grade from inventory.customer where city='paris')

--30
select * from inventory.customer
where not grade = any (select grade from inventory.customer where city='dallas')

select * from inventory.customer
where grade not in (select grade from inventory.customer where city='dallas')

select * from inventory.customer
where grade <>all(select grade from inventory.customer where city='dallas')

/*--31        There is no table called company_mast
select * from item_mast
select * from company_mast
select avg(pro_price), c.name
from item_mast m, company_mast mm where m.pro_id=mm.pro_id
group by c.name   */

--32  there is not table called company_mast in this database

--33  there is not table called company_mast in this database
/*SELECT m.pro_price, m.pro_name, mm.com_name
FROM item_mast m, company_mast mm
WHERE m.pro_id = mm.com_id
AND m.pro_price = (SELECT MAX(pro_price) FROM item_mast WHERE pro_id = company_mast.com_id);*/

--34
select * from emp_details
where emp_lname='gabriel' or emp_lname='dosio'

select * from emp_details
where emp_lname=any(select emp_lname from emp_details where emp_lname in ('gabriel', 'dosio'))

--35
select * from emp_details
where emp_dept in(89,63)

/*--36   emp_department table has not same data
select * from emp_details d, emp_department e
where d.emp_dept=e.dpt_code and
e.dpt_allotment>50000 */

--37
select * from employee.department
--38, 39 ,37 emp_department is shortage for working queries



