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
DROP VIEW IF EXISTS sum_vote_res CASCADE;
DROP VIEW IF EXISTS election_detail CASCADE;
DROP VIEW IF EXISTS party_detail CASCADE;


-- Define views for your intermediate steps here.

-- Find the sum of the votes
CREATE VIEW sum_vote_res AS
SELECT SUM(votes) AS sum_votes, election.id AS election_id
FROM election_result, election 
WHERE election_result.election_id = election.id
GROUP BY election.id;


-- Check if votes_valid is null. If so, make it as sum of the votes
CREATE VIEW election_detail AS
SELECT id, country_id, e_date, COALESCE(votes_valid, sum_vote_res.sum_votes) AS votes_total
FROM election, sum_vote_res
WHERE sum_vote_res.election_id = election.id;

-- Create the view of partyies between 1996 to 2016, and the valid votes
CREATE VIEW party_detail AS  -- groupedByElection
SELECT CAST(EXTRACT(YEAR FROM e_date) AS float) AS year, country_id, party_id, 
        CASE
            WHEN ((100::numeric * SUM(votes)) / MAX(votes_total)) IS NOT NULL
            THEN ((100::numeric * SUM(votes)) / MAX(votes_total))
            ELSE 0
        END AS valid_vote
FROM election_result, election_detail
WHERE election_detail.id = election_result.election_id
        AND CAST(EXTRACT(YEAR FROM e_date)AS float) > 1995
        AND CAST(EXTRACT(YEAR FROM e_date)AS float) < 2017
GROUP BY election_detail.id, election_detail.e_date, party_id, country_id
ORDER BY party_id;



-- If there are multiple elections one year, report the average of the percent of the valid votes
CREATE VIEW party_vote AS --groupedByYear
SELECT year, country_id, party_id, AVG(valid_vote) AS vote_avg
FROM party_detail, country
GROUP BY year, country_id, party_id
HAVING AVG(valid_vote) > 0;


-- the answer to the query 
insert into q1 (
    SELECT party_vote.year AS year, country.name AS countryName,
        CASE
            WHEN party_vote.vote_avg <= 5 THEN '(0-5]'
            WHEN party_vote.vote_avg > 5 AND party_vote.vote_avg <= 10 THEN '(5-10]'
            WHEN party_vote.vote_avg > 10 AND party_vote.vote_avg <= 20 THEN '(10-20]'
            WHEN party_vote.vote_avg > 20 AND party_vote.vote_avg <= 30 THEN '(20-30]'
            WHEN party_vote.vote_avg > 30 AND party_vote.vote_avg <= 40 THEN '(30-40]'
            ELSE '(40-100]'
        END AS voteRange, 
        party.name_short AS partyName
    FROM party_vote, country, party
    WHERE party_vote.country_id = country.id AND 
            party_vote.party_id = party.id
    GROUP BY party_vote.year, countryName, partyName, party_vote.vote_avg
);


