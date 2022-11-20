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
Order by Average_Growth_Rate  Desc
