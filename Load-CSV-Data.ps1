# =====================================================
# SCRIPT: Load-CSV-Data.ps1
# PROPOSITO: Script PowerShell para cargar datos CSV automáticamente
# AUTOR: Daniel Arevalo - Alex Hernandez
# FECHA: Junio 2025
# =====================================================

param(
    [string]$User = "CARS_USER",
    [string]$Password = "A123",
    [string]$Database = "XE"
)

Write-Host "===============================================" -ForegroundColor Green
Write-Host "CARGA AUTOMATIZADA DE DATOS CSV" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Verificar que existe el archivo CSV
if (-not (Test-Path "nuevo_vehiculos.csv")) {
    Write-Host "ERROR: No se encontró el archivo nuevo_vehiculos.csv" -ForegroundColor Red
    exit 1
}

# Verificar que existe el archivo de control
if (-not (Test-Path "11_load_csv.ctl")) {
    Write-Host "ERROR: No se encontró el archivo 11_load_csv.ctl" -ForegroundColor Red
    exit 1
}

Write-Host "Archivos encontrados:" -ForegroundColor Yellow
Write-Host "- nuevo_vehiculos.csv: $(Get-Item 'nuevo_vehiculos.csv' | Select-Object -ExpandProperty Length) bytes"
Write-Host "- 11_load_csv.ctl: $(Get-Item '11_load_csv.ctl' | Select-Object -ExpandProperty Length) bytes"

# Ejecutar SQL*Loader
Write-Host "`nEjecutando SQL*Loader..." -ForegroundColor Yellow
$sqlldrCommand = "sqlldr $User/$Password@$Database control=11_load_csv.ctl log=load_csv.log bad=load_csv.bad discard=load_csv.dsc"
Write-Host "Comando: $sqlldrCommand" -ForegroundColor Cyan

try {
    & cmd.exe /c $sqlldrCommand
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Host "`n✓ SQL*Loader ejecutado exitosamente" -ForegroundColor Green
    } else {
        Write-Host "`n⚠ SQL*Loader terminó con código: $exitCode" -ForegroundColor Yellow
    }
} catch {
    Write-Host "`n✗ Error ejecutando SQL*Loader: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Mostrar resultados
if (Test-Path "load_csv.log") {
    Write-Host "`n=== RESUMEN DE CARGA ===" -ForegroundColor Green
    $logContent = Get-Content "load_csv.log" | Where-Object { $_ -match "successfully loaded|rejected|discarded|Total logical records" }
    $logContent | ForEach-Object { Write-Host $_ -ForegroundColor White }
    
    # Verificar si hay errores
    if (Test-Path "load_csv.bad") {
        $badRecords = Get-Content "load_csv.bad" | Measure-Object -Line
        if ($badRecords.Lines -gt 0) {
            Write-Host "`n⚠ Se encontraron $($badRecords.Lines) registros con errores en load_csv.bad" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n=== SIGUIENTE PASO ===" -ForegroundColor Green
Write-Host "Para procesar los datos cargados, ejecute:" -ForegroundColor White
Write-Host "sqlplus $User/$Password@$Database @07_data_load.sql" -ForegroundColor Cyan

Write-Host "`n===============================================" -ForegroundColor Green
