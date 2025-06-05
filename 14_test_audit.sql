-- ====================================================
-- SCRIPT: 14_test_audit.sql
-- DESCRIPCIÓN: Pruebas del sistema de auditoría
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: 05/06/2025
-- ====================================================

SET SERVEROUTPUT ON
SET ECHO ON
SET FEEDBACK ON

PROMPT ===============================================
PROMPT PRUEBAS DEL SISTEMA DE AUDITORÍA
PROMPT ===============================================

-- =====================================================
-- PASO 1: VERIFICAR ESTADO INICIAL
-- =====================================================

PROMPT 
PROMPT === Verificando tablas del sistema de auditoría ===

SELECT 'AUDIT_CONTROL' AS TABLA, COUNT(*) AS REGISTROS_INICIALES 
FROM AUDIT_CONTROL
UNION ALL
SELECT 'VEHICLES' AS TABLA, COUNT(*) AS REGISTROS 
FROM VEHICLES
UNION ALL
SELECT 'MANUFACTURERS' AS TABLA, COUNT(*) AS REGISTROS 
FROM MANUFACTURERS
UNION ALL
SELECT 'REGIONS' AS TABLA, COUNT(*) AS REGISTROS 
FROM REGIONS;

-- =====================================================
-- PASO 2: PRUEBAS DE INSERCIÓN
-- =====================================================

PROMPT 
PROMPT === PRUEBA 1: Insertando nuevo fabricante ===

INSERT INTO MANUFACTURERS (MANUFACTURER_ID, MANUFACTURER_NAME, COUNTRY, FOUNDED_YEAR, STATUS)
VALUES (SEQ_MANUFACTURERS.NEXTVAL, 'TESLA AUDIT TEST', 'USA', 2003, 'A');

PROMPT 
PROMPT === PRUEBA 2: Insertando nueva región ===

INSERT INTO REGIONS (REGION_ID, REGION_NAME, COUNTRY, STATUS)
VALUES (SEQ_REGIONS.NEXTVAL, 'CALIFORNIA TEST', 'USA', 'A');

-- =====================================================
-- PASO 3: PRUEBAS DE ACTUALIZACIÓN
-- =====================================================

PROMPT 
PROMPT === PRUEBA 3: Actualizando fabricante ===

UPDATE MANUFACTURERS 
SET MANUFACTURER_NAME = 'TESLA UPDATED TEST'
WHERE MANUFACTURER_NAME = 'TESLA AUDIT TEST';

PROMPT 
PROMPT === PRUEBA 4: Actualizando región ===

UPDATE REGIONS 
SET REGION_NAME = 'CALIFORNIA UPDATED TEST'
WHERE REGION_NAME = 'CALIFORNIA TEST';

-- =====================================================
-- PASO 4: VERIFICAR REGISTROS DE AUDITORÍA
-- =====================================================

PROMPT 
PROMPT === Verificando registros de auditoría generados ===

SELECT 
    TABLE_NAME,
    OPERATION_TYPE,
    AFFECTED_ROWS,
    TO_CHAR(PROCESS_DATE, 'DD/MM/YYYY HH24:MI:SS') AS FECHA_PROCESO,
    USER_NAME,
    ADDITIONAL_INFO
FROM AUDIT_CONTROL 
WHERE PROCESS_DATE >= SYSDATE - 1/24/60  -- Últimos minutos
ORDER BY PROCESS_DATE DESC;

-- =====================================================
-- PASO 5: PRUEBAS DE VISTAS DE AUDITORÍA
-- =====================================================

PROMPT 
PROMPT === PRUEBA 5: Vista de resumen de auditoría ===

SELECT * FROM VW_AUDIT_SUMMARY;

PROMPT 
PROMPT === PRUEBA 6: Actividad reciente ===

SELECT * FROM VW_AUDIT_RECENT WHERE ROWNUM <= 10;

PROMPT 
PROMPT === PRUEBA 7: Auditoría por usuario ===

SELECT * FROM VW_AUDIT_BY_USER;

-- =====================================================
-- PASO 6: PRUEBAS DE ELIMINACIÓN
-- =====================================================

PROMPT 
PROMPT === PRUEBA 8: Eliminando registros de prueba ===

DELETE FROM MANUFACTURERS WHERE MANUFACTURER_NAME = 'TESLA UPDATED TEST';
DELETE FROM REGIONS WHERE REGION_NAME = 'CALIFORNIA UPDATED TEST';

-- =====================================================
-- PASO 7: VERIFICACIÓN FINAL
-- =====================================================

PROMPT 
PROMPT === Verificación final de auditoría ===

SELECT 
    TABLE_NAME,
    OPERATION_TYPE,
    COUNT(*) AS TOTAL_OPERACIONES
FROM AUDIT_CONTROL 
WHERE PROCESS_DATE >= SYSDATE - 1/24/60  -- Últimos minutos
GROUP BY TABLE_NAME, OPERATION_TYPE
ORDER BY TABLE_NAME, OPERATION_TYPE;

PROMPT 
PROMPT === Conteo total de registros de auditoría ===

SELECT COUNT(*) AS TOTAL_AUDIT_RECORDS FROM AUDIT_CONTROL;

PROMPT 
PROMPT ===============================================
PROMPT PRUEBAS DEL SISTEMA DE AUDITORÍA COMPLETADAS
PROMPT ===============================================
