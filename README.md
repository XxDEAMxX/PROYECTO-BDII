# Sistema de Gestión de Vehículos - Oracle Database

## Descripción del Proyecto

Sistema completo de base de datos Oracle para la gestión de datos de vehículos de Craigslist, implementando un modelo de datos normalizado, procesos ETL, sistema integral de control de auditoría, **validación de fechas laborales**, **reportes estadísticos** y **paquetes PL/SQL** para organizar la lógica de negocio.

**Autores:** Daniel Arevalo - Alex Hernandez  
**Fecha:** Junio 2025  
**Base de Datos:** Oracle Database  
**Estado:** ✅ **PROYECTO COMPLETADO AL 100%**

## 🏗️ Arquitectura del Sistema

### Modelo de Datos Normalizado
- **Tablas principales:** VEHICLES, MANUFACTURERS, REGIONS
- **Tablas de catálogo:** CONDITIONS, FUELS, TRANSMISSIONS, CYLINDERS, DRIVES, SIZES, TYPES, PAINT_COLORS, TITLE_STATUSES
- **Tabla de reportes:** VEHICLE_REPORTS (NUEVA)
- **Normalización 3NF** con separación de entidades y relaciones optimizadas
- **Sistema de auditoría:** AUDIT_CONTROL con triggers automáticos

### Características Principales
- ✅ **Control de auditoría automático** - Registro de todas las operaciones DML
- ✅ **Validación de fechas laborales** - Función VALIDATE_LOAD_DATE (NUEVO)
- ✅ **Sistema de reportes estadísticos** - Con rango de fechas (NUEVO)
- ✅ **Paquetes PL/SQL** - Organización de lógica de negocio (NUEVO)
- ✅ **Procesos ETL** - Carga de datos desde CSV con validación
- ✅ **Integridad referencial** - Restricciones y constraints completos
- ✅ **Optimización** - Índices estratégicos para mejor rendimiento
- ✅ **Vistas de negocio** - Consultas predefinidas para análisis

## 📁 Estructura de Archivos

### Scripts de Instalación Principal
```
01_tablespaces_user.sql   # Configuración de tablespaces y usuario
02_sequences.sql          # Secuencias para llaves primarias
03_tables.sql            # Creación de todas las tablas
04_constraints.sql       # Restricciones e integridad referencial
05_indexes.sql           # Índices para optimización
06_procedures.sql        # Procedimientos, funciones y paquetes PL/SQL (ACTUALIZADO)
07_data_load.sql         # Carga de datos de prueba
08_views.sql             # Vistas de negocio
MASTER_INSTALL.sql       # Script maestro de instalación (ACTUALIZADO)
```

### Sistema de Auditoría
```
13_audit_control.sql     # Sistema completo de auditoría
14_test_audit.sql        # Pruebas del sistema de auditoría
15_audit_queries.sql     # Consultas útiles de auditoría
```

### ✅ Reorganización Completada: Funcionalidades Integradas
```
Los nuevos componentes están ahora integrados en sus scripts correspondientes:
• Tabla VEHICLE_REPORTS → 03_tables.sql
• Secuencia SEQ_VEHICLE_REPORTS → 02_sequences.sql  
• Procedimiento SP_GENERATE_VEHICLE_REPORT → 06_procedures.sql
• Vista VW_VEHICLE_REPORTS → 08_views.sql
```

### Scripts de Consultas y Mantenimiento
```
09_sample_queries.sql    # Consultas de ejemplo
10_cleanup.sql           # Limpieza de datos
11_load_csv.sql          # Carga desde CSV (SQL*Loader)
11_load_csv_direct.sql   # Carga directa desde CSV
11_load_csv.ctl          # Control file para SQL*Loader
12_full_test.sql         # Pruebas completas del sistema
16_final_verification.sql # Verificación final completa
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
@06_procedures.sql        -- Incluye funciones y paquetes PL/SQL
@08_views.sql
@13_audit_control.sql     -- Sistema de auditoría
```

## 🆕 Nuevas Funcionalidades Implementadas

### 1. Validación de Fechas Laborales
```sql
-- Función que valida:
-- • Días hábiles (lunes a viernes)
-- • Horario laboral (8:00 - 18:00)
-- • No fechas pasadas
-- • Máximo 3 días en el futuro

SELECT VALIDATE_LOAD_DATE(SYSDATE) FROM DUAL;
```

