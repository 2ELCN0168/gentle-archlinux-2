# THEMES
alias _themes="__show_themes"

__show_themes()
{

        local themes=("/etc/tty_themes.d/"*)
        printf "There are ${#themes[@]} themes in /etc/tty_themes.d/:\n"
        printf "\033[93m"
        printf "[@] Warning, themes are only available for the TTY.\n"
        printf "\033[0m"
        for i in "${themes[@]}"; do
                local name=$(basename ${i} ".sh")
                printf "\033[96m"
                printf "%s\n" "${name}"
                printf "\033[0m"
        done
        printf "\n"
}

if [[ "${TERM}" == "linux" ]]; then

        # These aliases are not loaded if outside a TTY
        alias _tokyo="source /etc/tty_themes.d/tokyonight_storm.sh"
        alias _latte="source /etc/tty_themes.d/catppuccin_latte.sh"
        alias _dracula="source /etc/tty_themes.d/dracula.sh"
        alias _amber="source /etc/tty_themes.d/mono_amber.sh"
        alias _green="source /etc/tty_themes.d/mono_green.sh"
        alias _powershell="source /etc/tty_themes.d/powershell.sh"
        alias _red="source /etc/tty_themes.d/red_impact.sh"
        alias _ryuuko="source /etc/tty_themes.d/ryuuko.sh"
        alias _batman="source /etc/tty_themes.d/batman.sh"
        alias _synth="source /etc/tty_themes.d/synthwave86.sh"
        alias _eforest="source /etc/tty_themes.d/everforest_dark.sh"
fi
