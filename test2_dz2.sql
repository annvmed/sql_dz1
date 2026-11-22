-- Проверка конкретных выборок

SELECT * FROM cities ORDER BY city_id;
SELECT * FROM routes ORDER BY route_id;
SELECT * FROM excursions ORDER BY excursion_id;
SELECT * FROM tours ORDER BY tour_id;
SELECT * FROM tour_excursion ORDER BY tour_id, excursion_id;