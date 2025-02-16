

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
