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
DROP VIEW IF EXISTS valid_country CASCADE;
DROP VIEW IF EXISTS Participation_Ratio CASCADE;
DROP VIEW IF EXISTS avg_PR_table CASCADE;
DROP VIEW IF EXISTS not_increasing CASCADE;
DROP VIEW IF EXISTS result CASCADE;

-- Define views for your intermediate steps here.


-- Find the countries that had at least one election between 2001 to 2016
CREATE VIEW valid_country AS
SELECT country_id, EXTRACT(YEAR FROM e_date) AS year, votes_cast, electorate
FROM election
WHERE EXTRACT(YEAR FROM e_date) > 2000
    	AND EXTRACT(YEAR FROM e_date) < 2017
GROUP BY country_id, year, election.votes_cast, election.electorate;


-- Find the participation ratios of the valid country
CREATE VIEW Participation_Ratio AS
SELECT year, country_id, (votes_cast::float / electorate::float) AS participation_ratios
FROM valid_country
GROUP BY year, country_id, valid_country.votes_cast, valid_country.electorate;


-- Find the average participation ratios for all the countries
CREATE VIEW avg_PR_table AS
SELECT year, country_id, AVG(participation_ratios) AS avg_participation_ratio
FROM Participation_Ratio
GROUP BY year, country_id
ORDER BY year, country_id;


-- Find the countries whose participation ratios were not increasing over the years
CREATE VIEW not_increasing AS
SELECT DISTINCT PR2.country_id
FROM avg_PR_table PR1, avg_PR_table PR2
WHERE PR1.year < PR2.year
		AND PR1.country_id = PR2.country_id
		AND PR1.avg_participation_ratio <= PR2.avg_participation_ratio;


-- Find the countries whose participation ratios were keep increasing over the years,
-- then subscribe it from all of the country id. 
-- Find the name of the country and the average participation ratios from 2001 to 2016
CREATE VIEW result AS
SELECT country.name as countryName, year, avg_participation_ratio AS participationRatio
FROM avg_PR_table, not_increasing, country
WHERE avg_PR_table.country_id = not_increasing.country_id
		AND avg_PR_table.country_id = country.id;


-- the answer to the query 
insert into q3 (
	SELECT countryName, year, participationRatio
	FROM result
);

