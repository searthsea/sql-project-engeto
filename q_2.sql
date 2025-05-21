--Q2 Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
	a_year,
	item_name,
	round(avg_wage / avg_price) AS items_per_avg_wage
FROM t_martin_schwarz_project_SQL_primary_final
WHERE 	a_year IN (2006, 2018)
	AND category_code IN (111301, 114201)
	AND industry_branch_code IS NULL