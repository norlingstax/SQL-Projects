# look over the dataset
select * from bikesales;

# there are null values in some columns, count them
select 'power' as 'column', count(*) as 'null count'
from bikesales
where power is null
union
select 'fuel', count(*) 
from bikesales
where fuel is null
union
select 'gear', count(*) 
from bikesales
where gear is null;

# exam dataset in more detail
select 'year' as 'column', min(year) as min, round(avg(year)) as average, max(year) as max
from bikesales
union
select 'price', min(price), round(avg(price)), max(price)
from bikesales
union
select 'mileage', min(mileage), round(avg(mileage)), max(mileage)
from bikesales
union
select 'power', min(power), round(avg(power)), max(power)
from bikesales;

/*Detail analysis description as per below.
There are a total of 29057 rows and 9 columns in the bikesales table, which is the database for this analysis.

Constraints analysis:
PRIMARY KEY constraint: The id column is designated as the primary key for the table. 
						This ensures that each row in the table is uniquely identified by its id value and prevents duplicate entries.
NOT NULL constraint: The price, mileage, make_model, year, offer_type columns cannot contain NULL values. 
					 This ensures that all required information is present for each sale and prevents incomplete or invalid data in the table.

Column Analysis:
1. id: There are 29057 unique rows.
2. price: The number of rows is 29057, as expected. Prices range from 1 to 888,888,888 (contains outliers and possibly false data).
3. mileage: There are 29057 rows with valus from 0 to 9,999,999. No null values.
4. power: There are 23654 values in this column ranging from 1 to 913595 (contains outliers and possibly false data).
5. make_model: There are 29057 rows with 2165 unique values.
6. year: As expected, there are 29057 rows with years from 1907 to 2022.
7. fuel: There are 2770 missing values in the column. Types of fuel: Gasoline, Two Stroke Gasoline, Electric, Diesel, Electric/Gasoline, LPG, Others.
8. gear: There are 10765 values. Types of gear: Manual, Automatic, Semi-automatic.
9. offer_type: There are five types of offer:  Used, New, Demonstration, Pre-registered, and Antique/Classic. This list contains no null values.*/

# count bikes for each year of production
select year, count(*) as sales
from bikesales
group by year
order by year asc;

# percentage of every offer type
select offer_type, round(count(*) * 100 / sum(count(*)) over(), 2) as percent
from bikesales
group by offer_type
order by percent desc;

# select 10 most expensive bikes with year and offer type
select make_model, year, offer_type, price
from bikesales
order by price desc
limit 10;

# top 10 selling bikes with the average price
select 
	make_model, 
    round(avg(price)) as 'price avg', 
    count(*) as sales
from bikesales
where make_model != 'Others'
group by make_model
order by sales desc
limit 10;

# BMW sales by year with average price and a running total
select 
	year, 
    round(avg(price)) as price_avg,
    count(*) as bmw_sales, 
    (sum(count(*)) over (order by year)) as running_total
from bikesales
where make_model like 'BMW%'
group by year
order by year;

# show average prices for used bikes for each decade
 select 	
	case when year > 2019 then '2020s'
		when year between 2010 and 2020 then '2010s'
        when year between 2000 and 2010 then '2000s'
        when year between 1990 and 2000 then '1990s'
        when year between 1980 and 1990 then '1980s'
        when year between 1970 and 1980 then '1970s'
        when year between 1960 and 1970 then '1960s'
        when year between 1950 and 1960 then '1950s'
        when year between 1940 and 1950 then '1940s'
        when year between 1930 and 1940 then '1930s'
        when year between 1920 and 1930 then '1920s'
        when year between 1910 and 1920 then '1910s'
        else '1900s' end as decade,
     round(avg(price)) as 'price avg'
from bikesales
where offer_type = 'Used'
group by decade
order by decade desc;

# select antique / classic bikes with price above average in this offer type
select * 
from bikesales 
where offer_type = 'Antique / Classic'
	and price > 
		(select avg(price) 
		from bikesales 
		where offer_type = 'Antique / Classic')
order by price desc;

# select the newest and the oldest bikes
select * 
from bikesales
where year in 
		(select min(year)
		from bikesales)
    or year in 
		(select max(year)
        from bikesales);