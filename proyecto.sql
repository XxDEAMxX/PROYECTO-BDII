CREATE TABLESPACE ts_datos
  DATAFILE 'ts_datos01.dbf' SIZE 300M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

-- Tablespace para índices
CREATE TABLESPACE ts_indices
  DATAFILE 'ts_indices01.dbf' SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;


-- Crear usuario (ajusta el nombre y contraseña según tu grupo)
CREATE USER cars_user IDENTIFIED BY a123
  DEFAULT TABLESPACE ts_datos
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON ts_datos
  QUOTA UNLIMITED ON ts_indices;

-- Permisos mínimos necesarios
GRANT CREATE SESSION TO cars_user;
GRANT CREATE TABLE TO cars_user;
GRANT CREATE VIEW TO cars_user;
GRANT CREATE PROCEDURE TO cars_user;
GRANT CREATE TRIGGER TO cars_user;
GRANT CREATE SEQUENCE TO cars_user;
GRANT CREATE SYNONYM TO cars_user;

CREATE TABLE tmp_craigslist_vehicles (
  id NUMBER,
  url VARCHAR2(1000),
  region VARCHAR2(100),
  region_url VARCHAR2(100),
  price NUMBER,
  year_data NUMBER,
  manufacturer VARCHAR2(100),
  model VARCHAR2(300),
  condition VARCHAR2(50),
  cylinders VARCHAR2(50),
  fuel VARCHAR2(50),
  odometer NUMBER,
  title_status VARCHAR2(50),
  transmission VARCHAR2(50),    
  VIN VARCHAR2(50),
  drive VARCHAR2(50),
  size_data VARCHAR2(50),
  type_data VARCHAR2(50),
  paint_color VARCHAR2(50),
  image_url VARCHAR2(1000),
  description_data CLOB,
  country VARCHAR2(100),
  state_data VARCHAR2(50),
  lat NUMBER,
  longitude NUMBER,
  posting_date VARCHAR2(100)
) TABLESPACE ts_datos;

-------

-- Tabla principal de vehículos
CREATE TABLE vehicles (
  id NUMBER,
  url VARCHAR2(1000),
  region_id NUMBER,
  price NUMBER,
  year NUMBER,
  manufacturer_id NUMBER,
  model VARCHAR2(300),
  condition_id NUMBER,
  cylinders_id NUMBER,
  fuel_id NUMBER,
  odometer NUMBER,
  title_status_id NUMBER,
  transmission_id NUMBER,
  vin VARCHAR2(50),
  drive_id NUMBER,
  size_id NUMBER,
  type_id NUMBER,
  paint_color_id NUMBER,
  image_url VARCHAR2(1000),
  description_data CLOB,
  posting_date DATE
);

-- Tabla de regiones
CREATE TABLE regions (
  id NUMBER,
  region VARCHAR2(100),
  region_url VARCHAR2(100),
  country VARCHAR2(100),
  state_data VARCHAR2(50),
  lat NUMBER,
  longitude NUMBER
);

-- Tabla de fabricantes
CREATE TABLE manufacturers (
  id NUMBER,
  name VARCHAR2(100)
);

-- Tablas para atributos categóricos
CREATE TABLE conditions (
  id NUMBER,
  name VARCHAR2(50)
);

CREATE TABLE cylinders (
  id NUMBER,
  name VARCHAR2(50)
);

CREATE TABLE fuels (
  id NUMBER,
  name VARCHAR2(50)
);

CREATE TABLE title_statuses (
  id NUMBER,
  name VARCHAR2(50)
);

CREATE TABLE transmissions (
  id NUMBER,
  name VARCHAR2(50)
);

CREATE TABLE drives (
  id NUMBER,
  name VARCHAR2(50)
);

CREATE TABLE sizes (
  id NUMBER,
  name VARCHAR2(50)
);

CREATE TABLE types (
  id NUMBER,
  name VARCHAR2(50)
);

CREATE TABLE paint_colors (
  id NUMBER,
  name VARCHAR2(50)
);


