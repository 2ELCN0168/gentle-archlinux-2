function set_hosts()
{
        local tempfile
        tempfile="$(mktemp)"

        {
                echo "127.0.0.1 localhost.localdomain localhost localhost-ipv4"
                echo "::1       localhost.localdomain localhost localhost-ipv6"
                echo -e "127.0.0.1 ${system_hostname}.localdomain ${system_hostname}.${system_domain_name} ${system_hostname}.${system_domain_name}-ipv4"
                echo -e "::1       ${system_hostname}.localdomain ${system_hostname}.${system_domain_name} ${system_hostname}.${system_domain_name}-ipv6"

        } > "/etc/hosts"

        column -t "/etc/hosts" > "${tempfile}"
        mv "${tempfile}" "/etc/hosts"

        printf "%b" "Setting up ${C_P}/etc/hosts${N_F}. Here is the file:\n\n"

        printf "%b" "${C_G}"
        cat "/etc/hosts"
        printf "%b" "${N_F}\n\n"
}
