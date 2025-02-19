# Do nothing if shell is not interactive
[[ "${-}" != *i* ]] && return

# History size
HISTSIZE=10000
HISTFILESIZE=20000

# Ignore consecutive and identical commands
HISTCONTROL=ignoredups:erasedups

# Add timestamps to commands in history
HISTTIMEFORMAT="%d/%m/%Y %H:%M:%S "

# Add history from previous sessions
shopt -s histappend
# Wrap lines on term resize
shopt -s checkwinsize

# Source every shell/env configuration file in "/etc/shell_conf.d"
for i in "/etc/shell_conf.d/"*.sh; do
        [[ -r "${i}" ]] && source "${i}"
done

source ~"/.git-prompt.sh"

# Prompt
PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'
if [[ "${TERM}" == "linux" ]]; then
        if [[ "${EUID}" -eq 0 ]]; then
                # Root account!
                PS1='\[\e[93m\][\@]\[\e[91m\][\u\[\e[0m\] \[\e[97m\]\w\[\e[91m\]]${PS1_CMD1}\[\e[0m\] \[\e[31m\]\H\n\[\e[91m\]\$\[\e[0m\] '
        elif id -nG "${USER}" | grep -qE '\b(sudo|wheel)\b'; then
                # Administrative user
                PS1='\[\e[96m\][\@][\[\e[92m\]\u\[\e[0m\] \[\e[90m\]\w\[\e[96m\]]\[\e[92m\]${PS1_CMD1}\n\[\e[93m\]\$\[\e[0m\] '
        else
                # Normal user
                PS1='(\[\e[96m\]\u\[\e[0m\] \[\e[90m\]\w\[\e[0m\])\[\e[92m\]${PS1_CMD1}\n\[\e[96m\]\$\[\e[0m\] '
        fi
else
        if [[ "${EUID}" -eq 0 ]]; then
                # Root account!
                PS1='\[\e[93m\][\@]\[\e[91m\][\[\e[1m\]\u\[\e[0m\] \[\e[97;1;2;3m\]\w\[\e[0;91m\]]\[\e[0m\]\[\e[91;2m\]${PS1_CMD1}\[\e[0m\] \[\e[31;2;3m\]\H\n\[\e[22;91m\]\$\[\e[0m\] '
        elif id -nG "${USER}" | grep -qE '\b(sudo|wheel)\b'; then
                # Administrative user
                PS1='\[\e[96m\][\@][\[\e[92;1m\]\u\[\e[0m\] \[\e[90;3m\]\w\[\e[0;96m\]]\[\e[0m\]\[\e[92;2m\]${PS1_CMD1}\n\[\e[0;93;3m\]\$\[\e[0m\] '
        else
                # Normal user
                PS1='(\[\e[96m\]\u\[\e[0m\] \[\e[97;2;3m\]\w\[\e[0m\])\[\e[92;2;3m\]${PS1_CMD1}\n\[\e[22;96m\]\$\[\e[0m\] '
        fi
fi

if [[ ! -z "${SSH_CONNECTION}" && "${TERM}" != "linux" ]]; then
        # In a SSH connection, set this prompt
        PS1='\[\e[90;3m\](ssh)\[\e[0m\] \[\e[3m\]\u\[\e[0m\] \[\e[92;2;3m\]\W\[\e[23;90m\]${PS1_CMD1}\n\[\e[0;97;1m\]\\$\[\e[0;92m\]_\[\e[0m\] '
fi
