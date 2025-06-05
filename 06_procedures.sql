-- =====================================================
-- SCRIPT: 06_procedures.sql
-- PROPOSITO: Procedimientos almacenados para carga de datos
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================

-- Procedimiento para cargar REGIONS
CREATE OR REPLACE PROCEDURE LOAD_REGIONS AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT REGION, REGION_URL, COUNTRY, STATE_DATA, LAT, LONGITUDE
      FROM TMP_CRAIGSLIST_VEHICLES
      WHERE REGION IS NOT NULL AND TRIM(REGION) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM REGIONS
          WHERE REGION = rec.REGION AND REGION_URL = rec.REGION_URL
            AND COUNTRY = rec.COUNTRY AND STATE_DATA = rec.STATE_DATA
            AND LAT = rec.LAT AND LONGITUDE = rec.LONGITUDE;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO REGIONS (REGION, REGION_URL, COUNTRY, STATE_DATA, LAT, LONGITUDE)
            VALUES (rec.REGION, rec.REGION_URL, rec.COUNTRY, rec.STATE_DATA, rec.LAT, rec.LONGITUDE);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar MANUFACTURERS
CREATE OR REPLACE PROCEDURE LOAD_MANUFACTURERS AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT MANUFACTURER FROM TMP_CRAIGSLIST_VEHICLES
      WHERE MANUFACTURER IS NOT NULL AND TRIM(MANUFACTURER) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM MANUFACTURERS WHERE NAME = rec.MANUFACTURER;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO MANUFACTURERS (NAME) VALUES (rec.MANUFACTURER);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar CONDITIONS
CREATE OR REPLACE PROCEDURE LOAD_CONDITIONS AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT CONDITION FROM TMP_CRAIGSLIST_VEHICLES
      WHERE CONDITION IS NOT NULL AND TRIM(CONDITION) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM CONDITIONS WHERE NAME = rec.CONDITION;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO CONDITIONS (NAME) VALUES (rec.CONDITION);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar CYLINDERS
CREATE OR REPLACE PROCEDURE LOAD_CYLINDERS AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT CYLINDERS FROM TMP_CRAIGSLIST_VEHICLES
      WHERE CYLINDERS IS NOT NULL AND TRIM(CYLINDERS) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM CYLINDERS WHERE NAME = rec.CYLINDERS;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO CYLINDERS (NAME) VALUES (rec.CYLINDERS);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar FUELS
CREATE OR REPLACE PROCEDURE LOAD_FUELS AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT FUEL FROM TMP_CRAIGSLIST_VEHICLES
      WHERE FUEL IS NOT NULL AND TRIM(FUEL) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM FUELS WHERE NAME = rec.FUEL;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO FUELS (NAME) VALUES (rec.FUEL);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar TITLE_STATUSES
CREATE OR REPLACE PROCEDURE LOAD_TITLE_STATUSES AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT TITLE_STATUS FROM TMP_CRAIGSLIST_VEHICLES
      WHERE TITLE_STATUS IS NOT NULL AND TRIM(TITLE_STATUS) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM TITLE_STATUSES WHERE NAME = rec.TITLE_STATUS;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO TITLE_STATUSES (NAME) VALUES (rec.TITLE_STATUS);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar TRANSMISSIONS
CREATE OR REPLACE PROCEDURE LOAD_TRANSMISSIONS AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT TRANSMISSION FROM TMP_CRAIGSLIST_VEHICLES
      WHERE TRANSMISSION IS NOT NULL AND TRIM(TRANSMISSION) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM TRANSMISSIONS WHERE NAME = rec.TRANSMISSION;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO TRANSMISSIONS (NAME) VALUES (rec.TRANSMISSION);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar DRIVES
CREATE OR REPLACE PROCEDURE LOAD_DRIVES AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT DRIVE FROM TMP_CRAIGSLIST_VEHICLES
      WHERE DRIVE IS NOT NULL AND TRIM(DRIVE) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM DRIVES WHERE NAME = rec.DRIVE;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO DRIVES (NAME) VALUES (rec.DRIVE);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar SIZES
