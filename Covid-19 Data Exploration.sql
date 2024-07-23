/* 
COVID-19 Worldwide Data Exloration

Using -  Aggregate functions, Converting data types, Joins, CTE, Temp Tables, Windows functions
*/

--1.Exploring the Covid Deaths Data

select * 
from Covid_Project..[CovidDeaths]
where continent is not null
order by 3,4

--2.select data that we are going to be using

select location,date, total_cases,new_cases,total_deaths,population
from Covid_Project..[CovidDeaths]
order by 1,2

--Looking at total cases vs total deaths
--3.Shows likelihood of dying if you contract covid into your country

select location,date,total_cases,total_deaths,(total_deaths/(nullif(total_cases,0)))*100 AS DeathPercentage
from Covid_Project..CovidDeaths
where location like '%India'
order by 1,2

--Looking at total cases vs population
--4.Shows what percentage of population got covid

select continent,location,date,population,total_cases,(total_cases/population)*100 AS PercentPopulationInfected
from Covid_Project..CovidDeaths
--where location like '%India'
order by 1,2

--5.Looking at Countries with Highest Infection Rate compared to Population

select location,population,max(total_cases) as HighestInfectionCount,max(cast(total_cases as float) / cast(population as float) * 100) AS PercentPopulationInfected
from Covid_Project..CovidDeaths
--where location like '%India'
group by location,population
order by PercentPopulationInfected desc


--6.Showing Countries with Highest Death Count and Highest Death rate per Population

select location, Population, max(total_deaths)as HighestDeathCount, MAX((total_deaths * 1.0/population)*100) as PercentPopulationDied
from Covid_Project..CovidDeaths
--where location like '%India'
group by location,population
order by HighestDeathCount desc

--7.Showing Continents with Highest Death Count

select continent, max(total_deaths)as TotalDeathCount
from Covid_Project..CovidDeaths
--where location like '%India'
group by continent
order by TotalDeathCount desc

-- 7.Global cases for each day

SELECT date, SUM(new_cases) as total_newcases, sum(new_deaths) as total_newdeaths, 
    case
        WHEN SUM(new_cases) <> 0 THEN SUM(new_deaths)*1.0/SUM(new_cases)*100 
        ELSE NULL
    END AS death_rate
FROM Covid_Project..CovidDeaths
WHERE Continent is not NULL
GROUP BY DATE
Order by date 

--8.Global Numbers

select sum(new_cases) as total_cases1,sum(new_deaths) as total_deaths1,sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from Covid_Project..CovidDeaths
order by 1,2


--9. Total Vaccination per continent
Select continent,location,total_vaccinations
From Covid_Project..CovidVaccinations 

--10.Looking at Total Population vs Vaccinations(To change data type can use cast or convert)

WITH PopVsVac (continent, location, date, population,  new_vaccinations, RollingCountofPeopleVaccinated)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(new_vaccinations AS BIGINT))
OVER (PARTITION BY dea.location order by dea.location, dea.date) AS RollingCountofPeopleVaccinated
FROM Covid_Project..CovidDeaths dea
JOIN Covid_Project..CovidVaccinations vac 
    ON dea.location = vac.location AND dea.date = vac.date
where dea.continent IS NOT NULL)
SELECT *, (RollingCountofPeopleVaccinated*1.0/population) * 100 AS PercentageofVaccinatedPeople
FROM PopVsVac










