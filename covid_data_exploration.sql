
select *
from [dbo].[covid_deaths]
order by location, date



-- comparing total cases vs total deaths


with cte as (
select location, date, population, new_cases, cast(total_cases as float) as infected, cast(total_deaths as float) as deaths
from [dbo].[covid_deaths]
where continent is not null
)

select *, (deaths/infected)*100 as death_percentage  from cte
order by 1,2


-- checking what percentage of population got covid in every location


with cte as (
select location, date, population, cast(total_cases as float) as infected
from [dbo].[covid_deaths]
where continent is not null
)

select *, (infected/population)*100 as infected_percentage  from cte
order by 1,2

-- countries with there highest inefection percent and count


with cte as (
select location, population, cast(total_cases as float) as infected
from [dbo].[covid_deaths]
where continent is not null
)

select location, population, max(infected) as highest_inefected, max((infected/population)*100) as infected_percentage  from cte
group by location,population
order by 1,2

--Countries with there highest death count and death percentage


with cte as (
select location, population, cast(total_deaths as float) as death_count
from [dbo].[covid_deaths]
where continent is not null
)

select location, population, max(death_count) as total_Deaths, max((death_count/population)*100) as deathsoverpopulation_perentage  from cte
group by location, population
order by 1


-- Global Numbers

SELECT
	FORMAT(date, 'MMM-yyyy') as monthyear,
    SUM(new_cases) AS TotalNewCases,
    SUM(cast(new_deaths as float)) AS TotalNewDeaths
from [dbo].[covid_deaths]
GROUP By FORMAT(date, 'MMM-yyyy')
ORDER BY 1 asc

-- continent numbers

select location, population,  infected, deaths, (infected/population)*100 as infectedpercentage, (deaths/population)*100 as deathpercentage
from 
	(
	select location, population, continent, max(cast(total_cases as float)) as infected , max(cast(total_deaths as float)) as deaths
	from [dbo].[covid_deaths]
	group by location, population, continent
	) as sub
where continent is null
and location  in ('Asia' , 'Africa' , 'Europe' , 'North America' ,  'South America' , 'Oceania')
order by 1

-- Comparing total population and total vaccination

with cte as (
select location, population, max(cast(people_vaccinated as float)) vaccinatedpopulation
	from [dbo].[covid_deaths]
	where continent is not null
	group by location, population
)
	select *, (vaccinatedpopulation/population) * 100 as population_vaccinated_percentage
	from cte
	order by 1,2

--comparing death percentage and vaccination percentage amongst income groups.

with cte as 
(
select location, population, max(cast(people_vaccinated as float)) as vaccinated, max(cast(total_deaths as float)) as deaths
from [dbo].[covid_deaths]
group by location, population
)
select *,(vaccinated/population)*100 as vaccinated_percentage, (deaths/population)*100 as death_percentage
from cte
where location like '%income%'
order by 1, 2