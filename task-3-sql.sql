-- #1
select category.name, count(film_id)
from category join film_category using(category_id)
group by category.name;

-- #2
select actor.first_name, actor.last_name 
from actor 
	join film_actor using(actor_id)
	join film using(film_id)
group by 1, 2
order by sum(film.rental_duration) desc
limit 10;

-- #3
select category.name
from category
    join film_category using(category_id)
    join film using(film_id)
group by category.name
order by sum(film.replacement_cost) desc
limit 1;

-- #4
select film_id
from film left join inventory using(film_id)
group by film_id
having count(*) = 1;

-- #5
with temp_table as (
	select first_name, last_name, count(*) as num
	from actor
		join film_actor using(actor_id)
		join film_category using(film_id)
		join category using(category_id)
	where category.name = 'Children' 
	group by first_name, last_name
    order by 3 desc
    ) 
select * from temp_table
having count(*) in (select num from temp_table limit 3)
order by 3 desc;

-- #6
select city, sum(active) as active_clients, count(active) - sum(active) as inactive_clients
from city
	join address using(city_id)
    join customer using(address_id)
group by city
order by 3 desc;

-- #7
with temp as (
	select name as category, rental_date as d1, return_date as d2, city
    from city
		join address using(city_id)
        join customer using(address_id)
        join rental using(customer_id)
        join inventory using(inventory_id)
        join film_category using(film_id)
        join category using(category_id)
	where return_date is not null
)
(select category, sum(d2 -d1) as hours
from temp
where city like '%a%'
group by category
order by 2 desc
limit 1
)
union all
(select category, sum(d2 - d1)
from temp
where city like '%-%'
group by category
order by 2
limit 1);





