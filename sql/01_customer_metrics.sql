-- Customer Overview

SELECT 
	COUNT(*) AS 'Total Customers'
FROM 
	telecom_churn;

-- Number of Total Customers : 3333



SELECT 
	churn AS 'Churned Customers', 
	COUNT(*) AS Count
FROM 
	telecom_churn
WHERE 
	churn = 1
GROUP BY 
	churn;

-- Number of Customers Churned : 483



SELECT 
	churn AS 'Churned Customers', 
	COUNT(*) as Count
FROM 
	telecom_churn
WHERE
	churn = 0
GROUP BY 
	churn;

-- Nuber of Retained Customers : 2850



SELECT  
	ROUND((SUM(churn)* 1.0 / COUNT(*)) * 100,2) AS 'Churn Rate'
FROM 
	telecom_churn;


-- Churn Rate : 14.49 %



SELECT  
	ROUND(((SELECT COUNT(*) FROM telecom_churn WHERE churn = 0) * 1.0 )/ COUNT(*) * 100,2) AS 'Retention Rate'
FROM 
	telecom_churn;
	
-- Retention Rate : 85.51 %


SELECT 
	ROUND(AVG(account_weeks),2) AS 'Average Account Weeks'
FROM 
	telecom_churn;
	
-- Average Account Weeks : 101.06


