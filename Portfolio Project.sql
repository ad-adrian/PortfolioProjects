SELECT *
FROM PortfolioProject..CovidDeaths
where continent is not null
Order by 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
Order by 3,4;

--This is the data that I will be using in this project.


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
where continent is not null
Order by 1,2


-- Looking at Total case vs Total Deaths
--shoes the likelihood of dying if you contract covid in your country


SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
Order by 1,2


--Total Cases vs Population
--shows what percentage of the population contracted COVID-19 


SELECT Location, date, population,total_cases, (total_cases/population)* 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
Order by 1,2


--Countries with hightest Infection RAte compared to Population


  SELECT Location, population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC;
 

 -- Countries with the highest Death count per population


SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Breaking things down by continent


SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Contintents with the hightest death count per population


SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--Global Numbers 
/*
SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) As total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
--GROUP BY date
ORDER BY 1,2*/

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) As total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
--GROUP BY date
ORDER BY 1,2
--Total Population vs Vaccinations
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3


--CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


--TEMP TABLE
Drop table if exists #PercentPopulationVacinated
Create Table #PercentPopulationVacinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVacinated
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2,3


Select *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVacinated


--Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2,3

Select *
From PercentPopulationVaccinated