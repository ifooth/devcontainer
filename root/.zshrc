# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/opt/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump fzf extract zsh-autosuggestions kubectl-autocomplete helm-autocomplete)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# 是否有效的软链接
function not_valid_link() {
    if [[ -L "$1" && -e "$1" ]];then
        # 1 = false
        return 1
    else
        # 0 = true
        return 0
    fi
}

autoload -Uz compinit
compinit

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH=/data/bin:/root/.go/bin:/opt/go/bin:/opt/py/bin:/opt/pyenv/bin:/opt/pyenv/shims:/root/.npm-packages/bin:$PATH

# zsh plugins
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=2"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#696969"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=256

# ssh
if [ ! -d "${HOME}/.ssh" ];then
    mkdir -p ${HOME}/.ssh
    touch ${HOME}/.ssh/config
fi

# vim
export VIM_ROOT=/opt/vim

# pyenv
export PYENV_ROOT=/opt/pyenv
PYENV_PKG=versions/3.12/lib/python3.12/site-packages
if [ ! -d "${HOME}/.pyenv/${PYENV_PKG}" ];then
    mkdir -p ${HOME}/.pyenv
    tar -xvf ${PYENV_ROOT}/versions.tar.gz -C ${HOME}/.pyenv
fi

if not_valid_link ${PYENV_ROOT}/${PYENV_PKG};then
    rm -rf ${PYENV_ROOT}/${PYENV_PKG}
    ln -sf ${HOME}/.pyenv/${PYENV_PKG} ${PYENV_ROOT}/${PYENV_PKG}
fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper
fi
export PYENV_VERSION=3.12

# virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
source /usr/local/bin/virtualenvwrapper.sh

# 添加显示 hostname
PS1=$'%{\e[0;32m%}%m%{\e[0m%}'$PS1
# PS1="%F{green}%m%f"$PS1

# direnv
show_virtual_env() {
    if [ -n "$VIRTUAL_ENV" ]; then
        env_name="($(basename $VIRTUAL_ENV))"
        if [[ $PS1 != *$env_name* ]];then
            echo "$env_name "
        fi
    fi
}
if [[ $PS1 != *"show_virtual_env"* ]];then
    PS1='$(show_virtual_env)'$PS1
fi

eval "$(direnv hook zsh)"

# Alias
alias echo_path='tr ":" "\n" <<< "$PATH"'
alias k="kubectl"

[[ -s "${HOME}/.zsh_profile" ]] && source "${HOME}/.zsh_profile"

# Remove duplicate $PATH entries
export PATH=$(zsh -fc 'typeset -U path; echo $PATH')
