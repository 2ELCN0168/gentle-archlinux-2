function menu_zoneinfo()
{
        # Return if already set in the bash config.
        [[ -n "${system_localtime}" ]] && return

        local ans country

        while true; do
                title "Time" "${C_C}" 40

                printf "%b" "${C_W}[0] - ${C_C}France${N_F} [default]\n"
                printf "%b" "${C_W}[1] - ${C_W}England${N_F}\n"
                printf "%b" "${C_W}[2] - ${C_W}US (New-York)${N_F}\n"
                printf "%b" "${C_W}[3] - ${C_R}Japan${N_F}\n"
                printf "%b" "${C_W}[4] - ${C_C}South Korea (Seoul)${N_F}\n"
                printf "%b" "${C_W}[5] - ${C_R}Russia (Moscow)${N_F}\n"
                printf "%b" "${C_W}[6] - ${C_R}China (CST - Shanghai)${N_F}\n"
                printf "%b" "${C_W}[7] - ${C_R}North Korea (Pyongyang)${N_F}\n"
                printf "%b" "\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Where do you live? [0-7] -> "

                read -r ans
                : "${ans:=0}"
                printf "%b" "\n"

                case "${ans}" in
                [0-7]) break ;;
                *) invalid_answer ;;
                esac
        done

        case "${ans}" in
        0)
                localtime="Europe/Paris"
                locales="fr"
                ;;
        1)
                localtime="Europe/London"
                locales="gb"
                ;;
        2)
                localtime="America/New_York"
                ;;
        3)
                localtime="Japan"
                locales="ja"
                ;;
        4)
                localtime="Asia/Seoul"
                locales="ko"
                ;;
        5)
                localtime="Europe/Moscow"
                locales="ru"
                ;;
        6)
                localtime="Asia/Shanghai"
                locales="zh"
                ;;
        7)
                localtime="Asia/Pyongyang"
                locales="ko"
                ;;
        esac

        if [[ -z "${system_localtime}" ]]; then
                update_config "system_localtime" "${localtime}" "${bash_config}"
        fi

        if [[ -z "${system_locales}" ]]; then
                update_config "system_locales" "${locales}" "${bash_config}"
        fi

        printf "%b" "${INFO} Zoneinfo set to: ${C_P}${localtime}${N_F}.\n"
        printf "%b" "${INFO} Locales set to: ${C_P}${locales}${N_F}.\n\n"

}
