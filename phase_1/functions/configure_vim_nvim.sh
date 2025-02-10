function configure_vim_nvim()
{
        local _vim

        [[ -n "${packages_vim_nvim_configuration}" ]] && return

        local ans

        while true; do
                printf "%b" "${Q} Do you want to deploy Vim/Neovim "
                printf "%b" "configuration files? [Y/n] -> "

                read -r ans
                : "${ans:=Y}"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        [yY]) _vim=1 ;;
        [nN]) _vim=0 ;;
        esac

        if [[ "${ans}" =~ ^[yY]$ ]]; then
                printf "%b" "\n"
                printf "%b" "${INFO} The files will be deployed in "
                printf "%b" "${C_P}/etc/skel/.config, /root/.config${N_F}\n"
                printf "%b" "and in your home directory if you create an user."
                printf "%b" "\n\n"
        fi

        update_config "packages_vim_nvim_configuration" "${_vim}" \
                "${bash_config}"
}
