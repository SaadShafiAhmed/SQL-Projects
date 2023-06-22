/*

Queries used for Tableau Project

*/



-- 1. 

SELECT population,MAX(cast (total_cases as float)) as total_cases, MAX(cast (total_deaths as float)) as total_deaths, MAX(((cast (total_deaths as float))/(cast(total_cases as float)))*100) as Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE location IN ('World')
Group BY location,population


-- 2. 


SELECT location,population, MAX(cast (total_deaths as float)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE location IN ('Europe','Asia','North America','South America','Africa','Oceania')
Group BY location,population
ORDER BY TotalDeathCount DESC


-- 3.

Select Location, Population, MAX(cast (total_cases as float)) as HighestInfectionCount,  Max((cast (total_cases as float)/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) OVER (PARTITION BY date) as HighestInfectionCount,  Max((total_cases/population))*100  OVER (PARTITION BY date) as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
