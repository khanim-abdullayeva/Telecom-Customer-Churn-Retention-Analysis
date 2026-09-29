-- Tenure Segmentetion

SELECT 
	*,
	CASE
		WHEN account_weeks <= 60 THEN 'New Customer'
		WHEN account_weeks <= 120 THEN 'Established Customer'
		WHEN account_weeks <= 180 THEN 'Long-term Customer'
		WHEN account_weeks <= 243 THEN 'Very Long-term Customer'
	END AS customer_segmentation
FROM
	telecom_churn;
	
	
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