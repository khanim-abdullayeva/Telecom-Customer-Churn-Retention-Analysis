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

--Tenure Segment Performance

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

DROP TABLE IF EXISTS temp_3;
CREATE TEMPORARY TABLE temp_3 AS
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


DROP TABLE IF EXISTS temp_4;
CREATE TEMP TABLE temp_4 AS 
SELECT 
	c.*,
	c1."Churned Customers"
FROM 	
	(SELECT
		monthly_charge_segment AS "Monthly Charge Segment",
		COUNT(*) AS "Total Customers"
	FROM	
		temp_3
	GROUP BY
		monthly_charge_segment) c
LEFT JOIN 
	(SELECT 
		monthly_charge_segment,
		COUNT(*) AS "Churned Customers"
	FROM 
		temp_3
	WHERE
		churn = 1
	GROUP BY 
		monthly_charge_segment) c1
ON
	c."Monthly Charge Segment" = c1.monthly_charge_segment;
	


-- Customer Value Segment Performance

SELECT
		c.*,
		c1."Average Monthly Charge",
		c1."Average Tenure",
		c1."Average Customer Service Calls"
FROM	
	(SELECT 
		*,
		ROUND(("Churned Customers" * 1.0 / "Total Customers") * 100, 2) AS "Churn Rate"
	FROM 
		temp_4
	ORDER BY
		"Churn Rate") c
LEFT JOIN
	(SELECT 
		monthly_charge_segment,
		ROUND(AVG(monthly_charge), 2) AS "Average Monthly Charge",
		ROUND(AVG(account_weeks), 2) AS "Average Tenure",
		ROUND(AVG(cust_serv_calls), 2) AS "Average Customer Service Calls"
	FROM
		temp_3
	GROUP BY
		monthly_charge_segment) c1
ON
	c."Monthly Charge Segment" = c1.monthly_charge_segment;

	
	
-- Data Usage Segmentation

CREATE TEMP TABLE temp_5 AS
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
	
	
CREATE TEMP TABLE temp_6 AS	
SELECT 
	d.*,
	d1."Churned Customers"
FROM
	(SELECT 
		data_usage_segment AS "Data Usage Segment",
		COUNT(*) AS "Total Customers"
	FROM
		temp_5
	GROUP BY 
		data_usage_segment) d
LEFT JOIN
	(SELECT
		data_usage_segment,
		COUNT(*) AS "Churned Customers"
	 FROM
		temp_5
	 WHERE
		churn = 1
	 GROUP BY
		data_usage_segment) d1
ON 
	d."Data Usage Segment" = d1.data_usage_segment;	

	
	
-- Data Usage Segment Performance

SELECT
		d.*,
		d1."Average Monthly Charge",
		d1."Average Tenure",
		d1."Average Customer Service Calls"
FROM	
	(SELECT 
		*,
		ROUND(("Churned Customers" * 1.0 / "Total Customers") * 100, 2) AS "Churn Rate"
	FROM 
		temp_6
	ORDER BY
		"Churn Rate") d
LEFT JOIN
	(SELECT 
		data_usage_segment,
		ROUND(AVG(monthly_charge), 2) AS "Average Monthly Charge",
		ROUND(AVG(account_weeks), 2) AS "Average Tenure",
		ROUND(AVG(cust_serv_calls), 2) AS "Average Customer Service Calls"
	FROM
		temp_5
	GROUP BY
		data_usage_segment) d1
ON
	d."Data Usage Segment" = d1.data_usage_segment;
	
	
	
	
-- Customer Service Risk Segmentation

CREATE TEMP TABLE temp_11 AS
SELECT
	*,
	CASE
		WHEN cust_serv_calls <= 3 THEN 'Low Support Usage'
		WHEN cust_serv_calls <= 6 THEN 'Medium Support Usage'
		WHEN cust_serv_calls <= 9 THEN 'High Support Usage'
	END AS cust_serv_calls_segment
FROM
	telecom_churn;