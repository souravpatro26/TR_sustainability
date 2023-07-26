use sql_casestudy

select * from ICS

--Q1. What are the number of unique Geographic Descriptions in data?

select count(distinct([GEOGRAPHIC DESCR#])) as Unique_Geographic_Descriptions from ICS

--Q2. Which company has more number of employees in 2011?
--Note : Impute missing values with 0 if any

UPDATE ICS
SET  [EMPLOYEES]= ISNULL([EMPLOYEES], 0)

SELECT Top 1 [Companies],Year,[EMPLOYEES] as employee_count
FROM ICS
WHERE [Year]= 2011
ORDER BY [EMPLOYEES] DESC


--Q3. What is the third highest social score of companies?
--Note : Impute null values with median value if any

UPDATE ICS
SET [Social Score] = REPLACE([Social Score], 'NA', 48.2)

select TOP 3 [Companies],[Social Score] from ICS
order by [Social Score] desc

--Q4. What is the average net sale for "Technology"  sector cluster in 2008 year?
--Note : Filter nulls data If any

select [Sector Cluster], avg([NET SALES OR REVENUES (kUSD)] ) Average_net_sale from ICS
where [Sector Cluster] = 'Technology' and Year = 2008 
group by [Sector Cluster]

select [NET SALES OR REVENUES (kUSD)] from ICS

--Q5. How many number of companies has Environmental Managemental System
--Certified Percentage is 100 in 2010 year?

select [Environmental Management System Certified Percent] from ICS
order by [Environmental Management System Certified Percent] 

Update ICS
set [Environmental Management System Certified Percent]=0
where [Environmental Management System Certified Percent]=' NA '

alter table ICS
alter column [Environmental Management System Certified Percent] float

 select count([Companies]) from ICS
 where [Year]=2010 and [Environmental Management System Certified Percent]=100

--Q6. Which ICB sector has lowest average total assets in Australia?
--Note : Impute missing values with zero

UPDATE ICS
SET [TOTAL ASSETS (kUSD)]= ISNULL([TOTAL ASSETS (kUSD)], 0)

select top 1 [ICB SECTOR NAME],round(AVG([TOTAL ASSETS (kUSD)]),2) as AVG_AST from ICS
where [GEOGRAPHIC DESCR#]='Australia'
group by [ICB SECTOR NAME]
order by AVG([TOTAL ASSETS (kUSD)]) 

--Q7. What is average injury rate for top 5 companies in 2015 year?
--Note : Pick top-5 companies based on their employee number  and impute missing values with zero

UPDATE ICS
SET [Total Injury Rate]= ISNULL([Total Injury Rate], 0)

Update ICS
set [Total Injury Rate]=0
where [Total Injury Rate]=' NA '

alter table ICS
alter column [Total Injury Rate] float

select [Companies],avg([Total Injury Rate]) as avg_Rate from ICS
where year=2015 and [Companies] in
(select Companies from (select top 5 [Companies],sum([EMPLOYEES]) As Employees from ICS
group by [Companies]
order by Employees desc) as t)
group by [Companies]
order by avg_Rate desc


--Q8. How many "Japan Geographic Desc" companies has EBIT % Net Sales is between 25 to 50 in 2012?

UPDATE ICS
SET [EBIT % of Net Sales]= ISNULL([EBIT % of Net Sales], 0)

Update ICS
set [EBIT % of Net Sales]=0
where [EBIT % of Net Sales]=' NA '

alter table ICS
alter column [Total Injury Rate] float

select distinct [EBIT % of Net Sales] from ICS
order by [EBIT % of Net Sales] desc

SELECT COUNT(*)
FROM (select *
from ICS
where [EBIT % of Net Sales] BETWEEN .25 AND .5
) AS T
where  [GEOGRAPHIC DESCR#]= 'Japan' AND Year = 2012

--Q9. Which cluster sector has highest waste total. Use data after 2010 year and consider not null records

select top 1 [Sector Cluster],sum([Waste Total]) as Total_waste from ICS
where Year > 2010 
group by [Sector Cluster]
order by Total_waste desc

--Q10. Which company from India has "CSR Sustainability External Audit" and "Average Social Score" is low

UPDATE ICS
SET [CSR Sustainability External Audit]= ISNULL([CSR Sustainability External Audit], 0)

Update ICS
set [CSR Sustainability External Audit]=0
where [CSR Sustainability External Audit]=' -   '

Update ICS
set [CSR Sustainability External Audit]=0
where [CSR Sustainability External Audit]=' NA '

alter table ICS
alter column [CSR Sustainability External Audit] float

select Top 1 [Companies],[GEOGRAPHIC DESCR#],[Social Score],[CSR Sustainability External Audit] from ICS
where [GEOGRAPHIC DESCR#]='India' and [CSR Sustainability External Audit]=' Y '
order by [Social Score]

--Q11. What is the percentage of companies from United States in 2013 year?

select 100*(Count(*)/(select count(*) from ICS where year='2013'))  as prcntge from ICS
where [GEOGRAPHIC DESCR#]='united states' and 
year='2013'

--Q12. Which ICB Sector contains highest percentage of Employees in 2014 Year?

select top 1 [ICB SECTOR NAME], (SUM(Employees)/(select sum(Employees) from ICS where Year = 2014))*100 as prcntge_emp_2014 from ICS
where Year = 2014
group by [ICB SECTOR NAME]
order by prcntge_emp_2014 desc

--Q13. Which year has lowest average net sales for Banks sector?

SELECT YEAR, AVG ([NET SALES OR REVENUES (kUSD)]) AS Avg_Net_Sales
FROM ICS
WHERE [ICB SECTOR NAME] = 'Banks'
GROUP BY [Year]
HAVING AVG( [NET SALES OR REVENUES (kUSD)]) = ( SELECT MIN(Avg_Net_Sales)
FROM ( SELECT AVG([NET SALES OR REVENUES (kUSD)]) AS Avg_Net_Sales
FROM ICS
WHERE [ICB SECTOR NAME] = 'Banks'
GROUP BY Year) as t)

--Q14. How many number "Geographic desc" are under EUROPE+AFRICAN,NON U.S. regional cluster in 2008 year?

select count(distinct [GEOGRAPHIC DESCR#]) from ICS
where year=2008 and [Regional Cluster]='EUROPE+AFRICA, NON-U.S.'

--Q15. What Percentage of companies not following Emission Reduction Policy Elements in 2010 year?
SELECT
    (TotalCompaniesNotFollowing / TotalCompanies)*100 AS PercentageNotFollowing
FROM 
(select count([Emission Reduction Policy Elements/Emissions]) as TotalCompaniesNotFollowing from ICS
where [Emission Reduction Policy Elements/Emissions]=' N ' and year =2010) as t1,
(select count([Companies]) as TotalCompanies from ICS where year=2010) as t2


