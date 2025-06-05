# Guía de Despliegue - Sistema de Gestión de Vehículos

**Autores:** Daniel Arevalo - Alex Hernandez  
**Fecha:** Junio 2025  
**Versión:** 2.0 (Con Sistema de Auditoría Completo)

## 🎯 Objetivo

Desplegar el sistema completo de gestión de vehículos con control de auditoría automático que registra todas las operaciones DML según los requisitos del proyecto.

## ✅ Checklist Pre-Instalación

- [ ] Oracle Database 11g o superior instalado y funcionando
- [ ] Usuario DBA disponible para crear tablespaces y usuarios
- [ ] Mínimo 100MB de espacio en disco disponible
- [ ] SQL*Plus o herramienta compatible instalada
- [ ] Todos los archivos SQL del proyecto disponibles

## 🚀 Proceso de Instalación

### Paso 1: Instalación Automática (RECOMENDADO)

```sql
-- Conectar como usuario DBA
sqlplus sys/password@XE as sysdba

-- Ejecutar instalación completa
@MASTER_INSTALL.sql
```

**✅ Resultado esperado:** 
- Sistema base instalado
- Sistema de auditoría activado
- Mensaje: "INSTALACIÓN COMPLETADA EXITOSAMENTE"

### Paso 2: Verificar Instalación

```sql
-- Verificar usuario y tablespaces
SELECT USERNAME, CREATED FROM DBA_USERS WHERE USERNAME = 'CARS_USER';

-- Verificar tablas principales
SELECT TABLE_NAME FROM USER_TABLES ORDER BY TABLE_NAME;

-- Verificar sistema de auditoría
SELECT COUNT(*) AS AUDIT_TRIGGERS FROM USER_TRIGGERS WHERE TRIGGER_NAME LIKE 'TRG_%';
```

**✅ Resultado esperado:**
- Usuario CARS_USER creado
- 8 tablas principales creadas
- 15+ triggers de auditoría activos

## 📊 Pruebas del Sistema de Auditoría

### Paso 3: Probar Sistema de Auditoría

```sql
-- Ejecutar pruebas de auditoría
@14_test_audit.sql
```

**✅ Resultado esperado:**
- Registros de INSERT, UPDATE, DELETE en AUDIT_CONTROL
- Vistas de auditoría funcionando correctamente
- Contadores de operaciones registrados

### Paso 4: Verificar Consultas de Auditoría

```sql
-- Ejecutar consultas de auditoría
@15_audit_queries.sql
```

**✅ Resultado esperado:**
- Resumen de actividad por tabla
- Estadísticas por usuario
- Análisis de rendimiento

## 📈 Carga de Datos

### Paso 5: Cargar Datos de Prueba

**Opción A: Datos de Prueba Directos**
```sql
@11_load_csv_direct.sql
@07_data_load.sql
```

**Opción B: PowerShell Automatizado**
```powershell
.\Load-CSV-Data.ps1
sqlplus CARS_USER/A123@XE @07_data_load.sql
```

#### Opción C: Datos de Prueba
```sql
sqlplus CARS_USER/A123@XE @11_load_csv_direct.sql
sqlplus CARS_USER/A123@XE @07_data_load.sql
```

### Paso 3: Verificar Instalación
```sql
sqlplus CARS_USER/A123@XE @12_full_test.sql
```

## ✅ Verificación Rápida

```sql
-- Conectar al sistema
sqlplus CARS_USER/A123@XE

-- Verificar datos
SELECT COUNT(*) AS total_vehiculos FROM VEHICLES;
SELECT manufacturer, COUNT(*) AS cantidad 
FROM VW_VEHICLES_COMPLETE 
GROUP BY manufacturer 
ORDER BY cantidad DESC;
```

## 🔧 Solución de Problemas Comunes

### Error: "Tablespace no existe"
```sql
-- Verificar tablespaces
SELECT tablespace_name FROM dba_tablespaces;
-- Si no existen, ejecutar: @01_tablespaces_user.sql
```

### Error: "Usuario no existe"
```sql
-- Verificar usuario
SELECT username FROM dba_users WHERE username = 'CARS_USER';
-- Si no existe, ejecutar: @01_tablespaces_user.sql
```

### Error en carga de CSV
```bash
# Verificar archivo existe
ls -la nuevo_vehiculos.csv
# Verificar permisos de archivo
chmod 644 nuevo_vehiculos.csv
```

## 📊 Consultas Útiles

```sql
-- Top 10 fabricantes
SELECT * FROM VW_STATS_BY_MANUFACTURER WHERE ROWNUM <= 10;

-- Vehículos por región
SELECT * FROM VW_STATS_BY_REGION WHERE ROWNUM <= 10;

-- Vehículos disponibles bajo $15,000
SELECT * FROM VW_VEHICLES_AVAILABLE WHERE PRICE < 15000;
```

## 🧹 Limpieza (Si es necesario)

```sql
-- ⚠️ CUIDADO: Esto borra todos los datos
@10_cleanup.sql

-- Para reinstalar desde cero
@MASTER_INSTALL.sql
```

## 📞 Soporte

- Revisar logs de instalación
- Verificar permisos de usuario
- Consultar README.md para documentación completa
- Ejecutar 12_full_test.sql para diagnóstico completo
