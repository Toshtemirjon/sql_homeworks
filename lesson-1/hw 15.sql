---hw 14 Nematov

--1 From the following table, write a SQL query to find the actors who played a role in the movie 'Annie Hall'. Return all the fields of actor table.
select * from movies.movie_cast
select * from movies.actor
select * from movies.Movie

SELECT *  FROM movies.actor 
WHERE act_id IN( SELECT act_id  FROM movies.movie_cast 
WHERE mov_id IN (SELECT mov_id FROM movies.movie 
WHERE mov_title='Annie Hall'))

--2 From the following tables, write a SQL query to find the director of a film that cast a role in 'Eyes Wide Shut'. Return director first name, last name.
select * from movies.Director
select * from movies.Movie_Direction
select * from movies.movie_cast

select * from movies.director d
where dir_id in (select dir_id from movies.movie_direction dd where   mov_id in 
(select mov_id from movies.movie_cast m where m.mov_id in (select mov_id from movies.movie where mov_title='eyes wide shut')))


--3  From the following table, write a  SQL query to find those movies that have been released in countries other than the United Kingdom. Return movie title, movie year, movie time, and date of release, releasing country.          
select * from movies.movie

select mov_title, mov_year, mov_time, mov_dt_rel, mov_rel_country from movies.movie
where mov_rel_country<>'UK'

--4 From the following tables, write a SQL query to find for movies whose reviewer is unknown. Return movie title, year, release date, director first name, last name, actor first name, last name.
select * from movies.movie
select * from movies.actor
select * from movies.director
select * from movies.movie_direction
select * from movies.movie_cast
select * from movies.reviewer
select * from movies.rating
select mov_title, mov_year, mov_dt_rel, dir_fname, dir_lname, act_fname, act_lname
from movies.movie a, movies.movie_direction b, movies.director c, 
movies. rating d, movies.reviewer e, movies.actor f, movies.movie_cast g
where a.mov_id=b.mov_id and b.dir_id=c.dir_id and a.mov_id=d.mov_id 
and d.rev_id=e.rev_id and a.mov_id=g.mov_id and g.act_id=f.act_id 
and e.rev_name is null

--5
--From the following tables, write a SQL query to find those movies directed by the director
--whose first name is Woddy and last name is Allen. Return movie title.
select * from movies.director
select * from movies.movie
select * from movies.movie_direction
select mov_title from movies.movie m 
where mov_id=(select mov_id from movies.movie_direction md where dir_id=
(select dir_id from movies.director d where dir_fname='Woddy' and dir_lname='Allen'))


select mov_title from movies.movie m 
join movies.movie_direction md on m.mov_id=md.mov_id
join movies.director d on md.dir_id=d.dir_id
where dir_fname ='Woddy' and dir_lname= 'Allen'

--6
select distinct mov_year from movies.movie m 
where mov_id=any(select mov_id from movies.rating r where rev_stars>3)
order by mov_year asc

--7
--From the following table, write a SQL query to search for movies that do not have any ratings. Return movie title.
select distinct mov_title from movies.movie m 
where mov_id not in ( select mov_id from movies.rating r)

--8
select rev_name from movies.reviewer r
where rev_id in(select rev_id from movies.rating rr where rev_stars is null) 

--9
select r.rev_name, b.mov_title, a.rev_stars
from movies.reviewer r, movies.rating a, movies.movie b
where b.mov_id=a.mov_id and r.rev_id=a.rev_id
and r.rev_name is not null and a.rev_stars is not null
order by rev_name, mov_title, rev_stars

--10
select r.rev_name, m.mov_title
from movies.reviewer r, movies.rating rr, movies.movie m, movies.rating r2
where m.mov_id=rr.mov_id and r.rev_id=rr.rev_id
and rr.rev_id=r2.rev_id
group by rev_name, mov_title
having count(*)>1

--11
select m.mov_title, max(r.rev_stars) Ratingstars from movies.movie m, movies.rating r
where m.mov_id=r.mov_id and r.rev_stars is not null
group by m.mov_title
order by m.mov_title asc

--12
select rev_name from movies.reviewer r
where rev_id=(select rev_id from movies.rating r where mov_id=
(select mov_id from movies.movie where mov_title='American Beauty'))

--13
select mov_title from movies.movie
where mov_id in (select mov_id from movies.rating where rev_id not in
(select rev_id from movies.reviewer where rev_name='Paul Monks'))

--14
select r.rev_name, m.mov_title, rr.rev_stars
from movies.reviewer r join movies.rating rr on r.rev_id=rr.rev_id
join movies.movie m on m.mov_id=rr.mov_id
where rr.rev_stars=(select min(rev_stars) from movies.rating)
order by rev_stars asc

--15
select mov_title from movies.movie m 
where mov_id in (select mov_id from movies.movie_direction 
where dir_id in (select dir_id from movies.director 
where dir_fname='James' and dir_lname='Cameron'))

--16
select * from movies.movie m 
where mov_id in ( select mov_id from movies.movie_cast 
where act_id in (select act_id from movies.movie_cast 
group by act_id having count(act_id)>1))

