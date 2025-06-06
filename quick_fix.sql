-- =====================================================
-- SCRIPT: quick_fix.sql
-- PROPOSITO: Diagnóstico y solución para datos NULL
-- AUTOR: Daniel Arevalo - Alex Hernandez  
-- FECHA: Junio 2025
-- =====================================================

SET SERVEROUTPUT ON SIZE 1000000
SET PAGESIZE 50
SET LINESIZE 120

PROMPT ===============================================
PROMPT DIAGNÓSTICO DEL PROBLEMA DE DATOS NULL
PROMPT ===============================================

PROMPT 
PROMPT === 1. ESTADO ACTUAL DE LAS TABLAS ===

-- Contar registros en todas las tablas
SELECT 'TMP_CRAIGSLIST_VEHICLES' AS TABLA, COUNT(*) AS TOTAL FROM TMP_CRAIGSLIST_VEHICLES
UNION ALL
SELECT 'VEHICLES', COUNT(*) FROM VEHICLES
UNION ALL
SELECT 'MANUFACTURERS', COUNT(*) FROM MANUFACTURERS
UNION ALL
SELECT 'FUELS', COUNT(*) FROM FUELS
UNION ALL
SELECT 'REGIONS', COUNT(*) FROM REGIONS
UNION ALL
SELECT 'CONDITIONS', COUNT(*) FROM CONDITIONS
ORDER BY TABLA;

PROMPT 
PROMPT === 2. ANÁLISIS DE DATOS NULL EN TABLA TEMPORAL ===

-- Analizar campos NULL en tabla temporal
SELECT 
    'MANUFACTURER' AS CAMPO, 
    COUNT(*) AS TOTAL_REGISTROS,
    COUNT(MANUFACTURER) AS NO_NULL,
    COUNT(*) - COUNT(MANUFACTURER) AS NULLS,
    ROUND((COUNT(*) - COUNT(MANUFACTURER)) * 100 / COUNT(*), 2) AS PCT_NULL
FROM TMP_CRAIGSLIST_VEHICLES
UNION ALL
SELECT 
    'YEAR_DATA', 
    COUNT(*),
    COUNT(YEAR_DATA),
    COUNT(*) - COUNT(YEAR_DATA),
    ROUND((COUNT(*) - COUNT(YEAR_DATA)) * 100 / COUNT(*), 2)
FROM TMP_CRAIGSLIST_VEHICLES
UNION ALL
SELECT 
    'FUEL', 
    COUNT(*),
    COUNT(FUEL),
    COUNT(*) - COUNT(FUEL),
    ROUND((COUNT(*) - COUNT(FUEL)) * 100 / COUNT(*), 2)
FROM TMP_CRAIGSLIST_VEHICLES
UNION ALL
SELECT 
    'MODEL', 
    COUNT(*),
    COUNT(MODEL),
    COUNT(*) - COUNT(MODEL),
    ROUND((COUNT(*) - COUNT(MODEL)) * 100 / COUNT(*), 2)
FROM TMP_CRAIGSLIST_VEHICLES;

PROMPT 
PROMPT === 3. REGISTROS COMPLETOS VS INCOMPLETOS ===

SELECT 
    CASE 
        WHEN MANUFACTURER IS NOT NULL AND YEAR_DATA IS NOT NULL AND FUEL IS NOT NULL 
        THEN 'COMPLETOS' 
        ELSE 'INCOMPLETOS' 
    END AS TIPO_REGISTRO,
    COUNT(*) AS CANTIDAD
FROM TMP_CRAIGSLIST_VEHICLES
GROUP BY 
    CASE 
        WHEN MANUFACTURER IS NOT NULL AND YEAR_DATA IS NOT NULL AND FUEL IS NOT NULL 
        THEN 'COMPLETOS' 
        ELSE 'INCOMPLETOS' 
    END;

PROMPT 
PROMPT === 4. ANÁLISIS DE TABLA VEHICLES (DESPUÉS DE ETL) ===

-- Ver cuántos vehículos tienen referencias NULL
SELECT 
    'MANUFACTURER_ID' AS CAMPO,
    COUNT(*) AS TOTAL,
    COUNT(MANUFACTURER_ID) AS NO_NULL,
    COUNT(*) - COUNT(MANUFACTURER_ID) AS NULLS
FROM VEHICLES
UNION ALL
SELECT 
    'FUEL_ID',
    COUNT(*),
    COUNT(FUEL_ID),
    COUNT(*) - COUNT(FUEL_ID)
FROM VEHICLES
UNION ALL
SELECT 
    'YEAR',
    COUNT(*),
    COUNT(YEAR),
    COUNT(*) - COUNT(YEAR)
FROM VEHICLES;

PROMPT 
PROMPT === 5. PROBLEMA DE LA VISTA VW_FUEL_PIVOT_BY_YEAR ===

PROMPT Esta vista usa INNER JOIN, por lo que excluye vehículos sin FUEL_ID:

SELECT 
    'Vehículos con FUEL_ID' AS DESCRIPCION,
    COUNT(*) AS CANTIDAD
FROM VEHICLES v
WHERE v.FUEL_ID IS NOT NULL
  AND v.YEAR BETWEEN 2015 AND 2024
