-- Q4 Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH 
average_price AS (
	SELECT 
		a_year,
		round(avg(avg_wage)) AS avg_wage,
		round(avg(avg_price)::NUMERIC, 2) AS avg_price
	FROM t_martin_schwarz_project_sql_primary_final
	WHERE industry_branch_code IS NULL
	GROUP BY a_year
	),
average_previous_year AS (
	SELECT
		a_year,
		avg_wage,
		lag(avg_wage) OVER (
			ORDER BY a_year
			) AS avg_wage_previous,
		avg_price,
		lag(avg_price) OVER (
			ORDER BY a_year
			) AS avg_price_previous
	FROM average_price
	)
SELECT
	*,
	round(((
		(avg_wage / avg_wage_previous - 1) - 
		(avg_price / avg_price_previous - 1)) * 100)::NUMERIC, 1) 
		AS diff_pct
FROM average_previous_year
	
