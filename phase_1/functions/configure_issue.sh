function configure_issue()
{
        # Return if already set in bash config
        [[ -n "${custom_issue}" ]] && return

        printf "%b" "${Q} Would you like to setup a ${C_P}/etc/issue${N_F} "
        printf "%b" "file [Y/n] -> "

        local ans

        while true; do
                read -r ans
                : "${ans:=Y}"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        if [[ "${ans}" =~ ^[yY]$ ]]; then
                issue=1
                printf "%b" "${INFO} If you want to change it, edit the file "
                printf "%b" "${C_P}/etc/issue${N_F} after reboot.\n\n"
        elif [[ "${ans}" =~ ^[nN]$ ]]; then
                issue=0
                printf "%b" "${INFO} No ${C_P}/etc/issue${N_F} will be "
                printf "%b" "created.\n\n"
        fi

        update_config "custom_issue" "${issue}" "${bash_config}"
}
