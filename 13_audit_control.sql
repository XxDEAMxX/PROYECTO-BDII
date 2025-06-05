-- ====================================================
-- SCRIPT: 13_audit_control_fixed.sql
-- DESCRIPCIÓN: Sistema de control de auditoría automático (CORREGIDO)
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: 05/06/2025
-- ====================================================

-- =====================================================
-- PASO 1: CREAR TABLA DE AUDITORÍA
-- =====================================================

PROMPT '*** CREANDO TABLA DE AUDITORÍA ***'

-- Eliminar tabla si existe (para reinstalación)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE AUDIT_CONTROL';
    DBMS_OUTPUT.PUT_LINE('Tabla AUDIT_CONTROL eliminada');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Tabla AUDIT_CONTROL no existía');
END;
/

-- Crear tabla de auditoría
CREATE TABLE AUDIT_CONTROL (
    AUDIT_ID        NUMBER(10) NOT NULL,
    TABLE_NAME      VARCHAR2(50) NOT NULL,
    OPERATION_TYPE  VARCHAR2(10) NOT NULL,
    AFFECTED_ROWS   NUMBER(10) DEFAULT 1,
    PROCESS_DATE    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    USER_NAME       VARCHAR2(50) DEFAULT USER,
    SESSION_ID      NUMBER(10) DEFAULT SYS_CONTEXT('USERENV', 'SESSIONID'),
    HOST_NAME       VARCHAR2(100) DEFAULT SYS_CONTEXT('USERENV', 'HOST'),
    IP_ADDRESS      VARCHAR2(45) DEFAULT SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
    ADDITIONAL_INFO VARCHAR2(500)
);

-- Crear secuencia para IDs de auditoría
CREATE SEQUENCE SEQ_AUDIT_ID
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Crear constraint de clave primaria
ALTER TABLE AUDIT_CONTROL 
ADD CONSTRAINT PK_AUDIT_CONTROL PRIMARY KEY (AUDIT_ID);

-- Crear constraint para tipo de operación
ALTER TABLE AUDIT_CONTROL 
ADD CONSTRAINT CHK_OPERATION_TYPE 
CHECK (OPERATION_TYPE IN ('INSERT', 'UPDATE', 'DELETE'));

-- Crear índices para mejor performance
CREATE INDEX IDX_AUDIT_TABLE_DATE ON AUDIT_CONTROL (TABLE_NAME, PROCESS_DATE);
CREATE INDEX IDX_AUDIT_USER_DATE ON AUDIT_CONTROL (USER_NAME, PROCESS_DATE);
CREATE INDEX IDX_AUDIT_OPERATION ON AUDIT_CONTROL (OPERATION_TYPE, PROCESS_DATE);

PROMPT 'Tabla AUDIT_CONTROL creada exitosamente'

-- =====================================================
-- PASO 2: PROCEDIMIENTO PARA REGISTRAR AUDITORÍA
-- =====================================================

PROMPT '*** CREANDO PROCEDIMIENTO DE AUDITORÍA ***'

CREATE OR REPLACE PROCEDURE SP_REGISTER_AUDIT (
    p_table_name     IN VARCHAR2,
    p_operation_type IN VARCHAR2,
    p_affected_rows  IN NUMBER DEFAULT 1,
    p_additional_info IN VARCHAR2 DEFAULT NULL
) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO AUDIT_CONTROL (
        AUDIT_ID,
        TABLE_NAME,
        OPERATION_TYPE,
        AFFECTED_ROWS,
        ADDITIONAL_INFO
    ) VALUES (
        SEQ_AUDIT_ID.NEXTVAL,
        UPPER(p_table_name),
        UPPER(p_operation_type),
        p_affected_rows,
        p_additional_info
    );
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        -- No lanzar error para no interrumpir la transacción principal
        NULL;
END SP_REGISTER_AUDIT;
/

PROMPT 'Procedimiento SP_REGISTER_AUDIT creado exitosamente'

-- =====================================================
-- PASO 3: TRIGGERS PARA TABLA VEHICLES
-- =====================================================

PROMPT '*** CREANDO TRIGGERS PARA TABLA VEHICLES ***'

