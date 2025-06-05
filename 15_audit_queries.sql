-- ====================================================
-- SCRIPT: 15_audit_queries.sql
-- DESCRIPCIÓN: Consultas útiles para el sistema de auditoría
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: 05/06/2025
-- ====================================================

SET PAGESIZE 50
SET LINESIZE 120
SET ECHO ON

PROMPT ===============================================
PROMPT CONSULTAS DEL SISTEMA DE AUDITORÍA
PROMPT ===============================================

-- =====================================================
-- CONSULTA 1: RESUMEN GENERAL DE ACTIVIDAD
-- =====================================================

PROMPT 
PROMPT === 1. RESUMEN GENERAL DE ACTIVIDAD POR TABLA ===

SELECT 
    TABLE_NAME AS TABLA,
    COUNT(*) AS TOTAL_OPERACIONES,
    COUNT(CASE WHEN OPERATION_TYPE = 'INSERT' THEN 1 END) AS INSERTS,
    COUNT(CASE WHEN OPERATION_TYPE = 'UPDATE' THEN 1 END) AS UPDATES,
    COUNT(CASE WHEN OPERATION_TYPE = 'DELETE' THEN 1 END) AS DELETES,
    MIN(PROCESS_DATE) AS PRIMERA_OPERACION,
    MAX(PROCESS_DATE) AS ULTIMA_OPERACION
FROM AUDIT_CONTROL
GROUP BY TABLE_NAME
ORDER BY TOTAL_OPERACIONES DESC;

-- =====================================================
-- CONSULTA 2: ACTIVIDAD RECIENTE (ÚLTIMAS 24 HORAS)
-- =====================================================

PROMPT 
PROMPT === 2. ACTIVIDAD RECIENTE (ÚLTIMAS 24 HORAS) ===

SELECT 
    TABLE_NAME,
    OPERATION_TYPE,
    AFFECTED_ROWS,
    TO_CHAR(PROCESS_DATE, 'DD/MM/YYYY HH24:MI:SS') AS FECHA_PROCESO,
    USER_NAME,
    SUBSTR(ADDITIONAL_INFO, 1, 50) AS INFO
FROM AUDIT_CONTROL
WHERE PROCESS_DATE >= SYSDATE - 1
ORDER BY PROCESS_DATE DESC;

-- =====================================================
-- CONSULTA 3: ACTIVIDAD POR USUARIO
-- =====================================================

PROMPT 
PROMPT === 3. ESTADÍSTICAS POR USUARIO ===

SELECT 
    USER_NAME AS USUARIO,
    COUNT(*) AS TOTAL_OPERACIONES,
    COUNT(DISTINCT TABLE_NAME) AS TABLAS_AFECTADAS,
    MIN(PROCESS_DATE) AS PRIMERA_ACTIVIDAD,
    MAX(PROCESS_DATE) AS ULTIMA_ACTIVIDAD
FROM AUDIT_CONTROL
GROUP BY USER_NAME
ORDER BY TOTAL_OPERACIONES DESC;

-- =====================================================
-- CONSULTA 4: OPERACIONES MASIVAS (BULK OPERATIONS)
-- =====================================================

PROMPT 
PROMPT === 4. OPERACIONES MASIVAS (MÁS DE 1 REGISTRO) ===

SELECT 
    TABLE_NAME,
    OPERATION_TYPE,
    AFFECTED_ROWS,
    TO_CHAR(PROCESS_DATE, 'DD/MM/YYYY HH24:MI:SS') AS FECHA_PROCESO,
    USER_NAME,
    ADDITIONAL_INFO
FROM AUDIT_CONTROL
WHERE AFFECTED_ROWS > 1
ORDER BY AFFECTED_ROWS DESC, PROCESS_DATE DESC;

-- =====================================================
-- CONSULTA 5: ACTIVIDAD POR PERÍODO
-- =====================================================

PROMPT 
PROMPT === 5. ACTIVIDAD POR HORA DEL DÍA (ÚLTIMOS 7 DÍAS) ===

SELECT 
    EXTRACT(HOUR FROM PROCESS_DATE) AS HORA,
    COUNT(*) AS OPERACIONES
FROM AUDIT_CONTROL
WHERE PROCESS_DATE >= SYSDATE - 7
GROUP BY EXTRACT(HOUR FROM PROCESS_DATE)
ORDER BY HORA;

-- =====================================================
-- CONSULTA 6: ERRORES Y PROBLEMAS POTENCIALES
-- =====================================================

