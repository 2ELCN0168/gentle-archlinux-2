function configure_vim_nvim()
{
        local _vim _nvim

        _vim="$(jaq -r '.packages.vim_nvim_configuration' "${json_config}")"

        [[ -n "${_vim}" ]] && return

        local ans

        while true; do
                printf "%b" "${Q} Do you want to deploy Vim/Neovim configuration files? [Y/n] -> "

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
                printf "%b" "${INFO} The files will be deployed in ${C_P}/etc/skel/.config, /root/.config${N_F}\n"
                printf "%b" "and in your home directory if you create an user.\n\n"
        fi

        jaq -i '.packages.vim_nvim_configuration = '"${_vim}" "${json_config}"
}
