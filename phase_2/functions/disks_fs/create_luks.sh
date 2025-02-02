function create_luks()
{
        local encryption="$(jaq -r '.drive.encryption' "${json_config}")"
        local _drive="$(jaq -r '.drive.drive' "${json_config}")"

        if [[ "${encryption}" -eq 0 ]]; then
                return
        fi

        if cryptsetup luksFormat "/dev/${_drive}2"; then
                printf "%b" "${SUC} ${C_P}/dev/${_drive}2${N_F} has been encrypted."
                printf "%b" "\n"
        else
                printf "%b" "${ERR} There was an error during ${C_P}/dev/"
                printf "%b" "${_drive}2${N_F} encryption. Exiting.\n"
                exit 1
        fi

        cryptsetup open "/dev/${_drive}2" root
}
