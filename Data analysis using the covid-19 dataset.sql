
SELECT location, date, population, median_age, total_cases, new_cases, total_deaths
FROM `tidal-fusion-410712.covid19.CovidDeaths`
order by 1,2


--Looking at total cases vs total deaths
select location, date, population, median_age, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as deathrate
FROM `tidal-fusion-410712.covid19.CovidDeaths`
order by 1,2


--Looking at total cases vs population

select location, date, population, total_cases, total_deaths, (total_cases/population)*100 as infectionrate
FROM `tidal-fusion-410712.covid19.CovidDeaths`
order by 1,2


--Looking at country with highest infection rate per population

select location, population, max(total_cases) as maxCases, max((total_cases/population))*100 as maxInfectionrate
FROM `tidal-fusion-410712.covid19.CovidDeaths`
GROUP BY 1,2
order by maxInfectionrate desc


--Countries with highest death count per population

select location, population, max(total_deaths) as maxdeathcount, max((total_deaths/population))*100 as maxdeathrate
FROM `tidal-fusion-410712.covid19.CovidDeaths`
where continent is not null
GROUP BY 1,2
order by maxdeathcount desc


--Looking at continents with the highest death count 

select continent, max(total_deaths) as maxdeathcount, max((total_deaths/population))*100 as maxdeathrate
FROM `tidal-fusion-410712.covid19.CovidDeaths`
where continent is not null
GROUP BY continent
order by maxdeathcount desc


-- Global numbers

SELECT 
  SUM(new_cases) AS total_cases, 
  SUM(new_deaths) AS total_deaths, 
  (SUM(new_deaths)/SUM(new_cases)) * 100 AS death_rate
FROM `tidal-fusion-410712.covid19.CovidDeaths`
where continent is not null


--Looking at total vaccinations vs population

with tt1 as (
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
FROM `tidal-fusion-410712.covid19.CovidDeaths` d
join `tidal-fusion-410712.covid19.CovidVacc` v
on d.location=v.location and d.date=v.date
where d.continent is not null
)

select *, (RollingPeopleVaccinated/population)*100 as VaccPercent 
FROM tt1


--Looking at death vs median age

select location, population, median_age, SUM(new_deaths) AS total_deaths, SUM(new_cases) AS total_cases, (SUM(new_deaths)/SUM(new_cases)) * 100 AS death_rate
FROM `tidal-fusion-410712.covid19.CovidDeaths`
where continent is not null
group by 1,2,3
order by 1,2















