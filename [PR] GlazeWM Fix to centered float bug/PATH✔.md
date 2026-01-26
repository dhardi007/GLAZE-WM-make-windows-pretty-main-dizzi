# ------------------------------------
1-	copy glazewm.exe and replace to:

C:\Program Files\glzr.io\GlazeWM

......
# Clone y Precompile el codigo con; cargo --release > ubicado en > glazewm\target\realese, gracias a: 
https://github.com/babysnakes/glazewm/blob/prevent-window-centering-PR/CONTRIBUTING.md

# Eso dio como resultado el glaze.exe. Para contruibuir:

 `cargo build` will build all binaries and libraries.
# `cargo run` will run the default binary, which is configured to be the wm.
cargo build && cargo run

# ------------------------------------
2- Prefieres el original cuando:

- No te importa que se centren las ventanas.

- Si prefieres poder redimensionar TODAS las ventanas
[util para el Task Manager, Re4 Remake, Geforce NOW etc]




# ------------------------------------
3- GLAZE WM CON PRIVILEGIOS [Sin Acceso Directo, sin Inicio, sin Start]:

#~ Manualmente [Windows + R > pwsh]
	Start-Process "glazewm.exe" -Verb RunAs   

#~ Pero si prefieres automatizar...
Copia el atajo GlazeWM en la carpeta Inicio- StartUp
(ubicado en ..\-[~Inicio~] )

	#~ El proceso para crear esto fue:
		1- Copia autostart-glaze-admin.vbs a Documentos\Scripts
		
		2- Click izquierdo en el escritorio > Crear acceso directo > inserta:
		C:\Windows\System32\wscript.exe "C:\Users\Diego\Documents\Scripts\autostart-glaze-admin.vbs"
		# El icono lo cambie manualmente al path de glazeWM
		
		# OTRAS ALTERNATIVAS
		powershell.exe -Window
		 Style Hidden "C:\Users\Diego\Documents\Scripts\autostart-glaze-admin.ps1"


			#-ExecutionPolicy Bypass -File  sobra antes del "C:\Users\...


# ------------------------------------
4. FIX BUG DE VENTANA

# SI SE BUGEA LA VENTANA EN FULLSCREEN (al usar Alt+F):
# ----------------- ACTIVAR VANILLA Windows -------------------

# METODO 1: Usa alt + F (floating) y luego re posiciona la ventana con Windows Left < >
# L;-----> Trucazo: para aplicaciones como GEFORCE NOW o Lol bloqueadas, debes de cambiar de escritorio con Windows + Ctrl

# METODO 2: SI SIGUE BLOQUEADO, CAMBIA DE ESCRITORIO [Windows Ctrl < >], REGRESA Y ARRASTRA LA VENTANA, pero no deberia de pasar mas.
# L;-----> Trucazo: esto tmb aplica para cuando las ventanas se minimizan al maximo. Con el matiz de que debes agrandar la ventana con Alt +F11 y luego lo de arriba.

