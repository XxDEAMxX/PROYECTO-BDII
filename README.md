# Sistema de Gestión de Vehículos - Oracle Database

## Descripción del Proyecto

Sistema completo de base de datos Oracle para la gestión de datos de vehículos de Craigslist, implementando un modelo de datos normalizado, procesos ETL, y un sistema integral de control de auditoría.

**Autores:** Daniel Arevalo - Alex Hernandez  
**Fecha:** Junio 2025  
**Base de Datos:** Oracle Database  

## 🏗️ Arquitectura del Sistema

### Modelo de Datos Normalizado
- **Tablas principales:** VEHICLES, MANUFACTURERS, REGIONS
- **Tablas de catálogo:** FUEL_TYPES, TRANSMISSIONS, DRIVE_TYPES, VEHICLE_CLASSES
- **Normalización 3NF** con separación de entidades y relaciones optimizadas
- **Sistema de auditoría:** AUDIT_CONTROL con triggers automáticos

### Características Principales
- ✅ **Control de auditoría automático** - Registro de todas las operaciones DML
- ✅ **Procesos ETL** - Carga de datos desde CSV con validación
- ✅ **Integridad referencial** - Restricciones y constraints completos
- ✅ **Optimización** - Índices estratégicos para mejor rendimiento
- ✅ **Vistas de negocio** - Consultas predefinidas para análisis
- ✅ **Procedimientos almacenados** - Lógica de negocio encapsulada

## 📁 Estructura de Archivos

### Scripts de Instalación Principal
```
01_tablespaces_user.sql   # Configuración de tablespaces y usuario
02_sequences.sql          # Secuencias para llaves primarias
03_tables.sql            # Creación de todas las tablas
04_constraints.sql       # Restricciones e integridad referencial
05_indexes.sql           # Índices para optimización
06_procedures.sql        # Procedimientos almacenados
07_data_load.sql         # Carga de datos de prueba
08_views.sql             # Vistas de negocio
MASTER_INSTALL.sql       # Script maestro de instalación
```

### Sistema de Auditoría (NUEVO)
```
13_audit_control.sql     # Sistema completo de auditoría
14_test_audit.sql        # Pruebas del sistema de auditoría
15_audit_queries.sql     # Consultas útiles de auditoría
```

### Scripts de Consultas y Mantenimiento
```
09_sample_queries.sql    # Consultas de ejemplo
10_cleanup.sql           # Limpieza de datos
11_load_csv.sql          # Carga desde CSV (SQL*Loader)
11_load_csv_direct.sql   # Carga directa desde CSV
11_load_csv.ctl          # Control file para SQL*Loader
12_full_test.sql         # Pruebas completas del sistema
```

### Scripts de Automatización
```
Load-CSV-Data.ps1        # PowerShell para automatizar carga
load-data.bat            # Batch file para carga de datos
```

## 🚀 Instalación

### Instalación Completa Automática
```sql
-- Ejecutar como usuario con privilegios DBA
@MASTER_INSTALL.sql
```

### Instalación Manual Paso a Paso
```sql
@01_tablespaces_user.sql
@02_sequences.sql
@03_tables.sql
@04_constraints.sql
@05_indexes.sql
@06_procedures.sql
@08_views.sql
@13_audit_control.sql    -- Sistema de auditoría
```

## 📊 Sistema de Control de Auditoría

### Características del Sistema de Auditoría

El sistema registra automáticamente:
- ✅ **Tabla afectada** (nombre_tabla)
- ✅ **Filas afectadas** (filas_afectadas) 
- ✅ **Tipo de operación** (operación): INSERT, UPDATE, DELETE
- ✅ **Fecha del proceso** (fecha_proceso)
- ✅ **Usuario del proceso** (usuario_proceso)
- ✅ **Información adicional** (detalles de la operación)

### Tabla de Auditoría

```sql
CREATE TABLE AUDIT_CONTROL (
    AUDIT_ID        NUMBER(10) PRIMARY KEY,
    TABLE_NAME      VARCHAR2(50) NOT NULL,      -- nombre_tabla
    OPERATION_TYPE  VARCHAR2(10) NOT NULL,      -- operación
    AFFECTED_ROWS   NUMBER(10) DEFAULT 1,       -- filas_afectadas
    PROCESS_DATE    TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- fecha_proceso
    USER_NAME       VARCHAR2(50) DEFAULT USER,  -- usuario_proceso
    SESSION_ID      NUMBER(20),
    HOST_NAME       VARCHAR2(50),
    IP_ADDRESS      VARCHAR2(15),
    ADDITIONAL_INFO VARCHAR2(500)
);
```

