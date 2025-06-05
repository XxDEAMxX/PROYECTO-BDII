# Guía de Despliegue Rápido - Sistema de Gestión de Vehículos

## 🚀 Instalación Completa (5 minutos)

### Prerrequisitos
- Oracle Database 11g o superior
- SQL*Plus o SQL Developer
- Usuario con privilegios DBA (para crear tablespaces y usuarios)

### Paso 1: Instalación Automática
```sql
-- Conectar como DBA
sqlplus system/password@database

-- Ejecutar instalación completa
@MASTER_INSTALL.sql
```

### Paso 2: Cargar Datos (Elegir una opción)

#### Opción A: SQL*Loader (Recomendado)
```bash
sqlldr CARS_USER/A123@XE control=11_load_csv.ctl log=load_csv.log
sqlplus CARS_USER/A123@XE @07_data_load.sql
```

#### Opción B: PowerShell (Windows)
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
