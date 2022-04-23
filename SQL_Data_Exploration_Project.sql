-- Viewing the Covid Deaths Dataset
select * 
from PortfolioProject..Covid_Deaths
where continent is not null
order by 3,4

--select * 
--from PortfolioProject..Covid_Vaccinations
-- where continent is not null
--order by 3,4

-- Exploring the Dataset
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..Covid_Deaths
where continent is not null
order by 1,2

-- Total Cases vs Total Deaths in United States
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from PortfolioProject..Covid_Deaths
where location like '%states%' and continent is not null
order by 1,2

-- Total Cases vs Population in United States
select location, date, population, total_cases, (total_cases/population)*100 as infected_percentage
from PortfolioProject..Covid_Deaths
where location like '%states%' and continent is not null
order by 1,2

-- Countries with highest infection count compared to population
select location, population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 as percent_population_infected
from PortfolioProject..Covid_Deaths
where continent is not null
group by location, population
order by percent_population_infected desc

-- Countries with highest death count compared to population
select location, max(cast (total_deaths as int)) as total_death_count
from PortfolioProject..Covid_Deaths
where continent is not null
group by location
order by total_death_count desc

-- By Continent
select continent, max(cast (total_deaths as int)) as total_death_count
from PortfolioProject..Covid_Deaths
where continent is not null
group by continent
order by total_death_count desc

-- Global Numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from PortfolioProject..Covid_Deaths
where continent is not null
group by date
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from PortfolioProject..Covid_Deaths
where continent is not null
order by 1,2


-- Joining the two tables
Select * 
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

-- Total Population vs Vaccinations
-- Use CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, rolling_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location Order by dea.location, dea.date) as rolling_people_vaccinated
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 2,3
)
Select *, (rolling_people_vaccinated/Population)*100
From PopvsVac

-- With CTE
With PopvsVac
as


-- Temporary Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255), 
Date datetime,
Population numeric,
New_Vaccinations numeric,
rolling_people_vaccinated numeric
)

Insert into  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location Order by dea.location, dea.date) as rolling_people_vaccinated
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 2,3

Select *, (rolling_people_vaccinated/Population)*100 
From #PercentPopulationVaccinated


-- Creating Views for Data Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location Order by dea.location, dea.date) as rolling_people_vaccinated
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 