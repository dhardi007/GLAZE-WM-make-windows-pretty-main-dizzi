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

async def auto_tiling_logic(websocket):
    """Lógica principal de auto-tiling"""
    try:
        await websocket.send("sub -e window_managed")
        print("🎯 Suscrito a eventos de ventanas. Auto-tiling activado!")
        
        while True:
            response = await websocket.recv()
            json_response = json.loads(response)
            try:
                sizePercentage = json_response["data"]["managedWindow"]["tilingSize"]
                if sizePercentage is None:
                    continue
                if sizePercentage <= 0.5:
                    await websocket.send('command toggle-tiling-direction')
                    print("🔄 Cambiando dirección de tiling...")
            except KeyError:
                pass
    except websockets.exceptions.ConnectionClosed:
        print("🔌 Conexión cerrada. Reintentando en 5 segundos...")
        await asyncio.sleep(5)
        return False  # Indicar que hay que reconectar
    return True

async def main():
    print("🚀 [Tiling] Iniciando auto-tiling...")
    
    # Puertos a probar (en orden de prioridad)
    ports = [6023, 6123, 6223, 6323]
    
    websocket = await try_connect(ports)
    
    if not websocket:
        print("💥 No se pudo conectar a ningún puerto. Verifica que GlazeWM esté ejecutándose.")
        return

    try:
        # Esperar 1 segundo después de conectar
        print("⏳ Esperando 1 segundo...")
        await asyncio.sleep(1)
        
        # Mover terminal al workspace 9 y enfocarlo
        print("📦 Moviendo terminal al workspace 9...")
        await send_glazewm_command("move", "--workspace", "9")
        await send_glazewm_command("focus", "--workspace", "9")
        
        # Esperar otro segundo
        print("⏳ Esperando 1 segundo más...")
        await asyncio.sleep(1)
        
        # Enfocar workspace 1
        print("🎯 Enfocando workspace 1...")
        await send_glazewm_command("focus", "--workspace", "1")
        
        # Mover terminal al workspace 9 y enfocarlo
        # print("📦 Moviendo terminal al workspace 9...")
        # await send_glazewm_command("move", "--workspace", "9")
        # await send_glazewm_command("focus", "--workspace", "9")
        
        # Enfocar workspace 1
        # print("🎯 Enfocando workspace 1...")
        # await send_glazewm_command("focus", "--workspace", "1")

        # Mover terminal al workspace 9 y enfocarlo
        # print("📦 Moviendo terminal al workspace 9...")
        # await send_glazewm_command("move", "--workspace", "9")
        # await send_glazewm_command("focus", "--workspace", "9")
        
        # Enfocar workspace 1
        # print("🎯 Enfocando workspace 1...")
        # await send_glazewm_command("focus", "--workspace", "1")

        # Recargar GlazeWM y yasbc config # PARA DESAPARECER LOS ICONOS de cierto tema [Aquamarine]
        import subprocess

        # En lugar de: yasbc reload
        subprocess.run(["yasbc", "reload"], capture_output=True, text=True)
        print("✅ YASB recargado")

        print("✅ Secuencia de inicio completada!")
        
        # Ahora ejecutar la lógica de auto-tiling
        while True:
            success = await auto_tiling_logic(websocket)
            if not success:
                # Reconectar
                websocket = await try_connect(ports)
                if not websocket:
                    break
        
    except Exception as e:
        print(f"💥 Error en main: {e}")
    finally:
        if websocket:
            await websocket.close()

if __name__ == "__main__":
    asyncio.run(main())
