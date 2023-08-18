SELECT *
FROM CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract Covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE Location = 'Nigeria'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows the percentage of population that have Covid


SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PopulationPercentage
FROM CovidDeaths
--WHERE Location = 'Nigeria'
ORDER BY 1,2

--Looking at Countries with the highest infection rate compared to population

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PopulationPercentageInfected
FROM CovidDeaths
--WHERE Location = 'Nigeria'
GROUP BY Location, Population
ORDER BY PopulationPercentageInfected desc

--Showing Countries with the Highest Death Count per Population

SELECT Location, MAX(Total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE Continent is not null
--WHERE Location = 'Nigeria'
GROUP BY Location
ORDER BY TotalDeathCount desc

-- Breaking it Down by Continent

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE Continent is not null
--WHERE Location = 'Nigeria'
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Showing Continents with the Highest Death Count per Population

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE Continent is not null
--WHERE Location = 'Nigeria'
GROUP BY continent
ORDER BY TotalDeathCount desc


-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
-- WHERE Location = 'Nigeria'
WHERE Continent is not null
GROUP BY date
ORDER BY 1,2


SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
-- WHERE Location = 'Nigeria'
WHERE Continent is not null
--GROUP BY date
ORDER BY 1,2


-- Looking at Total Population vs Vaccination

SELECT *
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT *
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea
JOIN Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


-- USE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
Select *
From PopvsVac


WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



--TEMP TABLE

CREATE TABLE #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert Into #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentagePopulationVaccinated


-- Creating View to Store Data for Later Visualizations

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3


Select *
From PercentPopulationVaccinated