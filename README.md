# **HR ANALYTICS INTERACTIVE DASHBOARD:<br>EMPLOYEE WELL-BEING, SALARIES, AND RISKS**

* 👤 **Author:** Asya Kolomiets  
* 📋 **Project Overview:** A comprehensive HR analytics project created to assess overall organizational health, analyze pay equity, and proactively identify employee turnover risks. The project covers the full workflow: from SQL transformations in BigQuery to building an interactive three-page dashboard in Tableau Desktop.  
* 📊 **Dashboard:** [**HR Analytics Interactive Dashboard**](https://public.tableau.com/views/HR-EmployeeAnalytics/HRAnalysisStory?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)  
* 📂 **Structure:** [**SQL Transformations & Queries**](https://github.com/asiakolomiets/hr-employee-analytics)  

<br>

## **🎯 Key Analytical Objectives:**
* **Overall Assessment of Team Professional Well-Being:** Tracking employees' emotional state, performance levels, and job satisfaction across key departments.
* **Compensation and Structure Analysis:** Diagnosing monthly income distribution across roles and seniority levels to identify financial disparities in salaries and alignment with the internal grading grid.
* **Proactive Team Risk Management:** Identifying high-risk employee groups to enable targeted managerial actions and prevent employee turnover.

<br>

## **🛠️ Technical Stack:**
* **SQL (Google BigQuery):** Common Table Expressions (CTEs), window functions, aggregations, data cleaning, conditional logic, data type formatting, and baseline calculations.
* **Tableau Desktop:** Interactive multi-page dashboard, custom Dual-Axis Lollipop charts, a Highlight Table for correlation analysis, interactive KPI Cards, dynamic Reference Lines tied to seniority levels, and localized worksheet filters.

<br>

## **📄 Dashboard Architecture:**

### **1. Health Overview**
* **KPI Cards:** Display average scores for work-life balance, job satisfaction, and performance compared to the target baseline with automatic color indicators. Serves as a quick indicator for identifying problem areas.
* **Satisfaction Distribution by Department:** Displays the percentage breakdown of satisfaction levels (1–5) within each department. Normalization by team size allows for an objective comparison of the satisfaction structure between large departments (R&D) and smaller units (HR), eliminating headcount bias regarding team status.
* **Satisfaction Distribution by Job Level:** Illustrates the percentage breakdown of job satisfaction scores at each level (from Junior to Director), helping identify gaps in support and working condition improvements across different workforce seniority tiers.

### **2. Budget Dashboard**
* **Monthly Income Analysis:** Visualizes salary levels by role within departments. Selecting any bar activates a dynamic reference line showing the company-wide average income for that respective level.
* **Detailed Metrics Table:** A detailed list of employees showing tenure in their current role, time since their last promotion, and monthly income. Interactive tooltips display salary thresholds and the grade average. Can be used as a cheat sheet to look up a specific employee and evaluate their position relative to their grade.
* **Interactive Filtering:** Top filter bar to tailor the financial slice to specific analytical queries.

### **3. Manager's Cheat Sheet**
* **KPI Cards:** Category selectors calculated from team metrics based on various criteria (employee performance rating, satisfaction, environment, internal company relationships, etc.); the category formation logic can be reviewed in the SQL code. They function as filters for the table and charts.
* **Employee Table:** An interactive table with built-in search and `True/False` status flags to view each employee's complete risk profile. Filtered via KPI cards to identify employee IDs belonging to specific categories.
* **Cross-Metric Correlation:** Highlights interrelationships between different combined categories. Used primarily to identify hidden root causes of triggers.
* **Burned Out Rate by Job Level:** Visualizes the number of employees in the most vulnerable category (Burn out) by seniority level. An extended tooltip shows the total headcount of the grade, the number of burned-out employees, and the exact Burn Out Rate percentage for that level.

<br>

## **💡 Key Insights:**

### **Health Overview Dashboard**
* **Observation:** Team performance exceeds a satisfactory level but remains unstable, whereas job satisfaction and work-life balance are low across all departments, with a slight deviation in the R&D department—though this may be a result of the department's size relative to others.
  * **Conclusion:** The company maintains KPI fulfillment through team overexertion. Low levels of job satisfaction and work-life balance indicate a risk of cumulative fatigue, which in the future may lead to decreased productivity and employee turnover.
* **Observation:** The distribution of satisfaction scores showed that no employee rated their job satisfaction at the highest score, which looks more like a data collection issue than an actual distribution. Nevertheless, the number of 1 and 2 ratings is quite significant in R&D (~36%) and Sales (~35%), and particularly critical in the HR department (~47%). This trend also holds true in the distribution across seniority levels.
  * **Conclusion:** The complete absence of maximum scores points to likely technical limitations of the scale or data collection. At the same time, the high concentration of low ratings signals systemic issues with internal communication, support, and staff motivation across all career levels, indicating a need for localized management focus.

### **Budget Dashboard**
* **Observation:** Average earnings for each level broken down by department generally show a normal trend. Upon closer inspection of the grades, deviations from the company average were identified: disparities are noticeable for Laboratory Technician in R&D (Middle — ~80%, Senior — ~63% of the average across roles), Lead positions (Healthcare Representative and Manufacturing Director in R&D, Sales Executive in Sales — ~83%), as well as premium Senior positions for Manager and Research Director in R&D and Manager in Sales (~25% higher than other roles at that level). Junior and Director levels are distributed evenly.
  * **Conclusion:** The company exhibits vertical salary asymmetry: management and leadership roles receive premium compensation, while key technical or operational positions (especially Laboratory Technician) are underfunded relative to the market or other departments. This creates a risk of internal demotivation and turnover among mid- and senior-level technical specialists.

### **Manager's Cheat Sheet**
* **Observation:** The Manager's Cheat Sheet serves as the primary tool for building HR action plans and responding to risks in a targeted manner. An analysis of burnout distribution by grade shows an even concentration of the metric across every seniority level, indicating the systemic nature of overwork rather than a localized issue within individual departments. At the same time, cross-category analysis refutes the widespread hypothesis that burnout (156 employees) primarily affects the company's top employees—the overlap with top performers (21 employees) and promotion candidates (1 employee) demonstrates that the risk zone is concentrated primarily among rank-and-file employees.