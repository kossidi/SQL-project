### список клиентов с непрерывной историей за год, то есть каждый месяц на регулярной основе без пропусков за указанный годовой период

SELECT ID_client
	FROM transactions
	WHERE date_new >= '2015-06-01' 
	AND date_new <= '2016-06-01'
	GROUP BY ID_client
	HAVING COUNT(DISTINCT DATE_FORMAT(date_new, '%Y-%m')) = 12;

SELECT ID_client, COUNT(DISTINCT DATE_FORMAT(date_new, '%Y-%m')) as active_months
	FROM transactions
	WHERE date_new >= '2015-06-01' AND date_new <= '2016-06-01'
	GROUP BY ID_client
	ORDER BY active_months DESC
	LIMIT 20;

### средний чек за период с 01.06.2015 по 01.06.2016

select ID_client, avg(Sum_payment) as avg_sum_payment
	from transactions
	where date_new >='2015-06-01' and date_new <='2016-06-01'
	group by ID_client; 

### средняя сумма покупок за месяц

SELECT trans_month,
    AVG(total_monthly_spend) AS global_avg_monthly_spend
FROM (
    SELECT 
        ID_client,
        DATE_FORMAT(date_new, '%Y-%m') AS trans_month,
        SUM(Sum_payment) AS total_monthly_spend
    FROM transactions
    WHERE date_new >= '2015-06-01' AND date_new <= '2016-06-01'
    GROUP BY ID_client, trans_month
) AS subquery
GROUP BY trans_month;

### количество всех операций по клиенту за период

SELECT 
    ID_client, 
    COUNT(Id_check) AS total_operations
FROM transactions
WHERE date_new >= '2015-06-01' AND date_new <= '2016-06-01'
GROUP BY ID_client;

### средняя сумма чека в месяц

SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS trans_month,
    AVG(Sum_payment) AS avg_check_monthly
FROM transactions
WHERE date_new >= '2015-06-01' AND date_new <= '2016-06-01'
GROUP BY trans_month
ORDER BY trans_month;

### среднее количество операций в месяц

SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS trans_month,
    AVG(ID_check) AS avg_check_monthly
FROM transactions
WHERE date_new >= '2015-06-01' AND date_new <= '2016-06-01'
GROUP BY trans_month
ORDER BY trans_month;

### среднее количество клиентов, которые совершали операции

SELECT AVG(active_clients_count) AS avg_active_clients_per_month
FROM (
    SELECT 
        DATE_FORMAT(date_new, '%Y-%m') AS trans_month,
        COUNT(DISTINCT ID_client) AS active_clients_count
    FROM transactions
    WHERE date_new >= '2015-06-01' AND date_new <= '2016-06-01'
    GROUP BY trans_month
) AS monthly_stats;

### долю от общего количества операций за год и долю в месяц от общей суммы операций

SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS trans_month,
    COUNT(Id_check) AS ops_in_month,
    COUNT(Id_check) * 100.0 / SUM(COUNT(Id_check)) OVER() AS pct_ops_of_total_year,
    SUM(Sum_payment) AS sum_in_month,
    SUM(Sum_payment) * 100.0 / SUM(SUM(Sum_payment)) OVER() AS pct_sum_of_total_year
FROM transactions
WHERE date_new >= '2015-06-01' AND date_new <= '2016-06-01'
GROUP BY trans_month;

### вывести % соотношение M/F/NA в каждом месяце с их долей затрат

SELECT 
    DATE_FORMAT(t.date_new, '%Y-%m') AS trans_month,
    IFNULL(c.gender, 'NA') AS gender,
    COUNT(t.Id_check) * 100.0 / SUM(COUNT(t.Id_check)) OVER(PARTITION BY DATE_FORMAT(t.date_new, '%Y-%m')) AS pct_ops_by_gender,
    SUM(t.Sum_payment) * 100.0 / SUM(SUM(t.Sum_payment)) OVER(PARTITION BY DATE_FORMAT(t.date_new, '%Y-%m')) AS pct_spend_by_gender
FROM transactions t
LEFT JOIN customers c ON t.ID_client = c.ID_client
WHERE t.date_new >= '2015-06-01' AND t.date_new < '2016-06-01'
GROUP BY trans_month, gender;

### возрастные группы клиентов с шагом 10 лет и отдельно клиентов, у которых нет данной информации, с параметрами сумма и количество операций за весь период, и поквартально - средние показатели и %.

SELECT 
    DATE_FORMAT(t.date_new, '%Y-%m') AS month,
    COALESCE(c.gender, 'NA') AS gen,
    COUNT(*) AS ops,
    SUM(t.Sum_payment) AS total
FROM transactions t
LEFT JOIN customers c USING(ID_client)
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month, gen;