### 2. Paquetes PL/SQL
```sql
-- PKG_VEHICLES_MANAGEMENT: Organiza toda la lógica de negocio

-- Carga completa con validación de fecha
EXEC PKG_VEHICLES_MANAGEMENT.EXECUTE_FULL_LOAD(SYSDATE);

-- Limpieza completa del sistema
EXEC PKG_VEHICLES_MANAGEMENT.EXECUTE_CLEANUP;

-- Validación de fecha via paquete
SELECT PKG_VEHICLES_MANAGEMENT.IS_VALID_LOAD_DATE(SYSDATE) FROM DUAL;
```

### 3. Sistema de Reportes Estadísticos
```sql
-- Generar reportes con rango de fechas específico

-- Reporte por fabricante
EXEC SP_GENERATE_VEHICLE_REPORT(DATE'2021-01-01', DATE'2021-12-31', 'BY_MANUFACTURER');

-- Reporte por región
EXEC SP_GENERATE_VEHICLE_REPORT(DATE'2021-01-01', DATE'2021-12-31', 'BY_REGION');

-- Reporte por año
EXEC SP_GENERATE_VEHICLE_REPORT(DATE'2021-01-01', DATE'2021-12-31', 'BY_YEAR');

-- Consultar reportes generados
SELECT * FROM VW_VEHICLE_REPORTS;
```

## 📊 Sistema de Control de Auditoría

### Características del Sistema de Auditoría

El sistema registra automáticamente todos los campos requeridos por el PDF:
- ✅ **nombre_tabla** → TABLE_NAME
- ✅ **filas_afectadas** → AFFECTED_ROWS 
- ✅ **operación** → OPERATION_TYPE (INSERT/UPDATE/DELETE)
- ✅ **fecha_proceso** → PROCESS_DATE
- ✅ **usuario_proceso** → USER_NAME
- ✅ **Información adicional** → ADDITIONAL_INFO, SESSION_ID, HOST_NAME, IP_ADDRESS

### Tabla de Auditoría

```sql
CREATE TABLE AUDIT_CONTROL (
    AUDIT_ID        NUMBER(10) PRIMARY KEY,
    TABLE_NAME      VARCHAR2(50) NOT NULL,      -- nombre_tabla (PDF)
    OPERATION_TYPE  VARCHAR2(10) NOT NULL,      -- operación (PDF)
    AFFECTED_ROWS   NUMBER(10) DEFAULT 1,       -- filas_afectadas (PDF)
    PROCESS_DATE    TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- fecha_proceso (PDF)
    USER_NAME       VARCHAR2(50) DEFAULT USER,  -- usuario_proceso (PDF)
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

### Opción 1: Carga Completa con Validación (RECOMENDADO)
```sql
-- Carga completa usando paquete con validación de fecha laboral
EXEC PKG_VEHICLES_MANAGEMENT.EXECUTE_FULL_LOAD(SYSDATE);
```

### Opción 2: Datos de Prueba Integrados
```sql
@07_data_load.sql
```

### Opción 3: Carga desde CSV
```sql
-- Preparar archivos CSV en el directorio del proyecto
@11_load_csv_direct.sql
```

### Opción 4: PowerShell Automatizado
```powershell
.\Load-CSV-Data.ps1
```

### Opción 5: SQL*Loader (Avanzado)
```bash
sqlldr CARS_USER/A123@XE control=11_load_csv.ctl log=load_csv.log
```

## 🧪 Pruebas y Verificación

### Pruebas de Validación y Reportes
```sql
-- Las pruebas están integradas en los archivos de pruebas generales
@12_full_test.sql     -- Incluye pruebas de todas las funcionalidades
@16_final_verification.sql  -- Verificación completa del sistema
```

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

### Verificación Final Completa
```sql
@16_final_verification.sql
```

## 🔍 Ejemplos de Uso Prácticos

### Validación de Fechas
```sql
-- Validar fecha actual
SELECT VALIDATE_LOAD_DATE(SYSDATE) FROM DUAL;

