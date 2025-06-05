# Sistema de Gestión de Vehículos - Documentación

## Descripción del Proyecto
Sistema de base de datos para gestionar información de vehículos de Craigslist, implementado en Oracle SQL con un modelo de datos normalizado.

## Estructura de Archivos

### Scripts de Instalación (Ejecutar en orden)
1. **01_tablespaces_user.sql** - Crea tablespaces y usuario del sistema
2. **02_sequences.sql** - Crea todas las secuencias para las claves primarias
3. **03_tables.sql** - Crea todas las tablas del modelo de datos
4. **04_constraints.sql** - Crea restricciones (PK, FK, UK, CHECK)
5. **05_indexes.sql** - Crea índices para optimización de consultas
6. **06_procedures.sql** - Crea procedimientos almacenados para carga de datos
7. **08_views.sql** - Crea vistas útiles para consultas

### Scripts de Operación
- **07_data_load.sql** - Ejecuta la carga completa de datos desde tabla temporal
- **09_sample_queries.sql** - Consultas de ejemplo y verificación
- **10_cleanup.sql** - Scripts de limpieza y mantenimiento
- **11_load_csv.ctl** - Archivo de control para SQL*Loader
- **11_load_csv.sql** - Script para facilitar uso de SQL*Loader
- **11_load_csv_direct.sql** - Carga directa de datos de prueba (alternativa)
- **12_full_test.sql** - Pruebas integrales del sistema
- **Load-CSV-Data.ps1** - Script PowerShell para carga automatizada

### Scripts Maestros
- **MASTER_INSTALL.sql** - Ejecuta toda la instalación automáticamente
- **load.sql** - Script original de procedimientos (para referencia)

## Instalación Rápida

### Opción 1: Instalación Automática
```sql
@MASTER_INSTALL.sql
```

### Opción 2: Instalación Manual
```sql
@01_tablespaces_user.sql
@02_sequences.sql
@03_tables.sql
@04_constraints.sql
@05_indexes.sql
@06_procedures.sql
@08_views.sql
```

## Carga de Datos

### Opción 1: SQL*Loader (Recomendado)
```bash
# Ejecutar SQL*Loader
sqlldr CARS_USER/A123@XE control=11_load_csv.ctl log=load_csv.log bad=load_csv.bad

# Procesar datos cargados
sqlplus CARS_USER/A123@XE @07_data_load.sql
```

### Opción 2: PowerShell Automatizado
```powershell
# Ejecutar script automatizado
.\Load-CSV-Data.ps1

# Procesar datos cargados
sqlplus CARS_USER/A123@XE @07_data_load.sql
```

### Opción 3: Datos de Prueba
```sql
-- Cargar datos de prueba directamente
@11_load_csv_direct.sql

-- Procesar datos cargados
@07_data_load.sql
```

### Opción 4: Manual con SQL*Loader Helper
```sql
-- Usar script helper
@11_load_csv.sql
```

## Modelo de Datos

### Tablas Principales
- **VEHICLES** - Tabla principal de vehículos
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

## Procedimientos Almacenados

### Procedimientos de Carga
- **LOAD_REGIONS** - Carga regiones
- **LOAD_MANUFACTURERS** - Carga fabricantes
- **LOAD_CONDITIONS** - Carga condiciones
- **LOAD_CYLINDERS** - Carga cilindros
- **LOAD_FUELS** - Carga combustibles
- **LOAD_TITLE_STATUSES** - Carga estados de título
- **LOAD_TRANSMISSIONS** - Carga transmisiones
- **LOAD_DRIVES** - Carga tracciones
- **LOAD_SIZES** - Carga tamaños
- **LOAD_TYPES** - Carga tipos
- **LOAD_PAINT_COLORS** - Carga colores
- **LOAD_VEHICLES** - Carga vehículos (tabla principal)

## Uso del Sistema

### Consultas Básicas
```sql
-- Ver estadísticas generales
SELECT * FROM VW_CATALOG_SUMMARY;

-- Top fabricantes
SELECT * FROM VW_STATS_BY_MANUFACTURER;

-- Vehículos disponibles
SELECT * FROM VW_VEHICLES_AVAILABLE WHERE PRICE < 20000;
```

### Consultas de Análisis
```sql
-- Ejecutar consultas de ejemplo
@09_sample_queries.sql
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
