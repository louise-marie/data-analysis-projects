SELECT Flight_Details
FROM `preppindata`.`pd_2024_wk_1_input`;

/*
Split the Flight Details field to form:
- Date 
- Flight Number
- From
- To
- Class
- Price

Convert the following data fields to the correct data types:
- Date to a date format
- Price to a decimal value
*/
SELECT 
	CAST(SUBSTRING_INDEX(Flight_Details,'//',1) AS DATE) AS Flight_Date,
    SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',2)), '//',-1) AS Flight_Number,
    SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Flight_Details, '//', 3), '//', -1), '-', 1) AS Departure_City,
    SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Flight_Details, '//', 3), '//', -1), '-', -1) AS Arrival_City,
    SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',4)), '//',-1) AS Flight_Class,
    CAST(SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',5)), '//',-1) AS FLOAT) AS Flight_Price
FROM `preppindata`.`pd_2024_wk_1_input`;

-- Change the Flow Card field to Yes / No values instead of 1 / 0
UPDATE `preppindata`.`pd_2024_wk_1_input`
SET Flow_Card_ = CASE
	WHEN Flow_Card_ = '1' THEN 'Yes'
    WHEN Flow_Card_ = '0' THEN 'No'
    ELSE Flow_Card_
END
LIMIT 4000;

-- Create two tables, one for Flow Card holders and one for non-Flow Card holders
CREATE TABLE `preppindata`.`pd_2024_wk_1_output_FlowCardHolders` AS
SELECT 
	CAST(SUBSTRING_INDEX(Flight_Details,'//',1) AS DATE) AS Flight_Date,
    SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',2)), '//',-1) AS Flight_Number,
    SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Flight_Details, '//', 3), '//', -1), '-', 1) AS Departure_City,
    SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Flight_Details, '//', 3), '//', -1), '-', -1) AS Arrival_City,
    SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',4)), '//',-1) AS Flight_Class,
    CAST(SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',5)), '//',-1) AS FLOAT) AS Flight_Price,
    Flow_Card_,
    Bags_Checked,
    Meal_Type
FROM `preppindata`.`pd_2024_wk_1_input`
WHERE Flow_Card_ = 'Yes';

CREATE TABLE `preppindata`.`pd_2024_wk_1_output_Non-FlowCardHolders` AS
SELECT 
	CAST(SUBSTRING_INDEX(Flight_Details,'//',1) AS DATE) AS Flight_Date,
    SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',2)), '//',-1) AS Flight_Number,
    SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Flight_Details, '//', 3), '//', -1), '-', 1) AS Departure_City,
    SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(Flight_Details, '//', 3), '//', -1), '-', -1) AS Arrival_City,
    SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',4)), '//',-1) AS Flight_Class,
    CAST(SUBSTRING_INDEX((SUBSTRING_INDEX(Flight_Details,'//',5)), '//',-1) AS FLOAT) AS Flight_Price,
    Flow_Card_,
    Bags_Checked,
    Meal_Type
FROM `preppindata`.`pd_2024_wk_1_input`
WHERE Flow_Card_ = 'No';