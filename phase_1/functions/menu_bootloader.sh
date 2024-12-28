function menu_bootloader()
{
        local uefi_mode="$(jaq -r '.system.uefi' ${json_config})"
        local bootloader="$(jaq -r '.system.bootloader' ${json_config})"
        
        # Return if 'bootloader' is set in the JSON config.
        [[ -n "${bootloader}" ]] && return

        # BIOS mode uses GRUB and no choice is available.
        if [[ "${uefi_mode}" -eq 0 ]]; then
                bootloader="grub"
                return
        fi
        
        while true; do
                title "Bootloader" "${C_C}" 40

                printf "%b" "[0] - ${C_C}rEFInd${N_F} (default)\n"
                printf "%b" "[1] - ${C_B}GRUB2${N_F}\n"
                printf "%b" "[2] - ${C_G}systemd-boot${N_F}\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Which one do you prefer? [0/1/2] -> "

                local ans
                read -r ans
                : "${ans:=0}"

                [[ "${ans}" =~ ^[0-2]$ ]] && break || invalid_answer
        done

        case "${ans}" in
               0) bootloader="refind" ;;
               1) bootloader="grub" ;;
               2) bootloader="systemd-boot" ;;
        esac

        jaq -i '.system.bootloader = "'"${bootloader}"'"' "${json_config}"

        case "${bootloader}" in
               "refind") bootloader="${C_C}rEFInd${N_F}" ;;
               "grub") bootloader="${C_B}GRUB${N_F}" ;;
               "systemd-boot") bootloader="${C_R}systemd-boot${N_F}" ;;
        esac

        printf "%b" "${INFO} ${bootloader} will be installed.\n\n" 
}
