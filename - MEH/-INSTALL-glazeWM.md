DIZZI README ~ Best WINDOWS Tile Manager
------------------------------------------------------

~[ YO MODIFIQUE; config [glazeWM]
		 \_;-> LA CONFIG DE ZEBAR Y LA HICE MIA (fokiu vimichael)

~[ YASB ESTA CON otra CONFIG DE GLAZEWM (de SleepyCatHey)

# ....Al tonto se le olvido explicar:
# Al editar el config.yaml hay comandos:
# ✅ COMANDOS CORRECTOS:
commands: ["ignore"]                    # Ignorar ventana
commands: ["set-floating"]              # Hacer flotante
commands: ["set-floating --centered"]   # Flotante centrada
commands: ["set-tiling"]                # Hacer tiling
commands: ["set-always-on-top"]         # Siempre encima (SOLO Windows 11)

Con eso defines los windows similar a windowsrules en hypr.
------------------------------------------------------
C:\Users\Diego\.glzr\glazewm

En esa ruta debes de pegar

zebar-config config

 ~ Ignora .weztern.lua, private-build-plans.toml
	~ IGNORA vanilla-clear [hay temas mejores y funcionales].

██╗███╗░░██╗░██████╗████████╗░█████╗░██╗░░░░░░█████╗░██████╗░
██║████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██╔══██╗██╔══██╗
██║██╔██╗██║╚█████╗░░░░██║░░░███████║██║░░░░░███████║██████╔╝
██║██║╚████║░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██╔══██║██╔══██╗
██║██║░╚███║██████╔╝░░░██║░░░██║░░██║███████╗██║░░██║██║░░██║
╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝

------------------------------------------------------
1 ~[- Instalar YASB waybar] ~ (Mejores temas, interactivad)
		\_;-> winget install --id AmN.yasb

----......
2 ~[- Instalar ZEBAR topbar] ~ (Overline-zebar incluye AUTO TILING
					 y permite scripts .vbs.. but meh)
					 
		\_;-> https://github.com/glzr-io/zebar/releases

......----
3 ~[- Instalar glazeWM]
		\_;-> winget install GlazeWM
		
......----
4 ~[- Instalar AutoTiling] ~ [Requiere Python desde la Web Store y posible pip desde la pwsh] ~ [Alternativa a GAT-GWMC [que requiere Rust]
		\_;->1. Instalar Python en la Web Store y:
		#	 INSTALA python-pi: > Windows + R > pwsh  >Escribe:
 							pip install pynvim
							 pip install 'python-lsp-server[all]'
		
		 \_> 2. Mueve autotiling.py modificado > a la carpeta: > \\Users\\Diego\\Documents
		 	UBICACION:
		 		     - AHORA EJECUTA EL ARCHIVO DESDE CMD:
		     
		  		     cd .\Documents\Scripts
		  	
		  		 	python autotiling.py
			
			3. Configuralo en el glazewm para que INICIE en AutoStart: 
		  \_>	general:
			 startup_commands: 
			 			  - "shell-exec python C:\\Users\\Diego\\Documents\\Scripts\\autotiling.py"

------------------------------------------------------												
CONSULTA EN:		
https://github.com/Dutch-Raptor/GAT-GWMc
------------------------------------------------------		








EL README DEL PELOTUDO:
------------------------------------------------------		
# My Windows Config

# My Terminal Setup

- [Wezterm](https://wezfurlong.org/wezterm/index.html)
- [Wezterm Config File](.wezterm.lua)

> The font is a custom Iosevka installation from [here](https://typeof.net/Iosevka/customizer). This is my build plan [here](./private-build-plans.toml).

# Window Manager Setup

- [GlazeWM](https://github.com/glzr-io/glazewm)
- [GlazeWM Config File](./config.yaml)

# TopBar Setup

- [Zebar](https://github.com/glzr-io/zebar)

To configure Zebar:

1. Copy [vanilla-clear](./vanilla-clear) widget to Zebar directory

```
cp ./vanilla-clear/ ~/.glzr/zebar/
```

2. Than disable other widgets in Zebar system tray.

### Old Zebar config

Zebar removed `.yaml` config in [v2.2.1](https://github.com/glzr-io/zebar/releases/tag/v2.2.1), but if you want, you can still use it: [Old Zebar Config](./zebar-config.yaml)

# Searching

- [Powertoys Run](https://learn.microsoft.com/en-us/windows/powertoys/run)

# Translucent Taskbar

- [TranslucentTB](https://apps.microsoft.com/detail/9pf4kz2vn4w9?hl=en-US&gl=US)

# Wallpaper

- [Link](https://wallhaven.cc/w/76edpv)
