-- =====================================================
-- SCRIPT: 12_full_test.sql
-- PROPOSITO: Script completo de pruebas del sistema
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================

SET SERVEROUTPUT ON SIZE 1000000
SET LINESIZE 120
SET PAGESIZE 50

PROMPT ===============================================
PROMPT PRUEBAS INTEGRALES DEL SISTEMA
PROMPT ===============================================

-- 1. VERIFICAR ESTRUCTURA DE BASE DE DATOS
PROMPT 
PROMPT === 1. VERIFICACIÓN DE OBJETOS ===

PROMPT 
PROMPT Tablespaces:
SELECT tablespace_name, status, contents 
FROM user_tablespaces 
WHERE tablespace_name IN ('TS_DATOS', 'TS_INDICES');

PROMPT 
PROMPT Tablas creadas:
SELECT table_name, num_rows, last_analyzed 
FROM user_tables 
ORDER BY table_name;

PROMPT 
PROMPT Secuencias:
SELECT sequence_name, last_number, increment_by 
FROM user_sequences 
ORDER BY sequence_name;

PROMPT 
PROMPT Procedimientos:
SELECT object_name, object_type, status 
FROM user_objects 
WHERE object_type = 'PROCEDURE' 
ORDER BY object_name;

PROMPT 
PROMPT Vistas:
SELECT view_name FROM user_views ORDER BY view_name;

-- 2. VERIFICAR CONSTRAINTS
PROMPT 
PROMPT === 2. VERIFICACIÓN DE CONSTRAINTS ===

PROMPT 
PROMPT Primary Keys:
SELECT constraint_name, table_name, status 
FROM user_constraints 
WHERE constraint_type = 'P' 
ORDER BY table_name;

PROMPT 
PROMPT Foreign Keys:
SELECT constraint_name, table_name, r_constraint_name, status 
FROM user_constraints 
WHERE constraint_type = 'R' 
ORDER BY table_name;

PROMPT 
PROMPT Unique Constraints:
SELECT constraint_name, table_name, status 
FROM user_constraints 
WHERE constraint_type = 'U' 
ORDER BY table_name;

-- 3. VERIFICAR ÍNDICES
PROMPT 
PROMPT === 3. VERIFICACIÓN DE ÍNDICES ===
SELECT index_name, table_name, uniqueness, status 
FROM user_indexes 
ORDER BY table_name, index_name;

-- 4. VERIFICAR DATOS (si existen)
PROMPT 
PROMPT === 4. VERIFICACIÓN DE DATOS ===

DECLARE
   v_count NUMBER;
BEGIN
   SELECT COUNT(*) INTO v_count FROM TMP_CRAIGSLIST_VEHICLES;
   DBMS_OUTPUT.PUT_LINE('Registros en TMP_CRAIGSLIST_VEHICLES: ' || v_count);
   
   IF v_count > 0 THEN
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('=== ESTADÍSTICAS DE DATOS CARGADOS ===');
      
      FOR rec IN (SELECT 'REGIONS' AS tabla, COUNT(*) AS total FROM REGIONS
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
                  ORDER BY 1) LOOP
         DBMS_OUTPUT.PUT_LINE(RPAD(rec.tabla, 20) || ': ' || LPAD(TO_CHAR(rec.total), 8) || ' registros');
      END LOOP;
   ELSE
      DBMS_OUTPUT.PUT_LINE('No hay datos cargados. Ejecute primero la carga de datos.');
   END IF;
END;
/

-- 5. PRUEBAS DE INTEGRIDAD REFERENCIAL
PROMPT 
PROMPT === 5. PRUEBAS DE INTEGRIDAD REFERENCIAL ===

DECLARE
   v_count NUMBER;
BEGIN
   DBMS_OUTPUT.PUT_LINE('Verificando integridad referencial...');
   
   -- Verificar vehículos sin región válida
   SELECT COUNT(*) INTO v_count
   FROM VEHICLES v
   WHERE v.REGION_ID IS NOT NULL 
     AND NOT EXISTS (SELECT 1 FROM REGIONS r WHERE r.ID = v.REGION_ID);
   DBMS_OUTPUT.PUT_LINE('Vehículos con región inválida: ' || v_count);
   
   -- Verificar vehículos sin fabricante válido
   SELECT COUNT(*) INTO v_count
   FROM VEHICLES v
   WHERE v.MANUFACTURER_ID IS NOT NULL 
     AND NOT EXISTS (SELECT 1 FROM MANUFACTURERS m WHERE m.ID = v.MANUFACTURER_ID);
   DBMS_OUTPUT.PUT_LINE('Vehículos con fabricante inválido: ' || v_count);
   
   DBMS_OUTPUT.PUT_LINE('Integridad referencial verificada.');
