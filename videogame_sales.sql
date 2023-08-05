-- Kaggle Video Game dataset by gregorysmith
-- https://www.kaggle.com/datasets/gregorut/videogamesales

-- Get column names
SELECT column_name
FROM `data-analysis-projects-394907.videogame_data_sales.INFORMATION_SCHEMA.COLUMNS`;

-- Copy original table to new table
CREATE TABLE `data-analysis-projects-394907.videogame_data_sales.videogame_sales_2` LIKE `data-analysis-projects-394907.videogame_data_sales.videogame_sales`

INSERT INTO `data-analysis-projects-394907.videogame_data_sales.videogame_sales_2` SELECT * FROM `data-analysis-projects-394907.videogame_data_sales.videogame_sales`;

-- Count how many games have been released in a year
SELECT Year, COUNT(Year)
FROM `data-analysis-projects-394907.videogame_data_sales.videogame_sales_2`
GROUP BY Year;

-- Remove rows that have N/A values
DELETE FROM `data-analysis-projects-394907.videogame_data_sales.videogame_sales_2`
WHERE Year="N/A";

-- Get MAX & MIN Year
SELECT MIN(Year) AS Min_Year, MAX(Year) AS Max_Year
FROM `data-analysis-projects-394907.videogame_data_sales.videogame_sales_2`;

-- EXPLORATION
-- 1. Most Genre released from 2000-2020
-- 2. Publishers with the most releases from 2000-2020
-- 3. Platforms with the most releases from 2000-2020
-- 4. [GLOBAL SALES] Who sold the most games and in what platform from 2000-2020

-- Top 3 Released Genre From 2000~
SELECT Genre, Count(Genre) AS Genre_Count
FROM `data-analysis-projects-394907.videogame_data_sales.videogame_sales_2`
WHERE Year>='2000'
GROUP BY Genre
ORDER BY Genre_Count DESC
LIMIT 3;

-- Top 3 Publishers with the most releases From 2000~
SELECT Publisher, Count(Publisher) AS Publisher_Count
FROM `data-analysis-projects-394907.videogame_data_sales.videogame_sales_2`
WHERE Year>='2000'
GROUP BY Publisher
ORDER BY Publisher_Count DESC
LIMIT 3;

-- Top 3 Platforms with the most released games From 2000~
SELECT Platform, Count(Platform) AS Platform_Count
FROM `data-analysis-projects-394907.videogame_data_sales.videogame_sales_2`
WHERE Year>='2000'
GROUP BY Platform
ORDER BY Platform_Count DESC
LIMIT 3;
