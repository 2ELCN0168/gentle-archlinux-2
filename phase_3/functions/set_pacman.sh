function set_pacman()
{
        printf "%b" "${INFO} Uncommenting ${C_P}Color${N_F} in "
        printf "%b" "${C_P}/etc/pacman.conf${N_F}.\n"

        printf "%b" "${INFO} Uncommenting ${C_P}ParallelDownloads 5${N_F} in "
        printf "%b" "${C_P}/etc/pacman.conf${N_F}.\n"

        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' "/etc/pacman.conf"
}
