/* 
Jamie Huang, jhuan131
Alexey Solganik, asolgan1
Zach Zhou, zzhou43
*/


DROP TABLE IF EXISTS CovidData;
DROP TABLE IF EXISTS AnnualCountryData;
DROP TABLE IF EXISTS AnnualEconData; 
DROP TABLE IF EXISTS Vaccination;
DROP TABLE IF EXISTS Country;

SET sql_notes = 0;

CREATE TABLE Country (
        name VARCHAR(50),
        migrantStock DOUBLE,
        stimulus DOUBLE,
        inOecd BOOLEAN,
        publicHealthcare BOOLEAN,
        dailyVacc INT,
        totalVacc INT,
        PRIMARY KEY(name)
);

CREATE TABLE Vaccination (
        name VARCHAR(50),
        dailyVacc INT,
        totalVacc INT,       
        PRIMARY KEY(name),
        FOREIGN KEY (name) REFERENCES Country(name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CovidData (
        name VARCHAR(50),
        month CHAR(8),
        deaths INT,
        cases INT,
        PRIMARY KEY(name, month),
        FOREIGN KEY (name) REFERENCES Country(name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AnnualCountryData (
        name VARCHAR(50),
        year INT,
        population INT,
        populationDensity DOUBLE,
        PRIMARY KEY(name, year),
        FOREIGN KEY (name) REFERENCES Country(name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AnnualEconData (
        name VARCHAR(50),
        year INT,
        unemploymentRate DOUBLE,
        netLB DOUBLE,
        cpi DOUBLE,
        gdp DOUBLE,
        PRIMARY KEY(name, year),
        FOREIGN KEY (name) REFERENCES Country(name) ON DELETE CASCADE ON UPDATE CASCADE
        
);

DROP VIEW IF EXISTS CovidData2020;

CREATE VIEW CovidData2020 AS
SELECT name, SUM(deaths) AS deaths, SUM(cases) AS cases
FROM CovidData
WHERE month LIKE "%2020%"
GROUP BY name;


LOAD DATA LOCAL INFILE './country.txt'
INTO TABLE Country
FIELDS TERMINATED BY ','
(@name, @migrantstock, @stimulus, @inOecd, @publicHealthcare, @dailyVacc, @totalVacc)
SET
name = TRIM(@name),
migrantStock = NULLIF(@migrantStock, ' '),
stimulus = NULLIF(@stimulus, ' '),
inOecd = NULLIF(@inOecd, ' '),
publicHealthcare = NULLIF(@publicHealthcare, ' '),
dailyVacc = NULLIF(@dailyVacc, ' '),
totalVacc = NULLIF(@totalVacc, ' ');


LOAD DATA LOCAL INFILE './vaccination.txt'
INTO TABLE Vaccination
FIELDS TERMINATED BY ','
(@name, @totalVacc, @dailyVacc)
SET
name = TRIM(@name),
dailyVacc = NULLIF(@dailyVacc, ' '),
totalVacc = NULLIF(@totalVacc, ' ');

UPDATE Country, Vaccination
SET Country.dailyVacc = Vaccination.dailyVacc, Country.totalVacc = Vaccination.totalVacc
WHERE Country.name = Vaccination.name;

DROP TABLE IF EXISTS Vaccination;

LOAD DATA LOCAL INFILE './annualecondata.txt'
INTO TABLE AnnualEconData
FIELDS TERMINATED BY ','
(@name, year, @gdp, @cpi, @unemploymentRate, @netLB)
SET
name = TRIM(@name),
unemploymentRate = NULLIF(@unemploymentRate, ' '),
netLB = NULLIF(@netLb, ' '),
cpi = NULLIF(@cpi, ' '),
gdp = NULLIF(@gdp, ' ');

LOAD DATA LOCAL INFILE './coviddata.txt'
INTO TABLE CovidData
FIELDS TERMINATED BY ','
(@name, @month, @cases, @deaths)
SET
name = TRIM(@name), 
month = TRIM(@month),
deaths = NULLIF(@deaths, ' '),
cases = NULLIF(@cases, ' ');

LOAD DATA LOCAL INFILE './annualcountrydata.txt'
INTO TABLE AnnualCountryData
FIELDS TERMINATED BY ','
(@name, year, @population, @populationDensity)
SET
name = TRIM(@name),
population = NULLIF(@population, ' '),
populationDensity = NULLIF(@populationDensity, ' ');


/* SET UP PROCEDURES */

DROP PROCEDURE IF EXISTS GetCountryData;
DROP PROCEDURE IF EXISTS GetAllCountriesSortedBy;
DROP PROCEDURE IF EXISTS GetAnnualData;
DROP PROCEDURE IF EXISTS GetAllAnnualDataSortedBy;
DROP PROCEDURE IF EXISTS GetCovidData;
DROP PROCEDURE IF EXISTS UpsertCountryTuple;
DROP PROCEDURE IF EXISTS UpsertCovidDataTuple;
DROP PROCEDURE IF EXISTS UpsertAnnualCountryDataTuple;
DROP PROCEDURE IF EXISTS UpsertAnnualEconDataTuple;
DROP PROCEDURE IF EXISTS DeleteCountryTuple;
DROP PROCEDURE IF EXISTS DeleteCovidDataTuple;
DROP PROCEDURE IF EXISTS DeleteAnnualCountryDataTuple;
DROP PROCEDURE IF EXISTS DeleteAnnualEconDataTuple;
DROP PROCEDURE IF EXISTS TopCountries;
DROP PROCEDURE IF EXISTS LowVaxRate;
DROP PROCEDURE IF EXISTS EmploymentRate;
DROP PROCEDURE IF EXISTS GetCPIAboveCovidCases;
DROP PROCEDURE IF EXISTS GDPAboveAndBelow;
DROP PROCEDURE IF EXISTS NetLbRange;
DROP PROCEDURE IF EXISTS ShowGDPGrowth;

DELIMITER $$

/* Given a country name, return country's basic information from Country relation */
CREATE PROCEDURE GetCountryData(IN countryName VARCHAR(50))
BEGIN 
    SELECT * 
    FROM Country
    WHERE name = countryName;
END; $$

/* Given a column to sort by and a direction (ASC or DESC), return all countries sorted */
CREATE PROCEDURE GetAllCountriesSortedBy(IN col VARCHAR(50), IN dir VARCHAR(5))
BEGIN
    IF dir = 'ASC' THEN
        SELECT *
        FROM Country
        ORDER BY 
        (CASE WHEN col = 'name' THEN name ELSE '' END),
        (CASE WHEN col = 'migrantStock' THEN migrantStock ELSE 0.0 END),
        (CASE WHEN col = 'stimulus' THEN stimulus ELSE 0.0 END) ,
        (CASE WHEN col = 'publicHealthcare' THEN publicHealthcare ELSE true END),
        (CASE WHEN col = 'inOECD' THEN inOECD ELSE true END),
        (CASE WHEN col = 'dailyVacc' THEN dailyVacc ELSE 0 END), 
        (CASE WHEN col = 'totalVacc' THEN totalVacc ELSE 0 END);
    ELSE 
        SELECT *
        FROM Country
        ORDER BY 
        (CASE WHEN col = 'name' THEN name ELSE '' END) DESC ,
        (CASE WHEN col = 'migrantStock' THEN migrantStock ELSE 0.0 END) DESC,
        (CASE WHEN col = 'stimulus' THEN stimulus ELSE 0.0 END) DESC,
        (CASE WHEN col = 'publicHealthcare' THEN publicHealthcare ELSE true END) DESC,
        (CASE WHEN col = 'inOECD' THEN inOECD ELSE true END) DESC,
        (CASE WHEN col = 'dailyVacc' THEN dailyVacc ELSE 0 END) DESC, 
        (CASE WHEN col = 'totalVacc' THEN totalVacc ELSE 0 END) DESC;
    END IF;
END; $$


/* Given a country name, retrieve it's annual econ data and annual country data */
CREATE PROCEDURE GetAnnualData(IN countryName VARCHAR(50))
BEGIN
    SELECT COALESCE(E.name, C.name) AS name, COALESCE(E.year, C.year) AS year, E.unemploymentRate, E.netLB, E.cpi, E.gdp, C.population, C.populationDensity
    FROM AnnualEconData AS E 
    LEFT OUTER JOIN AnnualCountryData AS C
    ON E.name = C.name AND E.year = C.year
    WHERE E.name = countryName OR C.name = countryName
    UNION 
    SELECT COALESCE(E.name, C.name) AS name, COALESCE(E.year, C.year) AS year, E.unemploymentRate, E.netLB, E.cpi, E.gdp, C.population, C.populationDensity
    FROM AnnualEconData AS E 
    RIGHT OUTER JOIN AnnualCountryData AS C
    ON E.name = C.name AND E.year = C.year
    WHERE E.name = countryName OR C.name = countryName
    ORDER BY year;
END; $$

/* Given a column to sort by and a direction, return all sorted annual data */

CREATE PROCEDURE GetAllAnnualDataSortedBy(IN col VARCHAR(50), IN dir VARCHAR(5))
BEGIN
    IF dir = 'ASC' THEN 
        SELECT COALESCE(E.name, C.name) AS name, COALESCE(E.year, C.year) AS year, E.unemploymentRate, E.netLB, E.cpi, E.gdp, C.population, C.populationDensity
        FROM AnnualEconData AS E 
        LEFT OUTER JOIN AnnualCountryData AS C
        ON E.name = C.name AND E.year = C.year
        UNION 
        SELECT COALESCE(E.name, C.name) AS name, COALESCE(E.year, C.year) AS year, E.unemploymentRate, E.netLB, E.cpi, E.gdp, C.population, C.populationDensity
        FROM AnnualEconData AS E 
        RIGHT OUTER JOIN AnnualCountryData AS C
        ON E.name = C.name AND E.year = C.year
        ORDER BY 
        (CASE WHEN col = 'name' THEN name ELSE '' END), 
        (CASE WHEN col = 'year' THEN year ELSE 0 END),
        (CASE WHEN col = 'unemploymentRate' THEN unemploymentRate ELSE 0.0 END),
        (CASE WHEN col = 'netLB' THEN netLB ELSE 0.0 END),
        (CASE WHEN col = 'cpi' THEN cpi ELSE 0.0 END),
        (CASE WHEN col = 'gdp' THEN gdp ELSE 0.0 END),
        (CASE WHEN col = 'population' THEN population ELSE 0 END),
        (CASE WHEN col = 'populationDensity' THEN populationDensity ELSE 0.0 END);
    ELSE
        SELECT COALESCE(E.name, C.name) AS name, COALESCE(E.year, C.year) AS year, E.unemploymentRate, E.netLB, E.cpi, E.gdp, C.population, C.populationDensity
        FROM AnnualEconData AS E 
        LEFT OUTER JOIN AnnualCountryData AS C
        ON E.name = C.name AND E.year = C.year
        UNION 
        SELECT COALESCE(E.name, C.name) AS name, COALESCE(E.year, C.year) AS year, E.unemploymentRate, E.netLB, E.cpi, E.gdp, C.population, C.populationDensity
        FROM AnnualEconData AS E 
        RIGHT OUTER JOIN AnnualCountryData AS C
        ON E.name = C.name AND E.year = C.year
        ORDER BY 
        (CASE WHEN col = 'name' THEN name ELSE '' END) DESC, 
        (CASE WHEN col = 'year' THEN year ELSE 0 END) DESC,
        (CASE WHEN col = 'unemploymentRate' THEN unemploymentRate ELSE 0.0 END) DESC,
        (CASE WHEN col = 'netLB' THEN netLB ELSE 0.0 END) DESC,
        (CASE WHEN col = 'cpi' THEN cpi ELSE 0.0 END) DESC,
        (CASE WHEN col = 'gdp' THEN gdp ELSE 0.0 END) DESC,
        (CASE WHEN col = 'population' THEN population ELSE 0 END) DESC,
        (CASE WHEN col = 'populationDensity' THEN populationDensity ELSE 0.0 END) DESC;
    END IF;
END; $$

/* Given a country's name, get's COVID data sorted by date */
CREATE PROCEDURE GetCovidData(IN countryName VARCHAR(50))
BEGIN 
    SELECT month, deaths, cases
    FROM CovidData
    WHERE name = countryName
    ORDER BY month ASC;
END; $$


/* Upsert a country */
CREATE PROCEDURE UpsertCountryTuple 
        (IN nm VARCHAR(50), IN migrant DOUBLE, IN stim DOUBLE, IN oecd BOOLEAN, IN hcare BOOLEAN, IN dVacc INT, IN tVacc INT)
BEGIN 
        IF EXISTS (SELECT * FROM Country WHERE name = nm) THEN
                UPDATE Country
                SET migrantStock = migrant, stimulus = stim, inOECD = oecd, publicHealthcare = hcare, dailyVacc = dVacc, totalVacc = tVacc
                WHERE name = nm;
                SELECT "Succesfully updated existing country", nm, migrant, stim, oecd, hcare, dVacc, tVacc;
        ELSE 
                INSERT INTO Country
                VALUES(nm, migrant, stim, oecd, hcare, dVacc, tVacc);
                SELECT "Succesfully inserted new country", nm, migrant, stim, oecd, hcare, dVacc, tVacc;
        END IF;
END; $$


/* Upsert Covid Data */
CREATE PROCEDURE UpsertCovidDataTuple
        (IN nm VARCHAR(50), IN m CHAR(8), IN d INT, IN c INT)
BEGIN
        IF NOT EXISTS (SELECT * FROM Country WHERE name = nm) THEN
                SELECT CONCAT("Country with name ", nm, " does not exist. Please add it first");
        ELSEIF EXISTS (SELECT * FROM CovidData WHERE name = nm AND month = m) THEN
                UPDATE CovidData
                SET deaths = d, cases = c
                WHERE name = nm AND month = m;
                SELECT "Successfully updated existing COVID data", nm, m, d, c;
        ELSE 
                INSERT INTO CovidData
                VALUES(nm, m, d, c);
                SELECT "Sucessfully inserted new COVID data", nm, m, d,c;
        END IF;    
END; $$

/* Upsert Annual Country Data */
CREATE PROCEDURE UpsertAnnualCountryDataTuple
        (IN nm VARCHAR(50), IN y CHAR(4), IN p INT, IN pd DOUBLE)
BEGIN
        IF NOT EXISTS (SELECT * FROM Country WHERE name = nm) THEN
                SELECT CONCAT("Country with name ", nm, " does not exist. Please add it first");
        ELSEIF EXISTS (SELECT * FROM AnnualCountryData WHERE name = nm AND year = y) THEN
                UPDATE AnnualCountryData
                SET population = p, populationDensity = pd
                WHERE name = nm AND year = y;
                SELECT "Successfully updated existing Annual Country Data", nm, y, p, pd;
        ELSE 
                INSERT INTO AnnualCountryData
                VALUES(nm, y, p, pd);
                SELECT "Sucessfully inserted new Annual Country Data", nm, y, p, pd;
        END IF;    
END; $$

/* Upsert annual econ data */
CREATE PROCEDURE UpsertAnnualEconDataTuple
        (IN nm VARCHAR(50), IN y CHAR(4), IN ur DOUBLE, IN nlb DOUBLE, IN c DOUBLE, IN g DOUBLE)
BEGIN
        IF NOT EXISTS (SELECT * FROM Country WHERE name = nm) THEN
                SELECT CONCAT("Country with name ", nm, " does not exist. Please add it first");
        ELSEIF EXISTS (SELECT * FROM AnnualEconData WHERE name = nm AND year = y) THEN
                UPDATE AnnualEconData
                SET unemploymentRate = ur, netLB = nlb, cpi = c, gdp = g
                WHERE name = nm AND year = y;
                SELECT "Successfully updated existing Annual Econ Data", nm, y, ur, nlb, c, g;
        ELSE 
                INSERT INTO AnnualEconData
                VALUES(nm, y, ur, nlb, c, g);
                SELECT "Sucessfully inserted new Annual Econ Data", nm, y, ur, nlb, c, g;
        END IF;    
END; $$


/* Delete a country */
CREATE PROCEDURE DeleteCountryTuple
        (IN nm VARCHAR(50))
BEGIN
        IF EXISTS (SELECT * FROM Country WHERE name = nm) THEN
                DELETE FROM Country
                WHERE name = nm; 
                SELECT CONCAT("Sucessfully deleted country with name: ", nm);
        ELSE
                SELECT CONCAT("No country with the name: ", nm, " was found. No deletion was performed"); 
        END IF;
END; $$

/* Delete a covid data */
CREATE PROCEDURE DeleteCovidDataTuple
        (IN nm VARCHAR(50), IN m CHAR(8))
BEGIN
        IF EXISTS (SELECT * FROM CovidData WHERE name = nm AND month = m) THEN
                DELETE FROM CovidData
                WHERE name = nm AND month = m; 
                SELECT CONCAT("Sucessfully deleted COVID data with country name: ", nm, " and month: ", m);
        ELSE
                SELECT CONCAT("No COVID Data with the country name: ", nm, " and month: ", m, " was found. No deletion was performed"); 
        END IF;
END; $$

/* Delete an annual country data tuple */
CREATE PROCEDURE DeleteAnnualCountryDataTuple
        (IN nm VARCHAR(50), IN y CHAR(4))
BEGIN
        IF EXISTS (SELECT * FROM AnnualCountryData WHERE name = nm AND year = y) THEN
                DELETE FROM AnnualCountryData
                WHERE name = nm AND year = y; 
                SELECT CONCAT("Sucessfully deleted Annual Country Data with country name: ", nm, " and year: ", y);
        ELSE
                SELECT CONCAT("No Annual Country Data with the country name: ", nm, " and year: ", y, " was found. No deletion was performed"); 
        END IF;
END; $$

/* Delete an annual econ data tuple */
CREATE PROCEDURE DeleteAnnualEconDataTuple
        (IN nm VARCHAR(50), IN y CHAR(4))
BEGIN
        IF EXISTS (SELECT * FROM AnnualEconData WHERE name = nm AND year = y) THEN
                DELETE FROM AnnualEconData
                WHERE name = nm AND year = y; 
                SELECT CONCAT("Sucessfully deleted Annual Econ Data with country name: ", nm, " and year: ", y);
        ELSE
                SELECT CONCAT("No Annual Econ Data with the country name: ", nm, " and year: ", y, " was found. No deletion was performed"); 
        END IF;
END; $$
                                      
/* Given month and year, output the top n countries by covid cases or deaths two buttons for each */
CREATE PROCEDURE TopCountries(IN mo VARCHAR(4), IN y VARCHAR(4), IN dir INT)
BEGIN
        IF dir = 0 THEN
           SELECT *
           FROM CovidData AS C
           WHERE SUBSTRING(C.month, 1, 4) = y AND SUBSTRING(C.month, 6, 8) = mo AND C.cases IS NOT NULL
           ORDER BY C.cases DESC
           LIMIT 10;
        ELSE
           SELECT *
           FROM CovidData AS C
           WHERE SUBSTRING(C.month, 1, 4) = y AND SUBSTRING(C.month, 6, 8) = mo AND C.cases IS NOT NULL
           ORDER BY C.deaths DESC
           LIMIT 10;
        END IF;
END; $$
                                                                               
/* Given user input of population desnity n, output the country with the lowest\
 vaccination rate with population density less than n. */
CREATE PROCEDURE LowVaxRate(IN n INT)
BEGIN
WITH VaccRate AS
       (SELECT C.name AS name, C.totalVacc / ACD.population / 10 AS VaccRate
        FROM Country AS C, AnnualCountryData AS ACD
        WHERE C.name = ACD.name AND ACD.year = 2020 AND ACD.population IS NOT NULL AND C.totalVacc IS NOT NULL)
SELECT ACD.name, MIN(V.VaccRate) AS VaccRate
FROM AnnualCountryData AS ACD, VaccRate AS V
WHERE ACD.year = 2020 AND ACD.populationDensity < n AND V.name = ACD.name;
END; $$

       
/* Radio or toggle buttons to switch from lower to higher unemployment rate and sort ascending/descending cases. */                                                                                          
CREATE PROCEDURE EmploymentRate(IN dir INT)
BEGIN
IF dir = 0 THEN
   WITH negativeDeltaURate AS
        (SELECT A1.name AS name, A2.unemploymentRate - A1.unemploymentRate AS changeInUnemploymentRate
         FROM AnnualEconData AS A1, AnnualEconData AS A2
         WHERE A1.name = A2.name AND A1.year = 2020 AND A2.year = 2021 AND A2.unemploymentRate < A1.unemploymentRate)
   SELECT U.name, U.changeInUnemploymentRate, C.cases
   FROM negativeDeltaURate AS U, CovidData2020 AS C
   WHERE U.name = C.name AND C.cases IS NOT NULL
   ORDER BY C.cases ASC;
ELSE
   WITH positiveDeltaURate AS
        (SELECT A1.name AS name, A2.unemploymentRate - A1.unemploymentRate AS changeInUnemploymentRate
         FROM AnnualEconData AS A1, AnnualEconData AS A2
         WHERE A1.name = A2.name AND A1.year = 2020 AND A2.year = 2021 AND A2.unemploymentRate > A1.unemploymentRate)
   SELECT U.name, U.changeInUnemploymentRate, C.cases
   FROM positiveDeltaURate AS U, CovidData2020 AS C
   WHERE U.name = C.name AND C.cases IS NOT NULL
   ORDER BY C.cases DESC;
END IF;
END; $$      
                                         
/*Given covid cases, list all countries that have greater than that number of cases along with their change in CPI */                                   
CREATE PROCEDURE GetCPIAboveCovidCases(IN caseNum INT)
BEGIN
  WITH ChangeInCPI AS 
       (SELECT A1.name AS name, A2.cpi - A1.cpi AS cpiChange
       FROM AnnualEconData as A1, AnnualEconData as A2
       WHERE A1.name = A2.name AND A1.year = 2020 AND A2.year = 2021),
   MaxCount AS
       (SELECT name, MAX(cases) AS cases
       FROM CovidData
       GROUP BY name)
  SELECT C.name, cpiChange
  FROM ChangeInCPI AS C JOIN MaxCount AS M ON C.name = M.name
  WHERE cases > caseNum;
  END; $$

/* Give a mean GDP, list all countries with GDP above that, and list all countries with GDP below that in two tables */
CREATE PROCEDURE GDPAboveAndBelow(IN meanGDP INT, IN dir VARCHAR(10))
BEGIN
   IF dir = 'Above' THEN
	SELECT DISTINCT name, gdp
  	FROM AnnualEconData AS AEC
  	WHERE gdp> meanGDP AND year = 2021;
   ELSE	
  	SELECT DISTINCT name, gdp
  	FROM AnnualEconData AS AEC
  	WHERE gdp < meanGDP AND year = 2021;
   END IF;
END;$$

/*Give two numbers for net_lb, find countries whose net_lb is between that range. Also indicate stimulusif they have it */
CREATE PROCEDURE NetLbRange(In low INT, In high INT)
BEGIN
SELECT AED.name AS name, C.stimulus AS stimulus
FROM AnnualEconData as AED LEFT OUTER JOIN Country AS C ON AED.name = C.name
WHERE netLB > low AND netLB < high AND year = 2020
ORDER BY netLB ASC;
END;$$          
								 
CREATE PROCEDURE showGDPGrowth(In country VARCHAR(15))
BEGIN
SELECT AED1.name AS name, AED2.gdp - AED1.gdp
FROM AnnualEconData as AED1 JOIN AnnualEconData as AED2 ON AED1.name = AED2.name
WHERE AED1.year = 2020 AND AED2.year = 2021 AND AED1.name = country;
END;$$
                                                                                          
DELIMITER ;

