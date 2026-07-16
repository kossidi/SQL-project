select * from data_test;


SELECT COUNT(DISTINCT user_id) AS november_mau
FROM data_test
WHERE date >= '2023-11-01' AND date <= '2023-11-30';
    
    
SELECT date, COUNT(DISTINCT user_id) AS dau
FROM data_test
WHERE date >= '2023-11-01' AND date <= '2023-11-30'
group by date;


SELECT ROUND(AVG(daily_dau), 0) AS average_dau
FROM (SELECT date, COUNT(DISTINCT user_id) AS daily_dau
    FROM data_test
    WHERE date >= '2023-11-01' AND date <= '2023-11-30'
    GROUP BY date
) AS subquery;


SELECT 
    COUNT(DISTINCT CASE WHEN date = '2023-11-01' THEN user_id END) AS cohort_size,
    COUNT(DISTINCT CASE WHEN date = '2023-11-02' THEN user_id END) AS returned_users,
    (CAST(COUNT(DISTINCT CASE WHEN date = '2023-11-02' THEN user_id END) AS DECIMAL(10,2)) / 
     COUNT(DISTINCT CASE WHEN date = '2023-11-01' THEN user_id END)) * 100 AS retention_day_1
FROM data_test
WHERE user_id IN (
    SELECT user_id FROM data_test WHERE date = '2023-11-01'
);


SELECT 
    (COUNT(DISTINCT CASE WHEN view_adverts > 0 THEN user_id END) * 1.0 / 
     COUNT(DISTINCT user_id)) * 100 AS conversion_rate_percent
FROM data_test
WHERE date >= '2023-11-01' AND date <= '2023-11-30';


SELECT 
    SUM(view_adverts) / COUNT(DISTINCT user_id) AS avg_views_per_user
FROM data_test
WHERE date >= '2023-11-01' AND date <= '2023-11-30';



