-- Q5 Má výška HDP vliv na změny ve mzdách a cenách potravin? 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?



WITH 
filter_data AS (
	SELECT 
		a_year,
		avg(avg_wage) AS avg_wage,
		avg(avg_price) AS avg_price,
		avg(gdp_per_capita) AS gdp_per_capita
	FROM t_martin_schwarz_project_sql_primary_final
	WHERE industry_branch_code IS NULL
	GROUP BY a_year
),
previous_year AS (
	SELECT 
		a_year,
		avg_wage,
		lag(avg_wage) OVER (ORDER BY a_year) AS avg_wage_lag,
		avg_price,
		lag(avg_price) OVER (ORDER BY a_year) AS avg_price_lag,
		gdp_per_capita,
		lag(gdp_per_capita) OVER (ORDER BY a_year) AS gdp_lag
	FROM filter_data
) 
SELECT  
	a_year,
	round(((avg_wage / avg_wage_lag - 1) * 100), 2) AS wage_diff_pct,
	round(((avg_price / avg_price_lag - 1)::NUMERIC * 100), 2) AS price_diff_pct,
	round(((gdp_per_capita / gdp_lag - 1) * 100)::NUMERIC, 2) AS gdp_diff_pct
FROM previous_year 
ORDER BY a_year


