# Sistema de Gestión de Vehículos - Oracle Database

## Descripción del Proyecto

Sistema de base de datos Oracle para gestión de datos de vehículos de Craigslist con modelo normalizado, procesos ETL, auditoría automática y validación de fechas laborales.

**Autores:** Daniel Arevalo - Alex Hernandez  
**Fecha:** Junio 2025  
**Base de Datos:** Oracle Database XE  

## 🏗️ Arquitectura del Sistema

### Modelo de Datos
- **Tablas principales:** VEHICLES, MANUFACTURERS, REGIONS
- **Tablas de catálogo:** CONDITIONS, FUELS, TRANSMISSIONS, CYLINDERS, DRIVES, SIZES, TYPES, PAINT_COLORS, TITLE_STATUSES
- **Tabla temporal:** TMP_CRAIGSLIST_VEHICLES
- **Normalización 3NF** con integridad referencial

### Características
- ✅ **Control de auditoría automático**
- ✅ **Validación de fechas laborales**
- ✅ **Procesos ETL** con validación de datos
- ✅ **Índices optimizados** para consultas
- ✅ **Vistas de negocio** para análisis

## 📁 Estructura del Proyecto

### Scripts Principales (ejecutar en orden)

1. **01_tablespaces_user.sql** - Tablespaces y usuario
2. **02_sequences.sql** - Secuencias para IDs
3. **03_tables.sql** - Creación de tablas
4. **04_constraints.sql** - Restricciones y llaves foráneas
5. **05_indexes.sql** - Índices de optimización
6. **06_procedures.sql** - Procedimientos de carga (CORREGIDO)
7. **07_data_load.sql** - Ejecución de carga completa

### Scripts Complementarios

- **06b_procedures.sql** - Procedimientos avanzados
- **08_views.sql** - Vistas de negocio
- **09_sample_queries.sql** - Consultas de ejemplo
- **10_cleanup.sql** - Limpieza de datos
- **11_load_csv_direct.sql** - Carga de datos de prueba
- **12_full_test.sql** - Suite de pruebas
- **13_audit_control.sql** - Sistema de auditoría
- **15_audit_queries.sql** - Consultas de auditoría
- **diagnostico_urgente.sql** - Diagnóstico rápido

### Archivo de Datos

- **nuevo_vehiculos.csv** - Dataset de 1000+ vehículos

## 🚀 Instalación

### Paso a Paso

```sql
-- 1. Como usuario DBA
@01_tablespaces_user.sql

-- 2. Como CARS_USER
@02_sequences.sql
@03_tables.sql
@04_constraints.sql
@05_indexes.sql
@06_procedures.sql
@13_audit_control.sql
@08_views.sql
```

## 📊 Carga de Datos Masivos

### Usando DataGrip

1. **Preparar tabla temporal:**
```sql
TRUNCATE TABLE TMP_CRAIGSLIST_VEHICLES;
```

2. **Importar CSV con DataGrip:**
   - Abrir `nuevo_vehiculos.csv` en DataGrip
   - Clic derecho → "Import Data to Database"
   - Seleccionar tabla `TMP_CRAIGSLIST_VEHICLES`
   - Mapear columnas correctamente
   - Ejecutar importación

3. **Ejecutar proceso ETL:**
```sql
@07_data_load.sql
```

## 🔧 Funcionalidades Principales

### Validación de Fechas Laborales
```sql
-- Función que valida horario laboral (Lunes-Viernes, 8:00-18:00)
SELECT VALIDATE_LOAD_DATE(SYSDATE) FROM DUAL;
```

### Sistema de Auditoría
- Registro automático de INSERT, UPDATE, DELETE
- Tabla AUDIT_CONTROL con triggers automáticos
- Consultas de auditoría disponibles en `15_audit_queries.sql`

### Vistas de Negocio
```sql
-- Vista completa de vehículos
SELECT * FROM VW_VEHICLES_COMPLETE;

-- Estadísticas por fabricante
SELECT * FROM VW_STATS_BY_MANUFACTURER;
```

## 🧪 Verificación y Pruebas

### Diagnóstico Rápido
```sql
@diagnostico_urgente.sql
```

### Suite Completa de Pruebas
```sql
@12_full_test.sql
```

### Consultas de Ejemplo
```sql
@09_sample_queries.sql
```

## ⚠️ Instrucciones Post-Corrección

**Para usar el sistema corregido:**

1. **Recrear procedimientos:**
```sql
CONNECT CARS_USER/A123@localhost:1521/xe
@06_procedures.sql
```

2. **Ejecutar carga:**
```sql
@07_data_load.sql
```

3. **Verificar resultados:**
```sql
@diagnostico_urgente.sql
SELECT COUNT(*) FROM VEHICLES;  -- Debe mostrar 1000+ registros
```

## 🔧 Correcciones Aplicadas (v1.0 Final)

- ✅ **Procedimiento LOAD_VEHICLES corregido** - Carga todos los registros
- ✅ **Normalización de comparaciones** - Uso de UPPER/LOWER 
- ✅ **Manejo mejorado de fechas** - Conversión robusta desde CSV
- ✅ **Logging detallado** - Seguimiento de errores
- ✅ **Performance:** 27 vehículos → 1000+ vehículos completos

---

**Proyecto completado por:** Daniel Arevalo - Alex Hernandez | Junio 2025
