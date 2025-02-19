function set_vconsole()
{
        printf "%b" "${INFO} Creating the file ${C_P}/etc/vconsole.conf${N_F}.\n"

        {
                echo -e "KEYMAP=${system_keymap}"
                echo "FONT=ter-116b"
        } > "/etc/vconsole.conf"

        if [[ "${?}" -eq 0 ]]; then
                printf "%b" "${SUC} Created file ${C_P}/etc/vconsole.conf"
                printf "%b" "${N_F}.\n\n"
        else
                printf "%b" "${ERR} Could not create file ${C_P}"
                printf "%b" "/etc/vconsole.conf${N_F}.\n\n"
        fi

}