-- Trigger para INSERT en VEHICLES
CREATE OR REPLACE TRIGGER TRG_VEHICLES_INSERT
    AFTER INSERT ON VEHICLES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'VEHICLES',
        p_operation_type => 'INSERT',
        p_additional_info => 'VIN: ' || :NEW.VIN
    );
END;
/

-- Trigger para UPDATE en VEHICLES
CREATE OR REPLACE TRIGGER TRG_VEHICLES_UPDATE
    AFTER UPDATE ON VEHICLES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'VEHICLES',
        p_operation_type => 'UPDATE',
        p_additional_info => 'VIN: ' || :NEW.VIN
    );
END;
/

-- Trigger para DELETE en VEHICLES
CREATE OR REPLACE TRIGGER TRG_VEHICLES_DELETE
    AFTER DELETE ON VEHICLES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'VEHICLES',
        p_operation_type => 'DELETE',
        p_additional_info => 'VIN: ' || :OLD.VIN
    );
END;
/

PROMPT 'Triggers para VEHICLES creados exitosamente'

-- =====================================================
-- PASO 4: TRIGGERS PARA TABLA MANUFACTURERS
-- =====================================================

PROMPT '*** CREANDO TRIGGERS PARA TABLA MANUFACTURERS ***'

-- Trigger para INSERT en MANUFACTURERS
CREATE OR REPLACE TRIGGER TRG_MANUFACTURERS_INSERT
    AFTER INSERT ON MANUFACTURERS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'MANUFACTURERS',
        p_operation_type => 'INSERT',
        p_additional_info => 'Manufacturer: ' || :NEW.NAME
    );
END;
/

-- Trigger para UPDATE en MANUFACTURERS
CREATE OR REPLACE TRIGGER TRG_MANUFACTURERS_UPDATE
    AFTER UPDATE ON MANUFACTURERS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'MANUFACTURERS',
        p_operation_type => 'UPDATE',
        p_additional_info => 'Manufacturer: ' || :NEW.NAME
    );
END;
/

-- Trigger para DELETE en MANUFACTURERS
CREATE OR REPLACE TRIGGER TRG_MANUFACTURERS_DELETE
    AFTER DELETE ON MANUFACTURERS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'MANUFACTURERS',
        p_operation_type => 'DELETE',
        p_additional_info => 'Manufacturer: ' || :OLD.NAME
    );
END;
/

PROMPT 'Triggers para MANUFACTURERS creados exitosamente'

-- =====================================================
-- PASO 5: TRIGGERS PARA TABLA REGIONS
-- =====================================================

PROMPT '*** CREANDO TRIGGERS PARA TABLA REGIONS ***'

-- Trigger para INSERT en REGIONS
CREATE OR REPLACE TRIGGER TRG_REGIONS_INSERT
    AFTER INSERT ON REGIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'REGIONS',
        p_operation_type => 'INSERT',
        p_additional_info => 'Region: ' || :NEW.REGION
    );
END;
/

-- Trigger para UPDATE en REGIONS
CREATE OR REPLACE TRIGGER TRG_REGIONS_UPDATE
    AFTER UPDATE ON REGIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'REGIONS',
        p_operation_type => 'UPDATE',
        p_additional_info => 'Region: ' || :NEW.REGION
    );
END;
/

-- Trigger para DELETE en REGIONS
CREATE OR REPLACE TRIGGER TRG_REGIONS_DELETE
    AFTER DELETE ON REGIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT(
        p_table_name => 'REGIONS',
        p_operation_type => 'DELETE',
        p_additional_info => 'Region: ' || :OLD.REGION
    );
END;
/

PROMPT 'Triggers para REGIONS creados exitosamente'

-- =====================================================
-- PASO 6: TRIGGERS PARA TABLAS DE CATÁLOGOS
-- =====================================================

PROMPT '*** CREANDO TRIGGERS PARA TABLAS DE CATÁLOGOS ***'

