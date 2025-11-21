import asyncio
import websockets
import json
import subprocess
import time

async def try_connect(ports):
    for port in ports:
        try:
            uri = f"ws://localhost:{port}"
            print(f"🔍 Intentando conectar a {uri}...")
            websocket = await asyncio.wait_for(
                websockets.connect(uri), 
                timeout=3
            )
            print(f"✅ Conectado al puerto {port}")
            return websocket
        except Exception as e:
            print(f"❌ Puerto {port} falló: {e}")
            continue
    return None

async def send_glazewm_command(*args):
    """Envía un comando a GlazeWM usando la sintaxis correcta"""
    try:
        command_list = ["glazewm", "command"] + list(args)
        print(f"📝 Ejecutando: {' '.join(command_list)}")
        
        result = subprocess.run(
            command_list,
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            print(f"✅ Comando ejecutado: {' '.join(args)}")
            return True
        else:
            print(f"❌ Error en comando {' '.join(args)}: {result.stderr}")
            return False
    except Exception as e:
        print(f"💥 Error ejecutando comando {' '.join(args)}: {e}")
        return False

async def smart_vertical_tiling_manager(websocket):
    """Gestor INTELIGENTE de tiling vertical - VERSIÓN FINAL"""
    print("🎯 GESTOR INTELIGENTE DE TILING VERTICAL ACTIVADO")
    
    try:
        # Solo suscribirse a eventos esenciales
        await websocket.send("sub -e focused_container_moved")
        
        # Estado para tracking
        workspace_windows = {}
        last_action_time = 0
        
        while True:
            response = await websocket.recv()
            json_data = json.loads(response)
            
            # Manejo robusto de errores
            if not isinstance(json_data, dict):
                continue
                
            message_type = json_data.get("messageType", "")
            
            if message_type == "event_subscription":
                data = json_data.get("data", {})
                if not data:
                    continue
                    
                event_type = data.get("eventType", "")
                
                if event_type == "focused_container_moved":
                    window = data.get("focusedContainer", {})
                    if window:
                        await handle_tiling_transition(window, websocket)
                        
            # Pausa para no saturar
            await asyncio.sleep(0.1)
                    
    except Exception as e:
        print(f"💥 Error en gestor: {e}")
        return False
    return True

async def handle_tiling_transition(window, websocket):
    """Maneja transiciones de estado de ventanas - VERSIÓN OPTIMIZADA"""
    try:
        state = window.get("state", {})
        prev_state = window.get("prevState", {})
        
        state_type = state.get("type", "") if state else ""
        prev_state_type = prev_state.get("type", "") if prev_state else ""
        is_tiling = window.get("tilingSize") is not None
        
        # SOLO DETECTAR CAMBIO DE FLOATING A TILING (Alt+T)
        if (prev_state_type == "floating" and state_type == "tiling" and is_tiling):
            print("🎯 ALT+T DETECTADO - Aplicando tiling vertical inteligente...")
            await apply_intelligent_vertical_tiling(window)
            
    except Exception as e:
        print(f"⚠️ Error en transición: {e}")

async def apply_intelligent_vertical_tiling(window):
    """Aplica tiling vertical de manera inteligente"""
    try:
        # 1. Pequeña pausa para que GlazeWM procese el cambio
        await asyncio.sleep(0.3)
        
        # 2. Forzar dirección VERTICAL (toggle una vez es suficiente)
        await send_glazewm_command("toggle-tiling-direction")
        print("⬇️  Dirección vertical forzada")
        
        # 3. Ajustar tamaño basado en la situación
        await asyncio.sleep(0.2)
        
        # Estrategia de tamaño inteligente:
        # - Primera ventana: 70%
        # - Segunda ventana: 50% 
        # - Tercera+: 33%
        current_size = window.get("tilingSize", 1.0)
        
        if current_size >= 0.85:  # Probablemente primera ventana
            await send_glazewm_command("resize", "--height", "75%")
            print("📏 Tamaño ajustado: 70% (primera ventana)")
        elif current_size >= 0.6:  # Segunda ventana
            await send_glazewm_command("resize", "--height", "7%") 
            print("📏 Tamaño ajustado: 50% (segunda ventana)")
        else:  # Tercera o más ventanas
            await send_glazewm_command("resize", "--height", "7%")
            print("📏 Tamaño ajustado: 33% (múltiples ventanas)")
            
        print("✅ Tiling vertical aplicado exitosamente, Vegetta777!")
        
    except Exception as e:
        print(f"⚠️ Error aplicando tiling vertical: {e}")

async def floating_window_manager(websocket):
    """Gestor opcional para ventanas flotantes (sin center-window)"""
    try:
        await websocket.send("sub -e window_managed")
        
        while True:
            response = await websocket.recv()
            json_data = json.loads(response)
            
            if isinstance(json_data, dict) and json_data.get("messageType") == "event_subscription":
                data = json_data.get("data", {})
                if data and data.get("eventType") == "window_managed":
                    window = data.get("managedWindow", {})
                    if window and window.get("state", {}).get("type") == "floating":
                        print("🪟 Ventana flotante nueva - Ajustando tamaño...")
                        await asyncio.sleep(0.5)
                        # Solo ajustar tamaño, no centrar (comando no existe)
                        await send_glazewm_command("resize", "--width", "85%", "--height", "80%")
                        
            await asyncio.sleep(0.1)
            
    except Exception as e:
        print(f"💥 Error en gestor flotante: {e}")
        return False
    return True

async def main():
    print("🚀 [Floating] INICIANDO GESTOR DE TILING VERTICAL - VERSIÓN FINAL")
    
    # Puertos a probar
    ports = [6023, 6123, 6223, 6323]
    
    websocket = await try_connect(ports)
    
    if not websocket:
        print("💥 No se pudo conectar a ningún puerto.")
        return

    try:
        # Esperar estabilización
        print("⏳ Esperando 3 segundos...")
        await asyncio.sleep(3)
        
        # Configuración inicial mínima
        print("🎯 Configuración inicial...")
        
        # --- AGREGAR ESTAS LÍNEAS PARA MOVER TERMINAL ---
        print("📦 Moviendo terminal al workspace 9...")
        await send_glazewm_command("move", "--workspace", "9")
        await asyncio.sleep(0.5)
        await send_glazewm_command("focus", "--workspace", "1")
        # ------------------------------------------------
        
        # Forzar dirección vertical inicial
        await send_glazewm_command("toggle-tiling-direction")
        
        print("✅ Configuración completada!")
        print("""
🎮 MODO INTELIGENTE ACTIVADO:
   • Terminal movida a workspace 9
   • Workspace 1 enfocado  
   • Detección precisa de Alt+T
   • Tiling vertical automático
   • Ajuste inteligente de tamaños
        """)
        
        # Ejecutar solo el gestor principal (más estable)
        while True:
            success = await smart_vertical_tiling_manager(websocket)
            
            if not success:
                print("🔄 Reconectando...")
                websocket = await try_connect(ports)
                if not websocket:
                    print("💥 No se pudo reconectar. Saliendo...")
                    break
                await asyncio.sleep(2)
        
    except Exception as e:
        print(f"💥 Error en main: {e}")
    finally:
        if websocket:
            await websocket.close()
        print("👋 Script terminado")

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n🛑 Script interrumpido por el usuario")
    except Exception as e:
        print(f"💥 Error fatal: {e}")
