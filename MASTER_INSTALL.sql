-- =====================================================
-- SCRIPT: MASTER_INSTALL.sql
-- PROPOSITO: Script maestro para ejecutar todo el proyecto
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================

PROMPT ===============================================
PROMPT SISTEMA DE GESTIÓN DE VEHÍCULOS - INSTALACIÓN
PROMPT ===============================================
PROMPT Fecha: 
SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') AS FECHA_INSTALACION FROM DUAL;
PROMPT 

SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

PROMPT 
PROMPT === PASO 1: Creando tablespaces y usuario ===
@@01_tablespaces_user.sql

PROMPT 
PROMPT === PASO 2: Creando secuencias ===
@@02_sequences.sql

PROMPT 
PROMPT === PASO 3: Creando tablas ===
@@03_tables.sql

PROMPT 
PROMPT === PASO 4: Creando restricciones ===
@@04_constraints.sql

PROMPT 
PROMPT === PASO 5: Creando índices ===
@@05_indexes.sql

PROMPT 
PROMPT === PASO 6: Creando procedimientos almacenados ===
@@06_procedures.sql

PROMPT 
PROMPT === PASO 7: Creando vistas ===
@@08_views.sql

PROMPT 
PROMPT ===============================================
PROMPT INSTALACIÓN COMPLETADA EXITOSAMENTE
PROMPT ===============================================
PROMPT 
PROMPT === OPCIONES PARA CARGAR DATOS ===
PROMPT 
PROMPT Opción 1 - SQL*Loader (recomendado):
PROMPT   1. Ejecutar: sqlldr CARS_USER/A123@XE control=11_load_csv.ctl
PROMPT   2. Ejecutar: @@07_data_load.sql
PROMPT 
PROMPT Opción 2 - PowerShell automatizado:
PROMPT   1. Ejecutar: .\Load-CSV-Data.ps1
PROMPT   2. Ejecutar: @@07_data_load.sql
PROMPT 
PROMPT Opción 3 - Datos de prueba directos:
PROMPT   1. Ejecutar: @@11_load_csv_direct.sql
PROMPT   2. Ejecutar: @@07_data_load.sql
PROMPT 
PROMPT === OTROS SCRIPTS ÚTILES ===
PROMPT 
PROMPT Para probar el sistema: @@12_full_test.sql
PROMPT Para consultas de ejemplo: @@09_sample_queries.sql
PROMPT Para limpiar datos: @@10_cleanup.sql
PROMPT 
PROMPT ===============================================

SET ECHO OFF
SET FEEDBACK OFF
SET TIMING OFF
