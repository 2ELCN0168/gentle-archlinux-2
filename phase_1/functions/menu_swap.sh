function menu_swap()
{
        local swap

        # Return if 'system_swap' is set in the bash config.
        [[ -n "${system_swap}" ]] && return

        while true; do
                title "Swap" "${C_C}" 40

                printf "%b" "[0] - ${C_C}Swapfile${N_F}\n"
                printf "%b" "[1] - ${C_B}Zram${N_F} (default)\n"
                printf "%b" "[2] - ${C_Y}None${N_F}\n\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Which one do you prefer? [0/1/2] -> "

                local ans
                read -r ans
                : "${ans:=0}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[0-2]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        0) swap="swapfile" ;;
        1) swap="zram" ;;
        2) swap="none" ;;
        esac

        update_config "system_swap" "${swap}" "${bash_config}"
}
