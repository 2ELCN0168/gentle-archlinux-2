function menu_lvm()
{
        local is_lvm

        # Return if 'disk_lvm' is set in the bash config.
        [[ -n "${disk_lvm}" ]] && return

        while true; do
                printf "%b" "${Q} Do you want to use ${C_C}LVM${N_F}? [y/N] -> "

                local ans
                read -r ans
                : "${ans:=N}"
                printf "%b" "\n"

                case "${ans}" in
                [yY]) is_lvm=1 && break ;;
                [nN]) is_lvm=0 && break ;;
                *) invalid_answer ;;
                esac
        done

        printf "%b" "${INFO} LVM is set to: ${C_C}${is_lvm}${N_F}.\n\n"

        update_config "disk_lvm" "${is_lvm}" "${bash_config}"
}
