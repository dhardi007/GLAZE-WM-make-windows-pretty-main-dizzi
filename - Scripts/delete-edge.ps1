
# Script PowerShell para eliminar Microsoft Edge - Versión que preserva EdgeWebView
param()

# Función para verificar si Edge existe
function Test-EdgeExists {
  $edgePaths = @(
    "C:\Program Files (x86)\Microsoft\Edge\Application",
    # "C:\Program Files (x86)\Microsoft\EdgeWebView",
    "$env:USERPROFILE\AppData\Local\Microsoft\Edge",
    "$env:USERPROFILE\AppData\Local\Microsoft\EdgeUserData",
    # "$env:USERPROFILE\AppData\Local\Microsoft\EdgeWebView",
    "$env:LOCALAPPDATA\Microsoft\Edge"
  )

  foreach ($path in $edgePaths) {
    if (Test-Path $path) {
      return $true
    }
  }
  return $false
}

# Verificar si hay algo que eliminar antes de pedir elevación
if (-NOT (Test-EdgeExists)) {
  Write-Host "Microsoft Edge no encontrado en el sistema. No hay nada que eliminar." -ForegroundColor Green
  exit
}

# Verificar y elevar privilegios si es necesario
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Microsoft Edge detectado. Elevando privilegios a Administrador..." -ForegroundColor Yellow

  # Re-ejecutar el script como administrador y CERRAR después
  $scriptPath = $myinvocation.mycommand.definition
  $arguments = "-File `"$scriptPath`""

  $process = Start-Process pwsh -Verb RunAs -ArgumentList $arguments -PassThru
  # Esperar a que el proceso elevado termine
  $process.WaitForExit()
  # Cerrar este proceso también
  exit
}

# ============================================
# A partir de aquí el script se ejecuta como administrador
# ============================================
Write-Host "=== EJECUTANDO COMO ADMINISTRADOR ===" -ForegroundColor Green
Write-Host "Eliminando Microsoft Edge (preservando EdgeWebView)..." -ForegroundColor Yellow

# Función para forzar cierre de procesos relacionados con Edge
function Stop-EdgeProcesses {
  Write-Host "Deteniendo todos los procesos de Edge (preservando EdgeWebView)..." -ForegroundColor Yellow

  $edgeProcessNames = @(
    "msedge",
    "MicrosoftEdge",
    # "edgewebview",
    # "msedgewebview2",  # NO detener EdgeWebView - usado por otras apps
    "MicrosoftEdgeUpdate",
    "edge"
  )

  $processesStopped = 0
  foreach ($processName in $edgeProcessNames) {
    try {
      $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
      if ($processes) {
        foreach ($process in $processes) {
          Write-Host "Deteniendo proceso: $($process.ProcessName) (PID: $($process.Id))" -ForegroundColor Cyan
          Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
          $processesStopped++
        }
      }
    }
    catch {
      Write-Host "No se pudo detener proceso $processName : $($_.Exception.Message)" -ForegroundColor Red
    }
  }

  if ($processesStopped -gt 0) {
    Write-Host "Esperando 3 segundos para que los procesos se cierren..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
  }
}

# Función para eliminar Edge excluyendo EBWebView
function Remove-EdgeExcludingWebView {
  param([string]$Path)

  if (-not (Test-Path $Path)) {
    Write-Host "La ruta no existe: $Path" -ForegroundColor Yellow
    return $true
  }

  # Si la ruta contiene "Application", excluir EBWebView
  if ($Path -like "*\Application") {
    Write-Host "Eliminando contenido de Application, EXCLUYENDO EBWebView (usado por otras apps)..." -ForegroundColor Cyan

    try {
      # Tomar ownership primero
      & takeown /f "$Path" /r /d y 2>&1 | Out-Null
      & icacls "$Path" /grant administrators:F /t 2>&1 | Out-Null

      # Eliminar todo EXCEPTO la carpeta EBWebView
      Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {
        $_.FullName -notlike "*\EBWebView\*"
      } | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

      Write-Host "✓ Eliminado Edge Application (preservando EBWebView)" -ForegroundColor Green
      return $true
    }
    catch {
      Write-Host "✗ Error al eliminar Application: $($_.Exception.Message)" -ForegroundColor Red
      return $false
    }
  }

  return $false
}

# Función para eliminar con múltiples intentos
function Remove-WithRetry {
  param(
    [string]$Path,
    [int]$MaxAttempts = 3
  )

  if (-not (Test-Path $Path)) {
    Write-Host "La ruta no existe: $Path" -ForegroundColor Yellow
    return $true
  }

  for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
    try {
      Write-Host "Intento $attempt para eliminar: $Path" -ForegroundColor Cyan

      # Tomar ownership primero
      try {
        & takeown /f "$Path" /r /d y 2>&1 | Out-Null
        & icacls "$Path" /grant administrators:F /t 2>&1 | Out-Null
      }
      catch { }

      Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
      Write-Host "✓ Eliminado exitosamente: $Path" -ForegroundColor Green
      return $true
    }
    catch {
      Write-Host "Intento $attempt falló: $($_.Exception.Message)" -ForegroundColor Red

      if ($attempt -lt $MaxAttempts) {
        Write-Host "Reintentando en 2 segundos..." -ForegroundColor Yellow
        Stop-EdgeProcesses
        Start-Sleep -Seconds 2
      }
    }
  }

  Write-Host "✗ No se pudo eliminar después de $MaxAttempts intentos: $Path" -ForegroundColor Red
  return $false
}

# MAIN EXECUTION
try {
  Stop-EdgeProcesses

  # Rutas a eliminar (SOLO Edge, NO EdgeWebView)
  $pathsToRemove = @(
    "C:\Program Files (x86)\Microsoft\Edge\Application",  # Solo Application, NO EdgeWebView
    # "C:\Program Files (x86)\Microsoft\EdgeWebView",  # NO eliminar - usado por otras apps
    "$env:USERPROFILE\AppData\Local\Microsoft\Edge",
    "$env:USERPROFILE\AppData\Local\Microsoft\EdgeUserData",
    # "$env:USERPROFILE\AppData\Local\Microsoft\EdgeWebView",  # NO eliminar - usado por otras apps
    "$env:LOCALAPPDATA\Microsoft\Edge"
  )

  # Procesar eliminación
  $successCount = 0
  $actualRemovals = 0

  Write-Host "`nIniciando eliminación de archivos..." -ForegroundColor Magenta

  foreach ($path in $pathsToRemove) {
    # Intentar eliminación especial para Application (excluyendo EBWebView)
    if (Remove-EdgeExcludingWebView -Path $path) {
      $successCount++
      Write-Host "---" -ForegroundColor Gray
      continue
    }

    # Eliminación normal para otras rutas
    if (Remove-WithRetry -Path $path) {
      $successCount++
      if (-not (Test-Path $path)) {
        $actualRemovals++
      }
    }
    Write-Host "---" -ForegroundColor Gray
  }

  # Resultados
  Write-Host "`n=== RESUMEN ===" -ForegroundColor Magenta
  Write-Host "Rutas procesadas: $($pathsToRemove.Count)" -ForegroundColor Cyan
  Write-Host "Rutas eliminadas exitosamente: $successCount" -ForegroundColor Green
  Write-Host "Archivos realmente eliminados: $actualRemovals" -ForegroundColor Cyan

  if ($actualRemovals -gt 0) {
    Write-Host "`n🎉 Microsoft Edge eliminado (EdgeWebView preservado)!" -ForegroundColor Green
  }
  else {
    Write-Host "`nℹ️  No se encontraron archivos de Edge para eliminar." -ForegroundColor Blue
  }

  # Verificación final
  Write-Host "`n=== VERIFICACIÓN FINAL ===" -ForegroundColor Magenta
  $mainEdgePath = "C:\Program Files (x86)\Microsoft\Edge\Application"
  $webViewPath = "C:\Program Files (x86)\Microsoft\Edge\Application\*\EBWebView"

  if (Test-Path $mainEdgePath) {
    Write-Host "⚠️  La carpeta Application todavía existe (puede contener EBWebView)" -ForegroundColor Yellow
    Write-Host "   Ubicación: $mainEdgePath" -ForegroundColor Yellow

    if (Test-Path $webViewPath) {
      Write-Host "✅ EBWebView preservado correctamente (usado por otras apps)" -ForegroundColor Green
    }
  }
  else {
    Write-Host "✅ Carpeta Application de Edge eliminada correctamente" -ForegroundColor Green
  }
}
finally {
  # ESTO SIEMPRE SE EJECUTA, INCLUSO SI HAY ERRORES
  Write-Host "`nCerrando PowerShell en 2 segundos..." -ForegroundColor Cyan
  Start-Sleep -Seconds 2
  exit
}
