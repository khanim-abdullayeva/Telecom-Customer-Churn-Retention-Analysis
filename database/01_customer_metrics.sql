SELECT COUNT(*) AS 'Total Customers'
FROM telecom_churn;

-- Number of Total Customers

SELECT Churn AS 'Churned Customers', COUNT(*) as Count
FROM telecom_churn
GROUP BY Churn
HAVING Churn = '1';

-- Number of Customers Churned : 483