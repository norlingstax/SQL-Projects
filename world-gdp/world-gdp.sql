-- look over the datasets
select * from gdp;
select * from country;

-- total gdp of the world 1960-2022
select 
    year,
    gdp_value
from gdp
where country_name = 'World'
order by year asc;

-- top 10 countries according to their gdp in 2000-2022
select 
	rank() over(order by sum(gdp_value) desc) as 'rank',
	country_name,
    sum(gdp_value) as gdp_total
from gdp inner join country using(country_code)
where year > 1999
group by country_name
order by gdp_total desc
limit 10;

-- europian countries' gdp in 2022, descending order
select 
	rank() over(order by gdp_value desc) as 'rank',
	country_name, 
    gdp_value
from gdp
where year = '2022'
	and country_code in 
		(select code 
        from world.country 
        where continent = 'Europe')
order by gdp_value desc;

-- countries with gdp higher than average in the period of 2000-2022
select 
	country_name,
    sum(gdp_value) as gdp_total
from gdp
where year > 1999
	and country_code in
		(select distinct country_code
        from country)
group by country_name
having gdp_total > 
		(select avg(gdp_value) 
        from gdp 
        where country_name = 'World' 
			and year > 1999)
order by gdp_total desc;

# countries and their government form, population, life expectancy ordered according to total gdp since 2010, descending
select distinct mg.country_name, wc.governmentform, wc.population, wc.lifeexpectancy
from myproject.gdp mg inner join world.country wc
	on mg.country_code = wc.code
where year > 2009
group by mg.country_name, wc.governmentform, wc.population, wc.lifeexpectancy
order by sum(mg.gdp_value) desc;

-- list of african countries ordered by gdp in 2022 with a difference from average among them for each country
with africa as (
    select distinct code
    from world.country
    where continent = 'Africa'
),
gdp_filtered as (
    select *
    from gdp g
    inner join africa a
    on g.country_code = a.code
    where g.year = '2022'
),
averages AS (
    select avg(gdp_value) as average
    from gdp_filtered
),
merged as (
    select *
    from gdp_filtered, averages
)
select dense_rank() over(order by gdp_value desc) as 'rank',
    country_name,
    gdp_value,
    round((gdp_value - average), 2) as difference
from merged
group by country_name, gdp_value, average
order by gdp_value desc;
