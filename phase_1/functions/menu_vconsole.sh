function menu_vconsole()
{
        local keymap="$(jaq -r '.system.keymap' "${json_config}")"

        # Return if it's already set in the JSON config.
        [[ -n "${keymap}" ]] && return

        while true; do
                title "Keymap" "${C_C}" 40

                printf "%b" "[0] - ${C_B}US INTL. - QWERTY with dead keys "
                printf "%b" "${N_F}(default)\n"
                printf "%b" "[1] - ${C_B}US - QWERTY${N_F}\n"
                printf "%b" "[2] - ${C_C}FR - AZERTY${N_F}\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Select your keymap [0/1/2] -> "

                local ans
                read -r ans
                : "${ans:=0}"

                if [[ "${ans}" =~ ^[0-2]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        0) keymap="us-acentos" ;;
        1) keymap="us" ;;
        2) keymap="fr" ;;
        esac

        printf "%b" "${INFO} You chose ${C_P}${keymap}${N_F}.\n\n"

        jaq -i '.system.keymap = "'"${keymap}"'"' "${json_config}"
}
