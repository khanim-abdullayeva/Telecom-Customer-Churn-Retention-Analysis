SELECT COUNT(*) AS 'Total Customers'
FROM telecom_churn

-- Number of Total Customers

SELECT Churn, COUNT(*) as Count
FROM telecom_churn
GROUP BY Churn;

