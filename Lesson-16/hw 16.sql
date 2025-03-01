--hw 16
CREATE TABLE #Consecutives
(
     Id VARCHAR(5)  
    ,Vals INT /* Value can be 0 or 1 */
)
GO
 
INSERT INTO #Consecutives VALUES
('a', 1),
('a', 0),
('a', 1),
('a', 1),
('a', 1),
('a', 0),
('b', 1),
('b', 1),
('b', 0),
('b', 1),
('b', 0)
GO

select * from #Consecutives

with cte as(
select id, count(*) + 1 as num from #Consecutives where id = 'a' group by id 
union all
select id, count(*) + 1 as num from #Consecutives where id = 'b' group by id),
cte2 as(
select id, isnull(lag(Vals) over(partition by id order by Vals), Vals) as Vals from #Consecutives)
select c2.id, num, count(Vals) as consecutive from cte2 as c2
join cte as c on c2.id = c.id
where Vals <> 0 group by c2.id, num
order by id