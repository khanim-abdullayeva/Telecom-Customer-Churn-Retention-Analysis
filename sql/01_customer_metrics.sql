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


-- Account/Tenure Metrics

SELECT 
	ROUND(AVG(account_weeks),2) AS 'Average Account Weeks'
FROM 
	telecom_churn;
	
-- Average Account Weeks : 101.06


SELECT 
	MIN(account_weeks) AS 'Minimum Account Week'
FROM
	telecom_churn;
	
-- Minimum Account Week : 1


SELECT 
	MAX(account_weeks) AS 'Maximum Account Weeks'
FROM
	telecom_churn;
	
-- Maximum Account Weeks : 243


-- Usage Metrics


SELECT
	ROUND(AVG(data_usage),2) AS 'Average Data Usage'
FROM
	telecom_churn;

-- Average Data Usage per Customer : 0.82
	
	
SELECT
	ROUND(AVG(day_mins),2) AS 'Average Daily Minutes'
FROM
	telecom_churn;
	
-- Average Daily Minutes per Customer : 179.78


SELECT
	ROUND(AVG(day_calls),2) AS 'Average Daily Calls'
FROM
	telecom_churn;
	
-- Average Daily Calls per Customer : 100.44


SELECT
	ROUND(AVG(roam_mins),2) AS 'Average Roam Minutes'
FROM
	telecom_churn;
	
-- Average Roam Minutes per Customer : 10.24


-- Financial Metrics


SELECT
	ROUND(AVG(monthly_charge),2) AS 'Average Monthly Charge'
FROM
	telecom_churn;
	
-- Average Monthly Charge per Customer : $56.31


SELECT
	ROUND(SUM(monthly_charge),2) AS 'Total Charge'
FROM
	telecom_churn;

-- Total Charge : $187,665.1



SELECT
	ROUND(AVG(overage_fee),2) AS 'Average Overage Fee'
FROM
	telecom_churn;
	
-- Average Overage Fee per Customer : $10.05


SELECT
	ROUND(SUM(overage_fee),2) AS 'Total Overage Fee'
FROM
	telecom_churn;

-- Total Overage Fee : $33,501.61


-- Service Adoption


SELECT
	data_plan AS 'Data Plan', 
	COUNT(*) AS 'Count'
FROM
	telecom_churn
WHERE
	data_plan = 1
GROUP BY
	data_plan;

-- Number of customers who have Data Plan : 922


SELECT
	data_plan AS 'Data Plan', 
	COUNT(*) AS 'Count'
FROM
	telecom_churn
WHERE
	data_plan = 0
GROUP BY
	data_plan;

-- Number of customers who do not have Data Plan : 2411


SELECT
	contract_renewal AS 'Contract Renewal', 
	COUNT(*) AS 'Count'
FROM
	telecom_churn
WHERE
	contract_renewal = 1
GROUP BY
	contract_renewal;

-- Number of customers who have Contract Renewal : 3010


SELECT
	contract_renewal AS 'Contract Renewal', 
	COUNT(*) AS 'Count'
FROM
	telecom_churn
WHERE
	contract_renewal = 0
GROUP BY
	contract_renewal;

-- Number of customers who do not have Contract Renewal : 323



