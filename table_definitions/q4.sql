-- Left-right

SET SEARCH_PATH TO parlgov;
drop table if exists q4 cascade;

-- You must not change this table definition.


CREATE TABLE q4(
        countryName VARCHAR(50),
        r0_2 INT,
        r2_4 INT,
        r4_6 INT,
        r6_8 INT,
        r8_10 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.
CREATE VIEW first_interval AS
SELECT  coun.name, COUNT(p_position.left_right) AS num 
FROM parlgov.party_position AS p_position, parlgov.party AS party, parlgov.country AS coun 
WHERE p_position.party_id = party.id AND party.country_id = coun.id AND p_position.left_right >= 0 AND p_position.left_right < 2 
GROUP BY coun.name;

CREATE VIEW second_interval AS
SELECT  coun.name, COUNT(p_position.left_right) AS num 
FROM parlgov.party_position AS p_position, parlgov.party AS party, parlgov.country AS coun 
WHERE p_position.party_id = party.id AND party.country_id = coun.id AND p_position.left_right >= 2 AND p_position.left_right < 4 
GROUP BY coun.name;

CREATE VIEW third_interval AS
SELECT  coun.name, COUNT(p_position.left_right) AS num 
FROM parlgov.party_position AS p_position, parlgov.party AS party, parlgov.country AS coun 
WHERE p_position.party_id = party.id AND party.country_id = coun.id AND p_position.left_right >= 4 AND p_position.left_right < 6 
GROUP BY coun.name;

CREATE VIEW fourth_interval AS
SELECT  coun.name, COUNT(p_position.left_right) AS num 
FROM parlgov.party_position AS p_position, parlgov.party AS party, parlgov.country AS coun 
WHERE p_position.party_id = party.id AND party.country_id = coun.id AND p_position.left_right >= 6 AND p_position.left_right < 8 
GROUP BY coun.name;

CREATE VIEW fifth_interval AS
SELECT  coun.name, COUNT(p_position.left_right) AS num 
FROM parlgov.party_position AS p_position, parlgov.party AS party, parlgov.country AS coun 
WHERE p_position.party_id = party.id AND party.country_id = coun.id AND p_position.left_right >= 8 AND p_position.left_right < 10 
GROUP BY coun.name;

CREATE VIEW final_answer AS
SELECT fir.name AS countryName, fir.num AS r_two, sec.num AS r_four, thi.num AS r_six, fou.num AS r_eight, fif.num AS r_ten 
FROM first_interval AS fir, second_interval AS sec, third_interval AS thi, fourth_interval AS fou, fifth_interval AS fif 
WHERE fir.name = sec.name AND sec.name = thi.name AND thi.name = fou.name AND fou.name = fif.name;

-- the answer to the query 
INSERT INTO q4 
SELECT countryName, r_two, r_four, r_six, r_eight, r_ten 
FROM final_answer

