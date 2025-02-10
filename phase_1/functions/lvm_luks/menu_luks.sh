function menu_luks()
{
        local _encryption

        # Return if 'disk_encryption' is set in the bash config.
        [[ -n "${disk_encryption}" ]] && return

        while true; do
                printf "%b" "${Q} Do you want your system to be encrypted with "
                printf "%b" "${C_R}LUKS${N_F}? [y/N] -> "

                local ans
                read -r ans
                : "${ans:=N}"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        if [[ "${ans}" =~ ^[yY]$ ]]; then
                _encryption=1
                printf "%b" "${INFO} Your drive will be encrypted.\n\n${N_F}"
        elif [[ "${ans}" =~ ^[nN]$ ]]; then
                _encryption=0
                printf "%b" "${INFO} Your drive won't be encrypted.\n\n${N_F}"
        fi

        update_config "disk_encryption" "${_encryption}" "${bash_config}"
}
