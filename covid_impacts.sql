SELECT Location, date, total_cases, new_cases,total_deaths, population
FROM CovidDeaths$ cd
ORDER BY 1,2; 

-- Percentage of total deaths 
SELECT location, date, total_cases, total_deaths,(cd.total_deaths / cd.total_cases) * 100 AS "DeathRatePercentage"
FROM CovidDeaths$ cd
ORDER BY 3,4; 

WITH infection_rate AS (
SELECT location, date, total_cases, population,(cd.total_deaths / cd.population) * 100 AS "InfectionRatePercentage"
FROM CovidDeaths$ cd
ORDER BY 3,4)


--Countries with highest infection rate compared to population
SELECT Location, population, MAX(total_cases) AS "HighestInfectionCount", MAX(InfectionRatePercentage) AS "TotalPopulationInfectionRate"
FROM infection_rate
GROUP BY Location, population
ORDER BY TotalPopulationInfectionRate DESC;

--Highest death count per population
SELECT Location, population, MAX(CAST(total_deaths) AS INT) AS "DeathCount"
FROM infection_rate
WHERE continent IS NOT NULL 
GROUP BY Location
ORDER BY TotalDeathCOunt DESC; 