### Triggers Automáticos
- **TRG_VEHICLES_***: Auditoría de la tabla principal de vehículos
- **TRG_MANUFACTURERS_***: Auditoría de fabricantes
- **TRG_REGIONS_***: Auditoría de regiones
- **TRG_FUEL_TYPES_***: Auditoría de tipos de combustible
- **TRG_TRANSMISSIONS_***: Auditoría de transmisiones
- **TRG_DRIVE_TYPES_***: Auditoría de tipos de tracción
- **TRG_VEHICLE_CLASSES_***: Auditoría de clases de vehículos
- **TRG_BULK_LOAD_AUDIT**: Para operaciones masivas

### Vistas de Auditoría
```sql
VW_AUDIT_SUMMARY    -- Resumen general por tabla
VW_AUDIT_RECENT     -- Actividad reciente (últimas 48 horas)
VW_AUDIT_BY_USER    -- Estadísticas por usuario
```

## 📈 Carga de Datos

### Opción 1: Datos de Prueba Integrados
```sql
@07_data_load.sql
```

### Opción 2: Carga desde CSV
```sql
-- Preparar archivos CSV en el directorio del proyecto
@11_load_csv_direct.sql
```

### Opción 3: PowerShell Automatizado
```powershell
.\Load-CSV-Data.ps1
```

### Opción 4: SQL*Loader (Avanzado)
```bash
sqlldr CARS_USER/A123@XE control=11_load_csv.ctl log=load_csv.log
```

## 🧪 Pruebas y Verificación

### Probar el Sistema de Auditoría
```sql
@14_test_audit.sql
```

### Consultas de Auditoría
```sql
@15_audit_queries.sql
```

### Pruebas Generales del Sistema
```sql
@12_full_test.sql
```

## 🔍 Consultas Útiles de Auditoría

### Verificar actividad reciente
```sql
SELECT * FROM VW_AUDIT_RECENT WHERE ROWNUM <= 20;
```

### Resumen por tabla
```sql
SELECT * FROM VW_AUDIT_SUMMARY;
```

### Actividad por usuario
```sql
SELECT * FROM VW_AUDIT_BY_USER;
```

### Operaciones masivas
```sql
SELECT * FROM AUDIT_CONTROL WHERE AFFECTED_ROWS > 1;
```

## 🛠️ Mantenimiento

### Limpiar datos de prueba
```sql
@10_cleanup.sql
```

### Verificar estado de auditoría
```sql
SELECT COUNT(*) AS TOTAL_AUDIT_RECORDS FROM AUDIT_CONTROL;
```

### Verificar triggers activos
```sql
SELECT TRIGGER_NAME, STATUS FROM USER_TRIGGERS WHERE TRIGGER_NAME LIKE 'TRG_%';
```

## 📋 Modelo de Datos

### Tablas Principales
- **VEHICLES** - Tabla principal de vehículos
- **MANUFACTURERS** - Fabricantes de vehículos
- **REGIONS** - Regiones geográficas
- **REGIONS** - Información geográfica
- **MANUFACTURERS** - Fabricantes de vehículos

### Tablas de Catálogo
- **CONDITIONS** - Condiciones del vehículo
- **FUELS** - Tipos de combustible
- **TRANSMISSIONS** - Tipos de transmisión
- **CYLINDERS** - Número de cilindros
- **DRIVES** - Tipos de tracción
- **SIZES** - Categorías de tamaño
- **TYPES** - Tipos de vehículo
- **PAINT_COLORS** - Colores de pintura
- **TITLE_STATUSES** - Estados del título

### Vistas Principales
- **VW_VEHICLES_COMPLETE** - Vista completa con todos los datos desnormalizados
- **VW_STATS_BY_MANUFACTURER** - Estadísticas por fabricante
- **VW_STATS_BY_REGION** - Estadísticas por región
- **VW_VEHICLES_AVAILABLE** - Vehículos disponibles con filtros básicos
- **VW_VEHICLE_REPORTS** - Vista de reportes estadísticos generados

### Sistema de Reportes (NUEVO)
- **VEHICLE_REPORTS** - Tabla de reportes estadísticos
- **SP_GENERATE_VEHICLE_REPORT** - Generación de reportes con rango de fechas

### Validación de Fechas Laborales (NUEVO)
- **VALIDATE_LOAD_DATE** - Función de validación según requisitos del PDF