UNION ALL
SELECT 
    'Vehículos sin FUEL_ID (excluidos)',
    COUNT(*)
FROM VEHICLES v
WHERE v.FUEL_ID IS NULL
  AND v.YEAR BETWEEN 2015 AND 2024;

PROMPT 
PROMPT === 6. SOLUCIÓN: CARGAR DATOS MEJORADOS ===

BEGIN
    DBMS_OUTPUT.PUT_LINE('Para solucionar el problema:');
    DBMS_OUTPUT.PUT_LINE('1. Ejecute: @@11_load_csv_direct.sql (datos mejorados)');
    DBMS_OUTPUT.PUT_LINE('2. Ejecute: @@07_data_load.sql (proceso ETL completo)');
    DBMS_OUTPUT.PUT_LINE('3. Consulte: SELECT * FROM VW_FUEL_PIVOT_BY_YEAR;');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Esto cargará 25 vehículos con datos completos entre 2015-2024');
END;
/

-- =====================================================
-- FUNCIÓN AUXILIAR PARA LIMPIAR Y RECARGAR
-- =====================================================

PROMPT 
PROMPT === 7. SCRIPT DE LIMPIEZA Y RECARGA AUTOMÁTICA ===

-- Procedure para limpiar y recargar datos
CREATE OR REPLACE PROCEDURE CLEANUP_AND_RELOAD IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== LIMPIEZA Y RECARGA AUTOMÁTICA ===');
    
    -- Limpiar datos existentes
    DBMS_OUTPUT.PUT_LINE('1. Limpiando tablas...');
    DELETE FROM VEHICLES;
    DELETE FROM REGIONS;
    DELETE FROM MANUFACTURERS;
    DELETE FROM CONDITIONS;
    DELETE FROM CYLINDERS;
    DELETE FROM FUELS;
    DELETE FROM TITLE_STATUSES;
    DELETE FROM TRANSMISSIONS;
    DELETE FROM DRIVES;
    DELETE FROM SIZES;
    DELETE FROM TYPES;
    DELETE FROM PAINT_COLORS;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('2. Verificando tabla temporal...');
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM TMP_CRAIGSLIST_VEHICLES;
        DBMS_OUTPUT.PUT_LINE('   Registros en tabla temporal: ' || v_count);
        
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   ERROR: No hay datos en tabla temporal');
            DBMS_OUTPUT.PUT_LINE('   Ejecute: @@11_load_csv_direct.sql primero');
            RETURN;
        END IF;
    END;
    
    DBMS_OUTPUT.PUT_LINE('3. Ejecutando proceso ETL...');
    
    -- Cargar catálogos
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
    
    -- Cargar vehículos
    LOAD_VEHICLES;
    
    DBMS_OUTPUT.PUT_LINE('4. Proceso completado exitosamente');
    
    -- Mostrar estadísticas finales
    FOR rec IN (SELECT 'VEHICLES' AS tabla, COUNT(*) AS total FROM VEHICLES
                UNION ALL
                SELECT 'MANUFACTURERS', COUNT(*) FROM MANUFACTURERS
                UNION ALL
                SELECT 'FUELS', COUNT(*) FROM FUELS
                ORDER BY 1) LOOP
        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(rec.tabla, 15) || ': ' || rec.total || ' registros');
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END CLEANUP_AND_RELOAD;
/

PROMPT 
PROMPT === PROCEDIMIENTO CREADO ===
PROMPT Para ejecutar limpieza y recarga automática: EXEC CLEANUP_AND_RELOAD;

-- =====================================================
-- CONSULTA FINAL PARA VERIFICAR RESULTADOS
-- =====================================================

PROMPT 
PROMPT === 8. CONSULTA DE VERIFICACIÓN FINAL ===

-- Mostrar algunos registros de la vista problemática
PROMPT Primeros registros de VW_FUEL_PIVOT_BY_YEAR:

SELECT * FROM (
    SELECT FUEL_TYPE, "FUEL_2015", "FUEL_2016", "FUEL_2017", "FUEL_2018", "FUEL_2019"
    FROM VW_FUEL_PIVOT_BY_YEAR
    WHERE ROWNUM <= 5
);

-- Mostrar vehículos con datos completos
PROMPT 
PROMPT Vehículos con datos completos para análisis:

SELECT 
    v.ID,
    m.NAME AS MANUFACTURER,
    v.MODEL,
    v.YEAR,
    f.NAME AS FUEL,
    c.NAME AS CONDITION
FROM VEHICLES v
LEFT JOIN MANUFACTURERS m ON v.MANUFACTURER_ID = m.ID
LEFT JOIN FUELS f ON v.FUEL_ID = f.ID  
LEFT JOIN CONDITIONS c ON v.CONDITION_ID = c.ID
WHERE v.YEAR BETWEEN 2015 AND 2024
  AND v.MANUFACTURER_ID IS NOT NULL
  AND v.FUEL_ID IS NOT NULL
  AND ROWNUM <= 10
ORDER BY v.YEAR DESC;

PROMPT ===============================================
PROMPT DIAGNÓSTICO COMPLETADO
PROMPT =============================================== 
