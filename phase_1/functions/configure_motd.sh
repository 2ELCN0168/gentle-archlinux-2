function configure_motd()
{
        local motd="$(jaq -r '.customization.motd' ${json_config})"

        # Return if already set in JSON config
        [[ -n "${motd}" ]] && return

        printf "%b" "${Q} Would you like to setup a ${C_P}/etc/motd${N_F} "
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
                motd=1
                printf "%b" "${INFO} If you want to change it, edit the file "
                printf "%b" "${C_P}/etc/motd${N_F} after reboot.\n\n"
        elif [[ "${ans}" =~ ^[nN]$ ]]; then
                motd=0
                printf "%b" "${INFO} No ${C_P}/etc/motd${N_F} will be "
                printf "%b" "created.\n\n"
        fi

        jaq -i '.customization.motd = "'"${motd}"'"' "${json_config}"
}
