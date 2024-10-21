# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode auto
plugins=(
    autoupdate
    zsh-autosuggestions
    zsh-syntax-highlighting
    tmux
    z
    direnv
    docker
    docker-compose
    kubectl
    aws
    poetry
)
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
ZSH_TMUX_UNICODE=true
if ! [[ "$UID" == 0 || "$TERM_PROGRAM" == "vscode" ]]; then
    ZSH_TMUX_AUTOSTART=true
    ZSH_TMUX_AUTOQUIT=true
fi
source $ZSH/oh-my-zsh.sh

# Default editor
export EDITOR="/usr/bin/vim"

# Do not save space-prefixed commands to history
setopt HIST_IGNORE_SPACE

# Aliases
alias l="ls -lFhAv --group-directories-first --color"

# pipx
export PATH="$PATH:$HOME/.local/bin"

# pyenv
if [ -d $HOME/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# n
if [ -d $HOME/n ]; then
    export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

# Starship (keep at the very bottom of .zshrc)
export VIRTUAL_ENV_DISABLE_PROMPT=1
eval "$(starship init zsh)"
