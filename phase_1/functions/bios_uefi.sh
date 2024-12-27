function bios_uefi()
{
        local efi_path="$(jaq -r '.system.efi_path' ${json_config})"
        local uefi

        if [[ -f "${efi_path}" ]]; then
                uefi=1
                printf "%b" "${INFO} Running in ${C_C}UEFI${N_F} mode.\n"
                printf "%b" "You have the choice for the bootloader.\n\n"
        else
                uefi=0
                printf "%b" "${INFO} Running in ${C_R}BIOS${N_F} mode.\n"
                printf "%b" "Bootloader choice is set to ${C_R}GRUB${N_F}\n\n"
        fi

        jaq -i '.system.uefi = '"${uefi}" "${json_config}"
}
