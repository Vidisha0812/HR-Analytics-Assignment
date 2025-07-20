SELECT TOP 10 * FROM [dbo].[HR_Analytics (1)];
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY (SELECT NULL)) AS rn
    FROM [dbo].[HR_Analytics (1)]
)
DELETE FROM CTE WHERE rn > 1;
UPDATE [dbo].[HR_Analytics (1)]
SET Gender = CASE 
    WHEN Gender IN ('M', 'male', 'MALE') THEN 'Male'
    WHEN Gender IN ('F', 'female', 'FEMALE') THEN 'Female'
    ELSE Gender
END;
UPDATE [dbo].[HR_Analytics (1)]
SET HourlyRate = ROUND(HourlyRate, 2),
    DailyRate = ROUND(DailyRate, 2);
SELECT * 
FROM [dbo].[HR_Analytics (1)]
WHERE EmpID IS NULL 
   OR Age IS NULL 
   OR Gender IS NULL 
   OR Department IS NULL;
SELECT Department,
       COUNT(*) AS Total_Employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
       ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate
FROM [dbo].[HR_Analytics (1)]
GROUP BY Department;
SELECT JobSatisfaction,
       Attrition,
       COUNT(*) AS Employee_Count
FROM [dbo].[HR_Analytics (1)]
GROUP BY JobSatisfaction, Attrition
ORDER BY JobSatisfaction;
SELECT JobRole,
       ROUND(AVG(TRY_CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_MonthlyIncome
FROM [dbo].[HR_Analytics (1)]
GROUP BY JobRole
ORDER BY Avg_MonthlyIncome DESC;
SELECT OverTime,
       JobInvolvement,
       COUNT(*) AS Employee_Count,
       ROUND(AVG(TRY_CAST(JobSatisfaction AS FLOAT)), 2) AS Avg_Satisfaction,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count
FROM [dbo].[HR_Analytics (1)]
GROUP BY OverTime, JobInvolvement;
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+' 
    END AS Age_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate
FROM [dbo].[HR_Analytics (1)]
GROUP BY 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+' 
    END
ORDER BY Age_Group;
SELECT 
    Department,
    JobLevel,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_Monthly_Income
FROM [dbo].[HR_Analytics (1)]
GROUP BY Department, JobLevel
ORDER BY Department, JobLevel;
SELECT 
    Gender,
    MaritalStatus,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate
FROM [dbo].[HR_Analytics (1)]
GROUP BY Gender, MaritalStatus
ORDER BY Gender, MaritalStatus;
