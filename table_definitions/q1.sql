-- VoteRange

SET SEARCH_PATH TO parlgov;
drop table if exists q1 cascade;

-- You must not change this table definition.

create table q1(
year INT,
countryName VARCHAR(50),
voteRange VARCHAR(20),
partyName VARCHAR(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- Check if votes_valid is null. If so, make it as sum of the votes
CREATE VIEW election_detail AS --election_full
SELECT id, country_id, e_date,
	CASE
        WHEN votes_valid IS NOT NULL THEN votes_valid
		ELSE (SELECT SUM(votes)
                FROM election_result 
			    WHERE election_result.election_id = election.id)
	END AS votes_total
FROM election;

-- Create the view of partyies between 1996 to 2016, and the valid votes
CREATE VIEW party_detail AS  -- groupedByElection
SELECT LEFT(election_detail.e_date, 4) AS year, party.country_id AS country_id, 
        election_result.party_id AS party_id, 
        CASE
            WHEN ((100::numeric * SUM(votes)) / MAX(votes_total)) AS num IS NOT NULL THEN num
            ELSE 0
        END AS valid_vote
FROM election_result, election_detail
WHERE election_detail.id = election_result.election_id
GROUP BY election_detail.id, country_id, party_id
HAVING  year > 1995 AND
        year < 2017;
ORDER BY party_id;

-- If there are multiple elections one year, report the average of the percent of the valid votes
CREATE VIEW party_vote AS --groupedByYear
SELECT year, country_id, party_id, AVG(valid_vote) AS vote_avg
FROM party_detail
GROUP BY year, country_id, party_id
HAVING AVG(valid_vote) > 0;


-- the answer to the query 
insert into q1 (
    SELECT PV.country_id AS countryName, PV.name AS partyName,
        CASE
            WHEN PD.vote <=5 THEN '(0-5]'
            WHEN PD.vote >5 AND PD.vote <=10 THEN '(5-10]'
            WHEN PD.vote >10 AND PD.vote <=20 THEN '(10-20]'
            WHEN PD.vote >20 AND PD.vote <=30 THEN '(20-30]'
            WHEN PD.vote >30 AND PD.vote <=40 THEN '(30-40]'
            ELSE '(40-100]'
        END AS voteRange,
        party.name_short AS partyName
    FROM party_vote PV, country, party
    WHERE PV.country_id = country.id AND 
            PV.party_id = party.id;
    GROUP BY countryName, partyName
);

