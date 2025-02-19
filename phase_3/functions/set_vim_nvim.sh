function set_vim_nvim()
{
        local paths=()
        paths=(
                "/root"
                "/etc/skel"
        )

        for i in "${paths[@]}"; do
                if [[ ! -d "${i}/.config" ]]; then
                        mkdir -p "${i}/.config"
                fi

                if cp -a "/root/gentle-archlinux-2/phase_3/include/.config/nvim" \
                        "${i}/.config" 1> "/dev/null" 2>&1; then
                        printf "%b" "${SUC} Copied ${C_P}Neovim configuration"
                        printf "%b" "${N_F} to ${C_P}${i}/.config${N_F}.\n"
                else
                        printf "%b" "${WARN} Could not copy ${C_P}Neovim "
                        printf "%b" "configuration"
                        printf "%b" "${N_F} to ${C_P}${i}/.config${N_F}.\n"
                fi

                if cp -a "/root/gentle-archlinux-2/phase_3/include/.config/.vimrc" \
                        "${i}/.config" 1> "/dev/null" 2>&1; then
                        printf "%b" "${SUC} Copied ${C_P}Vim configuration"
                        printf "%b" "${N_F} to ${C_P}${i}/.config${N_F}.\n"
                else
                        printf "%b" "${WARN} Could not copy ${C_P}Vim "
                        printf "%b" "configuration"
                        printf "%b" "${N_F} to ${C_P}${i}/.config${N_F}.\n"
                fi

                printf "%b" "\n"
        done

}
