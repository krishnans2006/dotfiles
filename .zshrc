# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
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
plugins=(git git-auto-fetch poetry zsh-autosuggestions zsh-syntax-highlighting ubuntu history-sync)
GIT_AUTO_FETCH_INTERVAL=86400

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="nano"
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# CUSTOM

# GPG fix for remote
export GPG_TTY=$TTY

# Update dotfiles on shell exit
zshexit() {
    [ -s "$HOME/dotfiles" ] && git -C "$HOME/dotfiles" fetch origin main && git -C "$HOME/dotfiles" reset --hard origin/main
}

# Remove history file size limit
export HISTSIZE=1000000000
export SAVEHIST="$HISTSIZE"
setopt EXTENDED_HISTORY

# histignorespace
setopt histignorespace

# history-sync
ZSH_HISTORY_FILE="${HOME}/.zsh_history"
ZSH_HISTORY_PROJ="${HOME}/.zsh_history_proj"
ZSH_HISTORY_FILE_ENC_NAME="zsh_history"
ZSH_HISTORY_COMMIT_MSG="History until $(date)"
# history-sync end

# ardupilot
[ -s "$HOME/Tech/TJUAV/ardupilot/Tools/completion" ] && source "$HOME/Tech/TJUAV/ardupilot/Tools/completion/completion.zsh"
# ardupilot end

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[ -s "$PNPM_HOME" ] && export PATH="$PNPM_HOME:$PATH"
# pnpm end

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# nvm end

# python user base binary directory
export PYTHON_USER_BASE="$HOME/.local/bin"
[ -s "$PYTHON_USER_BASE" ] && export PATH="$PYTHON_USER_BASE:$PATH"
# python user base binary directory end

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[ -s "$PYENV_ROOT" ] && export PATH="$PYENV_ROOT/bin:$PATH"
[ -s "$PYENV_ROOT" ] && eval "$(pyenv init -)"
[ -s "$PYENV_ROOT" ] && eval "$(pyenv virtualenv-init -)"
# pyenv end

# rust
export RUST_ROOT="$HOME/.cargo"
[ -s "$RUST_ROOT" ] && export PATH="$RUST_ROOT/bin:$PATH"
# rust end

# go
export GO_ROOT="/usr/local/go"
[ -s "$GO_ROOT" ] && export PATH="$GO_ROOT/bin:$PATH"
# go end

# jetbrains toolbox
export TOOLBOX_HOME="$HOME/.local/share/JetBrains/Toolbox/scripts"
[ -s "$TOOLBOX_HOME" ] && export PATH="$TOOLBOX_HOME:$PATH"
# jetbrains toolbox end

# gitlab cli
export GITLAB_HOST=gitlab.tjhsst.edu
# gitlab cli end

# modular cli
export MODULAR_HOME="$HOME/.modular"
export MOJO_BIN="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin"
[ -s "$MODULAR_HOME" ] && [ -s "$MOJO_BIN" ] && export PATH="$MOJO_BIN:$PATH"
# modular cli end

# bob neovim
export BOB_NVIM="$HOME/.local/share/bob/nvim-bin"
[ -s "$BOB_NVIM" ] && export PATH="$BOB_NVIM:$PATH"
# bob neovim end

# oci cli
export OCI_BIN="$HOME/bin"
[ -s "$OCI_BIN" ] && export PATH="$OCI_BIN:$PATH"
[[ -e "/home/krishnan/lib/oracle-cli/lib/python3.11/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/home/krishnan/lib/oracle-cli/lib/python3.11/site-packages/oci_cli/bin/oci_autocomplete.sh"
# oci cli end

# git-subrepo
export GIT_SUBREPO_ROOT="$HOME/.git-subrepo"
[ -s "$GIT_SUBREPO_ROOT" ] && source "$HOME/.git-subrepo/.rc"
# git-subrepo end
