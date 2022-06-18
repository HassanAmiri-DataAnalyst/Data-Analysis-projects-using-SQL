-- Query 1
-- Total Cases Vs Total Deaths
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..Covid_Deaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--Query 2
-- Total Death Count bases on Continents
Select Location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
Where continent is null 
and location not in ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income', 'Low Income')
Group by location
order by TotalDeathCount desc

-- Query 3
-- Total infections per country as compared to its population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Covid_Deaths
Group by Location, Population
order by PercentPopulationInfected desc

-- Query 4

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Covid_Deaths
Group by Location, Population, date
order by PercentPopulationInfected desc