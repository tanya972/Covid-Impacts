SELECT Location, continent, date, total_cases, new_cases,total_deaths, population
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
SELECT location, MAX(CAST(total_deaths AS INT)) AS "DeathCount"
FROM CovidDeaths$ cd 
WHERE continent IS NULL --if continent is null, then
GROUP BY continent 
ORDER BY DeathCount DESC; 

--showing highest death count by continent 
SELECT continent, MAX(CAST(total_deaths AS INT)) AS "DeathCount"
FROM CovidDeaths$ cd
WHERE continent is not null 
GROUP BY continent 
ORDER BY DeathCount desc

--global numbers 
SELECT date, SUM(new_cases) as "Total New Cases", SUM(CAST(new_deaths as INT)) AS "DeathCount", (SUM(CAST(new_deaths as INT))/SUM(new_cases))*100 as "DeathPercentage"
FROM CovidDeaths$ cd 
WHERE continent is not null
GROUP BY date 
order by 1, 2 

/*looking at total population vs vaccinations
With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated) as (
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by death.location ORDER BY death.date) as "Rolling_People_Vaccinated"
FROM CovidDeaths$ death
JOIN CovidVaccinations$ vac
ON death.location = vac.location
AND death.date = vac.date
where death.continent is not null 
ORDER BY 1, 2, 3)  */

--Temp Table
DROP Table if exists PercentPopulationVaccinated 
CREATE Table PercentPopulationVaccinated(
	Continent nvarchar(255),
	Location nvarchar(255), 
	Date datetime,
	Population numeric,
	New_Vaccination numeric, 
	Rolling_People_Vaccinated numeric
)

Insert into PercentPopulationVaccinated
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by death.location ORDER BY death.location, death.date) as "Rolling_People_Vaccinated"
FROM CovidDeaths$ death
JOIN CovidVaccinations$ vac
ON death.location = vac.location
AND death.date = vac.date
where death.continent is not null 
ORDER BY 1, 2, 3

SELECT *, (Rolling_People_Vaccinated/Population)*100 as "Percentage Vaccinated" 
FROM PercentPopulationVaccinated 

CREATE View PercentPopulation as 
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by death.location ORDER BY death.location, death.date) as "Rolling_People_Vaccinated"
FROM CovidDeaths$ death
JOIN CovidVaccinations$ vac
ON death.location = vac.location
AND death.date = vac.date
where death.continent is not null 
--ORDER BY 1, 2, 3





