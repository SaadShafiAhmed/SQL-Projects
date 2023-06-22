SELECT location,date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths(percentage of people who died)
-- Shows the likelihood of dying if you contract Covid in India
SELECT location,date, total_cases, total_deaths, (cast (total_deaths as float)/total_cases)*100 as Death_Percentage 
FROM PortfolioProject..CovidDeaths
where location like 'india'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows the percentage of population got Covid
SELECT location,date, total_cases, population, (total_cases/population)*100 as Percentage_Cases 
FROM PortfolioProject..CovidDeaths
where location like 'cyprus'
ORDER BY 1,2

-- Looking at Countries with highest Infection rate compared to Population
SELECT location, population, MAX((total_cases/population)*100) as Highest_Infection_Rate 
FROM PortfolioProject..CovidDeaths
GROUP BY location,population
order by Highest_Infection_Rate DESC

-- Looking at Countries with highest death percentage compared to Population
SELECT location, population, MAX(cast (total_deaths as float)) as Highest_Total_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location,population
order by Highest_Total_deaths DESC

-- NOW LOOKING AT THINGS FROM CONTINENT POV

SELECT location,date, (cast(total_cases as float)) as total_cases, (cast(total_deaths as float)) as total_deaths , population 
FROM PortfolioProject..CovidDeaths
WHERE location IN ('Europe','Asia','North America','South America','Africa','Oceania')
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths(percentage of people who died)
-- Shows the likelihood of dying if you contract Covid in Asia
SELECT location,date, (cast(total_cases as float)) as total_cases, (cast(total_deaths as float)) as total_deaths , ((cast (total_deaths as float))/(cast(total_cases as float)))*100 as Death_Percentage 
FROM PortfolioProject..CovidDeaths
where location like 'asia'
ORDER BY 2

-- Looking at the time when there was maximum chances of dying if you contract covid in Asia
SELECT location,date, (cast(total_cases as float)) as total_cases, (cast(total_deaths as float)) as total_deaths , ((cast (total_deaths as float))/(cast(total_cases as float)))*100 as Death_Percentage 
FROM PortfolioProject..CovidDeaths
where location like 'asia'
ORDER BY Death_Percentage DESC

-- Looking at Total Cases vs Population
-- Shows the percentage of population got Covid
SELECT location,date, SUM(cast(total_cases as float)) as total_cases, SUM(population) as population, (SUM(cast(total_cases as float))/SUM(population))*100 as Percentage_Cases 
FROM PortfolioProject..CovidDeaths
where location like 'asia'
GROUP BY location,date
ORDER BY 2

-- Looking at Continents with highest Infection rate compared to Population
SELECT location, MAX(population) as population, MAX((total_cases/population)*100) as Highest_Infection_Rate 
FROM PortfolioProject..CovidDeaths
WHERE continent is NULL AND location IN ('Europe','Asia','North America','South America','Africa','Oceania')
GROUP BY location
order by Highest_Infection_Rate DESC

-- Looking at Continents with highest deaths
SELECT location, MAX(population) as Total_Population, MAX(cast (total_deaths as int)) as Highest_Total_deaths
FROM PortfolioProject..CovidDeaths
WHERE location IN ('Europe','Asia','North America','South America','Africa','Oceania')
GROUP BY location
order by Highest_Total_deaths DESC

--GLOBAL NUMBERS
--GENERAL QUERY FOR WORLD
SELECT date,new_cases,total_cases,new_deaths,total_deaths
FROM PortfolioProject..CovidDeaths
WHERE location IN ('World')
ORDER BY 1

SELECT location,population,MAX(cast (total_cases as float)) as total_cases, MAX(cast (total_deaths as float)) as total_deaths
FROM PortfolioProject..CovidDeaths
WHERE location = 'World'
Group BY location,population

-- WORLD DEATH PERCENTAGE
SELECT date,total_cases, total_deaths,((cast (total_deaths as float))/(cast(total_cases as float)))*100 as Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE location IN ('World')
ORDER BY 1

-- LOOKING AT THE TOTAL POPULATION VS ONES VACCINATED

SELECT dea.location,dea.date,dea.population,(cast (vac.total_vaccinations as float)) as total_vaccinations, (cast (vac.new_vaccinations as float)) as new_vaccinations
FROM PortfolioProject..CovidDeaths dea JOIN PortfolioProject..CovidVaccinations vac ON dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL AND dea.location = 'India'

-- PERCENTAGE OF POPULATION VACCINATED FULLY 

SELECT dea.location,dea.date,dea.population, Cast (vac.people_fully_vaccinated as float) as people_fully_vaccinated , ((cast (vac.people_fully_vaccinated as float))/dea.population)*100 as Vaccinated_Percentage
FROM PortfolioProject..CovidDeaths dea JOIN PortfolioProject..CovidVaccinations vac ON dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL AND dea.location = 'India' 

-- CREATING VIEW FOR STROING DATA FOR LATER VISUALISATIONS

CREATE VIEW POPULATION_FULLY_VACCINATED AS
SELECT dea.location,dea.date,dea.population, Cast (vac.people_fully_vaccinated as float) as people_fully_vaccinated , ((cast (vac.people_fully_vaccinated as float))/dea.population)*100 as Vaccinated_Percentage
FROM PortfolioProject..CovidDeaths dea JOIN PortfolioProject..CovidVaccinations vac ON dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL AND dea.location = 'India' 
