# Airline_Passenger_Satisfaction

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/airplane.jpg)

## Project Overview


- **Dataset Link:** [Airline Passenger Satisfaction Dataset](https://www.kaggle.com/datasets/teejmahal20/airline-passenger-satisfaction/data?select=test.csv)
- **SQL Scripts:** [Airline Passenger Satisfaction SQL Scripts](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/SQL_Queries_Answers/airline_passenger_satisfaction_sql_queries.sql)
- **SQL Questions/Answers:** [Airline Passenger Satisfaction SQL Quetions/Answers](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/SQL_Queries_Answers/Airline_Passenger_Satisfaction_SQL_Answers.pdf)
- **Power BI Dashboards:** [Power BI Dashboards](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Dashboards.pdf)

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


## Project Results
![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/OverviewSummary.png)

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/CustomerSegments.png)

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/ServiceQuality.png)

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/FlightDistance%26Delays.png)

![](https://github.com/DQuanBui/Airline_Passenger_Satisfaction/blob/main/PowerBI_Results/Details.png)

## Conclusion

## Contact
For any inquiries or questions regarding the project, please contact me at dbui10@fordham.edu