END;
/

-- 6. PRUEBAS DE PERFORMANCE
PROMPT 
PROMPT === 6. PRUEBAS DE PERFORMANCE ===

PROMPT 
PROMPT Test 1: Consulta por fabricante (debe usar índice)
SET TIMING ON
SELECT COUNT(*) FROM VW_VEHICLES_COMPLETE WHERE MANUFACTURER = 'Toyota';
SET TIMING OFF

PROMPT 
PROMPT Test 2: Consulta por rango de precios (debe usar índice)
SET TIMING ON
SELECT COUNT(*) FROM VW_VEHICLES_COMPLETE WHERE PRICE BETWEEN 10000 AND 20000;
SET TIMING OFF

PROMPT 
PROMPT Test 3: Consulta por año (debe usar índice)
SET TIMING ON
SELECT COUNT(*) FROM VW_VEHICLES_COMPLETE WHERE YEAR = 2020;
SET TIMING OFF

-- 7. VALIDACIÓN DE VISTAS
PROMPT 
PROMPT === 7. VALIDACIÓN DE VISTAS ===

PROMPT 
PROMPT Vista VW_VEHICLES_COMPLETE (primeros 3 registros):
SELECT * FROM VW_VEHICLES_COMPLETE WHERE ROWNUM <= 3;

PROMPT 
PROMPT Vista VW_STATS_BY_MANUFACTURER (top 5):
SELECT * FROM VW_STATS_BY_MANUFACTURER WHERE ROWNUM <= 5;

PROMPT 
PROMPT Vista VW_STATS_BY_REGION (top 5):
SELECT * FROM VW_STATS_BY_REGION WHERE ROWNUM <= 5;

-- 8. PRUEBAS DE PROCEDIMIENTOS
PROMPT 
PROMPT === 8. PRUEBAS DE PROCEDIMIENTOS ===

DECLARE
   v_count_before NUMBER;
   v_count_after NUMBER;
BEGIN
   DBMS_OUTPUT.PUT_LINE('Probando procedimientos de carga...');
   
   -- Contar registros antes
   SELECT COUNT(*) INTO v_count_before FROM MANUFACTURERS;
   DBMS_OUTPUT.PUT_LINE('Fabricantes antes: ' || v_count_before);
   
   -- Ejecutar procedimiento (debe ser idempotente)
   LOAD_MANUFACTURERS;
   
   -- Contar registros después
   SELECT COUNT(*) INTO v_count_after FROM MANUFACTURERS;
   DBMS_OUTPUT.PUT_LINE('Fabricantes después: ' || v_count_after);
   
   IF v_count_before = v_count_after THEN
      DBMS_OUTPUT.PUT_LINE('✓ Procedimiento es idempotente');
   ELSE
      DBMS_OUTPUT.PUT_LINE('⚠ Procedimiento no es idempotente');
   END IF;
END;
/

-- 9. REPORTE FINAL
PROMPT 
PROMPT === 9. REPORTE FINAL ===

DECLARE
   v_tables_count NUMBER;
   v_procedures_count NUMBER;
   v_views_count NUMBER;
   v_constraints_count NUMBER;
   v_indexes_count NUMBER;
BEGIN
   SELECT COUNT(*) INTO v_tables_count FROM user_tables;
   SELECT COUNT(*) INTO v_procedures_count FROM user_objects WHERE object_type = 'PROCEDURE';
   SELECT COUNT(*) INTO v_views_count FROM user_views;
   SELECT COUNT(*) INTO v_constraints_count FROM user_constraints;
   SELECT COUNT(*) INTO v_indexes_count FROM user_indexes;
   
   DBMS_OUTPUT.PUT_LINE('===============================================');
   DBMS_OUTPUT.PUT_LINE('RESUMEN DE PRUEBAS COMPLETADAS');
   DBMS_OUTPUT.PUT_LINE('===============================================');
   DBMS_OUTPUT.PUT_LINE('Tablas creadas: ' || v_tables_count);
   DBMS_OUTPUT.PUT_LINE('Procedimientos: ' || v_procedures_count);
   DBMS_OUTPUT.PUT_LINE('Vistas: ' || v_views_count);
   DBMS_OUTPUT.PUT_LINE('Constraints: ' || v_constraints_count);
   DBMS_OUTPUT.PUT_LINE('Índices: ' || v_indexes_count);
   DBMS_OUTPUT.PUT_LINE('');
   DBMS_OUTPUT.PUT_LINE('Sistema validado exitosamente.');
   DBMS_OUTPUT.PUT_LINE('Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
   DBMS_OUTPUT.PUT_LINE('===============================================');
END;
/
