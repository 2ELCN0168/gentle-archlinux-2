function menu_root_account()
{
        local root_account

        # Return if root_account is set in the JSON config.
        [[ -n "${user_root_account}" ]] && return

        while true; do
                printf "%b" "${Q} Do you want to lock the root account? "
                printf "%b" "[Y/n] ->"

                local ans
                read -r ans
                : "${ans:=Y}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        [yY]) root_account=0 ;;
        [nN]) root_account=1 ;;
        esac

        if [[ "${ans}" =~ ^[yY]$ ]]; then
                printf "%b" "${INFO} ${C_R}root${N_F} account will be locked."
                printf "%b" "\n\n"
        fi

        update_config "user_root_account" "${root_account}" "${bash_config}"
}
