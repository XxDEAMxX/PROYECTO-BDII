-- ====================================================
-- SCRIPT: quick_fix.sql
-- DESCRIPCIÓN: Script rápido para diagnosticar y corregir errores
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: 05/06/2025
-- ====================================================

SET SERVEROUTPUT ON
SET ECHO ON

PROMPT ===============================================
PROMPT DIAGNÓSTICO RÁPIDO DEL SISTEMA
PROMPT ===============================================

-- Verificar si el usuario existe y está conectado
SELECT USER AS USUARIO_ACTUAL, 
       TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') AS FECHA_ACTUAL
FROM DUAL;

-- Verificar tablespaces
PROMPT 
PROMPT === VERIFICANDO TABLESPACES ===
SELECT tablespace_name, status 
FROM user_tablespaces 
WHERE tablespace_name IN ('TS_DATOS', 'TS_INDICES')
UNION ALL
SELECT 'TS_DATOS (verificando)', 'MISSING' FROM DUAL 
WHERE NOT EXISTS (SELECT 1 FROM user_tablespaces WHERE tablespace_name = 'TS_DATOS')
UNION ALL
SELECT 'TS_INDICES (verificando)', 'MISSING' FROM DUAL 
WHERE NOT EXISTS (SELECT 1 FROM user_tablespaces WHERE tablespace_name = 'TS_INDICES');

-- Verificar secuencias críticas
PROMPT 
PROMPT === VERIFICANDO SECUENCIAS ===
SELECT sequence_name, last_number FROM user_sequences
WHERE sequence_name IN ('SEQ_VEHICLES_ID', 'SEQ_REGIONS_ID', 'SEQ_MANUFACTURERS_ID')
ORDER BY sequence_name;

-- Verificar tablas críticas
PROMPT 
PROMPT === VERIFICANDO TABLAS ===
SELECT table_name, num_rows, status FROM user_tables 
WHERE table_name IN ('TMP_CRAIGSLIST_VEHICLES', 'VEHICLES', 'REGIONS', 'MANUFACTURERS')
ORDER BY table_name;

-- Verificar procedimientos
PROMPT 
PROMPT === VERIFICANDO PROCEDIMIENTOS ===
SELECT object_name, object_type, status FROM user_objects 
WHERE object_type = 'PROCEDURE' 
AND object_name LIKE 'LOAD_%'
ORDER BY object_name;

-- Verificar datos en tabla temporal
PROMPT 
PROMPT === VERIFICANDO DATOS EN TABLA TEMPORAL ===
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM TMP_CRAIGSLIST_VEHICLES;
    DBMS_OUTPUT.PUT_LINE('Registros en TMP_CRAIGSLIST_VEHICLES: ' || v_count);
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('¡PROBLEMA! No hay datos en la tabla temporal');
        DBMS_OUTPUT.PUT_LINE('Solución: Ejecutar @@11_load_csv_direct.sql primero');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✓ Tabla temporal tiene datos');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

PROMPT 
PROMPT === DIAGNÓSTICO COMPLETADO ===
PROMPT Si hay errores arriba, siga las recomendaciones mostradas
PROMPT
