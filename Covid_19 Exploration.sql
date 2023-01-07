# CoVID 19 Exploration Analysis
## Skilled Used
Aggregate Funtion |Where Clause  |CTE |Temp Table |Creating Views |Converting Data Types

--GALANCE VIEW OF COVID-DEATH DATASET 
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM [Portfolio_Projects ]..CovidDeaths
ORDER BY 1,2
 

---Total_case vs Total_death per_country 
--To determine the likelihood of death contacted in individuals country
SELECT location,CAST (date AS DATE) AS Date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Percentage_death
FROM [Portfolio_Projects ]..CovidDeaths
ORDER BY 1,2
	---View 
CREATE VIEW Total_case_Vs_Total_deaths AS
SELECT location,CAST (date AS DATE) AS Date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Percentage_death
FROM [Portfolio_Projects ]..CovidDeaths
-- Filter by "WHERE" statement e.g 'Nigeria'
SELECT *
FROM Total_case_Vs_Total_deaths
WHERE location= 'Nigeria'

--Showing the daily total_case in regards to population per_country 
SELECT location,CAST (date AS DATE) AS Date,total_cases,population,
(total_cases/population)*100 AS Cases_per_population
FROM [Portfolio_Projects ]..CovidDeaths
ORDER BY 1,2
--View 
CREATE VIEW Total_case AS
SELECT location,CAST (date AS DATE) AS Date,total_cases,population,
(total_cases/population)*100 AS Cases_per_population
FROM [Portfolio_Projects ]..CovidDeaths
--Filtering view by Location e.g Ghana
SELECT *
FROM Total_case
WHERE Location='Ghana'

--Determining countries with highest infection rate per_population
SELECT location,population,MAX (total_cases)AS Infection_count,
MAX (total_cases/population)*100 AS Cases_per_population
FROM [Portfolio_Projects ]..CovidDeaths
WHERE continent='Africa'
GROUP BY location,population
ORDER BY Cases_per_population desc;
---View 
CREATE VIEW Infection_count_Per_Population AS
SELECT location,population,MAX (total_cases)AS Infection_count,
MAX (total_cases/population)*100 AS Cases_per_population
FROM [Portfolio_Projects ]..CovidDeaths
GROUP BY location,population
--- Query Example with the created view 
---Where Cases_per_population > 3.0 AND Highest_Infection_count < 300
SELECT *
FROM Infection_count_Per_Population
WHERE Cases_per_population > 3.0 AND 
Infection_count < 300

--Determining the countries with highest death recorded per_population 
SELECT continent, location,MAX (CAST(total_deaths AS int))AS Total_death_count
FROM [Portfolio_Projects ]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,continent
ORDER BY Total_death_count desc;
---Views
CREATE VIEW Countries_Death_Record AS
SELECT location,MAX (CAST(total_deaths AS int))AS Total_death_count
FROM [Portfolio_Projects ]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
-- Deleted view in orer to add more column to query 
DROP VIEW Countries_Death_Record
--- New View 
CREATE VIEW Countries_Death_Record AS
SELECT continent, location,MAX (CAST(total_deaths AS int))AS Total_death_count
FROM [Portfolio_Projects ]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent,location
---- Query Example with created view 
--WHERE Total_death_count < 5000 AND continent = Africa
SELECT location,Total_death_count
FROM Countries_Death_Record
WHERE Total_death_count <5000 AND
continent ='Africa'
ORDER BY Total_death_count desc;


---Used created view to to create a new query With 'Joins'
--Countries_Death_Record view and Infection_count_Per_Population AS ICP
SELECT CDR.location,population,Infection_count,Total_death_count,Cases_per_population
FROM Countries_Death_Record AS CDR 
JOIN Infection_count_Per_Population AS ICP
ON CDR.location=ICP.location
WHERE continent IS NOT NULL  AND 
continent = 'Africa'


---BREAKING BY CONTINENTAL HIERARCHY
--This is for drill-down purpose in visualization 
--Determining the continent with highest death recorded per_population 
SELECT continent,MAX (CAST(total_deaths AS int))AS Total_death_count
FROM [Portfolio_Projects ]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_death_count desc;

--Determining countries with highest infection rate per_population
SELECT continent,population,MAX (total_cases)AS Highest_Infection_count,
MAX (total_cases/population)*100 AS Cases_per_population
FROM [Portfolio_Projects ]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent,population
ORDER BY Highest_Infection_count desc;