CREATE OR REPLACE PROCEDURE LOAD_SIZES AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT SIZE_DATA FROM TMP_CRAIGSLIST_VEHICLES
      WHERE SIZE_DATA IS NOT NULL AND TRIM(SIZE_DATA) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM SIZES WHERE NAME = rec.SIZE_DATA;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO SIZES (NAME) VALUES (rec.SIZE_DATA);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar TYPES
CREATE OR REPLACE PROCEDURE LOAD_TYPES AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT TYPE_DATA FROM TMP_CRAIGSLIST_VEHICLES
      WHERE TYPE_DATA IS NOT NULL AND TRIM(TYPE_DATA) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM TYPES WHERE NAME = rec.TYPE_DATA;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO TYPES (NAME) VALUES (rec.TYPE_DATA);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar PAINT_COLORS
CREATE OR REPLACE PROCEDURE LOAD_PAINT_COLORS AS
   v_id NUMBER;
BEGIN
   FOR rec IN (
      SELECT DISTINCT PAINT_COLOR FROM TMP_CRAIGSLIST_VEHICLES
      WHERE PAINT_COLOR IS NOT NULL AND TRIM(PAINT_COLOR) IS NOT NULL
   ) LOOP
      BEGIN
         SELECT ID INTO v_id FROM PAINT_COLORS WHERE NAME = rec.PAINT_COLOR;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            INSERT INTO PAINT_COLORS (NAME) VALUES (rec.PAINT_COLOR);
      END;
   END LOOP;
   COMMIT;
END;
/

-- Procedimiento para cargar VEHICLES (requiere que las tablas referenciales ya estén cargadas)
CREATE OR REPLACE PROCEDURE LOAD_VEHICLES AS
   v_region_id       NUMBER;
   v_manufacturer_id NUMBER;
   v_condition_id    NUMBER;
   v_cylinders_id    NUMBER;
   v_fuel_id         NUMBER;
   v_title_status_id NUMBER;
   v_transmission_id NUMBER;
   v_drive_id        NUMBER;
   v_size_id         NUMBER;
   v_type_id         NUMBER;
   v_paint_color_id  NUMBER;
   v_count           NUMBER := 0;
   v_errors          NUMBER := 0;
BEGIN
   FOR rec IN (SELECT * FROM TMP_CRAIGSLIST_VEHICLES) LOOP
      -- Obtener IDs referenciales
      BEGIN
         SELECT ID INTO v_region_id FROM REGIONS
            WHERE REGION = rec.REGION AND REGION_URL = rec.REGION_URL
              AND COUNTRY = rec.COUNTRY AND STATE_DATA = rec.STATE_DATA
              AND LAT = rec.LAT AND LONGITUDE = rec.LONGITUDE;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_region_id := NULL; END;

      BEGIN SELECT ID INTO v_manufacturer_id FROM MANUFACTURERS WHERE NAME = rec.MANUFACTURER;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_manufacturer_id := NULL; END;

      BEGIN SELECT ID INTO v_condition_id FROM CONDITIONS WHERE NAME = rec.CONDITION;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_condition_id := NULL; END;

      BEGIN SELECT ID INTO v_cylinders_id FROM CYLINDERS WHERE NAME = rec.CYLINDERS;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_cylinders_id := NULL; END;

      BEGIN SELECT ID INTO v_fuel_id FROM FUELS WHERE NAME = rec.FUEL;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_fuel_id := NULL; END;

      BEGIN SELECT ID INTO v_title_status_id FROM TITLE_STATUSES WHERE NAME = rec.TITLE_STATUS;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_title_status_id := NULL; END;

      BEGIN SELECT ID INTO v_transmission_id FROM TRANSMISSIONS WHERE NAME = rec.TRANSMISSION;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_transmission_id := NULL; END;

      BEGIN SELECT ID INTO v_drive_id FROM DRIVES WHERE NAME = rec.DRIVE;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_drive_id := NULL; END;

      BEGIN SELECT ID INTO v_size_id FROM SIZES WHERE NAME = rec.SIZE_DATA;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_size_id := NULL; END;

      BEGIN SELECT ID INTO v_type_id FROM TYPES WHERE NAME = rec.TYPE_DATA;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_type_id := NULL; END;

      BEGIN SELECT ID INTO v_paint_color_id FROM PAINT_COLORS WHERE NAME = rec.PAINT_COLOR;
      EXCEPTION WHEN NO_DATA_FOUND THEN v_paint_color_id := NULL; END;

      -- Insertar vehículo
      BEGIN
         INSERT INTO VEHICLES (
            URL, REGION_ID, PRICE, YEAR, MANUFACTURER_ID, MODEL,
            CONDITION_ID, CYLINDERS_ID, FUEL_ID, ODOMETER,
            TITLE_STATUS_ID, TRANSMISSION_ID, VIN, DRIVE_ID,
            SIZE_ID, TYPE_ID, PAINT_COLOR_ID, IMAGE_URL,
            DESCRIPTION_DATA, POSTING_DATE
         )
         VALUES (
            rec.URL, v_region_id, rec.PRICE, rec.YEAR_DATA, v_manufacturer_id, rec.MODEL,
            v_condition_id, v_cylinders_id, v_fuel_id, rec.ODOMETER,
            v_title_status_id, v_transmission_id, rec.VIN, v_drive_id,
            v_size_id, v_type_id, v_paint_color_id, rec.IMAGE_URL,
            rec.DESCRIPTION_DATA, 
            CASE WHEN rec.POSTING_DATE IS NOT NULL 
                 THEN TO_DATE(rec.POSTING_DATE, 'YYYY-MM-DD') 
                 ELSE NULL END
         );
         v_count := v_count + 1;
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN NULL;
         WHEN OTHERS THEN 
            v_errors := v_errors + 1;
      END;
      
      -- Commit cada 1000 registros para mejor performance
      IF MOD(v_count, 1000) = 0 THEN
         COMMIT;
      END IF;
   END LOOP;
   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Vehículos procesados: ' || v_count);
   DBMS_OUTPUT.PUT_LINE('Errores encontrados: ' || v_errors);
