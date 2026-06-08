source /run/current-system/sw/share/zplug/init.zsh
source ~/.zplug/repos/marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '/home/dziks0nn/.zshrc'

# autoload -Uz compinit
# compinit
# End of lines added by compinstall
ZPLUG_PROTOCOL=SSH

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "romkatv/powerlevel10k", as:theme, use:powerlevel10k.zsh-theme
zplug "tolkonepiu/catppuccin-powerlevel10k-themes", on:"romkatv/powerlevel10k"
zplug "marlonrichert/zsh-autocomplete"
zplug "hcgraf/zsh-sudo"

zplug load

unset zle_bracketed_paste
apply_catppuccin classic mocha

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^H" backward-kill-word

alias cls="clear"
alias update="sudo nixos-rebuild switch"
alias ..="cd .."
alias zshrc="source ~/.zshrc"
alias dotfiles="code ~/dotfiles --new-window"
