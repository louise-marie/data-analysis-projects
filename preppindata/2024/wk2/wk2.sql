-- Update incorrect date values to the correct format
UPDATE `preppindata`.`pd_2024_wk_2_output_flow_card`
SET `Date` = STR_TO_DATE(`Date`, '%d/%m/%Y');

UPDATE `preppindata`.`pd_2024_wk_2_output_nonflow_card`
SET `Date` = STR_TO_DATE(`Date`, '%d/%m/%Y');

-- Alter the table to change the column type
ALTER TABLE `preppindata`.`pd_2024_wk_2_output_flow_card` 
MODIFY COLUMN `Date` DATE NULL DEFAULT NULL;

ALTER TABLE `preppindata`.`pd_2024_wk_2_output_nonflow_card` 
MODIFY COLUMN `Date` DATE NULL DEFAULT NULL;

-- Union the files together
SELECT * FROM preppindata.pd_2024_wk_2_output_nonflow_card
UNION ALL
SELECT * FROM preppindata.pd_2024_wk_2_output_flow_card;

-- Convert the Date field to a Quarter Number instead
-- Name this field Quarter
SELECT Date, Quarter(Date) AS Quarter FROM preppindata.pd_2024_wk_2_output_nonflow_card
  UNION ALL
SELECT Date, Quarter(Date) AS Quarter FROM preppindata.pd_2024_wk_2_output_flow_card;

-- Add Quarter column
-- Add Quarter column to the nonflow_card table
ALTER TABLE preppindata.pd_2024_wk_2_output_nonflow_card
ADD COLUMN Quarter INT;

-- Update the Quarter column with the quarter number
UPDATE preppindata.pd_2024_wk_2_output_nonflow_card
SET Quarter = QUARTER(Date);

-- Add Quarter column to the flow_card table
ALTER TABLE preppindata.pd_2024_wk_2_output_flow_card
ADD COLUMN Quarter INT;

-- Update the Quarter column with the quarter number
UPDATE preppindata.pd_2024_wk_2_output_flow_card
SET Quarter = QUARTER(Date);

-- Aggregate the data in the following ways:
-- Median price per Quarter, Flow Card? and Class
-- Minimum price per Quarter, Flow Card? and Class
-- Maximum price per Quarter, Flow Card? and Class
SELECT
  CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(Price ORDER BY Price SEPARATOR ','), ',', 50/100), ',', -1) AS DECIMAL) AS MedianPrice_FlowCard,
  MIN(Price) AS MinPrice_FlowCard,
  MAX(Price) AS MaxPrice_FlowCard
FROM preppindata.pd_2024_wk_2_output_flow_card
GROUP BY Quarter, Flow_Card, Class;

SELECT
  CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(Price ORDER BY Price SEPARATOR ','), ',', 50/100), ',', -1) AS DECIMAL) AS MedianPrice_NoFlowCard,
  MIN(Price) AS MinPrice_NoFlowCard,
  MAX(Price) AS MaxPrice_NoFlowCard
FROM preppindata.pd_2024_wk_2_output_nonflow_card
GROUP BY Quarter, Flow_Card, Class;

-- Create three separate flows where you have only one of the aggregated measures in each. 
-- One for the minimum price
SELECT
  MIN(Price) AS MinPrice_FlowCard
FROM preppindata.pd_2024_wk_2_output_flow_card
GROUP BY Quarter, Flow_Card, Class;

SELECT
  MIN(Price) AS MinPrice_NoFlowCard
FROM preppindata.pd_2024_wk_2_output_nonflow_card
GROUP BY Quarter, Flow_Card, Class;
-- One for the median price
SELECT
  CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(Price ORDER BY Price SEPARATOR ','), ',', 50/100), ',', -1) AS DECIMAL) AS MedianPrice_FlowCard
FROM preppindata.pd_2024_wk_2_output_flow_card
GROUP BY Quarter, Flow_Card, Class;

SELECT
  CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(Price ORDER BY Price SEPARATOR ','), ',', 50/100), ',', -1) AS DECIMAL) AS MedianPrice_NoFlowCard
FROM preppindata.pd_2024_wk_2_output_nonflow_card
GROUP BY Quarter, Flow_Card, Class;
-- One for the maximum price
SELECT
  MAX(Price) AS MaxPrice_FlowCard
FROM preppindata.pd_2024_wk_2_output_flow_card
GROUP BY Quarter, Flow_Card, Class;

