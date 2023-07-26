use sql_casestudy

/*Q1. How many number of Electricity ICB sector companies have Renewable
energy and their employees’ size less than 5K and their electricity purchased is
greater than the electricity produced.*/


--Cleaning and updating the Electricity/Purchased field by removing null,NA values.Changing the datatype to Float.
update ICS
set  [Electricity/Purchased]= ISNULL([Electricity/Purchased], 0)

update ICS
set  [Electricity/Produced]= ISNULL([Electricity/Produced], 0)

alter table ICS
alter column [Electricity/Purchased] float

--featching all the row records

select count(Companies) as No_company
from ICS
where  [ICB SECTOR NAME]= 'Electricity'
and [Renewable Energy Use] = ' Y '  
and [EMPLOYEES]  < 5000
and [Electricity/Purchased] > [Electricity/Produced]


/* Q2.  How many companies of Oil & Gas Sector from India and CHINA have Commercial Risks in 2008? */

select count(Companies) as No_companies
from ICS
where ([GEOGRAPHIC DESCR#]= 'India' OR [GEOGRAPHIC DESCR#]= 'China') and [ICB SECTOR NAME]= 'Oil & Gas Producers'
and[Commercial Risks and/or Opportunities Due to Climate Change]  = ' Y  '
and year = 2008


/*Q3. Which country spend on " Environment R&D"  over revenue average percentage is maximum in 2013?
Consider only the Chemical, Mining, and General Industrials sectors.*/

--Updating the Env# R&D spend over revenue (in%) field by setting as 0 from no data

Update ICS
set [Env# R&D spend over revenue (in%)]=0
where [Env# R&D spend over revenue (in%)]='no data'

select top 1 [GEOGRAPHIC DESCR#],([Env# R&D spend over revenue (in%)])        
from ICS
where Year=2013
and [ICB SECTOR NAME]  IN ('Chemicals', 'Mining', 'General Industrials')
group by [GEOGRAPHIC DESCR#],[Env# R&D spend over revenue (in%)]
order by [Env# R&D spend over revenue (in%)] desc

--or

select top 1 [GEOGRAPHIC DESCR#], [Env# R&D spend over revenue (in%)]
from
(
select *
from ICS
where [ICB SECTOR NAME] IN ('Mining', 'General', 'General Industrials') AND Year = 2013
) as T
where [Env# R&D spend over revenue (in%)] <> 'no data'
order by [Env# R&D spend over revenue (in%)] desc

--Q.4  In which year the total Women Employees are highest in United Kingdom and consider the company names start with ‘D’

--Cleaning and updating the Women Employees field by removing null,NA values.Changing the datatype to Float.

UPDATE ICS
SET [Women Employees]= ISNULL([Women Employees], 0)

Update ICS
set [Women Employees]=0
where [Women Employees]=' -   '

Update ICS
set [Women Employees]=0
where [Women Employees]=' NA '

alter table ICS
alter column [Women Employees] float

select top 1 year, round(sum([Women Employees]),0) as total_women_employees
from ICS
where [GEOGRAPHIC DESCR#]= 'United Kingdom'
and [Companies] LIKE 'D%'
group by year
order by total_women_employees desc

--Q5. Which Sector cluster have the Highest average Turnover of Employees in India. Consider only 2012 and 2014 years data.

--Cleaning and updating the Turnover of Employees field by removing null,NA values.Changing the datatype to Float.

UPDATE ICS
SET [Turnover of Employees]= ISNULL([Turnover of Employees], 0)

Update ICS
set [Turnover of Employees]=0
where [Turnover of Employees]=' -   '

Update ICS
set [Turnover of Employees]=0
where [Turnover of Employees]=' NA '

alter table ICS
alter column [Turnover of Employees] float

select top 1 [Sector Cluster], round(avg([Turnover of Employees]),2) as avg_turnover_of_employees
from ICS
where [GEOGRAPHIC DESCR#] = 'India' and year in (2012, 2014)
group by[Sector Cluster]
order by avg_turnover_of_employees desc