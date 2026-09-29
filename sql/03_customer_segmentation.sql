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
	
	
-