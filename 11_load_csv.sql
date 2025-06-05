-- =====================================================
-- SCRIPT: 11_load_csv.sql
-- PROPOSITO: Script para cargar datos CSV usando SQL*Loader
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================

PROMPT ===============================================
PROMPT CARGA DE DATOS CSV
PROMPT ===============================================

-- Limpiar tabla temporal antes de cargar
TRUNCATE TABLE TMP_CRAIGSLIST_VEHICLES;

PROMPT 
PROMPT Ejecutando SQL*Loader...
PROMPT Comando sugerido:
PROMPT 
PROMPT sqlldr CARS_USER/A123@XE control=11_load_csv.ctl log=load_csv.log bad=load_csv.bad
PROMPT 
PROMPT Después de ejecutar SQL*Loader, continúe con este script...
PROMPT 
PAUSE Presione ENTER después de ejecutar SQL*Loader...

-- Verificar los datos cargados
PROMPT 
PROMPT === VERIFICACIÓN DE DATOS CARGADOS ===
SELECT COUNT(*) AS "Total registros cargados" FROM TMP_CRAIGSLIST_VEHICLES;

PROMPT 
PROMPT === MUESTRA DE DATOS ===
SELECT * FROM TMP_CRAIGSLIST_VEHICLES WHERE ROWNUM <= 5;

PROMPT 
PROMPT === ESTADÍSTICAS DE CAMPOS NULOS ===
SELECT 
   'REGION' AS campo, COUNT(*) - COUNT(REGION) AS nulos FROM TMP_CRAIGSLIST_VEHICLES
UNION ALL
SELECT 'MANUFACTURER', COUNT(*) - COUNT(MANUFACTURER) FROM TMP_CRAIGSLIST_VEHICLES
UNION ALL
SELECT 'PRICE', COUNT(*) - COUNT(PRICE) FROM TMP_CRAIGSLIST_VEHICLES
UNION ALL
SELECT 'YEAR_DATA', COUNT(*) - COUNT(YEAR_DATA) FROM TMP_CRAIGSLIST_VEHICLES
UNION ALL
SELECT 'MODEL', COUNT(*) - COUNT(MODEL) FROM TMP_CRAIGSLIST_VEHICLES;

PROMPT 
PROMPT Los datos están listos para procesar con: @@07_data_load.sql
