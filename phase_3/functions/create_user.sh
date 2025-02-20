function create_user()
{
        printf "%b" "${INFO} Creating a new user: "
        printf "%b" "${C_P}${user_username}${N_F}.\n"

        if useradd -m -U -s "/bin/bash" "${user_username}" \
                1> "/dev/null" 2>&1; then
                printf "%b" "${SUC} Created user: ${C_P}"
                printf "%b" "${user_username}${N_F}.\n"
        else
                printf "%b" "${ERR} Could not create user: ${C_P}"
                printf "%b" "${user_username}${N_F}.\n"
                return
        fi

        printf "%b" "${INFO} Changing password for user: "
        printf "%b" "${C_P}${user_username}${N_F}.\n"

        while true; do
                if passwd "${user_username}"; then
                        break
                fi
        done

        if [[ "${user_administrator}" -eq 1 ]]; then
                printf "%b" "${INFO} Adding ${C_P}"
                printf "%b" "${user_username}${N_F} "
                printf "%b" "to ${C_P}wheel${N_F} group.\n"
                usermod -ag wheel "${user_username}"
        fi

        if [[ "${user_xdg_dirs}" -eq 1 ]]; then
                printf "%b" "${INFO} Creating user directories.\n"
                if sudo --user="${user_username}" xdg-user-dirs-update \
                        1> "/dev/null" 2>&1; then
                        printf "%b" "${SUC} Created user directories.\n"
                else
                        printf "%b" "${ERR} Could not create user directories.\n"
                fi
        fi

        printf "%b" "\n"
}
