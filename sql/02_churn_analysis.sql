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

/*
Calculate total and churned customers for each number of customer service calls,
then join the results to calculate the churn rate for each group.
*/

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
*/



-- Churn by Account Tenure

-- Segment customers into four account tenure groups based on the number of account weeks.

CREATE TEMP TABLE temp_1 AS 
SELECT 
	*, 
	CASE                                                          
		WHEN account_weeks <= 60 THEN 'New'
		WHEN account_weeks <= 120 THEN 'Established'
		WHEN account_weeks <= 180 THEN 'Long-term'
		WHEN account_weeks <= 243 THEN 'Very long-term'
	END AS segment
FROM 
	telecom_churn;

	
-- Calculate total and churned customers for each account tenure segment,
-- then join both results to calculate the churn rate for each segment.	
	
CREATE TEMPORARY TABLE temp_2 AS 
SELECT 
	s.*,
	s1."Churned Customers"
FROM 	
	(SELECT
		segment AS Segment,
		COUNT(*) AS "Total Customers"
	FROM	
		temp_1
	GROUP BY
		segment) s
LEFT JOIN 
	(SELECT 
		segment,
		COUNT(*) AS "Churned Customers"
	FROM 
		temp_1
	WHERE
		churn = 1
	GROUP BY 
		segment) s1
ON
	s.Segment = s1.segment;


-- Calculate the churn rate for each account tenure segment.	
	
SELECT
	*,
	ROUND(("Churned Customers" * 1.0 / "Total Customers") * 100, 2) AS "Churn Rate"
FROM
	temp_2;
	
	
-- Churn by Monthly Charge Analysis


CREATE TEMPORARY TABLE temp_3 AS
SELECT 
	*,
	CASE
		WHEN monthly_charge <= 38 THEN 'Low'
		WHEN monthly_charge <= 62 THEN 'Medium'
		WHEN monthly_charge <= 87 THEN 'High'
		WHEN monthly_charge <= 111 THEN 'Very High'
	END AS charge_segment
FROM
	telecom_churn;
	
	
CREATE TEMPORARY TABLE temp_4 AS 
SELECT 
	m.*,
	m1."Churned Customers"
FROM 	
	(SELECT
		monthly_charge AS "Monthly Charge",
		COUNT(*) AS "Total Customers"
	FROM	
		temp_3
	GROUP BY
		monthly_charge) m
LEFT JOIN 
	(SELECT 
		monthly_charge,
		COUNT(*) AS "Churned Customers"
	FROM 
		temp_3
	WHERE
		churn = 1
	GROUP BY 
		monthly_charge) m1
ON
	m."Monthly Charge" = m1.monthly_charge;