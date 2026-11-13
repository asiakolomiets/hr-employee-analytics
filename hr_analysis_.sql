/* HR ANALYTICS: DATA CLEANING AND METRICS TRANSFORMATION
   Author: Asya Kolomiets
   Description: Cleaning raw HR data, structuring job levels, 
   calculating employee health and risk markers, and building analytical views.
*/

---------------------------------------------------------------------------------
-- SECTION 1: DATA CLEANING & STANDARDIZATION
---------------------------------------------------------------------------------

-- Base Cleaned Table
CREATE OR REPLACE TABLE `da-course-rd.hr_project.hr_analytics_clear` AS
WITH dedub AS (
  SELECT DISTINCT * 
  FROM `da-course-rd.hr_project.hr_analytics`
)
SELECT
    EmpID,
    Age,
    AgeGroup,
    Gender,
    Department,
    JobRole,
    MonthlyIncome,
    SalarySlab,
    PercentSalaryHike,
    YearsAtCompany,
    YearsInCurrentRole,
    YearsSinceLastPromotion,
    YearsWithCurrManager,
    PerformanceRating,
    JobInvolvement,
    WorkLifeBalance,
    EnvironmentSatisfaction,
    RelationshipSatisfaction,
    JobSatisfaction,
    OverTime,
    BusinessTravel,
    TrainingTimesLastYear,
    JobLevel,
    CASE 
      WHEN JobLevel = 1 THEN '1. Junior'
      WHEN JobLevel = 2 THEN '2. Middle'
      WHEN JobLevel = 3 THEN '3. Senior'
      WHEN JobLevel = 4 THEN '4. Lead'
      WHEN JobLevel = 5 THEN '5. Director'
      ELSE 'Unknown'
    END AS JobLevelName
FROM dedub
WHERE Attrition = FALSE;


---------------------------------------------------------------------------------
-- SECTION 2: EMPLOYEE RISK MARKERS & BENCHMARKS
---------------------------------------------------------------------------------

-- Marks View
CREATE OR REPLACE VIEW `da-course-rd.hr_project.employee_marks` AS
WITH marks_base AS (
  SELECT 
    EmpID,
    Department,
    JobRole,
    JobLevel,
    JobInvolvement,
    PerformanceRating,
    YearsAtCompany,
    YearsSinceLastPromotion,
    TrainingTimesLastYear,
    MIN(MonthlyIncome) OVER(PARTITION BY Department, JobRole, JobLevel) AS min_salary,
    MAX(MonthlyIncome) OVER(PARTITION BY Department, JobRole, JobLevel) AS max_salary,
    ROUND(AVG(MonthlyIncome) OVER(PARTITION BY Department, JobRole, JobLevel), 2) AS avg_salary,
    CASE 
      WHEN OverTime = TRUE
        AND (WorkLifeBalance <= 2 OR JobSatisfaction <= 2)
        AND PerformanceRating >= 3
        AND YearsAtCompany >= 1 THEN TRUE
      ELSE FALSE
    END AS burn_out,
    CASE
      WHEN (CAST(JobSatisfaction <= 2 AS INT64) + 
            CAST(WorkLifeBalance <= 2 AS INT64) + 
            CAST(RelationshipSatisfaction <= 2 AS INT64)) >= 2 THEN TRUE
      ELSE FALSE
    END AS needs_1on1,
    CASE
      WHEN (PerformanceRating + JobInvolvement + WorkLifeBalance) >= 10 THEN TRUE
      ELSE FALSE
    END AS top_emp
  FROM `da-course-rd.hr_project.hr_analytics_clear`
),
marks_adv AS (
  SELECT 
    EmpID,
    burn_out,
    needs_1on1,
    CASE
      WHEN PerformanceRating <= 2 
           AND JobInvolvement <= 2 
           AND needs_1on1 = TRUE THEN TRUE
      ELSE FALSE
    END AS retention_risk,
    CASE
      WHEN PerformanceRating > 3 
        AND YearsSinceLastPromotion >= 2 
        AND TrainingTimesLastYear >= 2
        AND JobInvolvement > 3 
        AND YearsAtCompany >= 3 
        AND JobLevel < 5 THEN TRUE
      ELSE FALSE 
    END AS promotion,
    top_emp,
    min_salary,
    max_salary,
    avg_salary
  FROM marks_base
)
SELECT *
FROM marks_adv;


---------------------------------------------------------------------------------
-- SECTION 3: AGGREGATED METRICS & CORRELATION MATRIX
---------------------------------------------------------------------------------

-- Health Summary View
CREATE OR REPLACE VIEW `da-course-rd.hr_project.employee_health` AS
SELECT
  COUNT(*) AS total_emp,
  COUNTIF(burn_out) AS burnout_count,
  ROUND(COUNTIF(burn_out) / COUNT(*) * 100, 2) AS burnout_percentage,
  COUNTIF(needs_1on1) AS needs_1on1_count,
  ROUND(COUNTIF(needs_1on1) / COUNT(*) * 100, 2) AS needs_1on1_percentage,
  COUNTIF(top_emp) AS top_performers_count,
  ROUND(COUNTIF(top_emp) / COUNT(*) * 100, 2) AS top_performers_percentage,
  COUNTIF(retention_risk) AS retention_risk_count,
  ROUND(COUNTIF(retention_risk) / COUNT(*) * 100, 2) AS retention_risk_percentage,
  COUNTIF(promotion) AS promotion_ready_count,
  ROUND(COUNTIF(promotion) / COUNT(*) * 100, 2) AS promotion_ready_percentage
FROM `da-course-rd.hr_project.employee_marks`;

-- Matrix View
CREATE OR REPLACE VIEW `da-course-rd.hr_project.employee_matrix` AS
WITH unnested_triggers AS (
  SELECT 
    EmpID,
    t.name AS trigger_name
  FROM `da-course-rd.hr_project.employee_marks`,
  UNNEST([
    STRUCT('burn_out' AS name, burn_out AS val),
    STRUCT('top_emp', top_emp),
    STRUCT('needs_1on1', needs_1on1),
    STRUCT('retention_risk', retention_risk),
    STRUCT('promotion', promotion)
  ]) t
  WHERE t.val = TRUE
)
SELECT 
  t1.trigger_name AS trigger_x,
  t2.trigger_name AS trigger_y,
  COUNT(DISTINCT t1.EmpID) AS emp_count
FROM unnested_triggers t1
JOIN unnested_triggers t2 USING (EmpID)
GROUP BY 1, 2;