CREATE DATABASE IF NOT EXISTS UKAccident;
USE UKAccident;

CREATE TABLE IF NOT EXISTS Accident(
Accident_Index VARCHAR(50),
Location_Easting_OSGR VARCHAR(50),
Location_Northing_OSGR VARCHAR(50),
Longitude VARCHAR(50),
Latitude VARCHAR(50),
Police_Force INT,
Accident_Severity INT,
Number_of_Vehicles INT,
Number_of_Casualties INT,
Accident_Date DATE,
Day_of_Week	INT,
Accident_Time TIME,
Local_Authority_District VARCHAR(50),
Local_Authority_Highway VARCHAR(50),
1st_Road_Class VARCHAR(50),
1st_Road_Number VARCHAR(50),
Road_Type VARCHAR(50),
Speed_limit VARCHAR(50),
Junction_Detail VARCHAR(50),
Junction_Control VARCHAR(50),
2nd_Road_Class VARCHAR(50),
2nd_Road_Number VARCHAR(50),
Pedestrian_Crossing_Human_Control VARCHAR(50),
Pedestrian_Crossing_Physical_Facilities VARCHAR(50),
Light_Conditions VARCHAR(50),
Weather_Conditions VARCHAR(50),
Road_Surface_Conditions VARCHAR(50),
Special_Conditions_at_Site VARCHAR(50),
Carriageway_Hazards VARCHAR(50),
Urban_or_Rural_Area VARCHAR(50),
Did_Police_Officer_Attend_Scene_of_Accident VARCHAR(50),
LSOA_of_Accident_Location VARCHAR(50));

set session sql_mode = ' ';
LOAD DATA INFILE
'F:/Accidents_2015.csv'
INTO TABLE Accident
FIELDS terminated by ','
ENCLOSED BY '"'
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Accident;

CREATE TABLE Vehicles(
Accident_Index VARCHAR(50),
Vehicle_Reference VARCHAR(50),
Vehicle_Type VARCHAR(50),
Towing_and_Articulation VARCHAR(50),
Vehicle_Manoeuvre VARCHAR(50),
Vehicle_Location_Restricted_Lane VARCHAR(50),
Junction_Location VARCHAR(50),
Skidding_and_Overturning VARCHAR(50),
Hit_Object_in_Carriageway VARCHAR(50),
Vehicle_Leaving_Carriageway VARCHAR(50),
Hit_Object_off_Carriageway VARCHAR(50),
1st_Point_of_Impact VARCHAR(50),
Was_Vehicle_Left_Hand_Drive VARCHAR(50),
Journey_Purpose_of_Driver VARCHAR(50),
Sex_of_Driver VARCHAR(50),
Age_of_Driver VARCHAR(50),
Age_Band_of_Driver VARCHAR(50),
Engine_Capacity_CC VARCHAR(50),
Propulsion_Code VARCHAR(50),
Age_of_Vehicle VARCHAR(50),
Driver_IMD_Decile VARCHAR(50),
Driver_Home_Area_Type VARCHAR(50),
Vehicle_IMD_Decile VARCHAR(50));

set session sql_mode = ' ';
LOAD DATA INFILE
'F:/Vehicles_2015.csv'
INTO TABLE Vehicles
FIELDS terminated by ','
ENCLOSED BY '"'
lines terminated by '\n'
ignore 1 rows;
SELECT * FROM Vehicles;

CREATE TABLE IF NOT EXISTS VehicleType(
Vehicle_Type VARCHAR(50),
Label VARCHAR(50));

set session sql_mode = ' ';
LOAD DATA INFILE
'F:/vehicle_types.csv'
INTO TABLE VehicleType
FIELDS terminated by ','
enclosed by '"'
lines terminated BY '\n'
ignore 1 rows;
SELECT * FROM VehicleType;

/* Evaluate Accident Severity and Total Accidents per Vehicle Type. */

SELECT vt.Label AS TypeOfVehicle, COUNT(*) AS Total_Accidents,
AVG(a.Accident_Severity) AS Average_Severity
FROM Accident a
JOIN Vehicles v ON v.Accident_Index = a.Accident_Index
JOIN VehicleType vt ON v.Vehicle_Type = vt.Vehicle_Type
GROUP BY vt.Label
ORDER BY Total_Accidents DESC;

/* Calculate the Average Severity by vehicle type. */

SELECT vt.Label AS TypeOfVehicle,
AVG(a.Accident_Severity) AS Average_Severity
FROM Accident a
JOIN Vehicles v ON v.Accident_Index = a.Accident_Index
JOIN VehicleType vt ON v.Vehicle_Type = vt.Vehicle_Type
GROUP BY vt.Label;

/* Calculate the Average Severity and Total Accidents by Motorcycle. */

SELECT vt.Label AS TypeOfVehicle, COUNT(*) AS Total_Accidents,
AVG(a.Accident_Severity) AS Average_Severity
FROM Accident a
JOIN Vehicles v ON v.Accident_Index = a.Accident_Index
JOIN VehicleType vt ON v.Vehicle_Type = vt.Vehicle_Type
WHERE vt.Label LIKE "Motorcycle%"
GROUP BY vt.Label;

