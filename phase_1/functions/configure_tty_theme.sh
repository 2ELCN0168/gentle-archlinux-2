function configure_tty_theme()
{
        local theme="$(jaq -r '.customization.tty_theme' ${json_config})"

        # Return if already set in the JSON config.
        [[ -n "${theme}" ]] && return

        local ans

        while true; do
                title "Themes" "${C_C}" 40

                printf "%b" "[0] - ${C_W}Catpuccin latte (light)${N_F}\n"
                printf "%b" "[1] - ${C_C}Tokyonight storm (dark)${N_F}\n"
                printf "%b" "[2] - ${C_R}Red impact (dark)${N_F}\n"
                printf "%b" "[3] - ${C_P}Dracula (dark)${N_F}\n"
                printf "%b" "[4] - ${C_Y}Mono Amber (dark)${N_F}\n"
                printf "%b" "[5] - ${C_G}Mono Green (dark)${N_F}\n"
                printf "%b" "[6] - ${C_B}Powershell (medium)${N_F}\n"
                printf "%b" "[7] - ${C_Y}Synthwave 86 (medium)${N_F} "
                printf "%b" "[default]\n"
                printf "%b" "[8] - ${C_Y}Everforest (dark)${N_F}\n"
                printf "%b" "[9] - ${C_W}Default colors (dark)${N_F}\n\n"
                
                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Which theme do you want to use for the TTY? "
                printf "%b" "Each one will be created in /etc/tty_themes.d -> "

                read -r ans
                : "${ans:=7}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[0-9]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        local theme_pretty theme theme_brightness
        

        case "${ans}" in
                0)
                        theme_pretty="Catppuccin latte"
                        theme="catppuccin_latte.sh"
                        theme_brightness=1
                        ;;
                1)
                        theme_pretty="Tokyonight Storm"
                        theme="tokyonight_storm.sh"
                        theme_brightness=0
                        ;;
                2)
                        theme_pretty="Red impact"
                        theme="red_impact.sh"
                        theme_brightness=0
                        ;;
                3)
                        theme_pretty="Dracula"
                        theme="dracula.sh"
                        theme_brightness=0
                        ;;
                4)
                        theme_pretty="Mono Amber"
                        theme="mono_amber.sh"
                        theme_brightness=0
                        ;;
                5)
                        theme_pretty="Mono Green"
                        theme="mono_green.sh"
                        theme_brightness=0
                        ;;
                6)
                        theme_pretty="Powershell"
                        theme="powershell.sh"
                        theme_brightness=0
                        ;;
                7)
                        theme_pretty="Synthwave 86"
                        theme="synthwave86.sh"
                        theme_brightness=0
                        ;;
                8)
                        theme_pretty="Everforest Dark"
                        theme="everforest_dark.sh"
                        theme_brightness=0
                        ;;
                9)
                        theme_pretty="Default"
                        ;;
        esac

        printf "%b" "${INFO} You chose ${C_P}${theme_pretty}${N_F}.\n\n"

        jaq -i '.customization.tty_theme = "'"${theme}"'"' "${json_config}"
        jaq -i '.customization.tty_theme_brightness = "'"${theme_brightness}"'"' \
        "${json_config}"
}