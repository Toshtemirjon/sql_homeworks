--hw 15
create table #EmptySeats(Number int, Empty varchar(1))

insert into #EmptySeats values (1, 'Y'), (2, 'N'), (3, 'N'), (4, 'Y'), (5, 'Y'), (6, 'Y'), (7, 'N'),
(8, 'Y'), (9, 'Y'), (10, 'Y'), (11, 'N'), (12, '')

select * from #EmptySeats

--Find 3 successive empty seats



with cte as(
select *, lag(empty, 1) over (order by number) as preone, lag(empty, 2) over (order by number) as pretwo,
lead(empty, 1) over (order by number) afterone, lead(empty, 2) over (order by number) aftertwo
from #Emptyseats), cte2 as(
select *, number - row_number() over(order by number) rn from cte
where (empty = 'Y' and preone = 'Y' and pretwo = 'Y') or (empty = 'Y' and preone = 'Y' and afterone = 'Y')
or (empty = 'Y' and afterone = 'Y' and aftertwo = 'Y'))
select string_agg(number, ' - ') as EmptySeats from cte2
group by rn