function menu_lvm()
{
        local is_lvm="$(jaq -r '.drive.lvm' "${json_config}")"

        # Return if 'lvm' is set in the JSON config.
        [[ -n "${is_lvm}" ]] && return

        while true; do
                printf "%b" "${Q} Do you want to use ${C_C}LVM${N_F}? [y/N] -> "

                local ans
                read -r ans
                : "${ans:=N}"

                [[ "${ans}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done

        if [[ "${ans}" =~ ^[yY]$ ]]; then
                is_lvm=1
                printf "%b" "${INFO} You will use ${C_C}LVM${N_F}.\n\n"
        elif [[ "${ans}" =~ ^[nN]$ ]]; then
                is_lvm=0
                printf "%b" "${INFO} You won't use ${C_C}LVM${N_F}.\n\n"
        fi

        jaq -i '.drive.lvm = '${is_lvm} "${json_config}"
}