PROMPT 
PROMPT === 6. POSIBLES PROBLEMAS EN AUDITORÍA ===

SELECT 
    'Operaciones sin info adicional' AS TIPO_PROBLEMA,
    COUNT(*) AS CANTIDAD
FROM AUDIT_CONTROL
WHERE ADDITIONAL_INFO IS NULL
UNION ALL
SELECT 
    'Operaciones con 0 filas afectadas' AS TIPO_PROBLEMA,
    COUNT(*) AS CANTIDAD
FROM AUDIT_CONTROL
WHERE AFFECTED_ROWS = 0
UNION ALL
SELECT 
    'Operaciones muy antiguas (>30 días)' AS TIPO_PROBLEMA,
    COUNT(*) AS CANTIDAD
FROM AUDIT_CONTROL
WHERE PROCESS_DATE < SYSDATE - 30;

-- =====================================================
-- CONSULTA 7: TOP 10 DÍAS CON MÁS ACTIVIDAD
-- =====================================================

PROMPT 
PROMPT === 7. TOP 10 DÍAS CON MÁS ACTIVIDAD ===

SELECT * FROM (
    SELECT 
        TO_CHAR(PROCESS_DATE, 'DD/MM/YYYY') AS FECHA,
        COUNT(*) AS OPERACIONES_DIA,
        COUNT(DISTINCT USER_NAME) AS USUARIOS_ACTIVOS,
        COUNT(DISTINCT TABLE_NAME) AS TABLAS_AFECTADAS
    FROM AUDIT_CONTROL
    GROUP BY TO_CHAR(PROCESS_DATE, 'DD/MM/YYYY')
    ORDER BY OPERACIONES_DIA DESC
) WHERE ROWNUM <= 10;

-- =====================================================
-- CONSULTA 8: VERIFICACIÓN DE INTEGRIDAD
-- =====================================================

PROMPT 
PROMPT === 8. VERIFICACIÓN DE INTEGRIDAD DEL SISTEMA ===

SELECT 
    'Total registros en AUDIT_CONTROL' AS METRICA,
    TO_CHAR(COUNT(*)) AS VALOR
FROM AUDIT_CONTROL
UNION ALL
SELECT 
    'Registros con fecha futura' AS METRICA,
    TO_CHAR(COUNT(*)) AS VALOR
FROM AUDIT_CONTROL
WHERE PROCESS_DATE > SYSDATE
UNION ALL
SELECT 
    'Operaciones sin usuario' AS METRICA,
    TO_CHAR(COUNT(*)) AS VALOR
FROM AUDIT_CONTROL
WHERE USER_NAME IS NULL
UNION ALL
SELECT 
    'Tablas únicas auditadas' AS METRICA,
    TO_CHAR(COUNT(DISTINCT TABLE_NAME)) AS VALOR
FROM AUDIT_CONTROL;

-- =====================================================
-- CONSULTA 9: RENDIMIENTO DEL SISTEMA DE AUDITORÍA
-- =====================================================

PROMPT 
PROMPT === 9. ANÁLISIS DE RENDIMIENTO ===

SELECT 
    TO_CHAR(PROCESS_DATE, 'YYYY-MM') AS MES,
    COUNT(*) AS TOTAL_OPERACIONES,
    AVG(AFFECTED_ROWS) AS PROMEDIO_FILAS_AFECTADAS,
    MAX(AFFECTED_ROWS) AS MAX_FILAS_OPERACION
FROM AUDIT_CONTROL
GROUP BY TO_CHAR(PROCESS_DATE, 'YYYY-MM')
ORDER BY MES DESC;

-- =====================================================
-- CONSULTA 10: USANDO LAS VISTAS PREDEFINIDAS
-- =====================================================

PROMPT 
PROMPT === 10. RESUMEN USANDO VISTAS PREDEFINIDAS ===

PROMPT 
PROMPT --- Vista de Resumen General ---
SELECT * FROM VW_AUDIT_SUMMARY;

PROMPT 
PROMPT --- Actividad Reciente (Top 20) ---
SELECT * FROM VW_AUDIT_RECENT WHERE ROWNUM <= 20;

PROMPT 
PROMPT --- Resumen por Usuario ---
SELECT * FROM VW_AUDIT_BY_USER;

PROMPT 
PROMPT ===============================================
PROMPT CONSULTAS COMPLETADAS
PROMPT ===============================================
