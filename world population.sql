-- rename the table and change the column name
rename table `api_sp.pop.grow_ds2_en_csv_v2_2594848` to `world_population`;

alter table `world_population`
change column `ï»¿Country Name` `Country Name` text;

-- delete the extra row 
delete from `world_population`
where `Country Name` = 'ï»¿Country Name';

-- 1. find the country with the highest population in the most recent year (2023)
select 
    `country name`, 
    `country code`, 
    `2023` as population 
from `world_population` 
order by `2023` desc 
limit 1;

-- 2. find the country with the lowest population in the most recent year (2023)
select 
    `country name`, 
    `country code`, 
    `2023` as population 
from `world_population` 
order by `2023` asc 
limit 1;

-- 3. calculate the average population growth rate per decade (1961-2023)
select 
    `country name`, 
    `country code`, 
    (avg(`2020`) - avg(`2010`)) / avg(`2010`) * 100 as growth_rate_2010_2020, 
    (avg(`2010`) - avg(`2000`)) / avg(`2000`) * 100 as growth_rate_2000_2010, 
    (avg(`2000`) - avg(`1990`)) / avg(`1990`) * 100 as growth_rate_1990_2000, 
    (avg(`1990`) - avg(`1980`)) / avg(`1980`) * 100 as growth_rate_1980_1990 
from `world_population` 
group by `country name`, `country code`;

-- 4. identify countries with a declining population over the past decade (2013-2023)
select 
    `country name`, 
    `country code`, 
    `2013` as population_2013, 
    `2023` as population_2023, 
    (`2023` - `2013`) as population_change 
from `world_population` 
where `2023` < `2013` 
order by population_change asc;

-- 5. find the top 5 countries with the highest average annual growth rate from 2000 to 2020
select 
    `country name`, 
    `country code`, 
    ((avg(`2020`) - avg(`2000`)) / avg(`2000`)) / 20 * 100 as annual_growth_rate 
from `world_population` 
group by `country name`, `country code` 
order by annual_growth_rate desc 
limit 5;

-- 6. find the population of a specific country (e.g., 'India') over the last 5 years (2018-2023)
select 
    `country name`, 
    `country code`, 
    `2018` as population_2018, 
    `2019` as population_2019, 
    `2020` as population_2020, 
    `2021` as population_2021, 
    `2022` as population_2022, 
    `2023` as population_2023 
from `world_population` 
where `country name` = 'India';

-- 7. determine the average population for each continent, assuming you have a continent column in a related table
-- note: this assumes you have another table with country codes and continents.
select 
    c.continent, 
    avg(p.`2023`) as avg_population_2023 
from `world_population` p
join `continent_table` c on p.`country code` = c.`country code`
group by c.continent 
order by avg_population_2023 desc;

-- 8. calculate the total population change from 1961 to 2023 for each country
select 
    `country name`, 
    `country code`, 
    (`2023` - `1961`) as total_population_change 
from `world_population` 
order by total_population_change desc;

-- 9. find countries with stable populations (less than 1% change) over the past 10 years (2013-2023)
select 
    `country name`, 
    `country code`, 
    `2013` as population_2013, 
    `2023` as population_2023, 
    (abs(`2023` - `2013`) / `2013`) * 100 as percentage_change 
from `world_population` 
where (abs(`2023` - `2013`) / `2013`) * 100 < 1 
order by percentage_change;
