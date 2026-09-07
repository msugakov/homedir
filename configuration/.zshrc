HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000          # commands kept in memory per session
SAVEHIST=50000          # commands written to $HISTFILE (set equal to keep everything)

setopt SHARE_HISTORY          # the key one: write after each command AND import from other sessions
# setopt INC_APPEND_HISTORY     # to keep each terminal its own history, exclusive with SHARE_HISTORY
setopt EXTENDED_HISTORY       # save timestamp + duration per entry
setopt HIST_IGNORE_ALL_DUPS   # drop older duplicate of a repeated command
setopt HIST_IGNORE_SPACE      # don't record commands you prefix with a space
setopt HIST_VERIFY            # on history expansion (!!), show it before running

export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export PATH="$HOME/devtools/platform-tools:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/projects/homedir/bin"

HOST_COLOR=$(( ( $(print -rn -- "$HOST" | cksum | cut -d' ' -f1) + 4) % 6 + 1 ))
MY_PRE_PROMPT="%n@%F{$HOST_COLOR}%m%f %~"

autoload -Uz add-zsh-hook

exit_status_precmd() {
	local ec="$?"
	if (( ec )); then
		MY_EXIT_CODE="%F{red}[${ec}]%f "
	else
		MY_EXIT_CODE=""
    fi
}
add-zsh-hook precmd exit_status_precmd

if [[ -f "$HOME/.local/bin/git-prompt.sh" ]]; then
	source "$HOME/.local/bin/git-prompt.sh"

	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWSTASHSTATE=1
	GIT_PS1_SHOWUNTRACKEDFILES=1
	GIT_PS1_SHOWUPSTREAM=verbose
	GIT_PS1_SHOWCOLORHINTS=1

	git_prompt_precmd() {
		__git_ps1 "${MY_EXIT_CODE}${MY_PRE_PROMPT}" $'\n$ ' " (%s)"
	}

	add-zsh-hook precmd git_prompt_precmd
else
	setopt PROMPT_SUBST
	PROMPT='${MY_EXIT_CODE}'"${MY_PRE_PROMPT}"$'\n''\$ '
fi

set_terminal_title_precmd() {
    print -Pn "\e]0;[%n@%m] %~\a"
}

set_terminal_title_preexec() {
    print -Pn "\e]0;[%n@%m] $1\a"
}

add-zsh-hook precmd set_terminal_title_precmd
add-zsh-hook preexec set_terminal_title_preexec

if type fzf > /dev/null; then
	source <(fzf --zsh)
fi

if [[ "$(hostname)" != *-vm ]]; then
	eval "$(keychain --eval --quiet id_ed25519)"
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Thingy for GPG signing of git commits.
# Be also sure to install pinentry-curses and do
# sudo update-alternatives --config pinentry
export GPG_TTY="$(tty)"

alias g="git"
alias gs="git status"
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gpa="git pull --all --ff-only"

alias gw="./gradlew"

alias drun="docker run --rm -it --entrypoint=/bin/bash"
alias prun="podman run --rm -it --entrypoint=/bin/bash"

alias cdproj="cd ~/projects/"

alias lsbin="ls ~/.local/bin/"

alias hx="helix"

autoload -Uz compinit
compinit
if command -v kubectl &> /dev/null ; then
	alias k=kubectl
	source <(kubectl completion zsh)
	compdef k=kubectl
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

[[ -s "$HOME/.extra-zshrc" ]] && \. "$HOME/.extra-zshrc"  # Load extra stuff, e.g. for Docker

# Rust stuff
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Ruby
if [[ -d "$HOME/.rbenv/bin" ]]; then
	export PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(~/.rbenv/bin/rbenv init - zsh)"
fi

# .net tools
export PATH="$HOME/.dotnet/tools:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export COLUMNS="120"
