/*
ФИО студента: Евсеев Александр Юрьевич
Вариант: 17
Задание:
Описание предметной области
Описание экскурсионных туров. Включает в себя: маршруты, экскурсии, туры. 
Маршрут характеризуется названием, городом отправления, описанием маршрута, 
базовой ценой (без экскурсий) в рублях, 
указанием списка всех возможных для посещения городов и количеством дней пребывания в них. 
Экскурсия характеризуется: указанием города (в каждом городе может быть несколько экскурсий), 
названием, описанием и ценой в рублях. 
Тур характеризуется: указанием маршрута, датой отъезда, количеством дней тура, 
дополнительными взносами, дополнительным описанием.

Одна и та же экскурсия не может быть связана с несколькими городами.
*/



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
  -- Важно: city_id один, поэтому экскурсия не может быть связана сразу с несколькими городами.
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
  
  COMMIT;