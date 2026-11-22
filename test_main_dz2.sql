-- Тестовый скрипт для проверки заданий варианта 
-- Раскомментируйте нужный блок кода с заданием чтобы проверить его работу
-- (убрать '/*' и '*/' для нужного задания).
-- К сожалению я не придумал как уместить тест в одном скрипте чтобы не было полей null


-- Задание 1
-- Экскурсии с ценой в долларах
/*
WITH rate AS (
    SELECT 81.48::numeric AS usd_rate
)
SELECT
    e.*,
    CEIL(e.price / r.usd_rate)::integer AS price_usd
FROM excursions e
CROSS JOIN rate r
ORDER BY e.excursion_id;
*/

-- Задание 2 
-- Тур с максимальным числом экскурсий
/*
WITH tour_counts AS (
    SELECT
        t.tour_id,
        t.route_id,
        t.departure_date,
        t.days_count,
        t.extra_fees,
        t.extra_description,
        COUNT(te.excursion_id) AS excursions_count
    FROM tours t
    LEFT JOIN tour_excursion te
        ON te.tour_id = t.tour_id
    GROUP BY
        t.tour_id,
        t.route_id,
        t.departure_date,
        t.days_count,
        t.extra_fees,
        t.extra_description
)
SELECT *
FROM tour_counts
ORDER BY excursions_count DESC, tour_id
FETCH FIRST 1 ROW WITH TIES;
*/