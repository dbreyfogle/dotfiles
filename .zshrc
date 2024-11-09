# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode auto
plugins=(
    autoupdate
    zsh-autosuggestions
    zsh-syntax-highlighting
    tmux
    fzf
    z
    direnv
    git
    docker
    docker-compose
    kubectl
    helm
    terraform
    aws
    poetry
)
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
ZSH_TMUX_UNICODE=true
if ! [[ "$UID" == 0 || "$TERM_PROGRAM" == "vscode" ]]; then
    ZSH_TMUX_AUTOSTART=true
    ZSH_TMUX_AUTOQUIT=false
fi
source $ZSH/oh-my-zsh.sh

# Path
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

# Aliases
alias l="ls -lFhAv --group-directories-first --color"

# Default editor
export EDITOR="/usr/bin/vim"

# Do not save space-prefixed commands to history
setopt HIST_IGNORE_SPACE

# pyenv
if [ -d $HOME/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Starship (keep at the very bottom of .zshrc)
export VIRTUAL_ENV_DISABLE_PROMPT=1
eval "$(starship init zsh)"
