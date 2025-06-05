-- ====================================================
-- SCRIPT: install_step_by_step.sql
-- DESCRIPCIÓN: Instalación paso a paso con verificaciones
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: 05/06/2025
-- ====================================================

PROMPT ===============================================
PROMPT INSTALACIÓN PASO A PASO CON VERIFICACIONES
PROMPT ===============================================

SET SERVEROUTPUT ON SIZE 1000000
SET ECHO ON
SET FEEDBACK ON

-- PASO 1: Cargar datos de prueba primero
PROMPT 
PROMPT === PASO 1: CARGANDO DATOS DE PRUEBA ===
@@11_load_csv_direct.sql

-- Verificar que se cargaron los datos
PROMPT 
PROMPT Verificando datos cargados...
SELECT COUNT(*) AS "Registros en tabla temporal" FROM TMP_CRAIGSLIST_VEHICLES;

-- PASO 2: Ejecutar carga de datos
PROMPT 
PROMPT === PASO 2: EJECUTANDO CARGA DE DATOS ===
@@07_data_load.sql

-- PASO 3: Verificar resultados
PROMPT 
PROMPT === PASO 3: VERIFICANDO RESULTADOS ===

SELECT 'REGIONS' AS TABLA, COUNT(*) AS REGISTROS FROM REGIONS
UNION ALL
SELECT 'MANUFACTURERS', COUNT(*) FROM MANUFACTURERS  
UNION ALL
SELECT 'CONDITIONS', COUNT(*) FROM CONDITIONS
UNION ALL
SELECT 'CYLINDERS', COUNT(*) FROM CYLINDERS
UNION ALL
SELECT 'FUELS', COUNT(*) FROM FUELS
UNION ALL
SELECT 'TITLE_STATUSES', COUNT(*) FROM TITLE_STATUSES
UNION ALL
SELECT 'TRANSMISSIONS', COUNT(*) FROM TRANSMISSIONS
UNION ALL
SELECT 'DRIVES', COUNT(*) FROM DRIVES
UNION ALL
SELECT 'SIZES', COUNT(*) FROM SIZES
UNION ALL
SELECT 'TYPES', COUNT(*) FROM TYPES
UNION ALL
SELECT 'PAINT_COLORS', COUNT(*) FROM PAINT_COLORS
UNION ALL
SELECT 'VEHICLES', COUNT(*) FROM VEHICLES
ORDER BY 1;

-- PASO 4: Probar sistema de auditoría
PROMPT 
PROMPT === PASO 4: PROBANDO SISTEMA DE AUDITORÍA ===
@@14_test_audit.sql

PROMPT 
PROMPT ===============================================
PROMPT INSTALACIÓN COMPLETADA
PROMPT ===============================================
