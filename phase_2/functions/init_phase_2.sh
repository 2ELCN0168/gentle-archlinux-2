function init_phase_2()
{
        printf "%b" "${C_C}: :: : : ${C_G}STAGE 2 COMING IN. "
        printf "%b" "${C_C}: :: : :${N}\n"

        printf "%b" "${C_C}The installation starts now.${N_F}\n\n"

        local ans

        while true; do
                printf "%b" "${C_R}Do you want to begin the installation? "
                printf "%b" "[Y/n] ->${N} "

                read -r ans
                : "${ans:=Y}"

                case "${ans}" in
                [yY]) break ;;
                [nN]) exit 0 ;;
                *) invalid_answer ;;
                esac
        done
}
