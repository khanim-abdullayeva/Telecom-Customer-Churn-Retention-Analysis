-- Churn by Conract Renewal


SELECT
	contract_renewal AS "Contract Renewal",
	churn AS Churn,
	COUNT(*) AS Count,
	ROUND((SELECT COUNT(*) FROM telecom_churn WHERE churn = 1 and contract_renewal = 1)*1.0/ (SELECT COUNT(*) FROM telecom_churn WHERE contract_renewal = 1)*100,2) AS "Churn Rate"
FROM
	telecom_churn
WHERE
	contract_renewal = 1 AND churn = 1
GROUP BY 
	contract_renewal,churn;
	
-- Churn Rate of Customers who have Contract Renewal : 11.50 %



SELECT
	contract_renewal AS "Contract Renewal",
	churn AS Churn,
	COUNT(*) AS Count,
	ROUND((SELECT COUNT(*) FROM telecom_churn WHERE churn = 1 and contract_renewal = 0)*1.0/ (SELECT COUNT(*) FROM telecom_churn WHERE contract_renewal = 0)*100,2) AS "Churn Rate"
FROM
	telecom_churn
WHERE
	contract_renewal = 0 AND churn = 1
GROUP BY 
	contract_renewal,churn;
	
-- Churn Rate of Customers who do not have Contract Renewal : 42.41 %



-- Churn by Data Plan


SELECT
	data_plan AS "Data Plan",
	churn AS Churn,
	COUNT(*) AS Count,
	ROUND((SELECT COUNT(*) FROM telecom_churn WHERE churn = 1 and data_plan = 1)*1.0/ (SELECT COUNT(*) FROM telecom_churn WHERE data_plan = 1)*100,2) AS "Churn Rate"
FROM
	telecom_churn
WHERE
	data_plan = 1 AND churn = 1
GROUP BY 
	data_plan,churn;

-- Churn Rate of Customers who have Data Plan : 8.68 %


SELECT
	data_plan AS "Data Plan",
	churn AS Churn,
	COUNT(*) AS Count,
	ROUND((SELECT COUNT(*) FROM telecom_churn WHERE churn = 1 and data_plan = 0)*1.0/ (SELECT COUNT(*) FROM telecom_churn WHERE data_plan = 0)*100,2) AS "Churn Rate"
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

/*	
	Calculate total and churned customers for each account tenure segment,
	then join both results to calculate the churn rate for each segment.	
*/

	
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


-- Segment customers into four monthly charge groups based on their monthly charges.

DROP TABLE IF EXISTS temp_3;
CREATE TEMPORARY TABLE temp_3 AS
SELECT 
	*,
	CASE
		WHEN monthly_charge <= 38 THEN 'Low'
		WHEN monthly_charge <= 62 THEN 'Medium'
		WHEN monthly_charge <= 87 THEN 'High'
		WHEN monthly_charge <= 112 THEN 'Very High'
	END AS charge_segment
FROM
	telecom_churn;
	

/*
	Calculate total and churned customers for each monthly charge segment,
	then join both results to calculate the churn rate for each segment.	
*/

DROP TABLE IF EXISTS temp_4;
CREATE TEMPORARY TABLE temp_4 AS 
SELECT 
	c.*,
	c1."Churned Customers"
FROM 	
	(SELECT
		charge_segment AS "Charge Segment",
		COUNT(*) AS "Total Customers"
	FROM	
		temp_3
	GROUP BY
		charge_segment) c
LEFT JOIN 
	(SELECT 
		charge_segment,
		COUNT(*) AS "Churned Customers"
	FROM 
		temp_3
	WHERE
		churn = 1
	GROUP BY 
		charge_segment) c1
ON
	c."Charge Segment" = c1.charge_segment;
	
	
-- Calculate the churn rate for each monthly charge segment and sort the results by churn rate.
	
SELECT 
	*,
	ROUND(("Churned Customers" * 1.0 / "Total Customers") * 100, 2) AS "Churn Rate"
FROM 
	temp_4
ORDER BY
	"Churn Rate";
	
