function init_phase_2()
{
        printf "%b" "${C_G}This is the second phase of the script.${N_F} "
        printf "%b" "${C_C}The installation starts now.${N_F}\n\n"

        printf "%b" "${C_Y}Type Ctrl + C to stop the installation.\n"
        printf "%b" "${C_R}Installation will start in: "

        for i in {10..0}; do
                printf "%b" "${C_Y}${i}${N_F}"
                if [[ "${i}" -eq 0 ]]; then
                        break
                fi
                sleep 0.33
                for i in {1..2}; do
                        printf "%b" "."
                        sleep 0.33
                done
        done
}
