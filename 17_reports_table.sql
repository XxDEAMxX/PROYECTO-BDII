-- =====================================================
-- SCRIPT: 17_reports_table.sql
-- DESCRIPCIÓN: Tabla de reportes estadísticos con rango de fechas
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================

-- Crear tabla de reportes estadísticos
CREATE TABLE VEHICLE_REPORTS (
    REPORT_ID NUMBER(10) PRIMARY KEY,
    REPORT_TYPE VARCHAR2(50) NOT NULL,
    PERIOD_START DATE NOT NULL,
    PERIOD_END DATE NOT NULL,
    DIMENSION_KEY VARCHAR2(100),
    DIMENSION_VALUE VARCHAR2(200),
    TOTAL_VEHICLES NUMBER(10),
    AVG_PRICE NUMBER(12,2),
    MIN_PRICE NUMBER(12,2),
    MAX_PRICE NUMBER(12,2),
    TOTAL_VALUE NUMBER(15,2),
    GENERATION_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    GENERATED_BY VARCHAR2(50) DEFAULT USER
);

-- Crear secuencia para reportes
CREATE SEQUENCE SEQ_VEHICLE_REPORTS
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Procedimiento para generar reportes con rango de fechas
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
            REPORT_ID, REPORT_TYPE, PERIOD_START, PERIOD_END,
            DIMENSION_KEY, DIMENSION_VALUE, TOTAL_VEHICLES,
            AVG_PRICE, MIN_PRICE, MAX_PRICE, TOTAL_VALUE
        )
        SELECT 
            SEQ_VEHICLE_REPORTS.NEXTVAL,
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
            REPORT_ID, REPORT_TYPE, PERIOD_START, PERIOD_END,
            DIMENSION_KEY, DIMENSION_VALUE, TOTAL_VEHICLES,
            AVG_PRICE, MIN_PRICE, MAX_PRICE, TOTAL_VALUE
        )
        SELECT 
            SEQ_VEHICLE_REPORTS.NEXTVAL,
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
            REPORT_ID, REPORT_TYPE, PERIOD_START, PERIOD_END,
            DIMENSION_KEY, DIMENSION_VALUE, TOTAL_VEHICLES,
            AVG_PRICE, MIN_PRICE, MAX_PRICE, TOTAL_VALUE
        )
        SELECT 
            SEQ_VEHICLE_REPORTS.NEXTVAL,
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

-- Vista para consultar reportes fácilmente
CREATE OR REPLACE VIEW VW_VEHICLE_REPORTS AS
SELECT 
    REPORT_ID,
    REPORT_TYPE AS TIPO_REPORTE,
    TO_CHAR(PERIOD_START, 'DD/MM/YYYY') AS FECHA_INICIO,
    TO_CHAR(PERIOD_END, 'DD/MM/YYYY') AS FECHA_FIN,
    DIMENSION_VALUE AS DIMENSION,
    TOTAL_VEHICLES AS TOTAL_VEHICULOS,
    TO_CHAR(AVG_PRICE, '999,999,999.99') AS PRECIO_PROMEDIO,
    TO_CHAR(MIN_PRICE, '999,999,999.99') AS PRECIO_MINIMO,
    TO_CHAR(MAX_PRICE, '999,999,999.99') AS PRECIO_MAXIMO,
    TO_CHAR(TOTAL_VALUE, '999,999,999,999.99') AS VALOR_TOTAL,
    TO_CHAR(GENERATION_DATE, 'DD/MM/YYYY HH24:MI:SS') AS FECHA_GENERACION,
    GENERATED_BY AS GENERADO_POR
FROM VEHICLE_REPORTS
ORDER BY GENERATION_DATE DESC, REPORT_TYPE, DIMENSION_VALUE;

PROMPT 'Tabla de reportes y procedimiento creados exitosamente' 