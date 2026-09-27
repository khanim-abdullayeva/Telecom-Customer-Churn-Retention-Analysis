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