-- PRIMARY KEYS
ALTER TABLE vehicles ADD CONSTRAINT pk_vehicles PRIMARY KEY (id);
ALTER TABLE regions ADD CONSTRAINT pk_regions PRIMARY KEY (id);
ALTER TABLE manufacturers ADD CONSTRAINT pk_manufacturers PRIMARY KEY (id);
ALTER TABLE conditions ADD CONSTRAINT pk_conditions PRIMARY KEY (id);
ALTER TABLE cylinders ADD CONSTRAINT pk_cylinders PRIMARY KEY (id);
ALTER TABLE fuels ADD CONSTRAINT pk_fuels PRIMARY KEY (id);
ALTER TABLE title_statuses ADD CONSTRAINT pk_title_statuses PRIMARY KEY (id);
ALTER TABLE transmissions ADD CONSTRAINT pk_transmissions PRIMARY KEY (id);
ALTER TABLE drives ADD CONSTRAINT pk_drives PRIMARY KEY (id);
ALTER TABLE sizes ADD CONSTRAINT pk_sizes PRIMARY KEY (id);
ALTER TABLE types ADD CONSTRAINT pk_types PRIMARY KEY (id);
ALTER TABLE paint_colors ADD CONSTRAINT pk_paint_colors PRIMARY KEY (id);

