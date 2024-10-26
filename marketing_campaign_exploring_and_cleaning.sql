-- Creat the table for import
CREATE TABLE marketing_campaign (
	customer_id INTEGER,
	birth_year INTEGER,
	education TEXT,
	marital_status TEXT,
	income INTEGER,
	kidhome INTEGER,
	teenhome INTEGER,
	start_date TIMESTAMP WITHOUT TIME ZONE,
	days_last_purchase INTEGER,
	spent_wine INTEGER,
	spent_fruits INTEGER,
	spent_meat INTEGER,
	spent_fish INTEGER,
	spent_sweets INTEGER,
	spent_gold INTEGER,
	deal_purchases INTEGER,
	web_purchases INTEGER,
	catalog_purchases INTEGER,
	store_purchases INTEGER,
	web_visits INTEGER,
	campaign3 INTEGER,
	campaign4 INTEGER,
	campaign5 INTEGER,
	campaign1 INTEGER,
	campaign2 INTEGER,
	complain INTEGER,
	zcost INTEGER,
	zrevenue INTEGER,
	response INTEGER
);


-- Exploration and Cleaning the data
------------------------------------------------------------------
-- Identify if there is any null values in all colums
SELECT 
	income
FROM marketing_campaign
WHERE income IS NULL
-- Only the income column has 24 null values
;

-- Delete null values in the income cell
DELETE FROM marketing_campaign
WHERE income IS NULL
-- 24 rows deleted
;

-- birth_year outliers
SELECT
	birth_year,
	(2014 - birth_year) AS age,
	COUNT(*)
FROM marketing_campaign
WHERE (2014 - birth_year) > 100
GROUP BY birth_year, age
/*	With this query we have identified that the dataset has people 
	that was born in the year 1900 and before so we need to exclude 
	them to have an accurate analysis (3 outliers).
	This was done because the dataset was published in the year 2014
	By SAS Institute, 2014.
*/;

-- Delete values that are more than 100 years old
DELETE FROM marketing_campaign
WHERE (2014 - birth_year) > 100
-- 3 rows deleted
;

-- Education ef clients
SELECT
	education,
	COUNT(*)
FROM marketing_campaign
GROUP BY education;

-- Marital Satuts of clients
SELECT
	marital_status,
	COUNT(*)
FROM marketing_campaign
GROUP BY marital_status
/*
	The table has to types of value that does not match the type of value
	we could keep only 2 values to standarize the column:
	
	'Widow', 'YOLO', 'Alone', 'Absurd', 'Divorced' to SINGLE
	'Together' to MARRIED
*/
;

-- Update te table to standardize the marital_status column
UPDATE marketing_campaign
SET marital_status = 
    CASE 
        WHEN marital_status = 'Together' THEN 'Married'
        WHEN marital_status IN ('Widow', 'YOLO', 'Alone', 'Absurd', 'Divorced') THEN 'Single'
        ELSE marital_status 
    END;

-- Anual Income average, maximum, minimun and quartiles
SELECT
	ROUND(AVG(income)) AS avg_income,
	MIN(income) AS min_income,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY income) AS q1_income,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY income) AS median_income,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY income) AS q3_income,
	MAX(income) AS max_income
FROM marketing_campaign
WHERE income IS NOT NULL
/* Could group incomes by quartiles to segment clients by income:
	35284 or lower = Low Income
	35285 - 51373 = Median Low Income
	51374 - 68487 = Median High Income
	68488 or more = High Income
*/
;

-- Identify outliers in the income column
WITH quartiles AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY income) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY income) AS Q3
    FROM marketing_campaign
),
iqr_calculation AS (
    SELECT 
        Q1,
        Q3,
        (Q3 - Q1) AS IQR
    FROM quartiles
)
SELECT 
    mc.*,
    CASE 
        WHEN mc.income < (q.Q1 - 1.5 * q.IQR) THEN 'Lower Outlier'
        WHEN mc.income > (q.Q3 + 1.5 * q.IQR) THEN 'Upper Outlier'
        ELSE 'Normal'
    END AS outlier_status
FROM marketing_campaign mc
CROSS JOIN iqr_calculation q
WHERE 
    mc.income < (q.Q1 - 1.5 * q.IQR) 
    OR mc.income > (q.Q3 + 1.5 * q.IQR)
/*
	With this query we have identified that we have 8 outliers in the table
	that we need to delete from the tbale
*/

-- Date of customers enrolment max and min
SELECT
	MIN(DATE(start_date)) AS min_date,
	MAX(DATE(start_date)) AS max_date
FROM marketing_campaign
-- From July 30 2012 to June 29 2014
;

-- Remove income outliers
WITH quartiles AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY income) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY income) AS Q3
    FROM marketing_campaign
),
iqr_calculation AS (
    SELECT 
        Q1,
        Q3,
        (Q3 - Q1) AS IQR
    FROM 
        quartiles
)
DELETE FROM marketing_campaign
USING iqr_calculation
WHERE income < (iqr_calculation.Q1 - 1.5 * iqr_calculation.IQR)
	OR income > (iqr_calculation.Q3 + 1.5 * iqr_calculation.IQR)
-- 8 values deleted
	;


