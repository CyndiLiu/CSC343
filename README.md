# CSC343
database practise

![alt text](https://raw.githubusercontent.com/CyndiLiu/CSC343/master/table_reference.png)


ddl -> CREATE SCHEMA parlgov;
       SET SEARCH_PATH to parlgov;


country(id, name, abbreviation, oecd_accession_date);
    -- id primary key
    -- name, abbreviation UNIQUE


party(id, country_id, name_short, name, description);
    -- id primary key
    -- country_id REFERENCES country(id)
    -- UNIQUE(country_id, name_short)

cabinet(id, country_id, start_date, name, wikipedia, description, comment, previous_cabinet_id, election_id);
    -- id primary key
    -- country_id REFERENCES country(id)
    -- name UNIQUE
    -- previous_cabinet_id INT REFERENCES cabinet(id)

cabinet_party(id, cabinet_id, party_id, pm, description);
    -- id INT PRIMARY KEY
    -- cabinet_id INT REFERENCES cabinet(id)
    -- party_id INT REFERENCES party(id)
    -- pm,  BOOLEAN NOT NULL

CREATE TYPE election_type AS ENUM('European Parliament', 'Parliamentary election');

election(id, country_id, e_date, wikipedia, seats_total, electorate, votes_cast, votes_valid, 
                       description, previous_parliament_election_id, previous_ep_election_id, e_type);
    -- id INT primary key
    -- country_id INT REFERENCES country(id),
    -- previous_parliament_election_id, INT REFERENCES election(id),
    -- previous_ep_election_id INT REFERENCES election(id),
    -- e_type election_type NOT NULL 

election_result(id, election_id, party_id, alliance_id, seats, votes, description);
    -- id INT PRIMARY KEY,
    -- election_id INT REFERENCES election(id),
    -- party_id INT REFERENCES party(id),
    -- alliance_id,  INT REFERENCES election_result(id),
    -- UNIQUE (election_id, party_id)

party_position(party_id, left_right, state_market, liberty_authority);
    -- party_id,  INT PRIMARY KEY REFERENCES party(id),
    -- left_right REAL CHECK(left_right >= 0.0 AND left_right <= 10.0),
    -- state_market REAL CHECK(state_market >= 0.0 AND state_market <= 10.0),
    -- liberty_authority REAL CHECK(liberty_authority >= 0.0 AND liberty_authority <= 10.0)

party_family(party_id, family);
    -- party_id INT REFERENCES party(id),
    -- PRIMARY KEY(party_id, family)

politician_president(id, country_id, start_date, end_date, party_id, description, comment);
    -- id INT PRIMARY KEY,
    -- country_id INT REFERENCES country(id),
    -- party_id INT REFERENCES party(id),


