# -----------------------------------------------------------
# 🔹RESUMEN DE MAPEOS... DE POWERSHELL:🔹
# -----------------------------------------------------------
#🔹 PSReadLine (predicciones y navegación)🔹

# F2 → Alterna entre ListView (lista) e InlineView (texto fantasma gris).

# Tab → MenuComplete → muestra un menú con opciones de comandos/carpetas/ejecutables.

# Ctrl+Space → (igual que Tab, si lo tienes mapeado) menú de completado.

# ↑ / ↓ → Historial normal de comandos.

# Ctrl+r (sin PSFzf) → búsqueda incremental de historial.

#🔹 PSFzf (historial + búsqueda con fzf)🔹

# Ctrl+r → Historial con fzf interactivo (mucho más potente que el de PSReadLine).

# Ctrl+t → Selector fzf de archivos/carpetas para autocompletar en la línea.

#🔹 Zoxide🔹

# cd <palabra> → salta rápido a carpetas visitadas (aprende de tu historial).

# z <palabra> → lo mismo que arriba (alias corto).

#🔹 Alias personalizados🔹

# ls-a → Get-ChildItem -Force (lista archivos ocultos, tipo ls -a).

#npm → apunta a npm.cmd (evita que salga el .cmd feo en autocompletado).

# -----------------------------------------------------------
# 🔹INSTALACION DE MODULOS🔹
# -----------------------------------------------------------

# 0. Instalacion previa de modulos.

#📌 IMPORTANTE: Los comandos de instalación (Install-Module)

# no deben estar en este archivo. Solo se ejecutan una vez.
# Instalaciones nuevas:
# Install-Module -Name ZLocation -Force
# Install-Module -Name CompletionPredictor -Force
# winget install ajeetdsouza.zoxide
# winget install --id GitHub.cli -e --source winget # instalar github gh cli
# winget install --id Microsoft.PowerToys -e --scope machine
# winget install fzf
# winget install junegunn.fzf
# Install-Module -Name PSFzf -Force
# gh extension install meiji163/gh-notify
# gh ext install meiji163/gh-notify
# scoop install fd
# scoop install ripgrep
# iwr -useb get.scoop.sh | iex

# 	DESINSTALA E INSTALA nodejs:
# scoop uninstall nodejs-lts
# scoop install nodejs-lts
# npm install -g neovim
# $env:PATH += ";C:\Users\Diego\scoop\shims"
# t
#                  [tu usuario]

#	 INSTALA python-pi:
# pip install pynvim
# pip install 'python-lsp-server[all]'

#📌 Otras instalaciones para NVIM dizzigentleman:

# 	INSTALA CHOCHO y luego mingw:
#Set-ExecutionPolicy Bypass -Scope Process -Force
#[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
#iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#choco install mingw

# LUEGO ABRE NVIM. Ejecuta: Lazy sync, luego: Mason [con 2 puntos :] .. y por ultimo:
# :MasonInstall --force prettier markdownlint-cli2 markdown-toc vtsls

# :MasonInstall --force angular-language-server lua-language-server marksman eslint-lsp eslint_d emmylua_ls markdown

# -----------------------------------------------------------
# 🔹ARCHIVO DE PERFIL DE POWERSHELL🔹
# -----------------------------------------------------------

# 1. Configuración de idioma
$env:PSCORE_ICU_INVARIANT = 1
$env:LC_ALL = 'es-ES'
$env:LANG = 'es-ES'

# 2. Inicialización de Oh My Posh
# La ruta puede variar, usa la correcta
#& 'C:\Users\Diego\AppData\Local\oh-my-posh\init.1485567614143659716.ps1'
$env:POSH_SESSION_ID = "0dc46671-78eb-4a28-9e0d-53c78ecf680c"; & 'C:\Users\Diego\AppData\Local\oh-my-posh\init.1485567614143659716.ps1'

# 3. 📌 Importación de módulos esenciales

Import-Module PSReadLine
Import-Module Terminal-Icons
Import-Module CompletionPredictor
Import-Module PSFzf
# Importar winwal [Pywal, para poder usarlo en WT, nvim wallwaper]
Import-Module ~\Documents\winwal\winwal.psm1 -DisableNameChecking
Import-Module ~\Documents\winwal\WalManager.psm1 -DisableNameChecking
# Luego ZLocation - para evitar sobreescribir el prompt suggestion.
Import-Module ZLocation

# PSScriptAnalyzer no necesita ser importado en el perfil.

# Autocompletado y autocorrección
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
#Set-PSReadLineOption -PredictionViewStyle ListView
# ¿Prefieras todo en una sola linea fantasma gris y no una lista? descomenta Inline y comenta Listview.
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true

# 🐔✍📌¡¡TRUCAZO!! En vez de remapear List view como Inline y perder la lista
# Simplemente presiona F2 para alternar de modo segun convenga!

# 4. Alias de ls
# Alias para que 'ls' muestre todo como ls -a
Set-Alias ls-a Get-ChildItem -Force

# 5. Arrancar zoxide para mejorar sugerencias con z.. z = cd
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

# 6. PSReadLine MenuComplete (Ctrl+Space)

# Esto hace que Tab abra el menú de comandos y ejecutables
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::MenuComplete($null)
}


# 7. Alias para npm
# Alias para evitar que npm.cmd se autocomplete en MenuComplete
# SOLUCION *esto pasaba porque .cmd era la unica opcion aparte de npm al ejecutar Ctrl+Space):
Set-Alias npm npm.cmd

# 8 configurar ruta de NPM Y NODE
$env:PATH += ";C:\Users\Diego\scoop\shims"
$env:PATH += ";C:\Users\Diego.DESKTOP-0CQHRL5\.npm-global\bin"

#9 PSFZF para buscar comandos [Ctrl+R] y [Ctrl+T] para Filtrar busqueda pro

Set-PsFzfOption -PSReadLineChordProvider 'Ctrl+t' -PSReadLineChordReverseHistory 'Ctrl+r'

#10 NOTEPAD - notepads.exe de la store xd

function notepad {
  param(
    [string]$Path = $null
  )
  if (-not $Path) {
    Start-Process -FilePath "notepads.exe"
  }
  else {
    $path = $Path.Replace("/", "\")
    Start-Process -FilePath "notepads.exe" -ArgumentList $path
  }
}
# 📌 [Abrir Antigravity o VSCode]
# Si Antigravity está instalado, lo abre; si no, abre > Cursor > VSCode
function code {
  param([string]$Path = ".")
  $antigravityPath = "$env:LOCALAPPDATA\Programs\Antigravity\Antigravity.exe"
  $cursorPath = "$env:LOCALAPPDATA\Programs\Cursor\Cursor.exe"
  $codePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"

  if ($Path -and $Path -ne ".") { $Path = $Path.Replace("/", "\") }

  if (Test-Path $antigravityPath) { & $antigravityPath $Path }
  elseif (Test-Path $cursorPath) { & $cursorPath $Path }
  elseif (Test-Path $codePath) { & $codePath $Path }
  else { & code.exe $Path }
}

# 📌 Abrir únicamente vscode (FUERA de la función code)
function vscode {
  param([string]$Path = ".")
  $codePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
  if ($Path -and $Path -ne ".") { $Path = $Path.Replace("/", "\") }
  if (Test-Path $codePath) { & $codePath $Path }
  else { & code.exe $Path }
}
