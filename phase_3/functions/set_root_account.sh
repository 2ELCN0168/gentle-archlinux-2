function set_root_account()
{
        local state
        state=0

        if [[ "${user_root_account}" -eq 0 ]]; then

                printf "%b" "${INFO} Locking ${C_R}root${N_F} account...\n"

                if passwd -l root 1> "/dev/null" 2>&1; then
                        printf "%b" "${SUC} Locked ${C_R}root${N_F} account.\n\n"
                        state=1
                else
                        printf "%b" "${ERR} Could not lock ${C_R}root${N_F} account.\n\n"
                fi
        fi

        if [[ "${state}" -eq 1 ]]; then
                return
        fi

        printf "%b" "${INFO} Changing password for ${C_R}root${N_F}.\n"

        while true; do
                if passwd root; then
                        break
                fi
        done
}
