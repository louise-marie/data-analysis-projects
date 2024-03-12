-- Preppindata 2024 week 1: https://preppindata.blogspot.com/2024/01/2024-week-1-prep-airs-flow-card.html
-- 2024: Week 1 - Prep Air's Flow Card

-- Created a new table, as table to be manipulated
-- Split the Flight Details field to form: Date, Flight Number, From, To, Class, Price
-- Converted Date & Price columns to DATE & FLOAT types
CREATE TABLE `data-analysis-projects-394907.preppin_data.preppin-data_2024_week1_prep-air-flow-card_CLEANED` AS
SELECT Flight_Details, 
  CAST(SPLIT(Flight_Details, '//')[OFFSET(0)] AS DATE) AS Flight_Date,
  SPLIT(Flight_Details, '//')[OFFSET(1)] AS Flight_Number,
  SPLIT(SPLIT(Flight_Details, '//')[OFFSET(2)], '-')[OFFSET(0)] AS Flight_FromLocation,
  SPLIT(SPLIT(Flight_Details, '//')[OFFSET(2)], '-')[OFFSET(1)] AS Flight_ToLocation,
  SPLIT(Flight_Details, '//')[OFFSET(3)] AS Flight_Class,
  CAST(SPLIT(Flight_Details, '//')[OFFSET(4)] AS float64) AS Flight_Price,
  CAST (Flow_Card_ AS STRING) AS Flow_Card_, Bags_Checked, Meal_Type
FROM `data-analysis-projects-394907.preppin_data.preppin-data_2024_week1_prep-air-flow-card`;

-- Round off to two decimal points for Price column
UPDATE `data-analysis-projects-394907.preppin_data.preppin-data_2024_week1_prep-air-flow-card_CLEANED`
SET Flight_Price = ROUND(Flight_Price, 2)
WHERE TRUE;

-- Change the Flow Card field to Yes / No values instead of 1 / 0
UPDATE `data-analysis-projects-394907.preppin_data.preppin-data_2024_week1_prep-air-flow-card_CLEANED`
SET Flow_Card_ = CASE
  WHEN Flow_Card_ = '1' THEN 'Yes'
  WHEN Flow_Card_ = '0' THEN 'No'
  ELSE Flow_Card_
END
WHERE TRUE;

-- Create two tables, one for Flow Card holders and one for non-Flow Card holders

-- CARD HOLDERS
CREATE TABLE `data-analysis-projects-394907.preppin_data.preppin-data_2024_week1_prep-air-flow-card_CardHolders` AS
SELECT Flight_Date, Flight_Number, Flight_FromLocation ,Flight_ToLocation ,Flight_Class ,Flight_Price ,Flow_Card_ ,Bags_Checked ,Meal_Type
FROM `data-analysis-projects-394907.preppin_data.preppin-data_2024_week1_prep-air-flow-card_CLEANED`
WHERE Flow_Card_ = 'Yes';

-- NON-CARD HOLDERS
CREATE TABLE `data-analysis-projects-394907.preppin_data.preppin-data_2024_week1_prep-air-flow-card_NonCardHolders` AS
SELECT Flight_Date, Flight_Number, Flight_FromLocation ,Flight_ToLocation ,Flight_Class ,Flight_Price ,Flow_Card_ ,Bags_Checked ,Meal_Type
FROM `data-analysis-projects-394907.preppin_data.preppin-data_2024_week1_prep-air-flow-card_CLEANED`
WHERE Flow_Card_ = 'No';
