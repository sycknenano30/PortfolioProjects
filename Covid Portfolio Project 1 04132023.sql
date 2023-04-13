--Select *
--From CovidDeaths
--order by 3, 4

--Select *
--From CovidVaccinations
--order by 3, 4

Select *
From CovidDeaths
Order by Location

Select Location, Date, TotalCases, new_cases, TotalDeaths, Population
From CovidDeaths
Where Location not like '%income%' and Continent is null
order by 1, 2

--Taking a look at Total Cases vs Total Deaths
--Shows the Covid Mortality Rate in the Philippines

Select Location, Date, TotalCases, TotalDeaths, (TotalDeaths/TotalCases)*100 as MortalityRate
From CovidDeaths
Where Location = 'Philippines'
order by 1, 2

--Total Cases vs Population
--Shows the Covid Infection Rate in the Philippines

Select Location, Date, TotalCases, Population, (TotalCases/Population)*100 as InfectionRate
From CovidDeaths
Where Location = 'Philippines'
order by 1, 2

--Looking at Countries with the Highest Infection Rate

Select Location, Max (TotalCases) as MaximumTotalCase, Population, Max((TotalCases/Population))*100 as InfectionRate
From CovidDeaths
Where Location not like '%income%' and Continent is null
Group by Location, Population
order by InfectionRate Desc

--Comparing Countries with their Highest Death Count

Select Location, Max (TotalDeaths) as MaximumTotalDeaths
From CovidDeaths
Where Location not like '%income%' and Continent is null
Group by Location
order by Location

--Comparing Continents with their Highest Death Count

Select Continent, Max (TotalDeaths) as TotalDeathsPerContinent
From CovidDeaths
Where Location not like '%income%' and Continent is not null
Group by Continent
order by Continent

--Showing the Global Numbers

Select Sum(new_cases) GlobalCases, Sum(new_deaths) GlobalDeaths, (Sum(new_deaths)/Sum(new_cases))*100 GlobalMortalityRate
From CovidDeaths
Where Location not like '%income%' and Continent is not null

--Looking at Total Population vs Vaccinations as of April 6, 2023

With PopvsVac (Continent, Location, Date, Population, NewVaccination, AccumulativeVaccinationCount) as
(
Select dea.Continent, dea.Location, dea.Date, Population, NewVaccinations
, Sum(NewVaccinations) over (Partition by dea.Location order by dea.Location, dea.Date) as AccumulativeVaccinationCount
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.Location = vac.location
	and dea.Date = vac.date
Where dea.Continent is not null
)
Select Location, Max(AccumulativeVaccinationCount/Population)*100 as CurrentVaccinationRate
From PopvsVac
Group by Location

Select *
From CurrentVaccinationRate

Create View CurrentVaccinationRate as
With PopvsVac (Continent, Location, Date, Population, NewVaccination, AccumulativeVaccinationCount) as
(
Select dea.Continent, dea.Location, dea.Date, Population, NewVaccinations
, Sum(NewVaccinations) over (Partition by dea.Location order by dea.Location, dea.Date) as AccumulativeVaccinationCount
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.Location = vac.location
	and dea.Date = vac.date
Where dea.Continent is not null
)
Select Location, Max(AccumulativeVaccinationCount/Population)*100 as CurrentVaccinationRate
From PopvsVac
Group by Location