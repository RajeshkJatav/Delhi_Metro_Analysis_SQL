CREATE TABLE dmdata (
    station_id INTEGER PRIMARY KEY,            -- Unique station ID
    station_name VARCHAR(100) NOT NULL,        -- Name of the metro station
    distance_from_start_km DECIMAL(5, 2),      -- Distance from the starting station (in km)
    line VARCHAR(50) NOT NULL,                 -- Name of the metro line (e.g., 'Blue Line')
    opening_date DATE,                         -- Date when the station was opened
    station_layout VARCHAR(50),                -- Layout of the station (e.g., 'Elevated', 'Underground')
    latitude DECIMAL(9, 6),                    -- Latitude of the station for geospatial data
    longitude DECIMAL(9, 6)                    -- Longitude of the station for geospatial data
);

1. **Question**: How do you select all the data from the table `dmdata`?

select * from dmdata

2. **Question**: How can you filter the records to show only stations on a specific line (e.g., "Blue Line")?

select * from dmdata
where  line='Blue line'

3. **Question**: How do you count the total number of stations in the data?

select count(*) from dmdata

4. **Question**: How do you find the stations opened after 2010?

select * from dmdata
where opening_date >'2010-01-01'

5. **Question**: How can you sort the stations by their opening date in ascending order?

select station_name, opening_date from dmdata 
order by opening_date asc

6. **Question**: How do you find the number of stations on each line?

SELECT line, COUNT(*) FROM dmdata GROUP BY line;

7. **Question**: How do you find the station with the latest opening date?

select * from dmdata
order by opening_date desc
limit 1

8. **Question**: How do you find all stations that were opened between 2000 and 2015?

select * from dmdata
where opening_date between '2000-01-01' and '2015-12-31'

9. **Question**: How can you calculate the average number of stations per line?

SELECT AVG(station_count) FROM (SELECT line, COUNT(*) as station_count FROM dmdata
GROUP BY line) AS line_stats;

10. **Question**: How do you retrieve the distinct lines from the table?

select distinct(line) from dmdata

11. **Question**: How do you find the top 3 lines with the most stations?

SELECT line, COUNT(*) as station_count FROM dmdata 
GROUP BY line 
ORDER BY station_count 
DESC LIMIT 3;

12. **Question**: How do you get the number of stations that opened per year?

SELECT EXTRACT(YEAR FROM opening_date) AS year, COUNT(*) FROM dmdata 
GROUP BY year 
ORDER BY year;

13. **Question**: Write a query to find the longest line by number of stations.

SELECT line, COUNT(*) as station_count FROM dmdata 
GROUP BY line 
ORDER BY station_count DESC 
LIMIT 1;

14. **Question**: How do you find stations that share the same name but are on different lines?

SELECT station_name, COUNT(DISTINCT line) FROM dmdata 
GROUP BY station_name 
HAVING COUNT(DISTINCT line) > 1;

15. **Question**: How do you find the total number of stations opened in the last 5 years?

SELECT COUNT(*) FROM dmdata 
WHERE opening_date >= (CURRENT_DATE - INTERVAL '5 years');

16. **Question**: How can you calculate the total number of stations per year and display it with a cumulative total?

SELECT 
        EXTRACT(YEAR FROM opening_date) AS year, 
        COUNT(*) AS stations_opened, 
        SUM(COUNT(*)) OVER (ORDER BY EXTRACT(YEAR FROM opening_date)) AS cumulative_stations 
    FROM dmdata 
    GROUP BY year;

	
17. **Question**: How can you delete stations that were closed before the year 2000?

DELETE FROM dmdata WHERE opening_date < '2000-01-01';

18. **Question**: How do you update the line name for a specific station?

UPDATE dmdata SET line = 'New Line' WHERE station_name = 'Station X';

20. **Question**: How can you handle missing data for stations that do not have an opening date?
 
 
    SELECT * FROM dmdata WHERE opened IS NULL;
  

### Advanced Complex Queries:

21. **Question**: Write a query to find the top 2 years with the highest number of station openings.
   
    SELECT EXTRACT(YEAR FROM opened) AS year, COUNT(*) as stations_opened 
    FROM dmdata 
    GROUP BY year 
    ORDER BY stations_opened DESC 
    LIMIT 2;
 

22. **Question**: How can you generate a pivot table showing the count of stations by line and year?
   
   
    SELECT line, 
           SUM(CASE WHEN EXTRACT(YEAR FROM opened) = 2010 THEN 1 ELSE 0 END) AS "2010",
           SUM(CASE WHEN EXTRACT(YEAR FROM opened) = 2011 THEN 1 ELSE 0 END) AS "2011",
          
    FROM dmdata
    GROUP BY line;
  

23. **Question**: How do you add a new column to the table that indicates whether a station is "old" or "new" based on the opening date (before or after 2015)?
    
   
    ALTER TABLE dmdata ADD COLUMN station_age VARCHAR(10);

    UPDATE dmdata SET station_age = CASE 
        WHEN opening_date < '2015-01-01' THEN 'Old' 
        ELSE 'New' 
    END;
  

24. **Question**: Write a recursive query to show stations connected in a circular route (if applicable).
 
     
    WITH RECURSIVE station_circle AS (
        SELECT station_name, next_station_name FROM dmdata WHERE station_name = 'Station A'
        UNION ALL
        SELECT dm.station_name, dm.next_station_name
        FROM dmdata dm
        INNER JOIN station_circle sc ON dm.station_name = sc.next_station_name
    )
    SELECT * FROM station_circle;
    

25. **Question**: How can you rank the stations by their opening date within each line?
    
   
    SELECT station_name, line, opening_date,
           RANK() OVER (PARTITION BY line ORDER BY opening_date) as rank
    FROM dmdata;





