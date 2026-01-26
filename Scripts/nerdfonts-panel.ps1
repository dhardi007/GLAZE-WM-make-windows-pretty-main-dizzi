# Nerd Fonts Panel - Compatible con cualquier navegador
try {
    Write-Host "🎨 Iniciando Nerd Fonts Panel Universal..." -ForegroundColor Cyan

    # Función para encontrar navegadores instalados
    function Find-Browsers {
        $browsers = @()
        
        # Navegadores comunes con sus rutas
        $commonBrowsers = @(
            @{ Name = "Firefox"; Paths = @(
                "C:\Program Files\Mozilla Firefox\firefox.exe",
                "C:\Program Files (x86)\Mozilla Firefox\firefox.exe",
                "$env:LOCALAPPDATA\Mozilla Firefox\firefox.exe"
            )},
            @{ Name = "Chrome"; Paths = @(
                "C:\Program Files\Google\Chrome\Application\chrome.exe",
                "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
                "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
            )},
            @{ Name = "Edge"; Paths = @(
                "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
                "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
            )},
            @{ Name = "Brave"; Paths = @(
                "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe",
                "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"
            )},
            @{ Name = "Opera"; Paths = @(
                "C:\Program Files\Opera\launcher.exe",
                "$env:LOCALAPPDATA\Programs\Opera\launcher.exe"
            )},
            @{ Name = "Vivaldi"; Paths = @(
                "C:\Program Files\Vivaldi\Application\vivaldi.exe",
                "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"
            )}
        )
        
        foreach ($browser in $commonBrowsers) {
            foreach ($path in $browser.Paths) {
                if (Test-Path $path) {
                    $browsers += @{
                        Name = $browser.Name
                        Path = $path
                    }
                    Write-Host "✅ $($browser.Name) encontrado: $path" -ForegroundColor Green
                    break
                }
            }
        }
        
        return $browsers
    }

    # Función para abrir URL en navegador predeterminado (MÉTODO UNIVERSAL)
    function Open-DefaultBrowser {
        param([string]$Url)
        
        # Método 1: Usar Start-Process (más confiable para navegador predeterminado)
        Write-Host "🌐 Abriendo en navegador predeterminado: $Url" -ForegroundColor Yellow
        Start-Process $Url
        
        # Devolver el proceso (puede ser explorer.exe u otro)
        Start-Sleep -Milliseconds 500
        return Get-Process | Where-Object { $_.MainWindowTitle -like "*Nerd Fonts*" -or $_.MainWindowTitle -like "*cheat-sheet*" } | Select-Object -First 1
    }

    # Encontrar navegadores disponibles
    Write-Host "🔍 Buscando navegadores instalados..." -ForegroundColor Gray
    $availableBrowsers = Find-Browsers
    
    if ($availableBrowsers.Count -eq 0) {
        Write-Host "❌ No se encontraron navegadores. Usando método predeterminado." -ForegroundColor Yellow
    } else {
        Write-Host "📊 Navegadores encontrados: $($availableBrowsers.Count)" -ForegroundColor Green
        $availableBrowsers | ForEach-Object { Write-Host "   - $($_.Name)" -ForegroundColor Cyan }
    }

    $nerdFontsURL = "https://www.nerdfonts.com/cheat-sheet"
    
    # ABRIR CON NAVEGADOR PREDETERMINADO (MÉTODO UNIVERSAL)
    Write-Host "🚀 Abriendo Nerd Fonts Cheat Sheet..." -ForegroundColor Cyan
    $browserProcess = Open-DefaultBrowser -Url $nerdFontsURL
    
    Write-Host "⏳ Esperando a que cargue la página..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1

    # CONFIGURAR TAMAÑO Y POSICIÓN DE VENTANA
    Write-Host "📐 Configurando ventana..." -ForegroundColor Cyan
    Add-Type -AssemblyName System.Windows.Forms
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea

    # Tamaño optimizado para ver iconos (35% ancho, 80% alto)
    $width = [int]($screen.Width * 0.35)
    $height = [int]($screen.Height * 0.8)
    $x = [int](($screen.Width - $width) / 2)
    $y = [int](($screen.Height - $height) / 2)

    Write-Host "🖥️  Pantalla: $($screen.Width)x$($screen.Height)" -ForegroundColor Gray
    Write-Host "📏 Ventana: ${width}x${height} en [${x}, ${y}]" -ForegroundColor Green

    # FUNCIONES PARA MANIPULAR VENTANAS
    Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    
    [DllImport("user32.dll", SetLastError = true)]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);
    
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);
}
"@

    # BUSCAR Y REDIMENSIONAR VENTANA DEL NAVEGADOR
    Write-Host "🔍 Buscando ventana del navegador..." -ForegroundColor Gray
    $maxAttempts = 10
    $success = $false
    
    for ($i = 1; $i -le $maxAttempts; $i++) {
        Write-Host "   Intento $i/$maxAttempts..." -ForegroundColor Gray
        
        # Buscar entre todos los procesos de navegadores conocidos
        $browserProcesses = Get-Process | Where-Object {
            $_.ProcessName -match "(firefox|chrome|msedge|brave|opera|vivaldi)" -and 
            $_.MainWindowHandle -ne [IntPtr]::Zero -and
            $_.MainWindowTitle -notlike "" -and
            $_.MainWindowTitle -notlike "Default IME"
        }
        
        foreach ($proc in $browserProcesses) {
            # Verificar si la ventana tiene el título de Nerd Fonts
            $windowTitle = $proc.MainWindowTitle
            if ($windowTitle -like "*Nerd Fonts*" -or $windowTitle -like "*cheat-sheet*" -or $windowTitle -like "*nerdfonts.com*") {
                Write-Host "✅ Ventana encontrada: $windowTitle" -ForegroundColor Green
                
                $hwnd = $proc.MainWindowHandle
                
                # Mover y redimensionar
                [Win32]::SetWindowPos($hwnd, [IntPtr]::Zero, $x, $y, $width, $height, 0x0040)
                [Win32]::ShowWindow($hwnd, 9)  # SW_RESTORE = 9
                
                $success = $true
                Write-Host "✨ Nerd Fonts Panel configurado exitosamente!" -ForegroundColor Cyan
                break
            }
        }
        
        if ($success) { break }
        # Start-Sleep -Seconds 1
    }
    
    if (-not $success) {
        Write-Host "⚠️  No se pudo redimensionar automáticamente, pero el navegador está abierto." -ForegroundColor Yellow
        Write-Host "💡 Puedes redimensionar manualmente la ventana." -ForegroundColor Gray
    }

} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 El navegador debería estar abierto aunque haya errores de redimensionado." -ForegroundColor Yellow
}

Write-Host "🎯 Script completado." -ForegroundColor Green
exit
