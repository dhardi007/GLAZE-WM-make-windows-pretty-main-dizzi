# 🔧 Solución: GlazeWM v3.9.1 - Huecos y Resize

## ✅ Problemas Resueltos

### 1. "Huecos" entre ventanas - ERAN LOS BORDES

- ❌ **NO eran gaps** - Los gaps estaban correctamente en `0px`
- ✅ **ERAN LOS BORDES** - `window_effects.border.enabled: true` creaba líneas entre ventanas
- **Solución:** Bordes desactivados (`enabled: false`)
- **Alternativa:** Si quieres bordes delgados sin huecos visibles, puedes reactivarlos

### 2. Resize "no funciona" - Ventanas en FLOATING

- ⚠️ **El resize funciona DIFERENTE en floating vs tiling**
- En **TILING**: `resize` ajusta la proporción entre ventanas adyacentes
- En **FLOATING**: `resize` cambia el tamaño absoluto de la ventana
- **Solución:** Asegúrate de estar en modo **TILING** (`Alt + T`)
- Si prefieres floating, usa `Alt + F` y redimensiona manualmente con el mouse

### 3. Resize Mejorado (para TILING)

He aumentado el porcentaje de resize de **2% → 5%** para que sea más notorio:

**Atajos de resize:**

- `Alt + Ctrl + H/L` (o flechas izq/der): Cambiar ancho ±5%
- `Alt + Ctrl + K/J` (o flechas arriba/abajo): Cambiar alto ±5%
- `Alt + R`: Activar **modo resize** (luego usa solo H/J/K/L o flechas)
  - Presiona `ESC` o `Enter` para salir del modo resize

## 🎯 Cambios Aplicados

### Bordes Desactivados (elimina los "huecos")

```yaml
window_effects:
  focused_window:
    border:
      enabled: false  # ✅ DESACTIVADO
  other_windows:
    border:
      enabled: false  # ✅ DESACTIVADO
```

### Gaps Correctos (ya estaban bien)

```yaml
gaps:
  inner_gap: "0px"  # Sin espacios entre ventanas
  outer_gap:
    top: "0px"
    right: "0px"
    bottom: "0px"
    left: "0px"
```

### Resize Mejorado

```yaml
# Modo resize (Alt + R)
- name: "resize"
  keybindings:
    - commands: ["resize --width -5%"]   # H o ←
    - commands: ["resize --width +5%"]   # L o →
    - commands: ["resize --height +5%"]  # K o ↑
    - commands: ["resize --height -5%"]  # J o ↓
```

## 🧪 Cómo Probar AHORA

### 1. Recargar configuración

```powershell
Alt + Shift + R
```

### 2. Verificar que los huecos desaparecieron

- Abre 2-3 ventanas
- **NO deberías ver líneas/bordes entre ellas**
- Si aún ves espacios, son márgenes de la aplicación misma

### 3. Probar resize en TILING

**IMPORTANTE:** Asegúrate de estar en modo TILING

1. Abre 2 ventanas
2. Presiona `Alt + T` en cada una para asegurar que están en tiling
3. Presiona `Alt + R` para entrar en modo resize
4. Usa `H/J/K/L` o flechas para redimensionar
5. Presiona `ESC` para salir
6. **Deberías ver cambios notorios** (5% por tecla)

### 4. Cambiar entre Tiling y Floating

- `Alt + T`: Cambiar a modo **TILING** (resize funciona entre ventanas)
- `Alt + F`: Cambiar a modo **FLOATING** (ventana libre, redimensiona con mouse)

## 📊 Comparación: Tiling vs Floating

| Característica | TILING | FLOATING |
|----------------|--------|----------|
| **Posición** | Automática (grid) | Manual (libre) |
| **Resize** | Ajusta proporción entre ventanas | Cambia tamaño absoluto |
| **Uso de resize** | `Alt + R` + flechas | Menos útil, usa mouse |
| **Bordes** | Se notan más | Se notan menos |
| **Recomendado para** | Productividad, múltiples ventanas | Ventanas únicas, diálogos |

## 🚀 Próximos Pasos

### 1. Recargar GlazeWM

```powershell
Alt + Shift + R
```

### 2. Si quieres bordes delgados SIN huecos notorios

Edita `config.yaml`:

```yaml
window_effects:
  focused_window:
    border:
      enabled: true
      color: "#bea3c7"
  other_windows:
    border:
      enabled: true
      color: "#a1a1a1"
```

Luego recarga con `Alt + Shift + R`

### 3. Si el resize sigue sin funcionar

- ✅ Verifica que estés en modo **TILING** (no floating)
- ✅ Asegúrate de tener **al menos 2 ventanas** en el workspace
- ✅ Prueba con `Alt + R` para entrar en modo resize dedicado
- ✅ Si la ventana está en floating, presiona `Alt + T` primero

## 📚 Comandos Útiles

| Atajo | Acción |
|-------|--------|
| `Alt + T` | Cambiar a modo TILING |
| `Alt + F` | Cambiar a modo FLOATING |
| `Alt + R` | Activar modo RESIZE |
| `Alt + V` | Cambiar dirección de tiling (horizontal/vertical) |
| `Alt + Shift + R` | Recargar configuración |
| `Alt + Shift + W` | Redibujar todas las ventanas |

## 🔍 Resumen de Cambios

- ✅ **Bordes desactivados** - Elimina los "huecos" visuales
- ✅ **Resize aumentado** de 2% → 5% - Cambios más notorios
- ✅ **Sintaxis v3** - Removido `--centered` de `toggle-floating`
- ✅ **Documentación** - Explicación de tiling vs floating

---

**Nota Final:** El problema principal eran los **bordes**, no los gaps. Ahora con `border.enabled: false`, las ventanas deberían estar completamente pegadas sin espacios visibles.
