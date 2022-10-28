--I will be comparing how the trend of carbon emissions per country between the years 2000 and 2020

--Tables that will be used

SELECT * 
FROM PortfolioProject2..CO2Emissions;

SELECT *
FROM PortfolioProject2..CO2CountryPopulations;


SELECT *
FROM PortfolioProject2..CO2Emissions AS CO2E
LEFT JOIN PortfolioProject2..CO2CountryPopulations AS CO2P
ON CO2E.Country = CO2P.[Country ]
Where CO2E.year = '2020';


--Find the Top 10 countries that produced the most tons of CO2 Emissions in 2000


SELECT country,year, MAX([Annual CO2 emissions(Tons)]) AS AnnualCO2Emissions2000
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year ='2000'
AND country NOT IN ('North America','World','High-income countries','Upper-middle-income countries','Asia (excl. China & India)',
'Europe','Lower-middle-income countries','European Union (28)','European Union (27)','Europe (excl. EU-27)',
'Europe (excl. EU-28)','North America (excl. USA)','Asia','International transport','South America','Africa')
Group by country,year
Order BY AnnualCO2Emissions2000 DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;



--Find the CO2 Emissions in 2000 per continent From most to least


SELECT country,year, MAX([Annual CO2 emissions(Tons)]) AS AnnualCO2Emissions
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year ='2000'
AND country IN ('North America','South America','Europe','Asia','Africa','Antarctica','Australia')
Group by country,year
Order BY AnnualCO2Emissions DESC
OFFSET 0 ROWS FETCH FIRST 7 ROWS ONLY;



--Find the Top 5 countries that produced the most tons of CO2 Emissions in 2020 per Continent income class

SELECT country,year, MAX([Annual CO2 emissions(Tons)]) AS TotalCO2Emissions
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year ='2020'
AND country IN ('High-income countries','Upper-middle-income countries','Lower-middle-income countries')
Group by country,year
Order BY TotalCO2Emissions DESC;



--Find the Top 5 countries that produced the most tons of CO2 Emissions in 2020 w/population count 

SELECT CO2E.country,CO2E.year, MAX([Annual CO2 emissions(Tons)]) AS AnnualCO2Emissions,CO2P.[Population (2020)]
FROM PortfolioProject2..CO2Emissions AS CO2E
JOIN PortfolioProject2..CO2CountryPopulations AS CO2P
ON CO2E.Country = CO2P.[Country ]
Where CO2E.year ='2020'
AND	CO2E.country NOT IN ('North America','World','High-income countries','Upper-middle-income countries','Asia (excl. China & India)',
'Europe','Lower-middle-income countries','European Union (28)','European Union (27)','Europe (excl. EU-27)',
'Europe (excl. EU-28)','North America (excl. USA)','Asia')
Group by CO2E.country,CO2E.year,CO2P.[Population (2020)]
Order BY AnnualCO2Emissions DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;





--Find the CO2 Emissions in 2020 per continent

SELECT country,year, MAX([Annual CO2 emissions(Tons)]) AS AnnualCO2Emissions
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year ='2020'
AND country IN ('North America','South America','Europe','Asia','Africa','Antarctica','Australia')
Group by country,year
Order BY AnnualCO2Emissions DESC
OFFSET 0 ROWS FETCH FIRST 7 ROWS ONLY;


--Total carbon emissions produced worldwide in 2000

SELECT country,year, SUM([Annual CO2 emissions(Tons)]) AS TotalCO2Emissions
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year ='2000'
AND country  IN ('World')
Group by country,year
Order BY TotalCO2Emissions DESC


--Total carbon emissions produced worldwide in 2020

SELECT country,year, SUM([Annual CO2 emissions(Tons)]) AS TotalCO2Emissions
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year ='2020'
AND country  IN ('World')
Group by country,year
Order BY TotalCO2Emissions DESC



--Percent Increase in Emissions From 2000 to 2020 work on


SELECT country,year, SUM([Annual CO2 emissions(Tons)]) AS TotalAnnualCO2Emissions--MAX((SUM([Annual CO2 emissions(Tons)])/'25234207250'))* 100 AS PercentIncrease,

FROM PortfolioProject2..CO2Emissions AS CO2E
Where year IN ('2000', '2020')
AND country  IN ('World')
Group by country,year