/*
	Churn rate varies across monthly charge segments, 
	with customers in the High charge segment showing the highest churn rate (27.44%). 
	Customers in the Low and Very High segments have lower churn rates, at 13.95% and 10.56%, respectively, 
	while the Medium segment has the lowest churn rate (9.15%).
*/



-- Churn by Data Usage


-- Segment customers based on their level of data usage.

CREATE TEMPORARY TABLE temp_5 AS
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


/*
	Calculate total and churned customers for each data usage segment,
	then join both results to calculate the churn rate for each segment.	
*/

CREATE TEMPORARY TABLE temp_6 AS	
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

 
-- Calculate the churn rate for each data usage segment and sort the results by churn rate.
 
SELECT 
	*,
	ROUND(("Churned Customers" *1.0/ "Total Customers") * 100, 2) AS "Churn Rate"
FROM
	temp_6
ORDER BY
	"Churn Rate";

/*
	Churn rate is highest among customers with no data usage (17.76%) and 
	generally lower among customers who use mobile data. 
	This suggests that data usage is associated with lower churn in this dataset, 
	although the analysis does not establish a causal relationship
*/



-- Churn by Roaming Minutes

-- Segment customers based on their level of roamin minutes.

CREATE TEMP TABLE temp_7 AS
SELECT
	*,
	CASE
		WHEN roam_mins <= 5 THEN 'Low'
		WHEN roam_mins <= 10 THEN 'Moderate'
		WHEN roam_mins <= 15 THEN 'High'
		WHEN roam_mins <= 20 THEN 'Very High'
	END AS roam_segment
FROM
	telecom_churn;
	
	
/*	
	Calculate total and churned customers for each roaming segment,
	then join both results to calculate the churn rate for each segment.
*/
	
CREATE TEMP TABLE temp_8 AS
SELECT 
	r.*,
	r1."Churned Customers"
FROM
	(SELECT
		roam_segment AS "Roaming Segment",
		COUNT(*) AS "Total Customers"
	FROM 
		temp_7
	GROUP BY
		roam_segment) r
LEFT JOIN
	(SELECT 
		roam_segment,
		COUNT(*) AS "Churned Customers"
	 FROM
		temp_7
	WHERE
		churn = 1
	GROUP BY
		roam_segment) r1
ON 
	r."Roaming Segment" = r1.roam_segment;
	
	
-- Calculate the churn rate for each roaming segment and sort the results by churn rate.	
	
SELECT 
	*,
	ROUND(("Churned Customers" * 1.0 / "Total Customers") * 100, 2) AS "Churn Rate"
FROM
	temp_8;

/*
	Churn rate generally increases with higher roaming minutes,
	with the highest churn rate observed among very-high roaming users (19.51%).
*/



-- Churn by Overage Fee


-- Segment customers based on their level of overage fees.

CREATE TEMP TABLE temp_9 AS
SELECT
	*,
	CASE
		WHEN overage_fee <= 6 THEN 'Low'
		WHEN overage_fee <= 12 THEN 'Moderate'
		WHEN overage_fee <= 19 THEN 'High'
	END AS overage_fee_segment
FROM
	telecom_churn;
	
	
/*	
	Calculate total and churned customers for each overage fee segment,
	then join both results to calculate the churn rate for each segment.
*/	


CREATE TEMP TABLE temp_10 AS
SELECT 
	o.*,
	o1."Churned Customers"
FROM
	(SELECT
		overage_fee_segment AS "Overage Fee Segment",
		COUNT(*) AS "Total Customers"
	FROM
		temp_9
	GROUP BY 
		overage_fee_segment) o
LEFT JOIN
	(SELECT 
		overage_fee_segment,
		COUNT(*) AS "Churned Customers"
	 FROM
		temp_9
	 WHERE
		churn = 1
	 GROUP BY
		overage_fee_segment) o1
ON
	o."Overage Fee Segment" = o1.overage_fee_segment;
		
		
-- Calculate the churn rate for each overage fee segment.		
	 
SELECT
	*,
	Round(("Churned Customers" * 1.0 / "Total Customers") * 100, 2) AS "Churn Rate"
FROM
	temp_10;
	
/*
	Higher overage fee segments are associated with higher churn rates,
	with the highest churn rate observed among high-fee customers (19.52%).
*/