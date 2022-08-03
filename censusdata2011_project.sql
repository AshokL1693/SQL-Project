CREATE TABLE data1(
District VARCHAR,
State VARCHAR,
growth FLOAT,
sex_ratio FLOAT,
literacy FLOAT
);

CREATE TABLE data2(
District VARCHAR,
State VARCHAR,
Area_km2 FLOAT,
Population FLOAT
);

select * from data1;
select * from data2;

-- calulate total no.of rows in datasets -- 
SELECT  COUNT(*) FROM data1;
SELECT  COUNT(*) FROM data2;

-- Generate data for andhrapradesh and westbengal -- 
SELECT * FROM data1
WHERE state IN ('Andhra Pradesh','West Bengal');

--Total population of India --
SELECT SUM(population) AS Tot_population FROM data2;

-- Average growth per state -- 
SELECT  state,AVG(growth)*100 AS Avg_growthrate 
FROM data1
GROUP BY state
ORDER BY AVG(growth)DESC;

-- Find average sex_ratio per state {used cast()fun.for round()fun as 
"The round syntax is round(numeric,int) not round(double precision,int)"}-- 

SELECT  state,ROUND(CAST (AVG (sex_ratio) AS NUMERIC), 0) AS Avg_growthrate 
FROM data1
GROUP BY state;

--Avg Literacy rate having more than 90--
SELECT  state,ROUND(CAST(AVG (literacy)AS NUMERIC),0) AS Avg_literacy 
FROM data1
GROUP BY state
HAVING AVG (literacy)>90
ORDER BY AVG (literacy) DESC;

-- Top 3 states having highest growth rate -- 
SELECT state, AVG(growth)*100 AS avg_growthrate FROM data1
GROUP BY state
ORDER BY AVG(growth) DESC
LIMIT 3;

-- Bottom 3 states having lowest sex_ratio -- 
SELECT  state,ROUND(CAST (AVG (sex_ratio) AS NUMERIC), 0) AS Avg_growthrate 
FROM data1
GROUP BY state
ORDER BY AVG (sex_ratio) ASC
LIMIT 3;

-- Top and Bottom 3 states in literacy rate -- 

WITH Topstates AS 
   (
       SELECT state, ROUND(CAST(AVG(literacy)AS NUMERIC), 0) AS Avg_literacy 
    FROM data1
    GROUP BY state
    ORDER BY AVG(literacy) DESC 
    LIMIT 3
   ), 
Bottom_states AS 

   (
       SELECT state, ROUND(CAST(AVG(literacy)AS NUMERIC), 0) AS Avg_literacy 
    FROM data1
    GROUP BY state
    ORDER BY AVG(literacy) ASC
    LIMIT 3 
   ) 
   
   SELECT * FROM Topstates
   UNION 
   SELECT * FROM Bottom_states;

-- States starting with letter 'a'--
SELECT DISTINCT state FROM data1 
WHERE state ILIKE 'a%';
   
-- Calculate total no.of females and males for each state -- 

SELECT d.state,sum(d.males)total_males,sum(d.females) total_females FROM
(SELECT c.district, c.state state, 
 ROUND(CAST(c.population/(c.sex_ratio+1)AS INTEGER),0)males,
 ROUND (CAST ((c.population * c.sex_ratio) /(c.sex_ratio+1) AS INTEGER),0)females 
 FROM
 (SELECT a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population FROM data1 a
  INNER JOIN data2 b
  ON a.district = b.district)c)d
  GROUP BY d.state;

-- Calculate Literate people and Illiterate people from literacy ratio -- 

SELECT c.state,SUM(literate_people)AS Total_literate,SUM(illiterate_people)AS Total_illiterate
FROM
(SELECT d.district,d.state, ROUND(CAST (d.literacy_ratio * d.population AS INTEGER),0) literate_people,
ROUND(CAST((1- d.literacy_ratio)* d.population AS INTEGER),0) illiterate_people FROM
(SELECT a.district,a.state, (a.literacy)/100 literacy_ratio,b.population FROM data1 a
INNER JOIN data2 b
ON a.district = b.district) d)c
GROUP BY c.state
ORDER BY c.state;

-- population in previous sensus compared to present population -- 

SELECT SUM(f.previous_census_population)Total_previous_census_population,
SUM(f.current_sensus_population)Total_current_sensus_population 
FROM
(SELECT d.state ,SUM(previous_census_population)previous_census_population,
SUM(current_sensus_population)current_sensus_population FROM
(SELECT c.district,c.state,ROUND(CAST(c.population/(1+c.growth_rate)AS NUMERIC),0) previous_census_population,
c.population current_sensus_population
FROM
(SELECT a.district,a.state, a.growth growth_rate,b.population FROM data1 a
INNER JOIN data2 b
ON a.district = b.district)c)d
GROUP BY d.state)f;

--  previous census population Vs Area & 
-- present census population Vs Area -- 

SELECT (j.total_area/j.total_previous_census_population)as previous_census_population_vs_area,
(j.total_area/j.total_current_sensus_population)as current_sensus_population_vs_area
FROM 
(SELECT k.*,l.total_area FROM 
(SELECT '1' AS KEY,h.* from
(SELECT SUM(f.previous_census_population)Total_previous_census_population,
SUM(f.current_sensus_population)Total_current_sensus_population 
FROM
(SELECT d.state ,SUM(previous_census_population)previous_census_population,
SUM(current_sensus_population)current_sensus_population FROM
(SELECT c.district,c.state,ROUND(CAST(c.population/(1+c.growth_rate)AS NUMERIC),0) previous_census_population,
c.population current_sensus_population
FROM
(SELECT a.district,a.state, a.growth growth_rate,b.population FROM data1 a
INNER JOIN data2 b
ON a.district = b.district)c)d
GROUP BY d.state)f)h)k inner join (

SELECT '1' AS KEY,g.* from
(SELECT SUM(area_km2) total_area from data2)g)l ON k.key = l.key)j;

-- Top 3 districts from each state having highest literacy rate --
-- Using window funcition -- 

SELECT a.* from
(SELECT district,state,literacy,
rank() OVER (PARTITION by state ORDER BY literacy DESC) FROM data1)a
WHERE a.rank in (1,2,3) ORDER BY state;
