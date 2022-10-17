select * from covid_19_india

select * from covid_vaccine_statewise

select * from state_population
order by population desc

update state_population
set State_UnionTerritory = 'odisha'
where State_UnionTerritory = 'orissa'





-- percentage of population vacinated till 8th dec 2021

select State,population, max(Total_Vaccinated) as total_vaccinated,(population/max(Total_Vaccinated)) as percentage_vaccinated
from covid_vaccine_statewise cv right join state_population sp on
cv.State = sp.State_UnionTerritory
--where State is not null 
group by State,population
order by 1

-- state  with highest no of people vaccinated - 18-44
select top 3 State,max(cast([age_18_44] as int))as age_18_44_vac
from covid_vaccine_statewise
group by state
order by 2 desc

-- state with highest no people vaccinated - 45-60
select top 3 state,max(cast([age_45_60] as int)) as age_45_60--max(cast([age_60_above] as int)) as _60_plus 
from covid_vaccine_statewise
group by state
order by 2 desc


-- state with highest no people vaccinated - 60+
select top 3 state,max(cast([age_60_above] as int)) as _60_plus 
from covid_vaccine_statewise
group by state
order by 2 desc


--total vaccinations by types of vacines
select max([Total_Doses_Administered]) as total_doses,max( [ Covaxin]) as covaxin_count,max([CoviShield]) as covish_count,
max(cast([Sputnik _V ] as int)) as sputnik_count
from covid_vaccine_statewise

-- total cases vs population as of aug 2021
select state,population,max(confirmed) as total_confirmed,(max(confirmed)/population)*100 as percentage_infected
from covid_19_india cv right join state_population sp on
cv.state = sp.State_UnionTerritory
where state is not null
group by State,population
order by 1

-- total cases vs total deaths as of 2021 dec
select state, max(confirmed) as total_confirmed,max(deaths) as total_deaths,(max(deaths)/max(confirmed))*100 as percentage_death
from covid_19_india
where state not in ('Maharashtra***', 'Karanataka','Bihar****','Unassigned','Cases being reassigned to states',
'Dadra and Nagar Haveli and Daman and Diu','Ladakh','Lakshadweep','Madhya Pradesh***','Puducherry','Himanchal Pradesh'
,'Andaman and Nicobar Islands') and Deaths != 0
group by state
order by 2 desc


-- creating a view

drop view if EXISTS covid_states
create view covid_states as
select *,
DATEPART(MONTH,date) as months 
from covid_19_india
where state not in ('Maharashtra***', 'Karanataka','Bihar****','Unassigned','Cases being reassigned to states',
'Dadra and Nagar Haveli and Daman and Diu','Ladakh','Lakshadweep','Madhya Pradesh***','Puducherry','Himanchal Pradesh'
,'Andaman and Nicobar Islands','Dadra and Nagar Haveli','Daman & Diu')

select * from covid_states

select state,population,max(deaths) as total_deaths
from covid_states cs right join state_population sp on 
cs.state = sp.State_UnionTerritory
where State_UnionTerritory not in('Dadra and Nagar Haveli','Daman & Diu','Puducherry')
group by state,population
order by 2 desc

-- cases by months for all states

select state,months, max(Confirmed) highest_c
from covid_states
--where date like '%2021%'
group by state,months
order by highest_c DESC



