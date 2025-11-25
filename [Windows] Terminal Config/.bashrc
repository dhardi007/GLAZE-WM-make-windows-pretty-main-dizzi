# Aca se cambia el color del prompt a un color mas amarillento/crema.
# Tambien se define la distancia entre el prompt y la rama
# y se agrega el simbolo $ en vez de ~
# Y la rama en vez de estar en () esta en | con la señal ~ simulando las ramas.
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\
\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \
\[\033[33m\]\w\[\033[36m\]`__git_ps1 " ~|~ %s"`\
\[\033[0m\]\n\t > $ '

# 	done
# fin