SELECT
  MAX(Price) AS MaxPrice_NoFlowCard
FROM preppindata.pd_2024_wk_2_output_nonflow_card
GROUP BY Quarter, Flow_Card, Class;

SELECT
	Flow_Card,
	Quarter,
    MAX(CASE WHEN Class = 'Economy' THEN Price END) AS Economy_Max_Price,
	MAX(CASE WHEN Class = 'First Class' THEN Price END) AS First_Class_Max_Price,
	MAX(CASE WHEN Class = 'Premium Economy' THEN Price END) AS Premium_Economy_Class_Max_Price,
	MAX(CASE WHEN Class = 'Business Class' THEN Price END) AS Business_Class_Max_Price
FROM preppindata.pd_2024_wk_2_output_flow_card
GROUP BY Flow_Card, Quarter;

SELECT
	Flow_Card,
	Quarter,
    MAX(CASE WHEN Class = 'Economy' THEN Price END) AS Economy_Max_Price,
	MAX(CASE WHEN Class = 'First Class' THEN Price END) AS First_Class_Max_Price,
	MAX(CASE WHEN Class = 'Premium Economy' THEN Price END) AS Premium_Economy_Class_Max_Price,
	MAX(CASE WHEN Class = 'Business Class' THEN Price END) AS Business_Class_Max_Price
FROM preppindata.pd_2024_wk_2_output_nonflow_card
GROUP BY Flow_Card, Quarter;

-- Change the name of the following columns:
-- Economy to First
-- First Class to Economy
-- Business Class to Premium
-- Premium Economy to Business
UPDATE preppindata.pd_2024_wk_2_output_nonflow_card
SET Class = CASE
	WHEN Class = 'Economy' THEN 'First Class'
    WHEN Class = 'First Class' THEN 'Economy'
    WHEN Class = 'Business Class' THEN 'Premium Economy'
    WHEN Class = 'Premium Economy' THEN 'Business Class'
    ELSE Class
END;

UPDATE preppindata.pd_2024_wk_2_output_flow_card
SET Class = CASE
	WHEN Class = 'Economy' THEN 'First Class'
    WHEN Class = 'First Class' THEN 'Economy'
    WHEN Class = 'Business Class' THEN 'Premium Economy'
    WHEN Class = 'Premium Economy' THEN 'Business Class'
    ELSE Class
END;

SELECT Flow_Card, Quarter, 
	MAX(CASE WHEN Class = 'Economy' THEN Price END) AS Max_Economy,
	MAX(CASE WHEN Class = 'First Class' THEN Price END) AS Max_First_CLass,
	MAX(CASE WHEN Class = 'Premium Economy' THEN Price END) AS Max_Premium_Economy,
	MAX(CASE WHEN Class = 'Business Class' THEN Price END) AS Max_Business_Class,
    MIN(CASE WHEN Class = 'Economy' THEN Price END) AS Min_Economy,
	MIN(CASE WHEN Class = 'First Class' THEN Price END) AS Min_First_CLass,
	MIN(CASE WHEN Class = 'Premium Economy' THEN Price END) AS Min_Premium_Economy,
	MIN(CASE WHEN Class = 'Business Class' THEN Price END) AS Min_Business_Class,
	CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(Price ORDER BY Price SEPARATOR ','), ',', 50/100), ',', -1) AS DECIMAL) AS Median_Price

    FROM preppindata.pd_2024_wk_2_output_flow_card
    GROUP BY Flow_Card, Quarter
UNION ALL
SELECT Flow_Card, Quarter, 
	MAX(CASE WHEN Class = 'Economy' THEN Price END) AS Max_Economy,
	MAX(CASE WHEN Class = 'First Class' THEN Price END) AS Max_First_CLass,
	MAX(CASE WHEN Class = 'Premium Economy' THEN Price END) AS Max_Premium_Economy,
	MAX(CASE WHEN Class = 'Business Class' THEN Price END) AS Max_Business_Class,
    MIN(CASE WHEN Class = 'Economy' THEN Price END) AS Min_Economy,
	MIN(CASE WHEN Class = 'First Class' THEN Price END) AS Min_First_CLass,
	MIN(CASE WHEN Class = 'Premium Economy' THEN Price END) AS Min_Premium_Economy,
	MIN(CASE WHEN Class = 'Business Class' THEN Price END) AS Min_Business_Class
	FROM preppindata.pd_2024_wk_2_output_nonflow_card
    GROUP BY Flow_Card, Quarter;
    

