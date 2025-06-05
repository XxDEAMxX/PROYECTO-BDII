-- =====================================================
-- SCRIPT: 06b_advanced_procedures.sql
-- PROPOSITO: Procedimientos avanzados que usan auditoría
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- NOTA: Ejecutar DESPUÉS de 13_audit_control.sql
-- =====================================================

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

-- =====================================================
-- PROCEDIMIENTO PARA GENERAR REPORTES CON RANGO DE FECHAS
-- =====================================================

CREATE OR REPLACE PROCEDURE SP_GENERATE_VEHICLE_REPORT(
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_report_type IN VARCHAR2 DEFAULT 'BY_MANUFACTURER'
) IS
    v_count NUMBER := 0;
    v_validation_date DATE;
BEGIN
    -- Validar fecha actual para procesamiento
    v_validation_date := SYSDATE;
    IF NOT VALIDATE_LOAD_DATE(v_validation_date) THEN
        RAISE_APPLICATION_ERROR(-20010, 'No se puede procesar reporte fuera del horario laboral');
    END IF;
    
    -- Validar que las fechas sean coherentes
    IF p_start_date > p_end_date THEN
        RAISE_APPLICATION_ERROR(-20011, 'La fecha de inicio debe ser anterior a la fecha fin');
    END IF;
    
    -- Verificar que existan datos en el rango especificado
    SELECT COUNT(*) INTO v_count
    FROM VEHICLES 
    WHERE POSTING_DATE BETWEEN p_start_date AND p_end_date;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'No existen datos en el rango de fechas especificado');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Generando reporte ' || p_report_type || ' para período: ' || 
                         TO_CHAR(p_start_date, 'DD/MM/YYYY') || ' - ' || TO_CHAR(p_end_date, 'DD/MM/YYYY'));
    
    -- Limpiar reportes anteriores del mismo tipo y período
    DELETE FROM VEHICLE_REPORTS 
    WHERE REPORT_TYPE = p_report_type 
    AND PERIOD_START = p_start_date 
    AND PERIOD_END = p_end_date;
    
    -- Generar reporte por fabricante
    IF p_report_type = 'BY_MANUFACTURER' THEN
        INSERT INTO VEHICLE_REPORTS (
            REPORT_TYPE, PERIOD_START, PERIOD_END,
            DIMENSION_KEY, DIMENSION_VALUE, TOTAL_VEHICLES,
            AVG_PRICE, MIN_PRICE, MAX_PRICE, TOTAL_VALUE
        )
        SELECT 
            'BY_MANUFACTURER',
            p_start_date,
            p_end_date,
            'MANUFACTURER',
            m.NAME,
            COUNT(*),
            ROUND(AVG(v.PRICE), 2),
            MIN(v.PRICE),
            MAX(v.PRICE),
            SUM(v.PRICE)
        FROM VEHICLES v
        INNER JOIN MANUFACTURERS m ON v.MANUFACTURER_ID = m.ID
        WHERE v.POSTING_DATE BETWEEN p_start_date AND p_end_date
        AND v.PRICE IS NOT NULL
        GROUP BY m.ID, m.NAME;
        
    -- Generar reporte por región
    ELSIF p_report_type = 'BY_REGION' THEN
        INSERT INTO VEHICLE_REPORTS (
            REPORT_TYPE, PERIOD_START, PERIOD_END,
            DIMENSION_KEY, DIMENSION_VALUE, TOTAL_VEHICLES,
            AVG_PRICE, MIN_PRICE, MAX_PRICE, TOTAL_VALUE
        )
        SELECT 
            'BY_REGION',
            p_start_date,
            p_end_date,
            'REGION',
            r.REGION,
            COUNT(*),
            ROUND(AVG(v.PRICE), 2),
            MIN(v.PRICE),
            MAX(v.PRICE),
            SUM(v.PRICE)
        FROM VEHICLES v
        INNER JOIN REGIONS r ON v.REGION_ID = r.ID
        WHERE v.POSTING_DATE BETWEEN p_start_date AND p_end_date
        AND v.PRICE IS NOT NULL
        GROUP BY r.ID, r.REGION;
        
    -- Generar reporte por año
    ELSIF p_report_type = 'BY_YEAR' THEN
        INSERT INTO VEHICLE_REPORTS (
            REPORT_TYPE, PERIOD_START, PERIOD_END,
            DIMENSION_KEY, DIMENSION_VALUE, TOTAL_VEHICLES,
            AVG_PRICE, MIN_PRICE, MAX_PRICE, TOTAL_VALUE
        )
        SELECT 
            'BY_YEAR',
            p_start_date,
            p_end_date,
            'YEAR',
            TO_CHAR(v.YEAR),
            COUNT(*),
            ROUND(AVG(v.PRICE), 2),
            MIN(v.PRICE),
            MAX(v.PRICE),
            SUM(v.PRICE)
        FROM VEHICLES v
        WHERE v.POSTING_DATE BETWEEN p_start_date AND p_end_date
        AND v.PRICE IS NOT NULL
        AND v.YEAR IS NOT NULL
        GROUP BY v.YEAR
        ORDER BY v.YEAR;
    END IF;
    
    COMMIT;
    
    -- Registrar en auditoría
    SP_REGISTER_AUDIT(
        p_table_name => 'VEHICLE_REPORTS',
        p_operation_type => 'GENERATE',
        p_affected_rows => SQL%ROWCOUNT,
        p_additional_info => 'Reporte ' || p_report_type || ' generado para período ' || 
                             TO_CHAR(p_start_date, 'DD/MM/YYYY') || ' - ' || TO_CHAR(p_end_date, 'DD/MM/YYYY')
    );
    
    -- Mostrar resumen
    SELECT COUNT(*) INTO v_count FROM VEHICLE_REPORTS 
    WHERE REPORT_TYPE = p_report_type 
    AND PERIOD_START = p_start_date 
    AND PERIOD_END = p_end_date;
    
    DBMS_OUTPUT.PUT_LINE('Reporte generado exitosamente con ' || v_count || ' registros');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        SP_REGISTER_AUDIT(
            p_table_name => 'VEHICLE_REPORTS',
            p_operation_type => 'ERROR',
            p_affected_rows => 0,
            p_additional_info => 'Error generando reporte: ' || SQLERRM
        );
        RAISE;
END SP_GENERATE_VEHICLE_REPORT;
/

PROMPT 'Procedimientos avanzados con auditoría creados exitosamente'