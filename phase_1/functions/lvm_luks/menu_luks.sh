function menu_luks()
{
        local drive_encryption="$(jaq -r '.drive.encryption' "${json_config}")"

        # Return if 'drive_encryption' is set in the JSON config.
        [[ -n "${drive_encryption}" ]] && return

        while true; do
                printf "%b" "${Q} Do you want your system to be encrypted with "
                printf "%b" "${C_R}LUKS${N_F}? [y/N] -> "

                local ans
                read -r ans
                : "${ans:=N}"

                [[ "${ans}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done

        if [[ "${ans}" =~ ^[yY]$ ]]; then
                drive_encryption=1
                printf "%b" "${INFO} Your drive will be encrypted.\n\n${N_F}"
        elif [[ "${ans}" =~ ^[nN]$ ]]; then
                drive_encryption=0
                printf "%b" "${INFO} Your drive won't be encrypted.\n\n${N_F}"
        fi

        jaq -i '.drive.encryption = '"${drive_encryption}" "${json_config}"
}
