-- Spending and purchase type TOTALS
--------------------------------------------------------------
SELECT
	COUNT(*) AS total_clients,
	SUM(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS total_spent,
	SUM(deal_purchases + web_purchases + catalog_purchases + store_purchases) AS total_purchases,
	SUM(campaign1 + campaign2 + campaign3 + campaign4 + campaign5 + response) AS total_campaign_responses,
	SUM(complain) AS total_complains
FROM marketing_campaign;

-- Percentage Spent By Product
SELECT 
    ROUND(SUM(spent_wine) / CAST(SUM(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS NUMERIC) * 100, 2) AS wine,
    ROUND(SUM(spent_fruits) / CAST(SUM(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS NUMERIC) * 100, 2) AS fruits,
    ROUND(SUM(spent_meat) / CAST(SUM(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS NUMERIC) * 100, 2) AS meat,
    ROUND(SUM(spent_fish) / CAST(SUM(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS NUMERIC) * 100, 2) AS fish,
    ROUND(SUM(spent_sweets) / CAST(SUM(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS NUMERIC) * 100, 2) AS sweets,
    ROUND(SUM(spent_gold) / CAST(SUM(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS NUMERIC) * 100, 2) AS gold
FROM marketing_campaign;

-- Percent of Purchase Type
SELECT 
    ROUND(SUM(deal_purchases) / CAST(SUM(deal_purchases + web_purchases + catalog_purchases + store_purchases) AS NUMERIC) * 100, 2) AS deal,
    ROUND(SUM(web_purchases) / CAST(SUM(deal_purchases + web_purchases + catalog_purchases + store_purchases) AS NUMERIC) * 100, 2) AS web,
    ROUND(SUM(catalog_purchases) / CAST(SUM(deal_purchases + web_purchases + catalog_purchases + store_purchases) AS NUMERIC) * 100, 2) AS catalog,
    ROUND(SUM(store_purchases) / CAST(SUM(deal_purchases + web_purchases + catalog_purchases + store_purchases) AS NUMERIC) * 100, 2) AS store
FROM marketing_campaign;

--Segment Analysis
--------------------------------------------------------------
SELECT
	CASE 
		WHEN (2014 - birth_year) BETWEEN 18 AND 24 THEN '18-24'
		WHEN (2014 - birth_year) BETWEEN 25 AND 34 THEN '25-34'
		WHEN (2014 - birth_year) BETWEEN 35 AND 44 THEN '35-44'
		WHEN (2014 - birth_year) BETWEEN 45 AND 54 THEN '45-54'
		WHEN (2014 - birth_year) BETWEEN 55 AND 64 THEN '55-64'
		WHEN (2014 - birth_year) >= 65 THEN '65+'
	END AS cust_age,
	COUNT(*) AS total_clients,
	SUM(spent_wine) AS spent_wine,
	SUM(spent_fruits) AS spent_fruits,
	SUM(spent_meat) AS spent_meat,
	SUM(spent_fish) AS spent_fish,
	SUM(spent_sweets) AS spent_sweets,
	SUM(spent_gold) AS spent_gold,
	SUM(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS total_spent,
	AVG(spent_wine + spent_fruits + spent_meat + spent_fish + spent_sweets + spent_gold) AS avg_spent,
	SUM(campaign1 + campaign2 + campaign3 + campaign4 + campaign5 + response) AS campaign_response,
	SUM(complain) AS complains,
	SUM(deal_purchases) AS deals,
	SUM(web_purchases) AS web,
	SUM(catalog_purchases) AS catalog,
	SUM(store_purchases) AS store,
	SUM(deal_purchases + web_purchases + catalog_purchases + store_purchases) AS total_buys
FROM marketing_campaign
GROUP BY cust_age
ORDER BY cust_age;
/* 
	This query extracts a summary table to identify spending and purchase patterns by segment
*/


