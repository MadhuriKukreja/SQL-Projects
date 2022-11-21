use resume_projects;

--- number of rows --

select count(*) from dataset1;
select count(*) from dataset2;

-- Data only for Jharkhand and Bihar--

select d1.District, d1.State, d1.Growth, d1.Sex_ratio, d1.Literacy, d2.Area_km2, d2.Population
from dataset1 d1 join dataset2 d2 on d1.State = d2.State
where d1.State  = 'Bihar' or d1.state = 'Jharkhand'
group by d1.District;

-- Total Population of India ---

Select sum(Population) As 'Total Population' from dataset2;

-- Average Growth/sex/literarcy percentage of India --

Select d2.State, round(avg(Growth )*100,2) As 'Average Growth Rate' , 
round(avg(Sex_ratio),0) as 'Avg Sexratio', round(avg(Literacy),2) as 'Avg Literacy Rate'
from dataset1 d1
Join dataset2 d2 on d1.State = d2.State
Group by d2.State
Order by 'Avg Sexratio' Desc;

-- Top 3 State showing highest Growth rate --

Select  State, round(avg(Growth )*100,2) Average_Growth_Rate from dataset1
group by State
Order by Average_Growth_Rate  DESC
limit 3;

-- Top 3 and lowest 3 showing sex ratio --

drop table if exists top_states;

Create table top_states
(
State Varchar(30),
topstates float
);

Insert into top_states
Select  State, round(avg(Literacy ),2) Average_Literacy_Rate from dataset1
group by State
Order by Average_Literacy_Rate  DESC limit 3;

drop table if exists Bottom_states;

Create table Bottom_states
(
State Varchar(30),
Bottomstates float
);

Insert into Bottom_states
Select  State, round(avg(Literacy ),2) Average_Literacy_Rate from dataset1
group by State
Order by Average_Literacy_Rate  ASC limit 3;

-- Tables are created will be using union operatior for the results --
select * from Top_states
Union
select * from Bottom_states;

-- State with letter A --

Select d2.State, round(avg(Growth )*100,2) Average_Growth_Rate , 
round(avg(Sex_ratio),0)  Avg_Sexratio, round(avg(Literacy),2) Avg_Literacy_Rate
from dataset1 d1
Join dataset2 d2 on d1.State = d2.State
Group by d2.State
having d2.state like 'a%' or d2.state like '%n'
Order by Average_Growth_Rate  Desc;

-- Number of Male and female state wise --
select d4.state, Round(Sum(d4.Male),0) Total_Male, round(Sum(d4.Female),0) Total_Female from
(select d3.District, d3.state, round(d3.Population/(d3.Sex_ratio + 1),2)  Male, 
round((d3.Population * d3.Sex_ratio)/(d3.Sex_ratio+1),2) Female from
(select d1.District, d1.State, (Sex_ratio/1000) Sex_ratio, Population from dataset1 d1
join dataset2 d2 on d1.District = d2.District) d3) d4
group by d4.state;

-- Total Literacy rate ---
use resume_projects;
select d3.state, sum(Literate_People) Total_Literate_People, Sum(illiterate_people) Total_illiterate_people from
(select d1.District,d1.State, round((Literacy/100)*Population,0) Literate_People, round(((1-Literacy/100) * Population),0) illiterate_People  from dataset1 d1
join dataset2 d2 on d1.District = d2.District)d3
Group by d3.state
Order by Total_Literate_People DESC;

-- Growth of area/population --

select f.ID, round(g.Area/f.Total_Previous_population,4), round(g.Area/ f.Total_current_population,4) from
(select '1' as ID, d.* from
(select  Sum(c.Total_previous_census) Total_Previous_population, Sum(c.Total_current_census) Total_current_population from
(select b.State, Sum(b.Previous_census) Total_previous_census, sum(b.current_census) Total_current_census from
(select a.District, a.State, Round(a.Population/(1+a.Growth),0) Previous_census, a.Population current_census from
(select d1.District,d1.State, d1.Growth, d2.Population from dataset1 d1
join dataset2 d2 on d1.District = d2.District)a)b
Group by b.state)c)d)f 
Join
(select '1' as ID, e.Area from
(select sum(area_km2) Area from dataset2)e)g on f.ID = g.ID;

-- Top 3 District from each state as per literacy rate  --
Select b.* from 
(select District, State, Literacy,rank()over(Partition by State order by Literacy desc) Ranking from dataset1)b
where b.Ranking in (1,2,3) order by state;