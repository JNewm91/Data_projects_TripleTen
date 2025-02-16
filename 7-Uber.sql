-- Description of the data
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
        -- description: brief description of weather conditions, e.g. "light rain" or "scattered clouds"
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