END;
/

-- =====================================================
-- FUNCIÓN DE VALIDACIÓN DE FECHAS LABORALES
-- =====================================================

-- Función para validar fechas de carga según requisitos del PDF
CREATE OR REPLACE FUNCTION VALIDATE_LOAD_DATE(
    p_date IN DATE
) RETURN BOOLEAN IS
    v_day_name VARCHAR2(10);
    v_hour NUMBER;
    v_days_diff NUMBER;
BEGIN
    -- Verificar que la fecha no sea nula
    IF p_date IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: La fecha de carga no puede ser nula');
    END IF;
    
    -- Obtener día de la semana
    v_day_name := TO_CHAR(p_date, 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH');
    v_day_name := TRIM(v_day_name);
    
    -- Verificar día hábil (lunes a viernes)
    IF v_day_name IN ('SATURDAY', 'SUNDAY') THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: La fecha debe corresponder a un día hábil (lunes a viernes)');
    END IF;
    
    -- Obtener hora
    v_hour := TO_NUMBER(TO_CHAR(p_date, 'HH24'));
    
    -- Verificar horario laboral (8 AM a 6 PM)
    IF v_hour < 8 OR v_hour > 18 THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: La hora debe estar dentro del horario laboral (8:00 - 18:00)');
    END IF;
    
    -- Verificar que no sea fecha pasada
    IF TRUNC(p_date) < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20004, 'ERROR: No se permiten fechas en el pasado');
    END IF;
    
    -- Verificar que no sea más de 3 días en el futuro
    v_days_diff := TRUNC(p_date) - TRUNC(SYSDATE);
    IF v_days_diff > 3 THEN
        RAISE_APPLICATION_ERROR(-20005, 'ERROR: No se permiten fechas con más de 3 días de anticipación');
    END IF;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END VALIDATE_LOAD_DATE;
/

-- =====================================================
-- PAQUETE PARA ORGANIZAR LÓGICA DE NEGOCIO
-- =====================================================

-- Especificación del paquete
CREATE OR REPLACE PACKAGE PKG_VEHICLES_MANAGEMENT AS
    -- Procedimientos de carga principales
    PROCEDURE EXECUTE_FULL_LOAD(p_load_date IN DATE);
    PROCEDURE EXECUTE_CLEANUP;
    
    -- Función de validación
    FUNCTION IS_VALID_LOAD_DATE(p_date IN DATE) RETURN BOOLEAN;