-- Validar fecha específica
SELECT VALIDATE_LOAD_DATE(TO_DATE('15/06/2025 10:30', 'DD/MM/YYYY HH24:MI')) FROM DUAL;
```

### Generación de Reportes
```sql
-- Generar todos los tipos de reportes para el año 2021
EXEC SP_GENERATE_VEHICLE_REPORT(DATE'2021-01-01', DATE'2021-12-31', 'BY_MANUFACTURER');
EXEC SP_GENERATE_VEHICLE_REPORT(DATE'2021-01-01', DATE'2021-12-31', 'BY_REGION');
EXEC SP_GENERATE_VEHICLE_REPORT(DATE'2021-01-01', DATE'2021-12-31', 'BY_YEAR');

-- Ver todos los reportes generados
SELECT * FROM VW_VEHICLE_REPORTS ORDER BY FECHA_GENERACION DESC;
```

### Consultas de Auditoría
```sql
-- Ver actividad reciente
SELECT * FROM VW_AUDIT_RECENT WHERE ROWNUM <= 20;

-- Resumen por tabla
SELECT * FROM VW_AUDIT_SUMMARY;

-- Actividad por usuario
SELECT * FROM VW_AUDIT_BY_USER;

-- Operaciones masivas
SELECT * FROM AUDIT_CONTROL WHERE AFFECTED_ROWS > 1;
```

## 🛠️ Mantenimiento

### Limpiar datos de prueba
```sql
-- Usando procedimiento individual
@10_cleanup.sql

-- Usando paquete (RECOMENDADO)
EXEC PKG_VEHICLES_MANAGEMENT.EXECUTE_CLEANUP;
```

### Verificar estado del sistema
```sql
-- Estado de auditoría
SELECT COUNT(*) AS TOTAL_AUDIT_RECORDS FROM AUDIT_CONTROL;

-- Triggers activos
SELECT TRIGGER_NAME, STATUS FROM USER_TRIGGERS WHERE TRIGGER_NAME LIKE 'TRG_%';

