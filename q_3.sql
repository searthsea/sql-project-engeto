--Q3 Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH previous_year AS (
	SELECT DISTINCT
		a_year,
		item_name,
		round(avg_price::NUMERIC, 2) AS avg_price,
		round(lag(avg_price) OVER (
			PARTITION BY category_code
			ORDER BY a_year
			)::NUMERIC, 2) AS avg_price_previous
	FROM t_martin_schwarz_project_SQL_primary_final
	WHERE 	a_year IN (2006, 2018)
		AND industry_branch_code IS NULL
		AND item_name != 'Jakostní víno bílé'
	) 	
SELECT
	item_name,
	avg_price,
	avg_price_previous,
	round(((avg_price / avg_price_previous - 1) * 100)::NUMERIC, 2) AS price_diff_pct
FROM previous_year
WHERE a_year = 2018
ORDER BY price_diff_pct ASC