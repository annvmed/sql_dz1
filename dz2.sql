/*
ФИО студента: Евсеев Александр Юрьевич
Вариант: 17

Условия задания:
Выберите экскурсии (все поля таблицы), 
пересчитав их цену из рублей в доллары по текущему курсу ЦБ РФ 
и округлив её в большую сторону до доллара.
Найдите тур с самым большим числом возможных экскурсий.
*/

SET client_encoding = 'UTF8';

BEGIN;

DROP TABLE IF EXISTS tour_excursion CASCADE;
DROP TABLE IF EXISTS tours CASCADE;
DROP TABLE IF EXISTS excursions CASCADE;
DROP TABLE IF EXISTS route_cities CASCADE;
DROP TABLE IF EXISTS routes CASCADE;
DROP TABLE IF EXISTS cities CASCADE;

-- Города
CREATE TABLE cities (
    city_id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(150) NOT NULL UNIQUE
);

-- Маршруты
CREATE TABLE routes (
    route_id            INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                VARCHAR(200) NOT NULL,
    departure_city_id   INT NOT NULL,
    description         TEXT NOT NULL DEFAULT '',
    base_price          NUMERIC(12, 2) NOT NULL DEFAULT 0
                        CHECK (base_price >= 0),

    CONSTRAINT fk_routes_departure_city
        FOREIGN KEY (departure_city_id)
        REFERENCES cities (city_id)
);

