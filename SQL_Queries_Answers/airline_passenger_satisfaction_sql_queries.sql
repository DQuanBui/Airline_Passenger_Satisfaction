-- SQL Scripts for Airline Passenger Satisfaction Project
-- Author: Dang Quan Bui

USE airline_satisfaction;

-- Look at the database to understand the key metrics
SELECT 
	*
FROM 
	airline_satisfaction; 

-- ========================
-- PART 1: OVERVIEW SUMMARY
-- ========================

-- 1.1: Look at the Total Passengers in the dataset
SELECT 
	COUNT(*) AS total_passengers
FROM 
	airline_satisfaction; 

-- 1.2:Look at the Percentage of satisfied and dissatisfied passengers
SELECT 
	satisfaction, 
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM airline_satisfaction), 0) AS Percentage
FROM 
	airline_satisfaction
GROUP BY 
	satisfaction;

-- 1.3: Look at the Satisfaction Rate by Age Group
SELECT 
	age_group,
    ROUND(100.0 * SUM(CASE WHEN Satisfaction='Satisfied' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_percentage,
    COUNT(*) AS total_passengers
FROM 
	airline_satisfaction
GROUP BY 
	age_group
ORDER BY 
	satisfaction_rate_percentage DESC;

-- 1.4: Look at the Total Passengers by Travel Type
SELECT 
	travel_Type, 
	COUNT(*) AS total_passengers
FROM 
	airline_satisfaction 
GROUP BY 
	travel_type
ORDER BY 
	total_passengers DESC;

-- 1.5: Look at Total Passengers by Travel Class
SELECT 
	travel_class, 
	COUNT(*) AS total_passengers
FROM 
	airline_satisfaction
GROUP BY 
	travel_class
ORDER BY 
	total_passengers DESC;

-- 1.6: Look at Total Passengers by Gender
SELECT 
	gender, 
	COUNT(*) AS total_passengers
FROM 
	airline_satisfaction
GROUP BY 
	gender
ORDER BY 
	total_passengers DESC;

-- 1.7: Look at the satisfaction rate by (Travel Class and Age Group) combination
SELECT 
	travel_class, 
	age_group,
    ROUND(SUM(CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS satisfaction_rate
FROM 
	airline_satisfaction
GROUP BY 
	travel_class, 
	age_group
ORDER BY 
	satisfaction_rate DESC,
	travel_class;

-- 1.8: Look at whether passengers who experienced any delay (departure or arrival) are significantly less satisfied
WITH delay_flagged AS (
  SELECT 
	*,
    CASE 
		WHEN Departure_Delay_Minutes + Arrival_Delay_Minutes = 0 THEN 'No Delay'
        ELSE 'Delayed'
    END AS delay_status
  FROM 
	airline_satisfaction
),
satisfaction_delay AS (
  SELECT 
	delay_status,
    COUNT(*) AS total_delays,
    SUM(CASE WHEN satisfaction = 'Satisfied' THEN 1 ELSE 0 END) AS satisfied
  FROM 
	delay_flagged
  GROUP BY 
	delay_status
)
SELECT 
	delay_status,
    ROUND(satisfied * 100.0 / total_delays, 2) AS satisfaction_rate
FROM 
	satisfaction_delay;

-- ==================================
-- PART 2: CUSTOMER SEGMENTS ANALYSIS
-- ==================================

-- 2.1: Look at the satisfaction rate across Customer Types (Loyal vs Disloyal)
SELECT 
	customer_type,
    ROUND(100.0 * SUM(CASE WHEN Satisfaction='Satisfied' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_percentage
FROM 
	airline_satisfaction
GROUP BY 
	customer_type
ORDER BY 
	satisfaction_rate_percentage DESC;

-- 2.2: Look at which (Age Group × Travel Type) combinations have the highest dissatisfaction rate
SELECT 
	age_group, 
	travel_type,
    ROUND(100.0 * SUM(CASE WHEN Satisfaction='Dissatisfied' THEN 1 ELSE 0 END) / COUNT(*), 2) AS dissatisfaction_rate_percentage
FROM 
	airline_satisfaction
GROUP BY 
	age_group, 
	travel_type
ORDER BY 
	dissatisfaction_rate_percentage DESC;

-- 2.3: Look at the most common Travel Class for each Age Group
WITH class_passengers AS (
  SELECT 
	age_group, 
	travel_class, 
	COUNT(*) AS total_passengers,
    RANK() OVER (PARTITION BY age_group ORDER BY COUNT(*) DESC) AS ranking
  FROM 
	airline_satisfaction
  GROUP BY 
	age_group, 
	travel_class
)
SELECT 
	age_group, 
	travel_class, 
	total_passengers
FROM 
	class_passengers
WHERE
	ranking = 1
ORDER BY 
	total_passengers DESC;

-- 2.4: Look at the Male–Female satisfaction gap within each Customer Type
WITH rating AS (
  SELECT 
	customer_type, 
	gender,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction='Satisfied' THEN 1 ELSE 0 END) AS satisfaction
  FROM 
	airline_satisfaction
  GROUP BY 
	customer_type, 
	gender
)
SELECT 
	customer_type, 
	gender,
    ROUND(100.0 * satisfaction / NULLIF(total_passengers,0), 2) AS satisfaction_rate_percentage
FROM 
	rating
ORDER BY 
	customer_type, 
	satisfaction_rate_percentage DESC;

-- 2.5: Look at how satisfaction rate changes across Flight Haul Types for each Customer Type
SELECT 
	customer_type, 
	flight_haul_type,
    ROUND(100.0 * SUM(CASE WHEN satisfaction='Satisfied' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_percentage,
    COUNT(*) AS total_passengers
FROM 
	airline_satisfaction
GROUP BY 
	customer_type, 
	flight_haul_type
ORDER BY 
	customer_type, 
	satisfaction_rate_percentage DESC;

-- 2.6: Look at which (Age Group × Travel Class × Customer Type) combinations produce the highest share of “highly satisfied” passengers (Service_Level_Category = 'Excellent')
WITH segment AS (
  SELECT
      age_group,
      travel_class,
      customer_type,
      COUNT(*) AS total_passengers,
      SUM(CASE WHEN service_level_category = 'Excellent' THEN 1 ELSE 0 END) AS excellent_passengers
  FROM 
	airline_satisfaction
  GROUP BY 
	age_group, 
	travel_class, 
	customer_type
)
SELECT
    age_group,
    travel_class,
    customer_type,
    total_passengers,
    excellent_passengers,
    ROUND(100.0 * excellent_passengers / NULLIF(total_passengers,0), 2) AS excellent_share_percentage,
    RANK() OVER (ORDER BY 1.0 * excellent_passengers / NULLIF(total_passengers,0) DESC) AS rank_by_excellent_share
FROM 
	segment
ORDER BY 
	rank_by_excellent_share, 
	age_group, 
	travel_class, 
	customer_type;

-- ================================
-- PART 3: SERVICE QUALITY ANALYSIS
-- ================================

-- 3.1: Look at the Average Ratings of all In-flight services between Satisfied and Dissatisfied passengers
SELECT 
	satisfaction,
	ROUND(AVG(CAST(Inflight_Service AS float)), 2) AS average_inflight_service,
    ROUND(AVG(CAST(Baggage_Handling AS float)), 2) AS average_baggage_handling,
    ROUND(AVG(CAST(Seat_Comfort AS float)), 2) AS average_seat_comfort,
    ROUND(AVG(CAST(Onboard_Service AS float)), 2) AS average_onboard_service,
    ROUND(AVG(CAST(Inflight_Entertainment AS float)), 2) AS average_entertainment,
	ROUND(AVG(CAST(Legroom_Service AS float)), 2) AS average_legroom,
    ROUND(AVG(CAST(Cleanliness AS float)), 2) AS average_cleanliness,
    ROUND(AVG(CAST(Food_Drink  AS float)), 2) AS average_food_drink,
    ROUND(AVG(CAST(Inflight_Wifi_Service AS float)), 2) AS average_wifi
FROM 
	airline_satisfaction
GROUP BY 
	satisfaction;

-- 3.2: Look at the Average Ratings of all Pre-flight services between Satisfied and Dissatisfied passengers
SELECT 
	satisfaction,
    ROUND(AVG(CAST(Checkin_Service AS float)), 2) AS average_checkin,
    ROUND(AVG(CAST(Online_Boarding AS float)), 2) AS average_online_boarding,
    ROUND(AVG(CAST(Departure_Time_Convenience AS float)), 2) AS average_dep_time_convenience,
    ROUND(AVG(CAST(Gate_Location AS float)), 2) AS average_gate_location,
    ROUND(AVG(CAST(Ease_Online_Booking AS float)), 2) AS average_online_booking
FROM 
	airline_satisfaction
GROUP BY 
	satisfaction;

-- 3.3: Look at the Top 3 In-flight × Pre-flight service pairs that co-occur most among satisfied passengers (both scores ≥ 4)
WITH inflight AS (
  SELECT 
	passenger_ID, 
	s_in.feature AS inflight_feature
  FROM 
	airline_satisfaction a
  CROSS APPLY (VALUES
    ('Inflight_Service', Inflight_Service),
    ('Baggage_Handling', Baggage_Handling),
    ('Seat_Comfort', Seat_Comfort),
    ('Onboard_Service', Onboard_Service),
    ('Inflight_Entertainment', Inflight_Entertainment),
    ('Legroom_Service', Legroom_Service),
    ('Cleanliness', Cleanliness),
    ('Food_Drink', Food_Drink),
    ('Inflight_Wifi_Service', Inflight_Wifi_Service)
  ) s_in(feature, score)
  WHERE s_in.score >= 4
),
	preflight AS (
  SELECT 
	passenger_ID, 
	s_pre.feature AS preflight_feature
  FROM 
	airline_satisfaction a
  CROSS APPLY (VALUES
    ('Checkin_Service', Checkin_Service),
    ('Online_Boarding', Online_Boarding),
    ('Departure_Time_Convenience', Departure_Time_Convenience),
    ('Gate_Location', Gate_Location),
    ('Ease_Online_Booking', Ease_Online_Booking)
  ) s_pre(feature, score)
  WHERE 
	s_pre.score >= 4
),
	pairs AS (
  SELECT 
	a.passenger_ID, 
	i.inflight_feature, 
	p.preflight_feature
  FROM 
	airline_satisfaction a
	JOIN inflight  i ON i.passenger_ID = a.passenger_ID
	JOIN preflight p ON p.passenger_ID = a.passenger_ID
  WHERE 
	a.satisfaction= 'Satisfied'
)
SELECT 
	TOP 3 inflight_feature, preflight_feature, 
	COUNT(*) AS total_satisfied_passengers
FROM 
	pairs
GROUP BY 
	inflight_feature, 
	preflight_feature
ORDER BY 
	COUNT(*) DESC;

-- 3.4: Look at the Average bundle score of all In-flight services for Satisfied vs Dissatisfied passengers
WITH inflight_bundle AS (
  SELECT
    satisfaction,
    (
      CAST(Inflight_Service AS float) +
      CAST(Baggage_Handling AS float) +
      CAST(Seat_Comfort AS float) +
      CAST(Onboard_Service AS float) +
      CAST(Inflight_Entertainment AS float) +
      CAST(Legroom_Service AS float) +
      CAST(Cleanliness AS float) +
      CAST(Food_Drink AS float) +
      CAST(Inflight_Wifi_Service AS float)
    ) / 9.0 AS inflight_average
  FROM 
	airline_satisfaction
)
SELECT
  satisfaction,
  ROUND(AVG(inflight_average), 2) AS average_inflight_bundle
FROM 
	inflight_bundle
GROUP BY 
	Satisfaction
ORDER BY 
	average_inflight_bundle DESC;

-- 3.5: Look at the Average bundle score of all Pre-flight services by Travel Class
WITH preflight_bundle AS (
  SELECT
    Travel_Class,
    (
      CAST(Checkin_Service AS float) +
      CAST(Online_Boarding AS float) +
      CAST(Departure_Time_Convenience AS float) +
      CAST(Gate_Location AS float) +
      CAST(Ease_Online_Booking AS float)
    ) / 5.0 AS preflight_average
  FROM 
	airline_satisfaction
)
SELECT
  travel_class,
  ROUND(AVG(preflight_average), 2) AS average_preflight_bundle
FROM 
	preflight_bundle
GROUP BY 
	travel_class
ORDER BY 
	average_preflight_bundle DESC;

-- 3.6: Look at the single weakest service aspect per Travel Class
WITH aspect_average AS (
  SELECT Travel_Class, 'Wifi' AS aspect, AVG(Inflight_Wifi_Service) AS avg_score FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'Gate', AVG(Gate_Location) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'Food', AVG(Food_Drink) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'Seat', AVG(Seat_Comfort) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'IFE',  AVG(Inflight_Entertainment) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'Onboard', AVG(Onboard_Service) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'Legroom', AVG(Legroom_Service) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'Baggage', AVG(Baggage_Handling) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'Checkin', AVG(Checkin_Service) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'InflightSvc', AVG(Inflight_Service) FROM airline_satisfaction GROUP BY Travel_Class UNION ALL
  SELECT Travel_Class, 'Cleanliness', AVG(Cleanliness) FROM airline_satisfaction GROUP BY Travel_Class
),
ranked AS (
  SELECT 
	*,
    DENSE_RANK() OVER (PARTITION BY travel_class ORDER BY avg_score ASC) AS ranking
  FROM 
	aspect_average
)
SELECT 
	travel_class, 
	aspect AS weakest_service, 
	ROUND(avg_score,2) AS avg_score
FROM 
	ranked
WHERE 
	ranking = 1
ORDER BY 
	travel_class;

-- ========================================
-- PART 4: FLIGHT DISTANCE & DELAY ANALYSIS
-- ========================================

-- 4.1: Look at Average Total Delay Minutes by Flight Haul Type
SELECT 
	flight_haul_type,
    ROUND(AVG(CAST(departure_delay_minutes AS float) + CAST(arrival_delay_minutes AS float)), 2) AS average_total_delay
FROM 
	airline_satisfaction
GROUP BY 
	flight_haul_type
ORDER BY 
	average_total_delay DESC;

-- 4.2: Look at the Satisfaction Rate for passengers with different Arrival Delay Status categories
SELECT 
	arrival_delay_status,
    ROUND(100.0 * SUM(CASE WHEN Satisfaction='Satisfied' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_percentage,
    COUNT(*) AS flights
FROM 
	airline_satisfaction
WHERE 
	arrival_delay_status != 'Unknown'
GROUP BY 
	arrival_delay_status
ORDER BY 
	satisfaction_rate_percentage DESC;

-- 4.3: Look at which Travel Type within each Class drives higher delay (vs class baseline)
WITH segment AS (
  SELECT
    travel_class,
    travel_type,
    AVG(CASE WHEN arrival_delay_status <> 'On-time' THEN 1.0 ELSE 0 END) AS delay_rate
  FROM 
	airline_satisfaction
  WHERE 
	arrival_delay_status <> 'Unknown'
  GROUP BY 
	travel_class, 
	travel_type
)
SELECT
	travel_class,
	travel_type,
	ROUND(100*delay_rate,2) AS delay_rate_percentage,
	ROUND(100*(delay_rate - AVG(delay_rate) OVER (PARTITION BY Travel_Class)),2) AS gap_vs_class_avg_percentage
FROM 
	segment
ORDER BY 
	delay_rate_percentage DESC;

-- 4.4: Look at which Customer Type within each Travel Class drives higher delay vs class baseline
WITH segment AS (
  SELECT
    travel_type,           
    flight_haul_type,      
    AVG(CASE WHEN arrival_delay_status <> 'On-time' THEN 1.0 ELSE 0 END) AS delay_rate
  FROM 
	airline_satisfaction
  GROUP BY 
	travel_type, 
	flight_haul_type
)
SELECT
	travel_type,
	flight_haul_type,
	ROUND(100*delay_rate,2) AS delay_rate_percentage,
	ROUND(100*(delay_rate - AVG(delay_rate) OVER (PARTITION BY travel_type)),2) AS delay_diff_vs_type_average
FROM 
	segment
ORDER BY 
	travel_type, 
	delay_diff_vs_type_average DESC;

-- 4.5: Look at on-time performance by Age Group, and the change vs the previous age band
WITH age_group_on_time_rates AS (
    SELECT 
        age_group,
        AVG(CASE WHEN arrival_delay_status = 'On-time' THEN 1.0 ELSE 0 END) AS on_time_rate
    FROM 
		airline_satisfaction
    WHERE 
		arrival_delay_status IS NOT NULL
        AND arrival_delay_status <> 'Unknown'
    GROUP BY 
		age_group
)
	SELECT
		age_group,
		ROUND(100*on_time_rate, 2) AS on_time_rate_percentage,
		ROUND(100 * (on_time_rate - LAG(on_time_rate) OVER (ORDER BY Age_Group)), 2) AS change_vs_previous_percentage
FROM 
	age_group_on_time_rates
ORDER BY 
	age_group;
          
-- =================================================
-- THE END OF AIRLINE PASSENGER SATISFACTION PROJECT
-- =================================================