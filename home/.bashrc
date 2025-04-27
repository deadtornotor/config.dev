#
# ~/.bashrc
#
export PATH=$PATH:~/.cargo/bin/

export PATH=$PATH:~/git/bin/

export PATH=$PATH:~/bin/

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# take notes
nt() {
	nvim ~/Dokumente/notes/$1
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tping='ping archlinux.org'
alias update='yay -Syyu && flatpak update'


# PS1='[\u@\h \W]\$ '
PS1='\[\e[38;5;226;1m\]\u\[\e[0;38;5;196m\]@\[\e[38;5;39;1m\]\h\[\e[0m\] \[\e[38;5;207m\]>\[\e[0m\] \[\e[38;5;63m\]\W\[\e[0m\] \[\e[38;5;254m\]:\[\e[0m\] \[\e[38;5;64m\]\$\[\e[0m\] '


bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

fastfetch