-- Triggers para FUELS (no FUEL_TYPES)
CREATE OR REPLACE TRIGGER TRG_FUELS_INSERT
    AFTER INSERT ON FUELS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('FUELS', 'INSERT', 1, 'Fuel Type: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_FUELS_UPDATE
    AFTER UPDATE ON FUELS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('FUELS', 'UPDATE', 1, 'Fuel Type: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_FUELS_DELETE
    AFTER DELETE ON FUELS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('FUELS', 'DELETE', 1, 'Fuel Type: ' || :OLD.NAME);
END;
/

-- Triggers para TRANSMISSIONS
CREATE OR REPLACE TRIGGER TRG_TRANSMISSIONS_INSERT
    AFTER INSERT ON TRANSMISSIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('TRANSMISSIONS', 'INSERT', 1, 'Transmission: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_TRANSMISSIONS_UPDATE
    AFTER UPDATE ON TRANSMISSIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('TRANSMISSIONS', 'UPDATE', 1, 'Transmission: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_TRANSMISSIONS_DELETE
    AFTER DELETE ON TRANSMISSIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('TRANSMISSIONS', 'DELETE', 1, 'Transmission: ' || :OLD.NAME);
END;
/

-- Triggers para DRIVES (no DRIVE_TYPES)
CREATE OR REPLACE TRIGGER TRG_DRIVES_INSERT
    AFTER INSERT ON DRIVES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('DRIVES', 'INSERT', 1, 'Drive Type: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_DRIVES_UPDATE
    AFTER UPDATE ON DRIVES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('DRIVES', 'UPDATE', 1, 'Drive Type: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_DRIVES_DELETE
    AFTER DELETE ON DRIVES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('DRIVES', 'DELETE', 1, 'Drive Type: ' || :OLD.NAME);
END;
/

-- Triggers para TYPES (no VEHICLE_CLASSES)
CREATE OR REPLACE TRIGGER TRG_TYPES_INSERT
    AFTER INSERT ON TYPES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('TYPES', 'INSERT', 1, 'Vehicle Type: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_TYPES_UPDATE
    AFTER UPDATE ON TYPES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('TYPES', 'UPDATE', 1, 'Vehicle Type: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_TYPES_DELETE
    AFTER DELETE ON TYPES
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('TYPES', 'DELETE', 1, 'Vehicle Type: ' || :OLD.NAME);
END;
/

-- Triggers para CONDITIONS
CREATE OR REPLACE TRIGGER TRG_CONDITIONS_INSERT
    AFTER INSERT ON CONDITIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('CONDITIONS', 'INSERT', 1, 'Condition: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_CONDITIONS_UPDATE
    AFTER UPDATE ON CONDITIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('CONDITIONS', 'UPDATE', 1, 'Condition: ' || :NEW.NAME);
END;
/

CREATE OR REPLACE TRIGGER TRG_CONDITIONS_DELETE
    AFTER DELETE ON CONDITIONS
    FOR EACH ROW
BEGIN
    SP_REGISTER_AUDIT('CONDITIONS', 'DELETE', 1, 'Condition: ' || :OLD.NAME);
END;
/

PROMPT 'Triggers para tablas de catálogos creados exitosamente'

-- =====================================================
-- PASO 7: TRIGGER PARA CARGA MASIVA DE DATOS
-- =====================================================

PROMPT '*** CREANDO TRIGGER PARA CARGA MASIVA ***'

-- Trigger especial para procesos de carga masiva
CREATE OR REPLACE TRIGGER TRG_BULK_LOAD_AUDIT
    AFTER INSERT OR UPDATE OR DELETE ON VEHICLES
DECLARE
    v_operation VARCHAR2(10);
    v_row_count NUMBER := 0;
BEGIN
    -- Determinar el tipo de operación y contar filas afectadas
    IF INSERTING THEN
        v_operation := 'INSERT';
        v_row_count := SQL%ROWCOUNT;
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
        v_row_count := SQL%ROWCOUNT;
    ELSIF DELETING THEN
        v_operation := 'DELETE';
        v_row_count := SQL%ROWCOUNT;
    END IF;
    
    -- Solo registrar si afecta múltiples filas (carga masiva)
    IF v_row_count > 1 THEN
        SP_REGISTER_AUDIT(
            p_table_name => 'VEHICLES',
            p_operation_type => v_operation,
            p_affected_rows => v_row_count,
            p_additional_info => 'BULK OPERATION - ' || v_row_count || ' rows affected'
        );
    END IF;
END;
/

PROMPT 'Trigger para carga masiva creado exitosamente'

-- =====================================================
-- PASO 8: VISTAS DE AUDITORÍA
-- =====================================================

PROMPT '*** CREANDO VISTAS DE AUDITORÍA ***'

-- Vista de resumen de auditoría
CREATE OR REPLACE VIEW VW_AUDIT_SUMMARY AS
SELECT 
    TABLE_NAME,
    OPERATION_TYPE,
    COUNT(*) AS TOTAL_OPERATIONS,
    SUM(AFFECTED_ROWS) AS TOTAL_ROWS_AFFECTED,
    MIN(PROCESS_DATE) AS FIRST_OPERATION,
    MAX(PROCESS_DATE) AS LAST_OPERATION,
    COUNT(DISTINCT USER_NAME) AS DISTINCT_USERS
FROM AUDIT_CONTROL
GROUP BY TABLE_NAME, OPERATION_TYPE
ORDER BY TABLE_NAME, OPERATION_TYPE;

-- Vista de auditoría reciente (últimas 24 horas)
CREATE OR REPLACE VIEW VW_AUDIT_RECENT AS
SELECT 
    AUDIT_ID,
    TABLE_NAME,
    OPERATION_TYPE,
    AFFECTED_ROWS,
    PROCESS_DATE,
    USER_NAME,
    HOST_NAME,
    IP_ADDRESS,
    ADDITIONAL_INFO
FROM AUDIT_CONTROL
WHERE PROCESS_DATE >= SYSTIMESTAMP - INTERVAL '24' HOUR
ORDER BY PROCESS_DATE DESC;

-- Vista de auditoría por usuario
CREATE OR REPLACE VIEW VW_AUDIT_BY_USER AS
SELECT 
    USER_NAME,
    TABLE_NAME,
    OPERATION_TYPE,
    COUNT(*) AS OPERATIONS_COUNT,
    SUM(AFFECTED_ROWS) AS TOTAL_ROWS,
    MIN(PROCESS_DATE) AS FIRST_OPERATION,
    MAX(PROCESS_DATE) AS LAST_OPERATION
FROM AUDIT_CONTROL
GROUP BY USER_NAME, TABLE_NAME, OPERATION_TYPE
ORDER BY USER_NAME, TABLE_NAME, OPERATION_TYPE;

PROMPT 'Vistas de auditoría creadas exitosamente'

-- =====================================================
-- PASO 9: CONSULTAS DE VERIFICACIÓN
-- =====================================================

PROMPT '*** VERIFICANDO INSTALACIÓN DEL SISTEMA DE AUDITORÍA ***'

-- Verificar que la tabla fue creada
SELECT COUNT(*) AS "AUDIT_CONTROL_EXISTS"
FROM USER_TABLES 
WHERE TABLE_NAME = 'AUDIT_CONTROL';

-- Verificar triggers creados
SELECT 
    TRIGGER_NAME,
    TABLE_NAME,
    TRIGGERING_EVENT,
    STATUS
FROM USER_TRIGGERS 
WHERE TRIGGER_NAME LIKE 'TRG_%'
ORDER BY TABLE_NAME, TRIGGER_NAME;

-- Verificar vistas creadas
SELECT VIEW_NAME
FROM USER_VIEWS 
WHERE VIEW_NAME LIKE 'VW_AUDIT%'
ORDER BY VIEW_NAME;

-- Verificar procedimiento
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
FROM USER_OBJECTS 
WHERE OBJECT_NAME = 'SP_REGISTER_AUDIT';

PROMPT '*** SISTEMA DE AUDITORÍA INSTALADO EXITOSAMENTE ***'
PROMPT 'El sistema registrará automáticamente todas las operaciones DML'
PROMPT 'Use las vistas VW_AUDIT_SUMMARY, VW_AUDIT_RECENT y VW_AUDIT_BY_USER para consultar los logs'

-- =====================================================
-- PASO 10: GRANT DE PERMISOS (OPCIONAL)
-- =====================================================

-- Comentado por defecto, descomente si necesita otorgar permisos
/*
GRANT SELECT ON AUDIT_CONTROL TO PUBLIC;
GRANT SELECT ON VW_AUDIT_SUMMARY TO PUBLIC;
GRANT SELECT ON VW_AUDIT_RECENT TO PUBLIC;
GRANT SELECT ON VW_AUDIT_BY_USER TO PUBLIC;
*/

PROMPT '*** SCRIPT 13_audit_control_fixed.sql COMPLETADO ***'