END PKG_VEHICLES_MANAGEMENT;
/

-- Cuerpo del paquete
CREATE OR REPLACE PACKAGE BODY PKG_VEHICLES_MANAGEMENT AS
    
    -- Implementación de validación de fecha
    FUNCTION IS_VALID_LOAD_DATE(p_date IN DATE) RETURN BOOLEAN IS
    BEGIN
        RETURN VALIDATE_LOAD_DATE(p_date);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END IS_VALID_LOAD_DATE;
    
    -- Procedimiento principal de carga con validación de fecha
    PROCEDURE EXECUTE_FULL_LOAD(p_load_date IN DATE) IS
    BEGIN
        -- Validar fecha antes de proceder
        IF NOT VALIDATE_LOAD_DATE(p_load_date) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Fecha de carga inválida');
        END IF;
        
        -- Registrar inicio del proceso de carga
        SP_REGISTER_AUDIT(
            p_table_name => 'SISTEMA',
            p_operation_type => 'LOAD_START',
            p_affected_rows => 0,
            p_additional_info => 'Inicio de carga completa - Fecha: ' || TO_CHAR(p_load_date, 'DD/MM/YYYY HH24:MI:SS')
        );
        
        DBMS_OUTPUT.PUT_LINE('=== INICIANDO CARGA COMPLETA VIA PAQUETE ===');
        DBMS_OUTPUT.PUT_LINE('Fecha de carga validada: ' || TO_CHAR(p_load_date, 'DD/MM/YYYY HH24:MI:SS'));
        
        -- Ejecutar carga de datos
        LOAD_REGIONS;
        LOAD_MANUFACTURERS;
        LOAD_CONDITIONS;
        LOAD_CYLINDERS;
        LOAD_FUELS;
        LOAD_TITLE_STATUSES;
        LOAD_TRANSMISSIONS;
        LOAD_DRIVES;
        LOAD_SIZES;
        LOAD_TYPES;
        LOAD_PAINT_COLORS;
        LOAD_VEHICLES;
        
        -- Registrar finalización del proceso
        SP_REGISTER_AUDIT(
            p_table_name => 'SISTEMA',
            p_operation_type => 'LOAD_END',
            p_affected_rows => 0,
            p_additional_info => 'Carga completa finalizada exitosamente'
        );
        
        DBMS_OUTPUT.PUT_LINE('=== CARGA COMPLETA FINALIZADA EXITOSAMENTE ===');
        
    EXCEPTION
        WHEN OTHERS THEN
            SP_REGISTER_AUDIT(
                p_table_name => 'SISTEMA',
                p_operation_type => 'LOAD_ERROR',
                p_affected_rows => 0,
                p_additional_info => 'Error en carga: ' || SQLERRM
            );
            RAISE;
    END EXECUTE_FULL_LOAD;
    
    -- Procedimiento de limpieza
    PROCEDURE EXECUTE_CLEANUP IS
    BEGIN
        DELETE FROM VEHICLES;
        DELETE FROM PAINT_COLORS;
        DELETE FROM TYPES;
        DELETE FROM SIZES;
        DELETE FROM DRIVES;
        DELETE FROM TRANSMISSIONS;
        DELETE FROM TITLE_STATUSES;
        DELETE FROM FUELS;
        DELETE FROM CYLINDERS;
        DELETE FROM CONDITIONS;
        DELETE FROM MANUFACTURERS;
        DELETE FROM REGIONS;
        DELETE FROM TMP_CRAIGSLIST_VEHICLES;
        
        COMMIT;
        
        SP_REGISTER_AUDIT(
            p_table_name => 'SISTEMA',
            p_operation_type => 'CLEANUP',
            p_affected_rows => SQL%ROWCOUNT,
            p_additional_info => 'Limpieza completa de todas las tablas'
        );
        
        DBMS_OUTPUT.PUT_LINE('=== LIMPIEZA COMPLETA REALIZADA ===');
    END EXECUTE_CLEANUP;
    
END PKG_VEHICLES_MANAGEMENT;
/
