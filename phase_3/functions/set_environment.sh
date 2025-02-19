function set_environment()
{
        curl "https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-prompt.sh" \
                "/root/gentle-archlinux-2/phase_3/include/.git-prompt.sh"

        local shellrc=(
                ".bashrc"
                ".zshrc"
                ".git-prompt.sh"
        )

        local paths=(
                "/etc/skel"
                "/root"
        )

        for i in "${paths[@]}"; do
                for a in "${shellrc[@]}"; do
                        cp "/root/gentle-archlinux-2/phase_3/include/${a}" "${i}"
                done
        done

        if [[ "${n_korea}" -eq 1 ]]; then
                echo -e "alias fastfetch='fastfetch --logo redstaros'" \
                        >> "/etc/skel/{.bashrc,.zshrc}"
        fi

        cp "/root/gentle-archlinux-2/phase_3/include/shell_conf.d" "/etc"
}
