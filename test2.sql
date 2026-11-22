-- Тестовый скрипт для проверки заполнения данными таблиц

INSERT INTO cities (name) VALUES ('Москва'), ('Казань');
INSERT INTO routes (name, departure_city_id, base_price)
VALUES ('Тестовый маршрут', 1, 10000);
SELECT * FROM routes;