-- Список городов маршрута и количество дней пребывания в каждом
CREATE TABLE route_cities (
    route_id    INT NOT NULL,
    city_id     INT NOT NULL,
    days_count  INT NOT NULL CHECK (days_count > 0),

    PRIMARY KEY (route_id, city_id),

    CONSTRAINT fk_route_cities_route
        FOREIGN KEY (route_id)
        REFERENCES routes (route_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_route_cities_city
        FOREIGN KEY (city_id)
        REFERENCES cities (city_id)
);

-- Экскурсии
CREATE TABLE excursions (
    excursion_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city_id         INT NOT NULL,
    name            VARCHAR(200) NOT NULL,
    description     TEXT NOT NULL DEFAULT '',
    price           NUMERIC(12, 2) NOT NULL DEFAULT 0
                    CHECK (price >= 0),

    CONSTRAINT fk_excursions_city
        FOREIGN KEY (city_id)
        REFERENCES cities (city_id),

    CONSTRAINT uq_excursions_city_name
        UNIQUE (city_id, name)
);

-- Туры
CREATE TABLE tours (
    tour_id             INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    route_id            INT NOT NULL,
    departure_date      DATE NOT NULL,
    days_count          INT NOT NULL CHECK (days_count > 0),
    extra_fees          NUMERIC(12, 2) NOT NULL DEFAULT 0
                        CHECK (extra_fees >= 0),
    extra_description   TEXT NOT NULL DEFAULT '',

    CONSTRAINT fk_tours_route
        FOREIGN KEY (route_id)
        REFERENCES routes (route_id)
);

-- Какие экскурсии добавлены в тур
CREATE TABLE tour_excursion (
    tour_id         INT NOT NULL,
    excursion_id    INT NOT NULL,

    PRIMARY KEY (tour_id, excursion_id),

    CONSTRAINT fk_tour_excursion_tour
        FOREIGN KEY (tour_id)
        REFERENCES tours (tour_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_tour_excursion_excursion
        FOREIGN KEY (excursion_id)
        REFERENCES excursions (excursion_id)
        ON DELETE CASCADE
);

-- Добавить города
INSERT INTO cities (city_id, name) OVERRIDING SYSTEM VALUE VALUES
(1, 'Москва'),
(2, 'Санкт-Петербург'),
(3, 'Казань'),
(4, 'Сочи'),
(5, 'Владимир'),
(6, 'Суздаль'),
(7, 'Нижний Новгород'),
(8, 'Ярославль');

-- Добавить маршруты
INSERT INTO routes (route_id, name, departure_city_id, description, base_price)
OVERRIDING SYSTEM VALUE VALUES
(1, 'Золотое кольцо: Владимир — Суздаль', 1,
 'Классический маршрут по древним городам Золотого кольца.', 18000.00),
(2, 'Северная столица', 1,
 'Обзорный тур в Санкт-Петербург с посещением пригородов.', 22000.00),
(3, 'Казань и Поволжье', 1,
 'Тур по Казани и Нижнему Новгороду с обзорными экскурсиями.', 25000.00),
(4, 'Черноморский отдых', 1,
 'Пляжный тур в Сочи с экскурсиями по Красной Поляне.', 30000.00),
(5, 'Две столицы', 1,
 'Комбинированный тур Москва — Санкт-Петербург.', 28000.00);

-- Добавить города маршрутов
INSERT INTO route_cities (route_id, city_id, days_count) VALUES
(1, 5, 2),
(1, 6, 2),
(2, 2, 4),
(3, 3, 3),
(3, 7, 2),
(4, 4, 5),
(5, 1, 2),
(5, 2, 3);

-- Добавить экскурсии
INSERT INTO excursions (excursion_id, city_id, name, description, price)
OVERRIDING SYSTEM VALUE VALUES
(1, 5, 'Обзорная экскурсия по Владимиру',
 'Прогулка по историческому центру Владимира.', 1200.00),
(2, 6, 'Суздальский кремль',
 'Посещение Суздальского кремля и деревянного зодчества.', 1500.00),
(3, 2, 'Эрмитаж',
 'Экскурсия по главному музею Санкт-Петербурга.', 2500.00),
(4, 2, 'Петергоф',
 'Поездка в Петергоф с осмотром фонтанов.', 3200.00),
(5, 3, 'Казанский кремль',
 'Обзорная экскурсия по Казанскому кремлю.', 1800.00),
(6, 7, 'Нижегородский кремль',
 'Прогулка по Нижегородскому кремлю и набережной.', 1400.00),
(7, 4, 'Красная Поляна',
 'Экскурсия на курорт Красная Поляна.', 3500.00),
(8, 4, 'Олимпийский парк',
 'Посещение Олимпийского парка в Сочи.', 2000.00),
(9, 1, 'Красная площадь и Кремль',
 'Обзорная экскурсия по центру Москвы.', 2200.00),
(10, 2, 'Русский музей',
 'Экскурсия по Русскому музею.', 1600.00),
(11, 1, 'Третьяковская галерея',
 'Посещение Третьяковской галереи.', 1900.00),
(12, 2, 'Петропавловская крепость',
 'Экскурсия по Петропавловской крепости.', 1300.00);

-- Добавить туры
INSERT INTO tours (tour_id, route_id, departure_date, days_count, extra_fees, extra_description)
OVERRIDING SYSTEM VALUE VALUES
(1, 1, '2026-05-10', 5, 1500.00, 'Питание по программе, трансферы.'),
(2, 2, '2026-06-01', 5, 2000.00, 'Включены билеты в Эрмитаж и Петергоф.'),
(3, 3, '2026-07-15', 6, 2500.00, 'Проживание в гостиницах 3–4*.'),
(4, 4, '2026-08-05', 7, 3000.00, 'Пляжный отдых и экскурсии.'),
(5, 5, '2026-09-10', 6, 1800.00, 'Две столицы, экскурсионная программа.'),
(6, 1, '2026-10-01', 5, 1200.00, 'Осенний тур по Золотому кольцу.');

-- Добавить экскурсии в турах
INSERT INTO tour_excursion (tour_id, excursion_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(2, 10),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 11),
(5, 3),
(5, 4),
(5, 10),
(6, 1),
(6, 2);

-- Синхронизируем последовательности, чтобы ничего не упало
SELECT setval(pg_get_serial_sequence('cities', 'city_id'),
              COALESCE((SELECT MAX(city_id) FROM cities), 1), true);
SELECT setval(pg_get_serial_sequence('routes', 'route_id'),
              COALESCE((SELECT MAX(route_id) FROM routes), 1), true);
SELECT setval(pg_get_serial_sequence('excursions', 'excursion_id'),
              COALESCE((SELECT MAX(excursion_id) FROM excursions), 1), true);
SELECT setval(pg_get_serial_sequence('tours', 'tour_id'),
              COALESCE((SELECT MAX(tour_id) FROM tours), 1), true);

-- Задание 1
WITH rate AS (
    SELECT 81.48::numeric AS usd_rate
)
SELECT
    e.*,
    CEIL(e.price / r.usd_rate)::integer AS price_usd
FROM excursions e
CROSS JOIN rate r
ORDER BY e.excursion_id;

-- Задание 2
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

COMMIT;