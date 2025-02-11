function create_luks()
{
        if [[ "${system_encryption}" -eq 0 ]]; then
                return
        fi

        if cryptsetup luksFormat "/dev/${disk_drive}2"; then
                printf "%b" "${SUC} ${C_P}/dev/${disk_drive}2${N_F} has been encrypted."
                printf "%b" "\n"
        else
                printf "%b" "${ERR} There was an error during ${C_P}/dev/"
                printf "%b" "${disk_drive}2${N_F} encryption. Exiting.\n"
                exit 1
        fi

        cryptsetup open "/dev/${disk_drive}2" root
}