SELECT round((25234207250/34807259099 * 100),1) AS PercentIncreaseInEmissions




--Country with highest Carbon Emissions compared to rest countries 2020


SELECT country,year, MAX([Annual CO2 emissions(Tons)]) AS AnnualCO2Emissions
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year ='2020'
AND country NOT IN ('North America','World','High-income countries','Upper-middle-income countries','Asia (excl. China & India)',
'Europe','Lower-middle-income countries','European Union (28)','European Union (27)','Europe (excl. EU-27)',
'Europe (excl. EU-28)','North America (excl. USA)','Asia')
Group by country,year
Order BY AnnualCO2Emissions DESC
OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY;



--Break down of which sectors contrbuted to CO2 Emissions in 2020 by percentage

SELECT *
FROM PortfolioProject2..CO2Subsector;



--Creating View to store data for later visualizations


Create View RollingEmissions as
Select CO2E.Country,CO2E.Code, CO2E.year,CO2E.[Annual CO2 emissions(Tons)]
,SUM(cast(CO2E.[Annual CO2 emissions(Tons)] as bigint)) OVER (Partition by CO2E.Country Order by CO2E.Country,CO2E.year) as RollingEmissionsPerCountry,CO2P.[Population (2020)] 
FROM PortfolioProject2..CO2Emissions as CO2E
JOIN PortfolioProject2..CO2CountryPopulations as CO2P
	ON CO2E.Country = CO2P.[Country ]
	--and dea.date = vac.date
WHERE CO2P.[Population (2020)] is not null




--Used for tableau visualization


--1)Find the Top 10 countries that produced the most tons of CO2 Emissions in 2000


SELECT country,year, MAX([Annual CO2 emissions(Tons)]) AS AnnualCO2Emissions2000
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year ='2000'
AND country NOT IN ('North America','World','High-income countries','Upper-middle-income countries','Asia (excl. China & India)',
'Europe','Lower-middle-income countries','European Union (28)','European Union (27)','Europe (excl. EU-27)',
'Europe (excl. EU-28)','North America (excl. USA)','Asia','International transport','South America','Africa')
Group by country,year
Order BY AnnualCO2Emissions2000 DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;


--2)
SELECT CO2E.country,CO2E.year, MAX([Annual CO2 emissions(Tons)]) AS AnnualCO2Emissions,CO2P.[Population (2020)]
FROM PortfolioProject2..CO2Emissions AS CO2E
JOIN PortfolioProject2..CO2CountryPopulations AS CO2P
ON CO2E.Country = CO2P.[Country ]
Where CO2E.year ='2020'
AND	CO2E.country NOT IN ('North America','World','High-income countries','Upper-middle-income countries','Asia (excl. China & India)',
'Europe','Lower-middle-income countries','European Union (28)','European Union (27)','Europe (excl. EU-27)',
'Europe (excl. EU-28)','North America (excl. USA)','Asia')
Group by CO2E.country,CO2E.year,CO2P.[Population (2020)]
Order BY AnnualCO2Emissions DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;



--3)Total carbon emissions produced worldwide in 2000 vs 2020


SELECT country,year, SUM([Annual CO2 emissions(Tons)]) AS TotalCO2Emissions
FROM PortfolioProject2..CO2Emissions AS CO2E
Where year IN ('2000', '2020')
AND country  IN ('World')
Group by country,year
Order BY TotalCO2Emissions DESC


-- 4)Worldwide Emissions PER Sector 2020

SELECT *
FROM PortfolioProject2..CO2Subsector;


--5) Rolling total Emissions per country 2000 to 2020

Select CO2E.Country,CO2E.Code, CO2E.year,CO2E.[Annual CO2 emissions(Tons)]
,SUM(cast(CO2E.[Annual CO2 emissions(Tons)] as bigint)) OVER (Partition by CO2E.Country Order by CO2E.Country,CO2E.year) as RollingEmissionsPerCountry,CO2P.[Population (2020)] 
FROM PortfolioProject2..CO2Emissions as CO2E
JOIN PortfolioProject2..CO2CountryPopulations as CO2P
	ON CO2E.Country = CO2P.[Country ]
	--and dea.date = vac.date
WHERE CO2P.[Population (2020)] is not null
AND CO2E.year between '2000' and '2020';