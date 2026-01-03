#!/bin/bash
# Script para instalar extensiones en Antigravity/VSCode en Linux
# Generado desde Windows

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Instalador de Extensiones VSCode/Antigravity${NC}"
echo ""

# Detectar editor disponible
EDITOR=""
if command -v antigravity &>/dev/null; then
  EDITOR="antigravity"
  echo -e "${GREEN}✅ Detectado: Antigravity${NC}"
elif command -v code &>/dev/null; then
  EDITOR="code"
  echo -e "${GREEN}✅ Detectado: VSCode${NC}"
elif command -v codium &>/dev/null; then
  EDITOR="codium"
  echo -e "${GREEN}✅ Detectado: VSCodium${NC}"
else
  echo -e "${RED}❌ Error: No se encontró ningún editor compatible${NC}"
  echo "Instala uno de estos editores:"
  echo "  - Antigravity: paru -S antigravity-bin"
  echo "  - VSCode: paru -S visual-studio-code-bin"
  echo "  - VSCodium: paru -S vscodium-bin"
  exit 1
fi

# Archivo de extensiones
EXTENSIONS_FILE="vscode-extensions-final.txt"

if [ ! -f "$EXTENSIONS_FILE" ]; then
  echo -e "${RED}❌ No se encontró el archivo: $EXTENSIONS_FILE${NC}"
  echo "Copia el archivo desde Windows a esta carpeta"
  exit 1
fi

# Contadores
TOTAL=0
SUCCESS=0
FAILED=0
SKIPPED=0

# Extensiones conocidas que NO están en VSX (solo para Antigravity)
PROPRIETARY_EXTENSIONS=(
  "github.copilot"
  "github.copilot-chat"
  "ms-vscode.powershell"
  "ms-dotnettools.csdevkit"
  "ms-dotnettools.csharp"
)

echo ""
echo -e "${BLUE}📦 Instalando extensiones...${NC}"
echo "----------------------------------------"

# Crear archivo de fallos
FAILED_FILE="failed-extensions.txt"
>"$FAILED_FILE"

while IFS= read -r extension; do
  # Saltar líneas vacías
  if [ -z "$extension" ]; then
    continue
  fi

  TOTAL=$((TOTAL + 1))

  # Verificar si es extensión propietaria y estamos usando Antigravity
  IS_PROPRIETARY=false
  if [ "$EDITOR" = "antigravity" ]; then
    for prop_ext in "${PROPRIETARY_EXTENSIONS[@]}"; do
      if [ "$extension" = "$prop_ext" ]; then
        IS_PROPRIETARY=true
        break
      fi
    done
  fi

  if [ "$IS_PROPRIETARY" = true ]; then
    echo -e "${YELLOW}⚠️  [$TOTAL] Saltando (propietaria): $extension${NC}"
    echo "$extension # Propietaria - no disponible en VSX" >>"$FAILED_FILE"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  echo -e "${BLUE}[$TOTAL] Instalando: $extension${NC}"

  if $EDITOR --install-extension "$extension" --force 2>&1 | tee /tmp/install-output.txt | grep -q "successfully installed\|already installed"; then
    echo -e "  ${GREEN}✅ OK${NC}"
    SUCCESS=$((SUCCESS + 1))
  else
    if grep -q "not found\|Extension.*not found" /tmp/install-output.txt; then
      echo -e "  ${YELLOW}⚠️  NO DISPONIBLE en VSX${NC}"
      echo "$extension # No encontrada en VSX" >>"$FAILED_FILE"
    else
      echo -e "  ${RED}❌ ERROR${NC}"
      echo "$extension # Error de instalación" >>"$FAILED_FILE"
    fi
    FAILED=$((FAILED + 1))
  fi
  echo ""

done <"$EXTENSIONS_FILE"

# Resumen
echo "=========================================="
echo -e "${BLUE}📊 RESUMEN DE INSTALACIÓN${NC}"
echo "=========================================="
echo -e "Total de extensiones: ${BLUE}$TOTAL${NC}"
echo -e "✅ Instaladas exitosamente: ${GREEN}$SUCCESS${NC}"
echo -e "❌ Fallidas: ${RED}$FAILED${NC}"
echo -e "⚠️  Saltadas (propietarias): ${YELLOW}$SKIPPED${NC}"
echo ""

if [ $FAILED -gt 0 ]; then
  echo -e "${YELLOW}⚠️  Extensiones que fallaron:${NC}"
  cat "$FAILED_FILE"
  echo ""
  echo -e "${BLUE}💡 Para instalar extensiones que no están en VSX:${NC}"
  echo "1. Descarga el .vsix desde GitHub releases del proyecto"
  echo "2. O desde: https://marketplace.visualstudio.com"
  echo "3. Instala con: $EDITOR --install-extension archivo.vsix"
  echo ""
  echo -e "${BLUE}📝 Extensiones guardadas en: $FAILED_FILE${NC}"
fi

# Verificar extensión de Neovim (ya descargada)
if [ -f "asvetliakov.vscode-neovim-1.18.24.vsix" ]; then
  echo ""
  echo -e "${BLUE}🎯 Detectado archivo Neovim .vsix${NC}"
  read -p "¿Instalar extensión de Neovim desde .vsix? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Instalando Neovim desde .vsix..."
    if $EDITOR --install-extension asvetliakov.vscode-neovim-1.18.24.vsix; then
      echo -e "${GREEN}✅ Neovim instalado exitosamente${NC}"
    else
      echo -e "${RED}❌ Error instalando Neovim${NC}"
    fi
  fi
fi

echo ""
echo -e "${GREEN}✨ Instalación completada!${NC}"
echo "Reinicia $EDITOR para ver los cambios"
