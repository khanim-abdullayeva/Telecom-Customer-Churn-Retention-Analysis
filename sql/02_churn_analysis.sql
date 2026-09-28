-- Churn by Conract Renewal


SELECT
	contract_renewal AS 'Contract Renewal',
	churn AS 'Churn',
	COUNT(*) AS 'Count',
	ROUND((SELECT COUNT(*) FROM telecom_churn WHERE churn = 1 and contract_renewal = 1)*1.0/ (SELECT COUNT(*) FROM telecom_churn WHERE contract_renewal = 1)*100,2) AS 'Churn Rate'
FROM
	telecom_churn
WHERE
	contract_renewal = 1 AND churn = 1
GROUP BY 
	contract_renewal,churn;
	
-- Churn Rate of Customers who have Contract Renewal : 11.50 %



SELECT
	contract_renewal AS 'Contract Renewal',
	churn AS 'Churn',
	COUNT(*) AS 'Count',
	ROUND((SELECT COUNT(*) FROM telecom_churn WHERE churn = 1 and contract_renewal = 0)*1.0/ (SELECT COUNT(*) FROM telecom_churn WHERE contract_renewal = 0)*100,2) AS 'Churn Rate'
FROM
	telecom_churn
WHERE
	contract_renewal = 0 AND churn = 1
GROUP BY 
	contract_renewal,churn;
	
-- Churn Rate of Customers who do not have Contract Renewal : 42.41 %



-- Churn by Data Plan


SELECT
	data_plan AS 'Data Plan',
	churn AS 'Churn',
	COUNT(*) AS 'Count',
	ROUND((SELECT COUNT(*) FROM telecom_churn WHERE churn = 1 and data_plan = 1)*1.0/ (SELECT COUNT(*) FROM telecom_churn WHERE data_plan = 1)*100,2) AS 'Churn Rate'
FROM
	telecom_churn
WHERE
	data_plan = 1 AND churn = 1
GROUP BY 
	data_plan,churn;

-- Churn Rate of Customers who have Data Plan : 8.68 %


SELECT
	data_plan AS 'Data Plan',
	churn AS 'Churn',
	COUNT(*) AS 'Count',
	ROUND((SELECT COUNT(*) FROM telecom_churn WHERE churn = 1 and data_plan = 0)*1.0/ (SELECT COUNT(*) FROM telecom_churn WHERE data_plan = 0)*100,2) AS 'Churn Rate'
FROM
	telecom_churn
WHERE
	data_plan = 0 AND churn = 1
GROUP BY 
	data_plan,churn;

-- Churn Rate of Customers who do not have Data Plan : 16.72 %



-- Churn by Customer Service Calls


CREATE TEMP TABLE joined AS
SELECT 
	c.*,
	c1."Churned Customers"
FROM
	(SELECT 
		cust_serv_calls AS "Customer Service Calls",
		COUNT(*) AS "Total Customers"
	FROM
		telecom_churn
	GROUP BY 
		cust_serv_calls) c
LEFT JOIN 
	(SELECT 
		cust_serv_calls AS "Customer Service Calls",
		COUNT(*) AS "Churned Customers"
	FROM
		telecom_churn
	WHERE
		churn = 1
	GROUP BY 
		cust_serv_calls) c1
ON 
	c."Customer Service Calls" = c1."Customer Service Calls"
;

SELECT 
	*,
	ROUND(("Churned Customers" * 1.0 / "Total Customers")*100,2) AS "Churn Rate"
FROM
	joined;

	
/* 
Customers with 4 or more customer service calls 
show substantially higher churn rates, 
although the sample sizes for 7–9 calls are very small.
/*