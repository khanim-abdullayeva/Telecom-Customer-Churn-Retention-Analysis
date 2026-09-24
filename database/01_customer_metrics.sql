SELECT 
	COUNT(*) AS 'Total Customers'
FROM 
	telecom_churn;

-- Number of Total Customers : 3333

SELECT 
	Churn AS 'Churned Customers', 
	COUNT(*) AS Count
FROM 
	telecom_churn
WHERE 
	Churn = 1
GROUP BY 
	Churn;

-- Number of Customers Churned : 483

SELECT 
	Churn AS 'Churned Customers', 
	COUNT(*) as Count
FROM 
	telecom_churn
WHERE
	Churn = 0
GROUP BY 
	Churn;

-- Nuber of Retained Customers : 2850

SELECT  
	ROUND((SUM(Churn)* 1.0 / COUNT(*)) * 100,2) AS 'Churn Rate'
FROM 
	telecom_churn;


-- Churn Rate : 14.49 %