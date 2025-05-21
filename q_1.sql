--Q1 Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT
	DISTINCT 
		a_year,
		industry_branch_code,
		industry_name,
	round(avg_wage) AS wage
FROM t_martin_schwarz_project_SQL_primary_final
ORDER BY 
	industry_branch_code,
	a_year
