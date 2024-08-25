# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode auto
plugins=(
    autoupdate
    zsh-autosuggestions
    zsh-syntax-highlighting
    tmux
    z
    dotenv
    docker
    docker-compose
    kubectl
    aws
    poetry
)
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
ZSH_TMUX_UNICODE=true
if ! [[ "$UID" == 0 || -n "$SSH_CLIENT" || -n "$SSH_TTY" || "$TERM_PROGRAM" == "vscode" ]]; then
    ZSH_TMUX_AUTOSTART=true
    ZSH_TMUX_AUTOQUIT=false
fi
source $ZSH/oh-my-zsh.sh

# pyenv
if [ -d $HOME/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# pipx
export PATH="$PATH:$HOME/.local/bin"

# n
if [ -d $HOME/n ]; then
    export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

# Default editor
export EDITOR="/usr/bin/vim"

# Aliases
alias l="ls -lFhAv --group-directories-first --color"

# Starship (keep at the very bottom of .zshrc)
export VIRTUAL_ENV_DISABLE_PROMPT=1
eval "$(starship init zsh)"
