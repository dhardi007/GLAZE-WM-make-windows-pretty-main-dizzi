# Script para desactivar SOLO los bordes en el config activo
# Sin borrar ninguna otra configuración

$configPath = "C:\Users\Diego\.glzr\glazewm\config.yaml"

Write-Host "🔧 DESACTIVANDO BORDES EN CONFIG ACTIVO..." -ForegroundColor Cyan
Write-Host ""

# Crear backup
$backup = "$configPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item $configPath $backup
Write-Host "📦 Backup creado: $backup" -ForegroundColor Green
Write-Host ""

# Leer el archivo
$content = Get-Content $configPath -Raw

# Contar cuántos bordes están activados
$enabledCount = ([regex]::Matches($content, 'border:[\s\S]*?enabled:\s*true')).Count
Write-Host "🔍 Encontrados $enabledCount bordes activados" -ForegroundColor Yellow
Write-Host ""

# CAMBIO: Desactivar SOLO los bordes (focused_window y other_windows)
Write-Host "🔹 Desactivando bordes..." -ForegroundColor Yellow

# Reemplazar enabled: true por enabled: false SOLO en la sección de border
$content = $content -replace '(border:\s*\r?\n\s*enabled:\s*)true', '$1false'

# Guardar cambios
$content | Set-Content $configPath -NoNewline

Write-Host ""
Write-Host "✅ BORDES DESACTIVADOS" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Cambio realizado:" -ForegroundColor Cyan
Write-Host "  ✅ border.enabled: true → false" -ForegroundColor White
Write-Host ""
Write-Host "🔄 RECARGA GLAZEWM:" -ForegroundColor Yellow
Write-Host "   Alt + Shift + R" -ForegroundColor White
Write-Host ""
Write-Host "🎯 RESULTADO:" -ForegroundColor Cyan
Write-Host "   ❌ Sin líneas/bordes entre ventanas" -ForegroundColor White
Write-Host "   ✅ Todo lo demás intacto (gaps, workspaces, keybindings, etc.)" -ForegroundColor White
Write-Host ""
