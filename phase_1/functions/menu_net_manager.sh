function menu_net_manager()
{
        local net_manager

        # Return if it's already set
        [[ -n "${network_manager}" ]] && return

        while true; do
                title "Network Manager" "${C_C}" 40

                printf "%b" "[0] - ${C_G}systemd-networkd${N_F}\n"
                printf "%b" "[1] - ${C_C}NetworkManager${N_F} (default)\n"
                printf "%b" "${C_Y}[2] - I will use my own (skip) >>${N_F} \n\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Which network manager do you want to use? "
                printf "%b" "[0/1/2] -> "

                local ans
                read -r ans
                : "${ans:=1}"

                if [[ "${ans}" =~ ^[0-2]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        0)
                net_manager="systemd-networkd"
                ;;
        1)
                net_manager="networkmanager"
                ;;
        2)
                net_manager=""
                ;;
        esac

        if [[ "${ans}" -ne 2 ]]; then
                printf "%b" "${INFO} You will use ${C_P}${net_manager}"
                printf "%b" "${N_F}.\n\n"
        fi

        update_config "network_manager" "${net_manager}" "${bash_config}"
}
