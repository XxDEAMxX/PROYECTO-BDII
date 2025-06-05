@echo off
REM =====================================================
REM SCRIPT: load-data.bat
REM PROPOSITO: Ejecutar carga de datos CSV desde Windows
REM AUTOR: Daniel Arevalo - Alex Hernandez
REM FECHA: Junio 2025
REM =====================================================

echo ===============================================
echo SISTEMA DE GESTION DE VEHICULOS - CARGA DE DATOS
echo ===============================================
echo.

REM Verificar que PowerShell está disponible
powershell -Command "Get-Host" >nul 2>&1
if errorlevel 1 (
    echo ERROR: PowerShell no está disponible
    echo Instale PowerShell o use SQL*Loader manualmente
    pause
    exit /b 1
)

REM Ejecutar script PowerShell
echo Ejecutando carga automatizada...
powershell -ExecutionPolicy Bypass -File "Load-CSV-Data.ps1"

if errorlevel 1 (
    echo.
    echo ERROR: La carga automática falló
    echo Consulte el archivo load_csv.log para más detalles
    echo.
    echo Alternativas:
    echo 1. Usar SQL*Loader manualmente:
    echo    sqlldr CARS_USER/A123@XE control=11_load_csv.ctl
    echo 2. Usar datos de prueba:
    echo    sqlplus CARS_USER/A123@XE @11_load_csv_direct.sql
    pause
    exit /b 1
)

echo.
echo ===============================================
echo CARGA COMPLETADA
echo ===============================================
echo.
echo Para procesar los datos cargados, ejecute:
echo sqlplus CARS_USER/A123@XE @07_data_load.sql
echo.
pause