-- FOREIGN KEYS
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_region FOREIGN KEY (region_id) REFERENCES regions(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_condition FOREIGN KEY (condition_id) REFERENCES conditions(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_cylinders FOREIGN KEY (cylinders_id) REFERENCES cylinders(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_fuel FOREIGN KEY (fuel_id) REFERENCES fuels(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_title FOREIGN KEY (title_status_id) REFERENCES title_statuses(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_transmission FOREIGN KEY (transmission_id) REFERENCES transmissions(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_drive FOREIGN KEY (drive_id) REFERENCES drives(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_size FOREIGN KEY (size_id) REFERENCES sizes(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_type FOREIGN KEY (type_id) REFERENCES types(id);
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicle_color FOREIGN KEY (paint_color_id) REFERENCES paint_colors(id);

-- UNIQUE CONSTRAINTS (Ejemplo: evitar nombres repetidos en atributos categóricos)
ALTER TABLE manufacturers ADD CONSTRAINT uq_manufacturer_name UNIQUE (name);
ALTER TABLE conditions ADD CONSTRAINT uq_condition_name UNIQUE (name);
ALTER TABLE cylinders ADD CONSTRAINT uq_cylinders_name UNIQUE (name);
ALTER TABLE fuels ADD CONSTRAINT uq_fuel_name UNIQUE (name);
ALTER TABLE title_statuses ADD CONSTRAINT uq_title_status_name UNIQUE (name);
ALTER TABLE transmissions ADD CONSTRAINT uq_transmission_name UNIQUE (name);
ALTER TABLE drives ADD CONSTRAINT uq_drive_name UNIQUE (name);
ALTER TABLE sizes ADD CONSTRAINT uq_size_name UNIQUE (name);
ALTER TABLE types ADD CONSTRAINT uq_type_name UNIQUE (name);
ALTER TABLE paint_colors ADD CONSTRAINT uq_paint_color_name UNIQUE (name);

-- CHECK CONSTRAINTS (Ejemplo: año válido y odómetro positivo)
-- ALTER TABLE vehicles ADD CONSTRAINT chk_year_valid CHECK (year BETWEEN 1900 AND EXTRACT(YEAR FROM SYSDATE));
ALTER TABLE vehicles ADD CONSTRAINT chk_odometer_positive CHECK (odometer >= 0);


DECLARE
  v_region_id         NUMBER;
  v_manufacturer_id   NUMBER;
  v_condition_id      NUMBER;
  v_cylinders_id      NUMBER;
  v_fuel_id           NUMBER;
  v_title_status_id   NUMBER;
  v_transmission_id   NUMBER;
  v_drive_id          NUMBER;
  v_size_id           NUMBER;
  v_type_id           NUMBER;
  v_paint_color_id    NUMBER;
BEGIN
  FOR rec IN (
    SELECT * FROM tmp_craigslist_vehicles
  ) LOOP
    -- Región
    BEGIN
      SELECT id INTO v_region_id FROM regions
      WHERE region = rec.region AND region_url = rec.region_url
        AND country = rec.country AND state_data = rec.state_data
        AND lat = rec.lat AND longitude = rec.longitude;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_region_id FROM regions;
        INSERT INTO regions(id, region, region_url, country, state_data, lat, longitude)
        VALUES (v_region_id, rec.region, rec.region_url, rec.country, rec.state_data, rec.lat, rec.longitude);
    END;

    -- Manufacturer
    BEGIN
      SELECT id INTO v_manufacturer_id FROM manufacturers WHERE name = rec.manufacturer;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_manufacturer_id FROM manufacturers;
        INSERT INTO manufacturers(id, name) VALUES (v_manufacturer_id, rec.manufacturer);
    END;

    -- Condition
    BEGIN
      SELECT id INTO v_condition_id FROM conditions WHERE name = rec.condition;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_condition_id FROM conditions;
        INSERT INTO conditions(id, name) VALUES (v_condition_id, rec.condition);
    END;

    -- Cylinders
    BEGIN
      SELECT id INTO v_cylinders_id FROM cylinders WHERE name = rec.cylinders;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_cylinders_id FROM cylinders;
        INSERT INTO cylinders(id, name) VALUES (v_cylinders_id, rec.cylinders);
    END;

    -- Fuel
    BEGIN
      SELECT id INTO v_fuel_id FROM fuels WHERE name = rec.fuel;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_fuel_id FROM fuels;
        INSERT INTO fuels(id, name) VALUES (v_fuel_id, rec.fuel);
    END;

    -- Title status
    BEGIN
      SELECT id INTO v_title_status_id FROM title_statuses WHERE name = rec.title_status;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_title_status_id FROM title_statuses;
        INSERT INTO title_statuses(id, name) VALUES (v_title_status_id, rec.title_status);
    END;

    -- Transmission
    BEGIN
      SELECT id INTO v_transmission_id FROM transmissions WHERE name = rec.transmission;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_transmission_id FROM transmissions;
        INSERT INTO transmissions(id, name) VALUES (v_transmission_id, rec.transmission);
    END;

    -- Drive
    BEGIN
      SELECT id INTO v_drive_id FROM drives WHERE name = rec.drive;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_drive_id FROM drives;
        INSERT INTO drives(id, name) VALUES (v_drive_id, rec.drive);
    END;

    -- Size
    BEGIN
      SELECT id INTO v_size_id FROM sizes WHERE name = rec.size_data;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_size_id FROM sizes;
        INSERT INTO sizes(id, name) VALUES (v_size_id, rec.size_data);
    END;

    -- Type
    BEGIN
      SELECT id INTO v_type_id FROM types WHERE name = rec.type_data;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_type_id FROM types;
        INSERT INTO types(id, name) VALUES (v_type_id, rec.type_data);
    END;

    -- Paint color
    BEGIN
      SELECT id INTO v_paint_color_id FROM paint_colors WHERE name = rec.paint_color;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT NVL(MAX(id), 0) + 1 INTO v_paint_color_id FROM paint_colors;
        INSERT INTO paint_colors(id, name) VALUES (v_paint_color_id, rec.paint_color);
    END;

    -- Verificar duplicado en vehicles
    BEGIN
      IF rec.odometer IS NOT NULL AND rec.odometer >= 0 THEN
        INSERT INTO vehicles (
          id, url, region_id, price, year, manufacturer_id, model,
          condition_id, cylinders_id, fuel_id, odometer,
          title_status_id, transmission_id, vin, drive_id,
          size_id, type_id, paint_color_id, image_url,
          description_data, posting_date
        ) VALUES (
          rec.id, rec.url, v_region_id, rec.price, rec.year_data, v_manufacturer_id, rec.model,
          v_condition_id, v_cylinders_id, v_fuel_id, rec.odometer,
          v_title_status_id, v_transmission_id, rec.vin, v_drive_id,
          v_size_id, v_type_id, v_paint_color_id, rec.image_url,
          rec.description_data,
          TO_TIMESTAMP_TZ(rec.posting_date, 'YYYY-MM-DD"T"HH24:MI:SSTZH:TZM')
        );
      END IF;
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- Ya existe ese ID, lo ignoramos
    END;

  END LOOP;
  COMMIT;
END;
/


SELECT * FROM tmp_craigslist_vehicles;
SELECT * FROM vehicles;
SELECT * FROM title_statuses;
SELECT * FROM transmissions;
SELECT * FROM regions;

SELECT * FROM paint_colors;





-- DROP TABLE tmp_craigslist_vehicles PURGE;

-- SELECT COUNT(1) FROM tmp_craigslist_vehicles;

-- SELECT index_name
-- FROM user_indexes
-- WHERE table_name = 'tmp_craigslist_vehicles';

-- SELECT * FROM nls_database_parameters WHERE parameter = 'NLS_CHARACTERSET';



SELECT trigger_name, status
FROM user_triggers
WHERE trigger_name = 'TRG_CHECK_VEHICLE_YEAR';

SHOW ERRORS TRIGGER TRG_CHECK_VEHICLE_YEAR;

ALTER TRIGGER trg_check_vehicle_year DISABLE;