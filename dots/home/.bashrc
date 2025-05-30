#
# ~/.bashrc
#
export PATH=$PATH:~/.cargo/bin/

export PATH=$PATH:~/git/bin/

export PATH=$PATH:~/go/bin/

export PATH=$PATH:~/bin/

source ~/.profile

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# take notes
nt() {
	nvim ~/Dokumente/notes/$1
}

alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -a --color=auto'

alias grep='grep --color=auto'
alias tping='ping archlinux.org'
alias update='yay -Syyu && flatpak update'


# PS1='[\u@\h \W]\$ '
# PS1='\[\e[38;5;226;1m\]\u\[\e[0;38;5;196m\]@\[\e[38;5;39;1m\]\h\[\e[0m\] \[\e[38;5;207m\]>\[\e[0m\] \[\e[38;5;63m\]\W\[\e[0m\] \[\e[38;5;254m\]:\[\e[0m\] \[\e[38;5;64m\]\$\[\e[0m\] '
PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
PS1='\[\e[38;5;46m\]\u\[\e[38;5;125;1m\]@\[\e[0;38;5;51m\]\h\[\e[0m\] \[\e[90m\]-\[\e[0m\] \[\e[38;5;245;2;3m\]\w\[\e[0m\] \[\e[38;5;189;1;3m\]${PS1_CMD1}\n\[\e[0;38;5;250m\]>\[\e[0m\] \[\e[38;5;64m\]\$\[\e[0m\] '

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
