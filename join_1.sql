-- SELECT & JOIN --> Primary table

CREATE TABLE t_martin_schwarz_project_SQL_primary_final AS
	WITH 
	average_price AS (
		SELECT 
			avg(value) AS avg_price,
			date_part('year', date_from) AS a_year,
			category_code
		FROM czechia_price
		WHERE region_code IS NULL
		GROUP BY 
			date_part('year', date_from),
			category_code
		),
	average_wage AS (
		SELECT 
			avg(value) AS avg_wage,
			industry_branch_code,
			payroll_year
		FROM czechia_payroll
		WHERE 
				value_type_code = 5958
			AND calculation_code = 200
		GROUP BY
			industry_branch_code,
			payroll_year
	)
	SELECT
		ap.a_year,
		aw.avg_wage,
		aw.industry_branch_code,
		cpib.name AS industry_name,
		ap.avg_price,
		ap.category_code,
		cpc.name AS item_name,
		e.gdp / e.population AS gdp_per_capita
	FROM average_price ap
	LEFT JOIN average_wage aw
		ON aw.payroll_year = ap.a_year
	LEFT JOIN czechia_payroll_industry_branch cpib 
		ON cpib.code = aw.industry_branch_code
	LEFT JOIN czechia_price_category cpc
		ON ap.category_code = cpc.code
	LEFT JOIN economies e 
		ON e."year" = aw.payroll_year
	WHERE e.country = 'Czech Republic'

