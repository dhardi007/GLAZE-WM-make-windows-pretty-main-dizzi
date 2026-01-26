import subprocess
import os

# Cambiar al directorio de rclone
os.chdir(r"C:\Users\Diego\Desktop\rclone-v1.71.2-windows-amd64")

# Comandos para montar ambas unidades
comandos = [
    'rclone mount gdrive: I: --vfs-cache-mode writes --links',
    'rclone mount gd-musica: G: --vfs-cache-mode writes --links'
]

print("Montando ambas unidades de Google Drive...")
print("I: → Google Drive principal")
print("G: → Google Drive de música")

# Ejecutar en procesos separados
procesos = []
for comando in comandos:
    proceso = subprocess.Popen(f'start "" {comando}', shell=True)
    procesos.append(proceso)

print("Unidades montadas correctamente!")
print("Para desmontar ejecuta: rclone unmount I: && rclone unmount G:")
input("Presiona Enter para salir...")
