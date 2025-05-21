-- SELECT & JOIN --> Secondary table

CREATE TABLE t_martin_schwarz_project_SQL_secondary_final AS
	SELECT
		e.country,
		e."year" AS a_year,
		e.population,
		round(e.gdp) AS gdp,
		round (e.gdp / e.population) AS gdp_per_capita,
		e.gini 		
	FROM economies e
	LEFT JOIN countries c 
		ON e.country = c.country
	WHERE 	e."year" BETWEEN 2006 AND 2018 
		AND c.continent = 'Europe'
	ORDER BY country,
			 a_year		
			 