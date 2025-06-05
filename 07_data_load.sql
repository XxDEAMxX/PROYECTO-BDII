-- =====================================================
-- SCRIPT: 07_data_load.sql
-- PROPOSITO: Ejecutar la carga completa de datos
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================

-- Habilitar salida de mensajes
SET SERVEROUTPUT ON SIZE 1000000

-- BLOQUE ANÓNIMO PARA EJECUTAR TODAS LAS CARGAS
BEGIN
   DBMS_OUTPUT.PUT_LINE('=== INICIANDO PROCESO DE CARGA DE DATOS ===');
   DBMS_OUTPUT.PUT_LINE('Fecha/Hora: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
   DBMS_OUTPUT.PUT_LINE('');
   
   -- Verificar que existe data en tabla temporal
   DECLARE
      v_temp_count NUMBER;
   BEGIN
      SELECT COUNT(*) INTO v_temp_count FROM TMP_CRAIGSLIST_VEHICLES;
      DBMS_OUTPUT.PUT_LINE('Registros en tabla temporal: ' || v_temp_count);
      
      IF v_temp_count = 0 THEN
         DBMS_OUTPUT.PUT_LINE('ADVERTENCIA: No hay datos en TMP_CRAIGSLIST_VEHICLES');
         RETURN;
      END IF;
   END;
   
   DBMS_OUTPUT.PUT_LINE('');
   DBMS_OUTPUT.PUT_LINE('--- Cargando tablas de catálogo ---');
   
   -- Cargar tablas de catálogo primero (tablas independientes)
   DBMS_OUTPUT.PUT_LINE('1. Cargando REGIONS...');
   LOAD_REGIONS;
   DBMS_OUTPUT.PUT_LINE('   ✓ REGIONS cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('2. Cargando MANUFACTURERS...');
   LOAD_MANUFACTURERS;
   DBMS_OUTPUT.PUT_LINE('   ✓ MANUFACTURERS cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('3. Cargando CONDITIONS...');
   LOAD_CONDITIONS;
   DBMS_OUTPUT.PUT_LINE('   ✓ CONDITIONS cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('4. Cargando CYLINDERS...');
   LOAD_CYLINDERS;
   DBMS_OUTPUT.PUT_LINE('   ✓ CYLINDERS cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('5. Cargando FUELS...');
   LOAD_FUELS;
   DBMS_OUTPUT.PUT_LINE('   ✓ FUELS cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('6. Cargando TITLE_STATUSES...');
   LOAD_TITLE_STATUSES;
   DBMS_OUTPUT.PUT_LINE('   ✓ TITLE_STATUSES cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('7. Cargando TRANSMISSIONS...');
   LOAD_TRANSMISSIONS;
   DBMS_OUTPUT.PUT_LINE('   ✓ TRANSMISSIONS cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('8. Cargando DRIVES...');
   LOAD_DRIVES;
   DBMS_OUTPUT.PUT_LINE('   ✓ DRIVES cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('9. Cargando SIZES...');
   LOAD_SIZES;
   DBMS_OUTPUT.PUT_LINE('   ✓ SIZES cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('10. Cargando TYPES...');
   LOAD_TYPES;
   DBMS_OUTPUT.PUT_LINE('    ✓ TYPES cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('11. Cargando PAINT_COLORS...');
   LOAD_PAINT_COLORS;
   DBMS_OUTPUT.PUT_LINE('    ✓ PAINT_COLORS cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('');
   DBMS_OUTPUT.PUT_LINE('--- Cargando tabla principal ---');
   
   -- Finalmente cargar la tabla principal que depende de todas las anteriores
   DBMS_OUTPUT.PUT_LINE('12. Cargando VEHICLES...');
   LOAD_VEHICLES;
   DBMS_OUTPUT.PUT_LINE('    ✓ VEHICLES cargadas exitosamente.');
   
   DBMS_OUTPUT.PUT_LINE('');
   DBMS_OUTPUT.PUT_LINE('=== ESTADÍSTICAS DE CARGA ===');
   
   -- Mostrar estadísticas de carga
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
   
   DBMS_OUTPUT.PUT_LINE('');
   DBMS_OUTPUT.PUT_LINE('=== PROCESO COMPLETADO EXITOSAMENTE ===');
   DBMS_OUTPUT.PUT_LINE('Fecha/Hora fin: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
   
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('*** ERROR DURANTE LA CARGA ***');
      DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('Mensaje: ' || SQLERRM);
      DBMS_OUTPUT.PUT_LINE('Fecha/Hora error: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
      RAISE;
END;
/
