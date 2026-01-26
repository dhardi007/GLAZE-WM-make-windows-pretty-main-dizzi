Set WshShell = CreateObject("WScript.Shell")
' Cambiar directorio y ejecutar comandos
WshShell.CurrentDirectory = "C:\Users\Diego\Desktop\rclone-v1.71.2-windows-amd64"

' Montar ambas unidades
WshShell.Run "cmd /c start ""Google Drive"" rclone mount gdrive: I: --vfs-cache-mode writes --links", 0, False
WScript.Sleep 2000
WshShell.Run "cmd /c start ""Google Musica"" rclone mount gd-musica: G: --vfs-cache-mode writes --links", 0, False

MsgBox "Unidades montadas!" & vbCrLf & "I: → Google Drive" & vbCrLf & "G: → Música", vbInformation, "RClone Montado"