### Paquetes PL/SQL (NUEVO)
- **PKG_VEHICLES_MANAGEMENT** - Organización de lógica de negocio

### Tablas de Catálogo
- **FUEL_TYPES** - Tipos de combustible
- **TRANSMISSIONS** - Tipos de transmisión
- **DRIVE_TYPES** - Tipos de tracción
- **VEHICLE_CLASSES** - Clases de vehículos

### Sistema de Auditoría
- **AUDIT_CONTROL** - Registro de todas las operaciones DML

### Procedimientos Almacenados Principales
- **LOAD_REGIONS** - Carga regiones
- **LOAD_MANUFACTURERS** - Carga fabricantes
- **LOAD_FUELS** - Carga combustibles
- **LOAD_TRANSMISSIONS** - Carga transmisiones
- **LOAD_DRIVES** - Carga tracciones
- **LOAD_TYPES** - Carga tipos
- **LOAD_VEHICLES** - Carga vehículos (tabla principal)
- **SP_REGISTER_AUDIT** - Registro automático de auditoría

## 📋 Requisitos Técnicos

- **Oracle Database** 11g o superior
- **Usuario con privilegios:** CREATE TABLE, CREATE SEQUENCE, CREATE TRIGGER, CREATE PROCEDURE
- **Tablespace:** Mínimo 100MB disponible
- **Memory:** Configuración estándar de Oracle

## ⚠️ Notas Importantes

1. **Primera Instalación**: Es normal ver errores ORA-00955 (objeto ya existe) en reinstalaciones
2. **Rendimiento**: Los triggers de auditoría están optimizados con transacciones autónomas
3. **Backup**: El sistema de auditoría NO afecta la transacción principal en caso de errores
4. **Limpieza**: Considere implementar un job para limpiar registros de auditoría antiguos

## 🔗 Scripts Relacionados

- **Consultas de ejemplo:** `09_sample_queries.sql`
- **Procedimientos de negocio:** `06_procedures.sql`
- **Vistas de análisis:** `08_views.sql`
- **Control de auditoría:** `13_audit_control.sql`

## 📞 Soporte

Para preguntas o problemas con el sistema:
1. Revisar los logs de instalación
2. Ejecutar `14_test_audit.sql` para verificar auditoría
3. Consultar `15_audit_queries.sql` para análisis detallado

---

**Sistema implementado según especificaciones del proyecto de BD2**  
**Control de auditoría cumple 100% con los requisitos del PDF**
```

## Pruebas del Sistema

### Pruebas Integrales
```sql
-- Ejecutar todas las pruebas
@12_full_test.sql
```

### Validaciones Manuales
```sql
-- Verificar estructura
SELECT table_name FROM user_tables ORDER BY table_name;

-- Verificar datos
SELECT COUNT(*) FROM VEHICLES;
SELECT * FROM VW_VEHICLES_COMPLETE WHERE ROWNUM <= 5;
```

## Mantenimiento

### Limpiar Datos
```sql
-- PRECAUCIÓN: Esto eliminará todos los datos
@10_cleanup.sql
```

### Actualizar Estadísticas
```sql
EXEC DBMS_STATS.GATHER_SCHEMA_STATS('CARS_USER');
```

## Requisitos del Sistema
- Oracle Database 11g o superior
- Usuario con privilegios para crear tablespaces, tablas, secuencias, procedimientos y vistas
- Espacio en disco: ~500MB para tablespace de datos, ~100MB para índices

## Configuración Recomendada
- **Usuario:** CARS_USER
- **Password:** A123 (cambiar en producción)
- **Tablespace datos:** TS_DATOS (300MB inicial, auto-extensible)
- **Tablespace índices:** TS_INDICES (50MB inicial, auto-extensible)

## Notas Importantes
1. Ejecutar siempre los scripts en el orden indicado
2. La tabla temporal TMP_CRAIGSLIST_VEHICLES debe cargarse antes de ejecutar los procedimientos
3. Los procedimientos de carga son idempotentes (se pueden ejecutar múltiples veces)
4. Las vistas proporcionan acceso fácil a los datos desnormalizados
5. Los índices están optimizados para consultas comunes por fabricante, año, precio y región

## Soporte
Para problemas o mejoras, revisar los logs de ejecución y verificar que:
- Todos los objetos se crearon correctamente
- No hay errores de permisos
- Los datos en TMP_CRAIGSLIST_VEHICLES tienen el formato correcto