--GLOBAL FIGURES 
---Determination of Total_cases,Total deaths and percantage deaths on daily basis 
SELECT CAST (DATE AS date) AS Date, SUM(new_cases) AS Total_Cases,
SUM(CAST(new_deaths AS INT)) AS Total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Percentage_death
--new_death is in varchar, therefore requires to be converted to integer to effect the calculation 
FROM [Portfolio_Projects ]..CovidDeaths
where continent IS NOT NUll
GROUP BY date
ORDER BY 1,2

---Determination of Total_cases,Total deaths and percantage deaths overall 
SELECT  SUM(new_cases) AS Total_Cases,
SUM(CAST(new_deaths AS INT)) AS Total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Percentage_death
--new_death is in varchar, therefore requires to be converted to integer to effect the calculation 
FROM [Portfolio_Projects ]..CovidDeaths
where continent IS NOT NUll 
ORDER BY 1,2

---Determination of Total_cases,Total deaths and percantage deaths overall for individual country 
SELECT location, continent, population, 
SUM(new_cases) AS Total_Cases,
SUM(CAST(new_deaths AS INT)) AS Total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Percentage_death
--new_death is in varchar, therefore requires to be converted to integer to effect the calculation 
FROM [Portfolio_Projects ]..CovidDeaths
where continent IS NOT NUll 
GROUP BY location, continent,population
ORDER BY Total_cases desc;
---View 
CREATE VIEW Total_Cases_Death AS  
SELECT location, continent, population, 
SUM(new_cases) AS Total_Cases,
SUM(CAST(new_deaths AS INT)) AS Total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Percentage_death
--new_death is in varchar, therefore requires to be converted to integer to effect the calculation 
FROM [Portfolio_Projects ]..CovidDeaths
where continent IS NOT NUll 
GROUP BY location, continent,population
--Query Examples 
SELECT *
FROM Total_Cases_Death
WHERE Percentage_death>2.5

--Further query with two created view
SELECT TCD.location, continent, TCD.population,Total_cases,Total_deaths,Cases_per_population,Percentage_death
From total_Cases_Death AS TCD
JOIN Infection_count_Per_Population AS ICP
ON TCD.location=ICP.location
GROUP BY TCD.location, continent, TCD.population,Total_cases,Total_deaths,Cases_per_population,Percentage_death
ORDER BY Total_deaths desc;


--GLANCE VIEW OF COVID-VACCINATION DATASET 
SELECT *
FROM Portfolio_Projects..CovidVaccinations

---Checking population that got vaccinated
--By New Vaccination
SELECT continent,location,CAST (date AS DATE) AS Date,population,new_vaccinations
FROM Portfolio_Projects..CovidDeaths
---View 
CREATE VIEW New_Vaccinations AS
SELECT continent,location,CAST (date AS DATE) AS Date,population,new_vaccinations
FROM Portfolio_Projects..CovidDeaths
---Query Example 
SELECT *
FROM New_Vaccinations 
WHERE continent='Europe' AND 
new_vaccinations IS NOT NULL

--By Total Vaccination
SELECT continent,location,CAST (date AS DATE) AS Date,population,total_vaccinations
FROM Portfolio_Projects..CovidDeaths
---View 
CREATE VIEW Total_Vaccinations AS
SELECT continent,location,CAST (date AS DATE) AS Date,population,total_vaccinations
FROM Portfolio_Projects..CovidDeaths
---Query Example 
SELECT location,Date,population,total_vaccinations
FROM Total_Vaccinations 
WHERE continent between 'Africa' and 'Europe' and 
population<1000000
ORDER BY 3,2,1

--Countries Vaccination Record
SELECT continent, location,MAX (CAST(total_vaccinations AS int))AS Total_Vaccinations_Count
FROM [Portfolio_Projects ]..covidVaccinations
WHERE continent IS NOT NULL
GROUP BY location,continent
ORDER BY Total_Vaccinations_Count desc;
--- New View 
CREATE VIEW Countries_Vaccination_Count AS
SELECT continent, location,MAX (CAST(total_vaccinations AS int))AS Total_Vaccinations_Count
FROM [Portfolio_Projects ]..covidVaccinations
WHERE continent IS NOT NULL
GROUP BY location,continent
---- Query Example with created view
-- Countries where vaccination count is greater than 1 million
SELECT *
FROM Countries_Vaccination_Count
WHERE Total_Vaccinations_Count >1000000

