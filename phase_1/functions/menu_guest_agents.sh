function menu_guest_agents()
{
        while true; do
                title "Guest agents" "${C_C}" 40

                printf "%b" "[0] - ${C_C}qemu-guest-agent${N_F}\n"
                printf "%b" "[1] - ${C_B}virtualbox-guest-utils${N_F}\n"
                printf "%b" "[2] - ${C_Y}open-vm-tools${N_F}\n"
                printf "%b" "[3] - ${C_W}None${N_F} (default)\n\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Do you want to install a guest-agent? "
                printf "%b" "[0/1/2/3] -> "

                local ans
                read -r ans
                : "${ans:=3}"

                if [[ "${ans}" =~ ^[0-3]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        local guest_agent

        case "${ans}" in
                0) guest_agent="qemu-guest-agent" ;;
                1) guest_agent="virtualbox-guest-utils" ;;
                2) guest_agent="open-vm-tools" ;;
                3) guest_agent="" ;;
        esac

        if [[ "${ans}" -ne 3 ]]; then
                printf "%b" "${INFO} ${C_P}${guest_agent}${N_F} will "
                printf "%b" "be installed.\n\n"
        else
                printf "%b" "${INFO} No guest-agent will be installed.\n\n"
        fi

        jaq -i 'packages.additional_packages += ["'"${guest_agent}"'"]' \
        "${json_config}"
}