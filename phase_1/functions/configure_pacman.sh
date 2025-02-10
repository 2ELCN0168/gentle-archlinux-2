function configure_pacman()
{
        local par_down

        if [[ -z "${pacman_color}" ]]; then
                update_config "pacman_color" "1" "${bash_config}"
        fi

        local color_state

        if [[ "${pacman_color}" -eq 0 ]]; then
                color_state="${C_R}disabled${N_F}"
        elif [[ "${pacman_color}" -eq 1 ]]; then
                color_state="${C_G}enabled${N_F}"
        fi

        printf "%b" "${INFO} Pacman option ${C_P}Color${N_F}: ${color_state}"
        printf "%b" ".\n\n"

        if [[ -z "${pacman_parallel_downloads}" ]]; then
                par_down=8
                update_config "pacman_parallel_downloads" "${par_down}" "${bash_config}"
        else
                par_down="${pacman_parallel_downloads}"
        fi

        printf "%b" "${INFO} Pacman option ${C_P}ParallelDownloads${N_F}: "
        printf "%b" "${C_C}${par_down}${N_F}.\n\n"
}
