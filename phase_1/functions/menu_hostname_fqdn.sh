function menu_hostname()
{
        # Return if a hostname is provided in the bash config.
        [[ -n "${system_hostname}" ]] && return

        # REGEX:
        # Must start with a-Z or A-Z or 0-9. Hyphens are allowed after the first
        # letter. Must not exceed 63 characters.
        local hostname_regex="^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}$"

        # Hostname

        printf "%b" "${Q} Enter your hostname without domain.\n"
        printf "%b" "${Q} Recommended hostname length: ${C_P}15 chars "
        printf "%b" "${C_Y}[a-z][A-Z][0-9].${N_F}\n"
        printf "%b" "Default is ${C_B}'localhost'${N_F} -> "

        local ans

        while true; do
                read -r ans
                : "${ans:=localhost}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ${hostname_regex} ]]; then
                        printf "%b" "${INFO} Hostname: ${C_P}${ans}${N_F}.\n\n"
                        break
                else
                        printf "%b" "${WARN} ${C_R}Invalid hostname.${N_F} "
                        printf "%b" "Hostname must be ${C_P}1-63 characters "
                        printf "%b" "long${N_F}, containing only letters, "
                        printf "%b" "digits, hyphens, and cannot start or end "
                        printf "%b" "with a hyphen. \n\n"

                        printf "%b" "${Q}Please re-enter a valid "
                        printf "%b" "hostname -> "
                fi
        done

        update_config "system_hostname" "${ans}" "${bash_config}"
}

function menu_domain_name()
{
        # Return if a domain name is provided in the bash config.
        [[ -n "${system_domain_name}" ]] && return

        # REGEX:
        # Must start with a-z, A-Z, 0-9. Cannot begin or end with a hyphen or a
        # dot. Must not exceed 255 characters.
        local domain_regex="^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$"

        # Domain name

        printf "%b" "${Q} Enter your domain name "
        printf "%b" "(${C_G}[a-z][A-Z][0-9][.-]${N_F}).\n"
        printf "%b" "${Q} It must no begin with a dot or a hyphen.\n"
        printf "%b" "Default is ${C_B}'home.arpa'${N_F} (RFC 8375) -> "

        local ans

        while true; do
                read ans
                : "${ans:=home.arpa}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ${domain_regex} ]]; then
                        printf "%b" "${INFO} Domain name: "
                        printf "%b" "${C_P}${ans}${N_F}.\n\n"
                        break
                else
                        printf "%b" "${WARN} ${C_R}Invalid domain name.${N_F} "
                        printf "%b" "Domain names must be in the format ${C_Y}"
                        printf "%b" "'example.com'${N_F} or similar, contain "
                        printf "%b" "letters, digits, hyphens, periods, and "
                        printf "%b" "not start or end with a hyphen or a dot. "
                        printf "%b" "\n\n"

                        printf "%b" "${Q}Please re-enter a valid "
                        printf "%b" "domain name -> "
                fi
        done

        update_config "system_domain_name" "${ans}" "${bash_config}"
}
