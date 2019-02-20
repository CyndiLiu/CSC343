-- Winners

SET SEARCH_PATH TO parlgov;
drop table if exists q2 cascade;

-- You must not change this table definition.

create table q2(
countryName VARCHaR(100),
partyName VARCHaR(100),
partyFamily VARCHaR(100),
wonElections INT,
mostRecentlyWonElectionId INT,
mostRecentlyWonElectionYear INT
);


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS max_votes CASCADE;
DROP VIEW IF EXISTS winners CASCADE;
DROP VIEW IF EXISTS num_parties CASCADE;
DROP VIEW IF EXISTS number_win CASCADE;
DROP VIEW IF EXISTS total_win CASCADE;
DROP VIEW IF EXISTS avg_win_elec CASCADE;
DROP VIEW IF EXISTS over_three CASCADE;
DROP VIEW IF EXISTS most_recent_win CASCADE;
DROP VIEW IF EXISTS most_recent_election CASCADE;
DROP VIEW IF EXISTS new1 CASCADE;
DROP VIEW IF EXISTS new2 CASCADE;
DROP VIEW IF EXISTS new3 CASCADE;
DROP VIEW IF EXISTS result CASCADE;

-- Define views for your intermediate steps here.

-- Find the numbers of votes for each winning election
CREATE VIEW max_votes AS
SELECT election_id, MAX(votes) AS winning_votes
FROM election_result
GROUP BY election_id
ORDER BY election_id; 

-- Find the party with the most votes, the date of the election, 
-- and the country where the election took place
CREATE VIEW winners AS
SELECT party_id, country_id, votes, e_date, election_result.election_id
FROM ( max_votes
        JOIN election_result 
        ON max_votes.election_id = election_result.election_id)
    JOIN election
    ON election.id = max_votes.election_id
WHERE votes = winning_votes
ORDER BY election_id;

-- Count the numbers of parties in each country
CREATE VIEW num_parties AS
SELECT country_id, COUNT(id) AS parties
FROM party
GROUP BY country_id
ORDER BY country_id;

-- Count the numbers of each party's winning for an election in each country
CREATE VIEW number_win AS
SELECT party_id, country_id, COUNT(*) AS win_num
FROM winners
GROUP BY country_id, party_id
ORDER BY country_id, party_id;

-- Count the total number of winning elections in each country
CREATE VIEW total_win AS
SELECT country_id, SUM(win_num) AS totalwins
FROM number_win
GROUP BY (country_id)
ORDER BY country_id;

-- Find the average number of winning elctions for each country 
CREATE VIEW avg_win_elec AS
SELECT total_win.country_id, CAST(totalwins AS FLOAT)/parties AS average_wins
FROM total_win, num_parties 
WHERE num_parties.country_id = total_win.country_id
ORDER BY country_id;

-- Find the numbers of winning elections and information of all parties that have
-- won more than three times the average number of elections in same country
CREATE VIEW over_three AS -- morethanthree
SELECT number_win.country_id, party_id, win_num
FROM avg_win_elec, number_win
WHERE number_win.country_id = avg_win_elec.country_id
        AND win_num > average_wins * 3;

-- Find the most recent election win
CREATE VIEW most_recent_win AS
SELECT country_id, party_id, MAX(e_date) AS recent
FROM winners
GROUP BY country_id, party_id
ORDER BY recent;

-- Add the election_id to the previous table 
CREATE VIEW most_recent_election AS
SELECT election_id, most_recent_win.country_id, most_recent_win.party_id, recent
FROM most_recent_win, winners
WHERE most_recent_win.country_id = winners.country_id 
        AND most_recent_win.party_id = winners.party_id
        AND e_date = recent
ORDER BY election_id;



-- Find all arributes relating to the over_three
CREATE VIEW res_remove_five AS
SELECT over_three.party_id AS party_id, over_three.country_id AS country_id,
		win_num, election_id AS most_recent_id, recent AS most_recent_date
FROM over_three, most_recent_election
WHERE over_three.party_id = most_recent_election.party_id;



CREATE VIEW remove_four AS
SELECT res_remove_five.country_id, most_recent_id, res_remove_five.party_id, win_num, most_recent_date, family
FROM res_remove_five LEFT JOIN party_family
		ON res_remove_five.party_id = party_family.party_id;


CREATE VIEW remove_three AS
SELECT win_num, country.name AS countryName, most_recent_id, party.name AS partyName, most_recent_date, family
FROM remove_four, country, party
WHERE remove_four.party_id = party.id
        AND remove_four.country_id = country.id;


CREATE VIEW result AS
SELECT partyName, countryName, win_num, most_recent_id, EXTRACT(YEAR FROM most_recent_date) AS recent_date, 
	CASE 
            WHEN family = NULL THEN ' '
            ELSE family
        END AS new_family
FROM remove_three;


-- the answer to the query 
insert into q2 
SELECT countryName, partyName, new_family, win_num, most_recent_id AS mostRecentlyWonElectionId,
		CAST(recent_date AS INT) AS mostRecentlyWonElectionYear
FROM result;





