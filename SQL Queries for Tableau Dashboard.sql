/*

Queries used for Tableau Project

*/



-- 1. Global Numbers

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From Covid_Project..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--2.Showing Continents with Highest Death Count

select continent, max(total_deaths)as TotalDeathCount
from Covid_Project..CovidDeaths
--where location like '%India'
group by continent
order by TotalDeathCount desc

--3. Countries with Highest Infection Rate compared to Population

select location,population,max(total_cases) as HighestInfectionCount,max(cast(total_cases as float) / cast(population as float) * 100) AS PercentPopulationInfected
from Covid_Project..CovidDeaths
--where location like '%India'
group by location,population
order by PercentPopulationInfected desc

--4.Countries with Highest Infection Rate compared to Population and Date

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_Project..CovidDeaths
--Where location like '%states%'
Group by Location, Population,date
order by PercentPopulationInfected desc

--5. Total Vaccination per continent
Select continent,location,total_vaccinations
From Covid_Project..CovidVaccinations 