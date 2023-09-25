# create table for the database
create schema myproject;
use myproject;
create table `emissions` (
	id int primary key,
    country text,
	year int,
	rate float);

# look over the dataset
select * from emissions;

# check if there are any columns that have null values
select * 
from emissions
where country is null;

select * 
from emissions
where year is null;

select * 
from emissions
where rate is null;

# exam dataset in more detail
select min(year), max(year)
from emissions;

select distinct country
from emissions;

# select top 10 countries according to their emissions in 2021
select country, rate
from emissions
where year = '2021'
order by rate desc
limit 10;

#select top 10 countries according to their emissions in 1990-2021
select 
	country, 
    round(sum(rate), 2) as emissions
from emissions
group by country
order by emissions desc
limit 10;

# select annualy emissions by france 1990-2021
select year, rate
from emissions
where country = 'France'
order by year asc;

# select annualy emissions by french overseas territories 1990-2021 in total
update emissions
set country = 'Reunion'
where country = 'RГ©union';

select 
	year, 
	round(sum(rate), 2) as emissions
from emissions
where country = 'French Guiana'
	or country = 'French Polynesia'
    or country = 'Martinique'
    or country = 'Guadeloupe'
    or country = 'Reunion'
    or country = 'Saint Pierre and Miquelon'
    or country = 'New Caledonia'
group by year
order by year asc;

# select max emission and its year for top 50 countries    
select e.country, e.rate, e.year
from emissions e
inner join
    (select country, max(rate) as max_em
    from emissions 
    group by country) copy 
ON e.country = copy.country 
and e.rate = copy.max_em
order by rate desc
limit 50;

# select min emission and its year for top 50 countries   
select e.country, e.rate, e.year
from emissions e
inner join
    (select country, min(rate) as min_em
    from emissions 
    group by country) copy 
ON e.country = copy.country 
and e.rate = copy.min_em
order by rate desc
limit 50;

# select max and min China's emissions and their respective years
select rate, year
from emissions
where country = 'China'
and ((rate = 
		(select max(rate) 
        from emissions
        where country = 'China'))
	or (rate = 
		(select min(rate)
		from emissions
		where country = 'China')))