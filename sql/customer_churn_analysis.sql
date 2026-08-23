-- =============================================
-- Customer Churn Analysis
-- CustomerChurnPortfolio Database
-- =============================================

-- Query 1: Overall KPI Summary

SELECT 
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent,
CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) AS AvgMonthlyCharges,
SUM(RevenueAtRisk) AS TotalRevenueAtRisk
FROM CustomerChurn;

-- Query 2: Churn by Gender

SELECT 
Gender,
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent
FROM CustomerChurn
GROUP BY Gender;

-- Query 3: Churn by Senior Citizen Status

SELECT 
CASE 
    WHEN SeniorCitizen = 1 THEN 'Senior' 
	ELSE 'Non-Senior' 
	END AS CustomerType,
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent
FROM CustomerChurn
GROUP BY CASE WHEN SeniorCitizen = 1 THEN 'Senior' ELSE 'Non-Senior' END;


-- Query 4: Churn by Tenure Group

SELECT 
TenureGroup,
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent
FROM CustomerChurn
GROUP BY TenureGroup
ORDER BY TenureGroup;


-- Query 5: Churn by Contract Type

SELECT 
Contract,
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent,
SUM(RevenueAtRisk) AS RevenueAtRisk
FROM CustomerChurn
GROUP BY Contract;


-- Query 6: Churn by Payment Method

SELECT 
PaymentMethod,
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent,
SUM(RevenueAtRisk) AS RevenueAtRisk
FROM CustomerChurn
GROUP BY PaymentMethod;


-- Query 7: Churn by Internet Service Type

SELECT 
InternetService,
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent,
SUM(RevenueAtRisk) AS RevenueAtRisk
FROM CustomerChurn
GROUP BY InternetService;

-- Query 8: Churn by Online Security Status

SELECT 
OnlineSecurity,
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent
FROM CustomerChurn
GROUP BY OnlineSecurity;


-- Query 9: Churn by Tech Support Status

SELECT 
TechSupport,
COUNT(*) AS TotalCustomers,
SUM(ChurnFlag) AS ChurnedCustomers,
CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent
FROM CustomerChurn
GROUP BY TechSupport;


-- Query 10: Top High-Risk Customer Segments (CTE + Window Function + Ranking)
WITH SegmentChurn AS (
    SELECT 
    Contract,
    InternetService,
    PaymentMethod,
    COUNT(*) AS TotalCustomers,
    SUM(ChurnFlag) AS ChurnedCustomers,
    CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent,
    SUM(RevenueAtRisk) AS RevenueAtRisk
    FROM CustomerChurn
    GROUP BY Contract, InternetService, PaymentMethod
    HAVING COUNT(*) >= 50
)
SELECT 
Contract,
InternetService,
PaymentMethod,
TotalCustomers,
ChurnedCustomers,
ChurnRatePercent,
RevenueAtRisk,
RANK() OVER (ORDER BY ChurnRatePercent DESC) AS ChurnRiskRank
FROM SegmentChurn
ORDER BY ChurnRiskRank;


-- Query 11: Final Management Summary

WITH TopSegment AS (
    SELECT TOP 1
        Contract + ' + ' + InternetService + ' + ' + PaymentMethod AS SegmentName,
        ChurnRatePercent
    FROM (
        SELECT 
            Contract, InternetService, PaymentMethod,
            COUNT(*) AS TotalCustomers,
            CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ChurnRatePercent
        FROM CustomerChurn
        GROUP BY Contract, InternetService, PaymentMethod
        HAVING COUNT(*) >= 50
    ) AS Segments
    ORDER BY ChurnRatePercent DESC
)
SELECT 'Total Customers' AS Metric, CAST(COUNT(*) AS VARCHAR(50)) AS Value FROM CustomerChurn
UNION ALL
SELECT 'Churned Customers', CAST(SUM(ChurnFlag) AS VARCHAR(50)) FROM CustomerChurn
UNION ALL
SELECT 'Overall Churn Rate (%)', CAST(CAST(SUM(ChurnFlag) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS VARCHAR(50)) FROM CustomerChurn
UNION ALL
SELECT 'Avg Monthly Charges ($)', CAST(CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) AS VARCHAR(50)) FROM CustomerChurn
UNION ALL
SELECT 'Total Revenue At Risk ($)', CAST(SUM(RevenueAtRisk) AS VARCHAR(50)) FROM CustomerChurn
UNION ALL
SELECT 'Top At-Risk Segment', SegmentName + ' (' + CAST(ChurnRatePercent AS VARCHAR(10)) + '% churn)' FROM TopSegment;


