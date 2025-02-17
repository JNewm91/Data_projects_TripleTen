-- Description of the data:
-- A database with info on taxi rides in Chicago: neighborhoods table: data on city neighborhoods
     -- [neighborhoods table: data on city neighborhoods]
        -- name: name of the neighborhood
        -- neighborhood_id: neighborhood code
        -- cabs table: data on taxis
    -- [cabs table: data on taxis]
        -- cab_id: vehicle code
        -- vehicle_id: the vehicle's technical ID
        -- company_name: the company that owns the vehicle
        -- trips table: data on rides
     -- [trips table: data on rides]
        -- trip_id: ride code
        -- cab_id: code of the vehicle operating the ride
        -- start_ts: date and time of the beginning of the ride (time rounded to the hour)
        -- end_ts: date and time of the end of the ride (time rounded to the hour)
        -- duration_seconds: ride duration in seconds
        -- distance_miles: ride distance in miles
        -- pickup_location_id: pickup neighborhood code
        -- dropoff_location_id: dropoff neighborhood code
     -- [weather_records table: data on weather]
        -- record_id: weather record code
        -- ts: record date and time (time rounded to the hour)
        -- temperature: temperature when the record was taken
        -- description: a brief description of weather conditions, e.g. "light rain" or "scattered clouds"


-- The code below is used to find the number of taxi rides for each taxi company for November 15-16, 2017, and name the resulting field trips_amount, then print it. The results are sorted by the trips_amount field in descending order.

SELECT 
    company_name,
    COUNT(trip_id) AS trips_amount
FROM 
    cabs
        JOIN trips ON 
            cabs.cab_id = trips.cab_id 
WHERE 
    start_ts >= '2017-11-15' 
    AND start_ts < '2017-11-17'
GROUP BY 
    company_name 
ORDER BY 
    trips_amount DESC;


-- The code below is used to find the number of rides for every taxi company whose name contains the words "Yellow" or "Blue" for November 1-7, 2017. The resulting variable is named trips_amount and the results are grouped by the company_name field.

SELECT 
    company_name,
    COUNT(trip_id) AS trips_amount 
FROM 
    cabs 
    JOIN trips ON 
        cabs.cab_id = trips.cab_id 
WHERE 
    (company_name LIKE '%Yellow%' 
    OR company_name LIKE '%Blue%')
        AND start_ts >= '2017-11-01' 
        AND start_ts < '2017-11-08' 
GROUP BY 
    company_name
ORDER BY 
    trips_amount;


-- The code below is used to find the number of rides for the two most popular taxi companies: 'Flash Cab' and 'Taxi Affiliation Services'. The resulting variable was named 'trips_amount'. The rides for all other companies were joined in the group 'Other'. The data was then grouped by taxi company names and named 'company', with the results sorted in descending order by 'trips_amount'.

SELECT 
    company,
    COUNT(trip_id) AS trips_amount
FROM (
    SELECT 
        CASE 
            WHEN company_name IN 
            ('Flash Cab', 'Taxi Affiliation Services')
            THEN company_name 
            ELSE 'Other'
        END AS company,
        trip_id
    FROM 
        cabs
    JOIN trips ON 
        cabs.cab_id = trips.cab_id 
    WHERE 
        start_ts >= '2017-11-01' 
        AND start_ts < '2017-11-08'
) AS companies 
GROUP BY 
    company 
ORDER BY 
    trips_amount DESC;


-- The code below is used to Retrieve the identifiers of the O'Hare and Loop neighborhoods from the 'neighborhoods table'.

SELECT 
    neighborhood_id,
    name
FROM 
    neighborhoods 
WHERE 
    name LIKE '%Hare' OR name LIKE 'Loop';


-- The code below is used to retrieve the weather condition records from the 'weather_records' table for each hour. All hours are broken into two groups: 'Bad' if the description field contains the words 'rain' or 'storm', and 'Good' for others. The resulting field is named 'weather_conditions'.

SELECT 
    DATE_TRUNC('hour', ts) AS date_hour,
        CASE 
            WHEN description LIKE '%rain%' 
            OR description LIKE '%storm%' 
                    THEN 'Bad' ELSE 'Good'
        END AS weather_conditions 
FROM 
    weather_records 
ORDER BY 
    date_hour;


-- The code below is used to retrieve all the rides that started in the Loop (pickup_location_id: 50) on a Saturday and ended at O'Hare (dropoff_location_id: 63) from the 'trips' table. Also retrieved were the weather conditions and duration in seconds for each ride. Rides for which data on weather conditions is not available were omitted. 

SELECT 
    trips.start_ts AS start_ts,
    CASE 
        WHEN weather_records.description LIKE '%rain%' 
        OR weather_records.description LIKE '%storm%' 
        THEN 'Bad' ELSE 'Good'
    END AS weather_conditions, 
    trips.duration_seconds AS duration_seconds 
FROM 
    trips
    INNER JOIN 
        weather_records ON DATE_TRUNC('hour', trips.start_ts) 
        = DATE_TRUNC('hour', weather_records.ts)
WHERE 
    trips.pickup_location_id = 50 
    AND trips.dropoff_location_id = 63 
    AND EXTRACT('dow' FROM trips.start_ts) = 6 
    AND weather_records.description IS NOT NULL 
ORDER BY 
    trips.trip_id;
