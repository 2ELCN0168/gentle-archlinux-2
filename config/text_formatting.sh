function text_formatting()
{
        export C_R='\033[91m'
        export C_G='\033[92m'
        export C_Y='\033[93m'
        export C_B='\033[94m'
        export C_P='\033[95m'
        export C_C='\033[96m'
        export C_W='\033[97m'

        export B_R='\033[30;101m'
        export B_G='\033[30;102m'
        export B_Y='\033[30;103m'
        export B_B='\033[30;104m'
        export B_P='\033[30;105m'
        export B_C='\033[30;106m'
        export B_W='\033[30;107m'

        # Bold
        export B='\033[0;1m'

        export N_F='\033[0m'

        export Q="${B}${C_C}::${N_F}"
        export INFO="${C_C}[>]${N_F}"
        export SUC="${C_G}[@]${N_F}"
        export WARN="${C_Y}[!]${N_F}"
        export ERR="${C_R}[*]${N_F}"
}
function title()
{
        # Usage: title "Some text" [<"${C_C}"> [<length>]]

        local title="${1}"
        local color="${2:-${N_F}}"

        # NOTE:
        # 30 is the default width if nothing is provided as argument 3
        local total_width="${3:-30}"
        local inner_width=$((total_width - 2))
        local padding=$(((inner_width - ${#title}) / 2))

        local spaces_l="$(printf '%*s' "${padding}" '')"
        local spaces_r="$(
                printf '%*s' \
                        "$((inner_width - ${#title} - padding))" ''
        )"

        local colored_txt="${color}${spaces_l}${title}${spaces_r}${N_F}"

        local border_top="╒$(printf '═%.0s' $(seq 1 ${inner_width}))╕"
        local border_btm="└$(printf '─%.0s' $(seq 1 ${inner_width}))┘"

        printf "%b" "\n${border_top}\n"
        printf "%b" "╡${colored_txt}╞\n"
        printf "%b" "${border_btm}\n\n"
}

function invalid_answer()
{
        printf "%b" "${C_W}> ${WARN} ${C_R}Not a valid answer."
        printf "%b" "${N_F}\n\n"
}

function silent()
{
        "${@}" 1> "/dev/null" 2>&1
}

function update_config()
{
        local key="${1}"
        local value="${2}"
        local file="${3}"

        if grep -q "^${key}=" "${file}"; then
                sed -i "s|^${key}=.*|${key}=\"${value}\"|" "${file}"
        else
                echo "${key}=\"${value}\"" >> "${file}"
        fi
}
