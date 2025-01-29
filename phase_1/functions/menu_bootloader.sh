function menu_bootloader()
{
        local uefi_mode bootloader grub_auth
        uefi_mode="$(jaq -r '.system.uefi' "${json_config}")"
        bootloader="$(jaq -r '.system.bootloader' "${json_config}")"
        grub_auth="$(jaq -r '.system.grub_config.grub_auth' "${json_config}")"

        # Return if 'bootloader' is set in the JSON config.
        [[ -n "${bootloader}" ]] && return

        # BIOS mode uses GRUB and no choice is available.
        if [[ "${uefi_mode}" -eq 0 ]]; then
                bootloader="grub"
                jaq -i '.system.bootloader = "'"${bootloader}"'"' "${json_config}"
                return
        fi

        while true; do
                title "Bootloader" "${C_C}" 40

                printf "%b" "[0] - ${C_C}rEFInd${N_F} (default)\n"
                printf "%b" "[1] - ${C_B}GRUB2${N_F}\n"
                printf "%b" "[2] - ${C_G}systemd-boot${N_F}\n\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Which one do you prefer? [0/1/2] -> "

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
        0) bootloader="refind" ;;
        1) bootloader="grub" ;;
        2) bootloader="systemd-boot" ;;
        esac

        # TODO:
        # if [[ "${ans}" -eq 0 && -z ]]; then
        #         grub_options
        # fi

        jaq -i '.system.bootloader = "'"${bootloader}"'"' "${json_config}"

        case "${bootloader}" in
        "refind") bootloader="${C_C}rEFInd${N_F}" ;;
        "grub") bootloader="${C_B}GRUB${N_F}" ;;
        "systemd-boot") bootloader="${C_R}systemd-boot${N_F}" ;;
        esac

        printf "%b" "${INFO} ${bootloader} will be installed.\n\n"
}

function grub_options()
{
        local ans grub_auth

        while true; do
                printf "%b" "${Q} Do you want to enable authentication in "
                printf "%b" "GRUB? [Y/n] -> "

                read -r ans
                : "${ans:=Y}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        if [[ "${ans}" =~ ^[yY]$ ]]; then
                grub_auth=1
                printf "%b" "${INFO} GRUB authentication will be enabled.\n\n"

        elif [[ "${ans}" =~ ^[nN]$ ]]; then
                grub_auth=0
                printf "%b" "${INFO} GRUB authentication won't be enabled.\n\n"
        fi

        jaq -i '.system.grub_config.grub_auth = "'"${grub_auth}" \
                "${json_config}"
}
