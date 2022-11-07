# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gnzh" # "fishy" #"rkj-repos"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ssh-agent gpg-agent fzf)

# User configuration

export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export PATH="$HOME/devtools/platform-tools:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/projects/homedir/bin"

# TODO: is this needed at all?
## Flatpak paths
#export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

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

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export ALTERNATE_EDITOR=""
#export EDITOR="emacsclient -t"
#alias emax="$EDITOR"
export EDITOR="nano"

export LESS="--RAW-CONTROL-CHARS --quit-if-one-screen"

export WINEARCH=win32
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')
# Don't phone Microsoft about .net
export DOTNET_CLI_TELEMETRY_OPTOUT="1"

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Thingy for GPG signing of git commits.
# Be also sure to install pinentry-curses and do
# sudo update-alternatives --config pinentry
export GPG_TTY=$(tty)

alias gs="git status"
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gpa="git pull --all --ff-only"

alias gw="./gradlew"
alias fake="dotnet fake run build.fsx target"

alias exa="~/.local/bin/exa -l@ --git"

alias drun="docker run --rm -it --entrypoint=/bin/bash"

alias cdproj="cd ~/projects/"

# Does not work with kubectl installed from snap. Don't use snap.
if command -v kubectl &> /dev/null ; then
	alias k=kubectl
	complete -F __start_kubectl k
	source <(kubectl completion zsh)
fi

if command -v oc &> /dev/null ; then
	source <(oc completion zsh)
fi
if command -v helm &> /dev/null ; then
	source <(helm completion zsh)
fi
if command -v operator-sdk &> /dev/null ; then
	source <(operator-sdk completion zsh)
fi
if command -v tkn &> /dev/null ; then
	source <(tkn completion zsh)
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null ; then
	#eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
	#eval "$(pyenv virtualenv-init -)"
fi

export PATH="$HOME/.poetry/bin:$PATH"

[ -s "$HOME/.extra-zshrc" ] && \. "$HOME/.extra-zshrc"  # Load extra stuff, e.g. for Docker

# Rust stuff
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export COLUMNS="120"