---CREATING JOINS
--Summarization of Countries Total cases, Total Vaccinated, Total deaths and those that didn't get vaccinated
SELECT CVC.continent,CVC.location,TCD.population,TCD.Total_Cases,CVC.Total_Vaccinations_Count,
SUM(TCD.total_cases-CVC.Total_Vaccinations_Count) AS Not_Vaccinated, TCD.Total_deaths
FROM Total_Cases_Death AS TCD
JOIN Countries_Vaccination_Count AS CVC
ON TCD.location=CVC.location
GROUP BY CVC.continent,CVC.location,TCD.population,TCD.Total_Cases,CVC.Total_Vaccinations_Count,TCD.Total_deaths
order by Not_Vaccinated desc;


--USING PARTITION BY
--- To determine rolling total of new vaccination i.e. addition of previous day vaccination to the present day 
SELECT dea.continent, dea.location,CAST(dea.date AS Date) AS Date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Daily_rolling_new_Vac
FROM Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
ON dea.location= vac.location
AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3

-- View 
CREATE VIEW Rolling_Total_of_new_Vaccination  AS
SELECT dea.continent, dea.location,CAST(dea.date AS Date) AS Date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Daily_rolling_new_Vac
FROM Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
ON dea.location= vac.location
AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
-- Query Example 
SELECT *
FROM Rolling_Total_of_new_Vaccination
WHERE continent='ASia' AND 
location='India' AND Daily_rolling_new_Vac IS NOT NULL


--- To determine rolling total of new cases i.e. addition of previous day cases to the present day 
SELECT dea.continent, dea.location,CAST(dea.date AS Date) AS Date,dea.population,dea.new_cases,
SUM(CAST(dea.new_cases as INT))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Daily_rolling_new_cases
FROM Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
ON dea.location= vac.location
AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3
--View 
CREATE VIEW Rolling_total_of_New_Cases AS 
SELECT dea.continent, dea.location,CAST(dea.date AS Date) AS Date,dea.population,dea.new_cases,
SUM(CAST(dea.new_cases as INT))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Daily_rolling_new_cases
FROM Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
ON dea.location= vac.location
AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
-- Query Example 
SELECT location,Date,population,new_cases,Daily_rolling_new_cases
FROM Rolling_total_of_New_Cases
WHERE continent='North America'
ORDER BY 1,2,3


---USING CTE 
-- To Calculate the percentage of the  rolling total of the new population 
WITH PopvsVac (continent, location, date, population, Rolling_Total_of_new_Vac,new_vaccinations)
AS
(
SELECT dea.continent, dea.location,CAST(dea.date AS Date) AS Date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Daily_rolling_new_Vac
FROM Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
ON dea.location= vac.location
AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (Rolling_Total_of_new_Vac/population)*100 AS Percentage_Rolling_Total_of_new_Vac
FROM PopvsVac


--TEMP TABLE
--Using Temp Table to perform same function as CTE
CREATE TABLE #Percent_Population_Vaccinated
(
continent VARCHAR (225), 
location NVARCHAR (225), 
date DATETIME,
population NUMERIC,
new_vaccinations NUMERIC, 
Daily_rolling_new_Vac NUMERIC
)
INSERT INTO #Percent_Population_Vaccinated
SELECT dea.continent, dea.location,CAST(dea.date AS Date) AS Date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Daily_rolling_new_Vac
FROM Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
ON dea.location= vac.location
AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
SELECT *,(Daily_rolling_new_Vac/population)*100 AS Percentage_Rolling_Total_of_new_Vac
FROM #Percent_Population_Vaccinated

--FOR DROPPING Table
--DROP TABLE IF EXISTS #Percent_Population_Vaccinated
CREATE TABLE #Percent_Population_Vaccinated
(
continent VARCHAR (225), 
location NVARCHAR (225), 
date DATETIME,
population NUMERIC,
new_vaccinations NUMERIC, 
Daily_rolling_new_Vac NUMERIC
)
INSERT INTO #Percent_Population_Vaccinated
SELECT dea.continent, dea.location,CAST(dea.date AS Date) AS Date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Daily_rolling_new_Vac
FROM Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
ON dea.location= vac.location
AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
SELECT *,(Daily_rolling_new_Vac/population)*100 AS Percentage_Rolling_Total_of_new_Vac
FROM #Percent_Population_Vaccinated

