-- Participate

SET SEARCH_PATH TO parlgov;
drop table if exists q3 cascade;

-- You must not change this table definition.

create table q3(
        countryName varchar(50),
        year int,
        participationRatio real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS participationRatio_in_period CASCADE;
--DROP VIEW IF EXISTS full_countries CASCADE;
DROP VIEW IF EXISTS fit_countries CASCADE;
drop view if exists final_countries CASCADE;

-- Define views for your intermediate steps here.

create VIEW participationRatio_in_period as 
select country_id, extract(year from e_date) as year, avg(votes_cast::float / electorate::float) as participationRatio
from election
where extract(year from e_date) >= 2001 
    and extract(year from e_date) <= 2016 
group by(country_id, year);

create VIEW fit_countries as 
--select distinct country_id
--from participationRatio_in_period
--except
select distinct p1.country_id
from participationRatio_in_period p1,participationRatio_in_period p2
where p1.country_id = p2.country_id 
	and p1.year > p2.year 
	and p1.participationRatio >= p2.participationRatio;

create VIEW final_countries as
select fit_countries.country_id, year, participationRatio
from fit_countries join participationRatio_in_period 
    on fit_countries.country_id = participationRatio_in_period.country_id;

-- the answer to the query 
insert into q3 
select name, year, participationRatio 
from final_countries join country on country_id = id;
