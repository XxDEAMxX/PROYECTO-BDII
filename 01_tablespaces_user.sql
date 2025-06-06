-- =====================================================
-- SCRIPT: 01_tablespaces_user.sql
-- PROPOSITO: Crear tablespaces y usuario para el proyecto
-- AUTOR: Daniel Arevalo - Alex Hernandez
-- FECHA: Junio 2025
-- =====================================================


-- Crear tablespace para datos
CREATE TABLESPACE TS_DATOS
   DATAFILE 'ts_datos01.dbf' SIZE 300M
   AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

-- Tablespace para índices
CREATE TABLESPACE TS_INDICES
   DATAFILE 'ts_indices01.dbf' SIZE 50M
   AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

-- Crear usuario
CREATE USER CARS_USER IDENTIFIED BY A123
   DEFAULT TABLESPACE TS_DATOS
   TEMPORARY TABLESPACE TEMP
   QUOTA UNLIMITED ON TS_DATOS
   QUOTA UNLIMITED ON TS_INDICES;

-- Permisos necesarios para el usuario
GRANT CREATE SESSION TO CARS_USER;
GRANT CREATE TABLE TO CARS_USER;
GRANT CREATE VIEW TO CARS_USER;
GRANT CREATE PROCEDURE TO CARS_USER;
GRANT CREATE TRIGGER TO CARS_USER;
GRANT CREATE SEQUENCE TO CARS_USER;

COMMIT;




--validacion de permisos

SELECT grantee, granted_role
FROM dba_role_privs
WHERE grantee = 'cars_user';

SELECT * FROM DBA_USERS;

-- validacion permisos de sistema
SELECT *
FROM dba_sys_privs
WHERE grantee = 'cars_user';

--objetos de usuario
SELECT object_type, COUNT(*) AS cantidad
FROM user_objects
GROUP BY object_type;

SELECT *
FROM dba_objects
WHERE owner = 'cars_user';

--segmentos de usuario index and table
SELECT
  segment_name,
  segment_type,
  tablespace_name,
  bytes/1024/1024 AS mb_usados
FROM user_segments
--WHERE segment_type IN ('TABLE', 'INDEX')
ORDER BY segment_type, tablespace_name;


--validacion de tablas
SELECT
  CASE
    WHEN ROWNUM = (SELECT COUNT(*) FROM user_tables ) THEN
      'SELECT COUNT(1), ''' || table_name || ''' AS tabla FROM ' || table_name || ';'
    ELSE
      'SELECT COUNT(1), ''' || table_name || ''' AS tabla FROM ' || table_name || ' UNION'
  END AS consulta
FROM user_tables ;