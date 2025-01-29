function configure_pacman()
{
        local color par_down

        color="$(jaq -r '.system.pacman.color' "${json_config}")"
        par_down="$(jaq -r '.system.pacman.parallel_downloads' "${json_config}")"

        if [[ -z "${color}" ]]; then
                color=1
                jaq -i '.system.pacman.color = "'"${color}"'"' "${json_config}"
        fi

        local color_state

        if [[ "${color}" -eq 0 ]]; then
                color_state="${C_R}disabled${N_F}"
        elif [[ "${color}" -eq 1 ]]; then
                color_state="${C_G}enabled${N_F}"
        fi

        printf "%b" "${INFO} Pacman option ${C_P}Color${N_F}: ${color_state}"
        printf "%b" ".\n\n"

        if [[ -z "${par_down}" ]]; then
                par_down=8
                jaq -i '.system.pacman.parallel_downloads = "'"${par_down}"'"' \
                        "${json_config}"
        fi

        printf "%b" "${INFO} Pacman option ${C_P}ParallelDownloads${N_F}: "
        printf "%b" "${C_C}${par_down}${N_F}.\n\n"
}
