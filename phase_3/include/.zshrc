# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install

autoload -Uz compinit
compinit
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '(%b) '
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
eval "$(dircolors -b)"
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

zmodload zsh/net/tcp

setopt append_history 
setopt share_history
setopt extendedglob
setopt promptsubst
setopt histignoredups

# Exit on Ctrl+D even if command line is filled
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

# Source every shell/env configuration file in "/etc/shell_conf.d"
for i in "/etc/shell_conf.d/"*.sh; do
        [[ -r "${i}" ]] && source "${i}"
done

# PROMPT

precmd() { vcs_info }
NEWLINE=$'\n'
if [[ "${EUID}" -eq 0 ]]; then
        # Root account!
        PROMPT='%F{red}%M%f${NEWLINE}'
        PROMPT+='%F{yellow}%*%f %F{red}%B[%n]%b%f %F{white}%B%~%b%f %F{red}${vcs_info_msg_0_}%f${NEWLINE}'
        PROMPT+='%F{red}#%f '
elif id -nG "${USER}" | grep -qE '\b(sudo|wheel)\b'; then
        # Administrative user
        PROMPT='%F{cyan}%*%f %F{green}%B[%n]%b%f %F{white}%B%~%b%f %F{green}${vcs_info_msg_0_}%f${NEWLINE}'
        PROMPT+='%F{yellow}$%f '
else
        # Normal user
        PROMPT='%F{white}[%f%F{cyan}%n%f%F{white}) %B%~%b%f %F{green}${vcs_info_msg_0_}%f${NEWLINE}'
        PROMPT+='%F{cyan}$%f '
fi

if [[ ! -z "${SSH_CONNECTION}" && "${TERM}" != "linux" ]]; then
        # In a SSH connection, set this prompt
        PROMPT=$'%{\e[3;90m%}(ssh)%{\e[0m%} %{\e[1;97m%}%n%{\e[0m%} %{\e[3;92m%}%~%{\e[0m%} %{\e[90m%}${vcs_info_msg_0_}%{\e[0m%}${NEWLINE}'
        PROMPT+=$'%{\e[1;97m%}$%{\e[0;92m%}_%{\e[0m%} '
fi
