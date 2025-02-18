function set_hostname()
{
        echo -e "${system_hostname}.${system_domain_name}" > "/etc/hostname"

        if [[ "${?}" -eq 0 ]]; then
                printf "%b" "${SUC} Hostname (FQDN) set to: ${C_P}"
                printf "%b" "${system_hostname}.${system_domain_name}${N_F}."
                printf "%b" "\n\n"
        else
                printf "%b" "${ERR} Hostname (FQDN) could not be set to: ${C_P}"
                printf "%b" "${system_hostname}.${system_domain_name}${N_F}."
                printf "%b" "\n\n"
        fi
}
