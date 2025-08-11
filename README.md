# Airline_Passenger_Satisfaction

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/airplane.jpg)

## Project Overview
The Airline Passenger Satisfaction Project addresses a critical challenge faced by airlines: understanding the key drivers behind passenger satisfaction and loyalty in order to enhance service quality and customer retention. Using a dataset of over 104K passenger records, I applied SQL Server for in-depth data analysis and leveraged Power BI to design interactive dashboards that reveal patterns in customer segments, service performance, travel behaviors, and delay impacts. This project showcases an end-to-end analytics workflow, from data cleaning and transformation to advanced querying and dynamic visualization, demonstrating how data-driven approaches can support strategic decisions in the airline industry.

- **Dataset Link:** [Airline Passenger Satisfaction Dataset](https://www.kaggle.com/datasets/teejmahal20/airline-passenger-satisfaction/data?select=test.csv)
- **SQL Scripts:** [Airline Passenger Satisfaction SQL Scripts](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/SQL_Queries_Answers/airline_passenger_satisfaction_sql_queries.sql)
- **SQL Questions/Answers:** [Airline Passenger Satisfaction SQL Quetions/Answers](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/SQL_Queries_Answers/Airline_Passenger_Satisfaction_SQL_Answers.pdf)
- **Power BI Dashboards:** [Power BI Dashboards](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Dashboards.pdf)

## Architecture Overview
![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/ArchitectureOverview.png)

## Tools 
- Language: SQL
- Tools: MySQLWorkbench, KNIME, Power BI

## Dataset Overview
```sql 
-- Dataset Overview
SELECT 
	*
FROM 
	airline_satisfaction

-- Key Metrics Overview
SELECT
    COUNT(DISTINCT passenger_id) AS Total_Passengers,
    COUNT(DISTINCT gender) AS Gender,
    COUNT(DISTINCT customer_type) AS Customer_Type,
    ROUND(AVG(age), 0) AS Average_Age,
    COUNT(DISTINCT age_group) AS Age_Group,
    COUNT(DISTINCT travel_class) AS Travel_Class,
    COUNT(DISTINCT travel_type) AS Travel_Type,
    COUNT(DISTINCT flight_haul_type) AS Flight_Haul_Type,
    COUNT(DISTINCT service_level_category) AS Service_Level_Category,
    COUNT(DISTINCT arrival_delay_status) AS Arrival_Delay_Status,
    COUNT(DISTINCT departure_delay_status) AS Departure_Delay_Status
FROM
	airline_satisfaction
```
## Objectives
- Identify actionable service improvement opportunities by analyzing passenger satisfaction trends across demographics, loyalty tiers, travel classes, and flight types.
- Leverage SQL Server to execute advanced queries, aggregations, and comparative analyses, uncovering the operational and service factors that most influence customer satisfaction.
- Clean, validate, and standardize over 104K passenger records using KNIME and Excel to ensure a reliable, high-quality dataset for analysis.
- Develop 5 interactive Power BI dashboards to deliver clear, data-driven insights that empower airline stakeholders to enhance customer retention and optimize service strategies.

## Project Results
![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/OverviewSummary.png)

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/CustomerSegments.png)

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/ServiceQuality.png)

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/FlightDistance%26Delays.png)

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/Details.png)

## Conclusion
The project leverages KNIME, Excel, SQL Server, and Power BI to transform raw passenger data into meaningful insights that can shape service strategies and operational decisions. By providing a clear understanding of customer segments, service performance, and travel behaviors, this project equips airlines with the knowledge to enhance passenger experiences, strengthen loyalty, and address key operational challenges. It aims to support data-driven decision-making, improve service consistency, and contribute to long-term customer satisfaction and retention in the airline industry.

## Contact
For any inquiries or questions regarding the project, please contact me at dbui10@fordham.edu
