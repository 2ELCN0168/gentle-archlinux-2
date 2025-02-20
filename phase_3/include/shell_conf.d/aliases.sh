# NAVIGATION
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias conf="cd ${HOME}/.config"
alias pics="cd ${HOME}/Pictures"
alias vids="cd ${HOME}/Videos"
alias docs="cd ${HOME}/Documents"
alias music="cd ${HOME}/Music"
alias desk="cd ${HOME}/Desktop"
alias downs="cd ${HOME}/Downloads"
alias public="cd ${HOME}/Public"

# NETWORK
alias ipb='printf "\033[92m"; curl -s ifconfig.me; printf "\033[0m"'

# COLORS
alias diff='command diff --color=auto'
alias ll='command ls -lh --color=auto' # May be replaced in "REPLACEMENTS"
alias ls='command ls --color=auto'     # May be replaced in "REPLACEMENTS"
alias ip='command ip -color=auto'
alias grep='command grep --color=auto'
alias egrep='command grep -E --color=auto'
alias fgrep='command fgrep --color=auto'

# SAFETY
alias rm='command rm -i'
alias cp='command cp -i'
alias mv='command mv -i'

# CUSTOM OUTPUTS - USED IN ALIASES
function _ss()
{
        # BRIGHT GREEN
        printf "\033[92m"
        command ss "${@}"
        printf "\033[0m"
}

function _free()
{
        # BRIGHT YELLOW
        printf "\033[93m"
        command free "${@}"
        printf "\033[0m"
        printf "\n"
}

function _df()
{
        # BRIGHT YELLOW
        printf "\033[93m"
        command df "${@}"
        printf "\033[0m"
        printf "\n"
}

function _du()
{
        # BRIGHT YELLOW
        printf "\033[93m"
        command du "${@}"
        printf "\033[0m"
        printf "\n"
}

# CUSTOM OUTPUTS - STANDARD
function lsblk()
{
        # BRIGHT CYAN
        printf "\033[96m"
        command lsblk "${@}"
        printf "\033[0m"
        printf "\n"
}

function blkid()
{
        # BRIGHT BLUE
        printf "\033[94m"
        command blkid "${@}"
        printf "\033[0m"
        printf "\n"
}

function uptime()
{
        # BRIGHT RED
        printf "\033[91m"
        command uptime "${@}"
        printf "\033[0m"
        printf "\n"
}

function ps()
{
        # BRIGHT YELLOW
        printf "\033[93m"
        command ps "${@}"
        printf "\033[0m"
        printf "\n"
}

function ping()
{
        # BRIGHT BLUE
        printf "\033[94m"
        command ping "${@}"
        printf "\033[0m"
        printf "\n"
}

function traceroute()
{
        # BRIGHT BLUE
        printf "\033[94m"
        command traceroute "${@}"
        printf "\033[0m"
        printf "\n"
}

function reload()
{
        printf "\033[92m"
        if [[ "${SHELL}" == "/bin/bash" ]]; then
                source ~"/.bashrc"
                printf "%s" "[>] .bashrc reloaded.\n"
        elif [[ "${SHELL}" == "/bin/zsh" ]]; then
                source ~"/.zshrc"
                printf "%s" "[>] .zshrc reloaded.\n"
        fi
        printf "\033[0m"
}

# CONVENIENCE
alias untar='command tar xvf'
alias sstcp='_ss -eant'
alias ssudp='_ss -eanu'
alias tree='tree -CQhu --du --sort name'
alias history='fc -li 1'

# READABILITY
alias du='_du -h'
alias df='_df -h' # May be replaced in "REPLACEMENTS"
alias free='_free -h'

# REPLACEMENTS
if command -v eza 1> "/dev/null" 2>&1; then
        alias ls='eza'
        alias ll='eza -l'
fi

if command -v bat 1> "/dev/null" 2>&1; then
        alias cat='command bat -n --theme=base16-256'
fi

if command -v btm 1> "/dev/null" 2>&1; then
        alias btm='command btm -r 250ms -T'
fi

if command -v duf 1> "/dev/null" 2>&1; then
        alias df='command duf'
fi
# OTHERS
