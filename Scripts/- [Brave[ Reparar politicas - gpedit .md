# Eliminar políticas de Brave del Registro
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Name "BraveAIChatEnabled" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\BraveSoftware\Brave" -Name "BraveAIChatEnabled" -ErrorAction SilentlyContinue

# Verificar que se eliminó
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -ErrorAction SilentlyContinue
Get-ItemProperty -Path "HKCU:\SOFTWARE\Policies\BraveSoftware\Brave" -ErrorAction SilentlyContinue

# Cerrar Brave completamente
Stop-Process -Name "brave" -Force -ErrorAction SilentlyContinue

# Esperar 2 segundos
Start-Sleep -Seconds 2

# Abrir Brave de nuevo
Start-Process "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
```

3. **Verifica** en `brave://policy` que `BraveAIChatEnabled` **ya no aparezca**

4. **Ve a** `brave://settings/appearance` y busca "Mostrar el botón de Leo AI"

---

# ========================================
# * -- ESTA ME FUNCIONO!!! -- *
# ========================================
### Opción 2: Editor de Registro (Manual)
# ========================================
Si prefieres hacerlo visual:

1. `Win + R` → escribe: `regedit` → Enter

2. Navega a:
```
   HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave
```

3. Busca la clave `BraveAIChatEnabled`

4. **Elimínala** (clic derecho → Eliminar)

5. También verifica en:
```
   HKEY_CURRENT_USER\SOFTWARE\Policies\BraveSoftware\Brave
```

6. **Cierra Brave** y ábrelo de nuevo

---

### Opción 3: Brave Portable (Si no tienes permisos de admin)

Si no puedes modificar el registro porque no eres administrador:

1. **Descarga Brave Portable**: https://portapps.io/app/brave-portable/

2. **Descomprime** en cualquier carpeta (ej: `C:\BravePortable\`)

3. **Ejecuta** `brave-portable.exe`

La versión portable **ignora completamente las políticas del sistema**.

---

## 🤔 ¿Quién Configuró Esa Política?

Posibles culpables:

- **Antivirus corporativo** (McAfee, Norton, Kaspersky empresarial)
- **Software de administración remota** (TeamViewer, AnyDesk con políticas)
- **Configuración previa de IT** si la laptop fue de una empresa/universidad
- **Configuración accidental** si jugaste con `gpedit.msc` antes

---

## ✅ Verificación Final

Después de eliminar la política, en `brave://policy` deberías ver:
```
No hay políticas establecidas.