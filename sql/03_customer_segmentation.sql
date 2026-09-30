-- Tenure Segmentetion

DROP TABLE IF EXISTS temp_1
CREATE TEMP TABLE temp_1 AS 
SELECT 
	*, 
	CASE                                                          
		WHEN account_weeks <= 60 THEN 'New'
		WHEN account_weeks <= 120 THEN 'Established'
		WHEN account_weeks <= 180 THEN 'Long-term'
		WHEN account_weeks <= 243 THEN 'Very long-term'
	END AS customer_segment
FROM 
	telecom_churn;
	
DROP TABLE IF EXISTS temp_2
CREATE TEMP TABLE temp_2 AS 
SELECT 
	s.*,
	s1."Churned Customers"
FROM 	
	(SELECT
		segment AS "Customer Segment",
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
	s."Customer Segment" = s1.segment;

--Segment performance

SELECT
	j.*,
	j1."Average Monthly Charge",
	j1."Average Tenure",
	j1."Average Customer Service Calls"
FROM
	(SELECT
		*,
		ROUND(("Churned Customers" * 1.0 / "Total Customers") * 100, 2) AS "Churn Rate"
	FROM
		temp_2) j
LEFT JOIN
	(SELECT 
		customer_segment AS "Customer Segment",
		ROUND(AVG(monthly_charge), 2) AS "Average Monthly Charge",
		ROUND(AVG(account_weeks), 2) AS "Average Tenure",
		ROUND(AVG(cust_serv_calls), 2) AS "Average Customer Service Calls"
	FROM
		temp_1
	GROUP BY
		customer_segment) j1
ON
	j."Customer Segment" = j1."Customer Segment";
	
	
	
-- Customer Value Segmentation

SELECT 
	*,
	CASE
		WHEN monthly_charge <= 38 THEN 'Low'
		WHEN monthly_charge <= 62 THEN 'Medium'
		WHEN monthly_charge <= 87 THEN 'High'
		WHEN monthly_charge <= 112 THEN 'Very High'
	END AS monthly_charge_segment
FROM
	telecom_churn;
	
	
-- Usage Segmentation

SELECT
	*,
	CASE
		WHEN data_usage = 0 THEN 'No Data Usage'
		WHEN data_usage >= 2 THEN 'High Data Usage'
		WHEN data_usage >= 1 THEN 'Moderate Data Usage'
		WHEN data_usage > 0 AND data_usage < 1 THEN 'Low Data Usage'
	END AS data_usage_segment
FROM
	telecom_churn;
	
	
-- Customer Service Risk Segmentation

SELECT
	*,
	CASE
		WHEN cust_serv_calls <= 3 THEN 'Low Support Usage'
		WHEN cust_serv_calls <= 6 THEN 'Medium Support Usage'
		WHEN cust_serv_calls <= 9 THEN 'High Support Usage'
	END AS cust_serv_calls_segment
FROM
	telecom_churn;