#
#        ,                       _     _ _                       
#       /#\        __ _ _ __ ___| |__ | (_)_ __  _   ___  __     
#      ,###\      / _` | '__/ __| '_ \| | | '_ \| | | \ \/ /     
#     /#####\    | (_| | | | (__| | | | | | | | | |_| |>  <      
#    /##;-;##\    \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\TM   
#   /##(   )##`                                                  
#  /#;--   --;#\              Gentle Installer 2.                  
# /`           `\                                                
#

# Author: 2ELCN0168

function greetings()
{
        setfont
        clear

        local text

        if [[ "${opt_m}" -eq 1 ]]; then
                text="${C_P}Minimal installation mode.${N_F}"
        elif [[ "${opt_c}" -eq 1 ]]; then
                text="${C_G}Complete installation mode.${N_F}"
        elif [[ "${opt_e}" -eq 1 ]]; then
                text="${C_R}Hardened installation mode.${N_F}"
        else
                text="${C_C}Standard installation mode.${N_F}"
        fi

        printf "%b" "\n"
        printf "%b" "${C_B}       ,       ${C_C}                _     _ _                               \n"
        printf "%b" "${C_B}      /#\      ${C_C}  __ _ _ __ ___| |__ | (_)_ __  _   ___  __             \n"
        printf "%b" "${C_B}     ,###\     ${C_C} / _\` | '__/ __| '_ \| | | '_ \| | | \ \/ /            \n"
        printf "%b" "${C_B}    /#####\    ${C_C}| (_| | | | (__| | | | | | | | | |_| |>  <              \n"
        printf "%b" "${C_B}   /##;-;##\   ${C_C} \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\ ${C_G}TM    \n"
        printf "%b" "${C_B}  /##(   )##\`                                                               \n"
        printf "%b" "${C_B} /#;--   --;#\  ${C_Y}Gentle Installer. ${text}                              \n"
        printf "%b" "${C_B}/\`           \`\                                                            \n"
        printf "%b" "${N_F}\n"

        systemctl daemon-reload 1> "/dev/null" 2>&1
        local mounpoints=("home" "usr" "var" "tmp" "boot" "var/log")
        local counter=0

        for i in "${mountpoints[@]}"; do
                
                funmounting "${1}"
                ((counter++))

                if [[ "${counter}" -eq "${#mountpoints[@]}" ]]; then
                        funmounting "/mnt"
                        printf "%b" "\n"
                fi
        done
}

function funmounting()
{
        if silent umount -R "/mnt/${1}"; then
                printf "%b" "${SUC} Unmounted ${C_C}${1}${N_F}.\n"
        else
                printf "%b" "${ERR} Cannot unmount ${C_C}${1}${N_F}.\n"
                printf "%b" "${ERR} You may want to do it manually "
                printf "%b" "${ERR} before continuing.\n"
        fi
}
