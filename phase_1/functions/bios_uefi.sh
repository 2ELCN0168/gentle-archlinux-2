function bios_uefi()
{
        local efi_path="/sys/firmware/efi/fw_platform_size"

        # Return if 'uefi' is set in bash config.
        [[ -n "${system_uefi}" ]] && return

        if [[ -f "${efi_path}" ]]; then
                uefi=1
                printf "%b" "${INFO} Running in ${C_C}UEFI${N_F} mode.\n"
                printf "%b" "You have the choice for the bootloader.\n\n"
        else
                uefi=0
                printf "%b" "${INFO} Running in ${C_R}BIOS${N_F} mode.\n"
                printf "%b" "Bootloader choice is set to ${C_R}GRUB${N_F}\n\n"
        fi

        update_config "system_uefi" "${uefi}" "${bash_config}"
}
