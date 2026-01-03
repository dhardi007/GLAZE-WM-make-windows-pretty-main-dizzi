# 1. Encuentra dónde están tus extensiones de VSCode
ls "$env:USERPROFILE\.vscode\extensions" | Select-Object -ExpandProperty Name > vscode-extensions-folders.txt

# 2. Encuentra extensiones de Antigravity
ls "$env:LOCALAPPDATA\Antigravity\extensions" | Select-Object -ExpandProperty Name > antigravity-extensions-folders.txt

# 3. O busca en todas las ubicaciones posibles
Get-ChildItem -Path "$env:USERPROFILE\.vscode\extensions", "$env:LOCALAPPDATA\Antigravity\extensions", "$env:APPDATA\Code\User\extensions" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name | Sort-Object -Unique > todas-extensiones.txt

# 4. Verifica el resultado
cat todas-extensiones.txt

# Script para limpiar los nombres
Get-ChildItem "$env:USERPROFILE\.vscode\extensions" | ForEach-Object {
    $name = $_.Name
    # Remover versiones (números después del último -)
    if ($name -match '^(.+?-[\w-]+?)-\d+\.\d+\.\d+') {
        $matches[1]
    } else {
        $name -replace '-\d+\.\d+.*$', ''
    }
} | Sort-Object -Unique > vscode-extensions-clean.txt

cat vscode-extensions-clean.txt
```

## 📋 O manualmente desde lo que mostraste:

Según tu lista, tienes estas extensiones (extraigo algunas):
```
asvetliakov.vscode-neovim
bierner.color-info
bradlc.vscode-tailwindcss
github.copilot
github.copilot-chat
esbenp.prettier-vscode
eamodio.gitlens
ms-python.python
ms-vscode.live-server

# Eliminar líneas inválidas (.obsolete, .ae2a378e, extensions.json)
Get-Content vscode-extensions-clean.txt | Where-Object {
    $_ -notmatch '^\.' -and 
    $_ -notmatch 'extensions\.json' -and
    $_ -match '\w+\.\w+'
} | Set-Content vscode-extensions-final.txt

# Verifica
cat vscode-extensions-final.txt