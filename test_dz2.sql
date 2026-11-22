-- Проверка заполнения данными согласно второму дз

SELECT 'cities'        AS table_name, COUNT(*) AS rows_count FROM cities
UNION ALL
SELECT 'routes',        COUNT(*) FROM routes
UNION ALL
SELECT 'route_cities',  COUNT(*) FROM route_cities
UNION ALL
SELECT 'excursions',    COUNT(*) FROM excursions
UNION ALL
SELECT 'tours',         COUNT(*) FROM tours
UNION ALL
SELECT 'tour_excursion',COUNT(*) FROM tour_excursion
ORDER BY table_name;