-- Objetos del sistema
SELECT OBJECT_TYPE, COUNT(*) AS CANTIDAD 
FROM USER_OBJECTS 
GROUP BY OBJECT_TYPE 
ORDER BY OBJECT_TYPE;
```

## 📋 Modelo de Datos Completo

### Tablas Principales
- **VEHICLES** - Tabla principal de vehículos (con FKs a todas las tablas de catálogo)
- **MANUFACTURERS** - Fabricantes de vehículos
- **REGIONS** - Regiones geográficas con coordenadas

### Tablas de Catálogo
- **CONDITIONS** - Condiciones del vehículo (nuevo, usado, etc.)
- **FUELS** - Tipos de combustible (gasolina, diesel, eléctrico, etc.)
- **TRANSMISSIONS** - Tipos de transmisión (manual, automática)
- **CYLINDERS** - Número de cilindros del motor
- **DRIVES** - Tipos de tracción (FWD, RWD, AWD)
- **SIZES** - Categorías de tamaño del vehículo
- **TYPES** - Tipos de vehículo (sedan, SUV, truck, etc.)
- **PAINT_COLORS** - Colores de pintura disponibles
- **TITLE_STATUSES** - Estados legales del título

### Tablas del Sistema
- **TMP_CRAIGSLIST_VEHICLES** - Tabla temporal para carga de CSV
- **AUDIT_CONTROL** - Registro de todas las operaciones DML
- **VEHICLE_REPORTS** - Tabla de reportes estadísticos (NUEVA)

### Vistas Principales
- **VW_VEHICLES_COMPLETE** - Vista completa con todos los datos desnormalizados
- **VW_STATS_BY_MANUFACTURER** - Estadísticas por fabricante
- **VW_STATS_BY_REGION** - Estadísticas por región
- **VW_VEHICLES_AVAILABLE** - Vehículos disponibles con filtros básicos
- **VW_VEHICLE_REPORTS** - Vista de reportes estadísticos generados (NUEVA)
- **VW_AUDIT_SUMMARY** - Resumen de auditoría por tabla
- **VW_AUDIT_RECENT** - Actividad de auditoría reciente
- **VW_AUDIT_BY_USER** - Estadísticas de auditoría por usuario

### Funciones y Procedimientos Principales
- **VALIDATE_LOAD_DATE** - Función de validación de fechas laborales (NUEVA)
- **SP_GENERATE_VEHICLE_REPORT** - Generación de reportes con rango de fechas (NUEVO)
- **LOAD_REGIONS** - Carga regiones desde CSV
- **LOAD_MANUFACTURERS** - Carga fabricantes desde CSV
- **LOAD_VEHICLES** - Carga vehículos desde CSV (tabla principal)
- **SP_REGISTER_AUDIT** - Registro automático de auditoría

### Paquetes PL/SQL (NUEVO)
- **PKG_VEHICLES_MANAGEMENT** - Organización completa de la lógica de negocio
  - `EXECUTE_FULL_LOAD(p_load_date)` - Carga completa con validación
  - `EXECUTE_CLEANUP` - Limpieza completa del sistema
  - `IS_VALID_LOAD_DATE(p_date)` - Validación de fecha via paquete

## 📋 Requisitos Técnicos

- **Oracle Database** 11g o superior
- **Usuario con privilegios:** CREATE TABLE, CREATE SEQUENCE, CREATE TRIGGER, CREATE PROCEDURE, CREATE PACKAGE
- **Tablespace:** Mínimo 100MB disponible
- **Memory:** Configuración estándar de Oracle

## ✅ Cumplimiento Requisitos del PDF

| **Requisito** | **Implementación** | **Estado** |
|---------------|-------------------|------------|
| Descarga CSV desde Kaggle | `nuevo_vehiculos.csv` | ✅ **COMPLETO** |
| Usuario y tablespaces separados | `01_tablespaces_user.sql` | ✅ **COMPLETO** |
| Carga CSV (sin SQL*Loader) | Múltiples opciones implementadas | ✅ **COMPLETO** |
| Procedimientos por tabla | 12 procedimientos en `06_procedures.sql` | ✅ **COMPLETO** |
| Tabla de control de auditoría | `AUDIT_CONTROL` con todos los campos requeridos | ✅ **COMPLETO** |
| Triggers automáticos | Sistema completo para todas las tablas | ✅ **COMPLETO** |
| **Función validación fechas laborales** | `VALIDATE_LOAD_DATE` | ✅ **COMPLETO** |
| **Tabla de reporte con rango de fechas** | `VEHICLE_REPORTS + SP_GENERATE_VEHICLE_REPORT` | ✅ **COMPLETO** |
| **Paquetes PL/SQL** | `PKG_VEHICLES_MANAGEMENT` | ✅ **COMPLETO** |

## ⚠️ Notas Importantes

1. **Primera Instalación**: Es normal ver errores ORA-00955 (objeto ya existe) en reinstalaciones
2. **Validación de Fechas**: La función VALIDATE_LOAD_DATE debe usarse antes de cualquier proceso de carga
3. **Reportes**: Los reportes requieren datos existentes en el rango de fechas especificado
4. **Paquetes**: Use PKG_VEHICLES_MANAGEMENT para operaciones principales del sistema
5. **Rendimiento**: Los triggers de auditoría están optimizados con transacciones autónomas
6. **Backup**: El sistema de auditoría NO afecta la transacción principal en caso de errores

## 🔗 Scripts Relacionados

- **Nuevas funcionalidades:** `17_reports_table.sql`, `18_test_new_features.sql`
- **Procedimientos y paquetes:** `06_procedures.sql`
- **Control de auditoría:** `13_audit_control.sql`, `14_test_audit.sql`, `15_audit_queries.sql`
- **Consultas de ejemplo:** `09_sample_queries.sql`
- **Vistas de análisis:** `08_views.sql`
- **Verificación completa:** `16_final_verification.sql`

## 📞 Soporte

Para preguntas o problemas con el sistema:
1. Ejecutar `18_test_new_features.sql` para verificar nuevas funcionalidades
2. Ejecutar `16_final_verification.sql` para verificación completa
3. Revisar los logs de instalación
4. Ejecutar `14_test_audit.sql` para verificar auditoría
5. Consultar `15_audit_queries.sql` para análisis detallado

---

## 🏆 Estado del Proyecto

**✅ PROYECTO COMPLETADO AL 100%**

- ✅ **Cumple TODOS los requisitos del PDF**
- ✅ **Función de validación de fechas laborales implementada**
- ✅ **Sistema de reportes con rango de fechas funcionando**
- ✅ **Paquetes PL/SQL organizando la lógica de negocio**
- ✅ **Sistema de auditoría completo y automático**
- ✅ **Modelo de datos normalizado y optimizado**
- ✅ **Scripts de instalación, pruebas y verificación**

**Sistema implementado según especificaciones del proyecto de BD2**  
**Listo para sustentación y uso en producción** 🚀