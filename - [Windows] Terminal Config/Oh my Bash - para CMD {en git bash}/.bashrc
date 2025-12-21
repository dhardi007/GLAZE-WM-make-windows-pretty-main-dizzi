case $- in
  *i*) ;;
  *) return;;
esac

# Cargar git-prompt si está disponible
if [ -f /etc/bash_completion.d/git-prompt ]; then
  source /etc/bash_completion.d/git-prompt
elif [ -f /usr/share/git/completion/git-prompt.sh ]; then
  source /usr/share/git/completion/git-prompt.sh
elif [ -f /mingw64/share/git/completion/git-prompt.sh ]; then
  source /mingw64/share/git/completion/git-prompt.sh
fi

# Detectar mintty exclusivamente
if [[ "$TERM_PROGRAM" == "mintty" ]]; then
  # Estás en Git Bash clásico (mintty)
  PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\
\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \
\[\033[33m\]\w\[\033[36m\]`__git_ps1 " ~|~ %s"`\
\[\033[0m\]\n\t > $ '
else
  # En Windows Terminal, Linux, WSL, etc.
  export OSH="/c/Users/Diego.DESKTOP-0CQHRL5/.oh-my-bash"
  # Cargar oh-my-bash con el tema powerbash10k
  export OSH_THEME="powerbash10k" # Cambia esto al tema que prefieras: ej. powerbash10k, agnoster, kitsune etc.
                                  # Consultar en https://github.com/ohmybash/oh-my-bash/wiki/Themes
 
  source "$OSH/oh-my-bash.sh"
fi

OMB_USE_SUDO=true
completions=(git composer ssh)
aliases=(general)
plugins=(git bashmarks)
