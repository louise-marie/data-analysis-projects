-- GET TOTAL UNIQUE USERS
-- Total Daily Activity Unique IDs 

SELECT COUNT ( DISTINCT Id ) AS activity_Ids
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`;

-- Total Daily Calories Unique IDs 

SELECT COUNT ( DISTINCT Id ) AS calories_Ids
FROM `data-analysis-projects-394907.Bellabeat.dailyCalories_merged`;

-- Total Daily Intensities Unique IDs 

SELECT COUNT ( DISTINCT Id ) AS intensities_Ids
FROM `data-analysis-projects-394907.Bellabeat.dailyIntensities_merged`;

-- Total Daily Steps Unique IDs 

SELECT COUNT ( DISTINCT Id ) AS steps_Ids
FROM `data-analysis-projects-394907.Bellabeat.dailySteps_merged`;

-- Total Daily Sleep Unique IDs 

SELECT COUNT ( DISTINCT Id ) AS sleep_Ids
FROM `data-analysis-projects-394907.Bellabeat.sleepDay_merged`;

-- Total Weight Unique IDs 

SELECT COUNT ( DISTINCT Id ) AS weight_Ids
FROM `data-analysis-projects-394907.Bellabeat.weightLogInfo_merged`;

-- GET INFO ABOUT USER'S FITBIT USAGE
-- Activity count per user
SELECT Id, COUNT(Id) AS activityId_count
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Id;

-- Days where users are very/fairly/light active
SELECT 
  Day,
  ROUND(AVG(VeryActiveMinutes), 2) AS AvgVeryActiveMinutes,
  ROUND(AVG(FairlyActiveMinutes), 2) AS AvgFairlyActiveMinutes,
  ROUND(AVG(LightlyActiveMinutes), 2) AS AvgLightlyActiveMinutes
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Day;

-- Days where users are mostly inactive
SELECT 
  Day,
  ROUND(AVG(SedentaryMinutes), 2) AS AvgSedentaryMinutes
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Day
ORDER BY AvgSedentaryMinutes DESC;

-- Average number of total steps per user 
SELECT DISTINCT Id, AVG(TotalSteps) AS averageTotal_Steps
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Id
ORDER BY averageTotal_Steps DESC;

-- Min number of total steps per user 
SELECT DISTINCT Id, MIN(TotalSteps) AS minTotal_Steps
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Id
ORDER BY minTotal_Steps DESC;

-- Max number of total steps per user 
SELECT DISTINCT Id, MAX(TotalSteps) AS maxTotal_Steps
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Id
ORDER BY maxTotal_Steps DESC;

-- Count how many users reach at least 10k steps (AVG)
SELECT DISTINCT Id, AVG(TotalSteps) AS averageTotal_Steps,
  CASE
    WHEN AVG(TotalSteps) >= 10000 THEN "At least 10,000 steps (Avg)"
    ELSE "Less than 10,000 steps (Avg)"
    END AS StepStatus
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Id;

-- Avg of totalsteps, calories, very/fairly/lightly active
SELECT
  DISTINCT Id,
  AVG(TotalSteps) AS AvgSteps,
  AVG(Calories) AS AvgCalories,
  AVG(VeryActiveMinutes) AS AvgVeryActiveMinutes,
  AVG(FairlyActiveMinutes) AS AvgFairlyActiveMinutes,
  AVG(LightlyActiveMinutes) AS AvgLightlyActiveMinutes
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Id;

-- Min of totalsteps, calories, very/fairly/lightly active
SELECT
  DISTINCT Id,
  MIN(TotalSteps) AS MinSteps,
  MIN(Calories) AS MinCalories,
  MIN(VeryActiveMinutes) AS MinVeryActiveMinutes,
  MIN(FairlyActiveMinutes) AS MinFairlyActiveMinutes,
  MIN(LightlyActiveMinutes) AS MinLightlyActiveMinutes
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Id;

-- Min of totalsteps, calories, very/fairly/lightly active
SELECT
  DISTINCT Id,
  MAX(TotalSteps) AS MinSteps,
  MAX(Calories) AS MinCalories,
  MAX(VeryActiveMinutes) AS MinVeryActiveMinutes,
  MAX(FairlyActiveMinutes) AS MinFairlyActiveMinutes,
  MAX(LightlyActiveMinutes) AS MinLightlyActiveMinutes
FROM `data-analysis-projects-394907.Bellabeat.dailyActivity_merged`
GROUP BY Id;

-- Calculate efficiency of sleep
SELECT
  Date AS SleepDate,
  TotalMinutesAsleep,
  TotalTimeInBed,
  ROUND((TotalMinutesAsleep / TotalTimeInBed) * 100,2) AS SleepEfficiency,
  CASE
    WHEN (TotalMinutesAsleep / TotalTimeInBed) * 100 >= 85 THEN "Normal Sleep Efficiency"
    ELSE "Below Normal Sleep Efficiency"
    END AS SleepEfficiencyStatus
FROM `data-analysis-projects-394907.Bellabeat.sleepDay_merged`;

-- Get avg sleep minutes based on the days of the week
SELECT
  Day,
  AVG(TotalMinutesAsleep) AS AvgMinutesAsleep,
  AVG(TotalTimeInBed) AS AvgTimeInBed
FROM `data-analysis-projects-394907.Bellabeat.sleepDay_merged`
GROUP BY Day
ORDER BY Day DESC;
