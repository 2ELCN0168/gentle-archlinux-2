function configure_user()
{
        local active username home_dir administrator xdg_dirs
        active="$(jaq -r '.system.users.user.active' "${json_config}")"
        username="$(jaq -r '.system.users.user.username' "${json_config}")"
        home_dir="$(jaq -r '.system.users.user.home_dir' "${json_config}")"
        administrator="$(jaq -r '.system.users.user.administrator' "${json_config}")"
        xdg_dirs="$(jaq -r '.system.users.user.xdg_dirs' "${json_config}")"

        # Return if already set in JSON config.
        if [[ -n "${active}" ]]; then
                return
        fi

        local ans
        while true; do
                printf "%b" "${Q} Would you like to create a user? [Y/n] -> "
                : "${ans:=Y}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        # Exit if the user doesn't want to create a user (lol).
        if [[ "${ans}" =~ ^[nN]$ ]]; then
                printf "%b" "${INFO} No user will be created.\n\n"
                jaq -i '.system.users.user.active = "0"' "${json_config}"
                return
        elif [[ "${ans}" =~ ^[yY]$ ]]; then
                jaq -i '.system.users.user.active = "1"' "${json_config}"
        fi

        if [[ -z "${username}" ]]; then
                _username
        fi

        if [[ -z "${home_dir}" ]]; then
                _home_dir
        fi

        if [[ -z "${administrator}" ]]; then
                _administrator
        fi

        if [[ -z "${xdg_dirs}" ]]; then
                _xdg_dirs
        fi
}

function _username()
{
        local username_list=(
                "anamorphic-whale"
                "outrageous-panda"
                "fluffy-bear"
                "vilain-deer"
                "gentle-butterfly"
                "sweety-firefox"
                "lazy-jaguar"
                "unstoppable-hyrax"
                "violent-caterpillar"
                "amazing-penguin"
                "magical-elephant"
                "isometric-owl"
                "weird-canary"
                "cute-lizard"
        )

        local default_username
        default_username="$(shuf -n 1 -e "${username_list[@]}")"

        # REGEX:
        # Must start with a lowercase character or an underscore,
        # Hyphens and numbers are allowed after the first character.
        # Total length must not exceed 32 characters.
        local username_regex="^[a-z_][a-z0-9_-]{0,31}$"

        printf "%b" "${Q} Enter your username.\n"
        printf "%b" "Usernames must not exceed ${C_P}32 chars and they must "
        printf "%b" "only contain lowercase letters, digits, hyphens and "
        printf "%b" "underscores. \n"
        printf "%b" "Default is ${C_B}'${default_username}'${N_F} -> "

        local ans
        while true; do
                read -r ans
                : "${ans:=${default_username}}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ${username_regex} ]]; then
                        printf "%b" "${INFO} Username: ${C_P}${ans}${N_F}.\n\n"
                        break
                else
                        printf "%b" "${WARN} ${C_R}Invalid username${N_F}.\n"
                        printf "%b" "Please, enter a valid username -> "
                fi
        done

        jaq -i '.system.users.user.username = "'"${ans}"'"' "${json_config}"
}

function _home_dir()
{
        local ans home_dir

        while true; do
                printf "%b" "${Q} Do you want to create a home directory "
                printf "%b" "for this user? [Y/n] -> "

                read -r ans
                : "${ans:=Y}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        [yY]) home_dir=1 ;;
        [nN]) home_dir=0 ;;
        esac

        jaq -i '.system.users.user.home_dir = "'"${home_dir}"'"' "${json_config}"
}

function _administrator()
{
        local ans administrator

        while true; do
                printf "%b" "${Q} Will this user be administrator? \n"
                printf "%b" "${Q} ${C_Y}Warning, if you answer 'no'. The root "
                printf "%b" "account will be activated and you will be asked "
                printf "%b" "to change its password (lockdown prevention) "
                printf "%b" "${N_F}[Y/n] -> "

                read -r ans
                : "${ans:=Y}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        [yY]) administrator=1 ;;
        [nN]) administrator=0 ;;
        esac

        jaq -i '.system.users.user.administrator = "'"${administrator}"'"' \
                "${json_config}"
}

function _xdg_dirs()
{
        local ans xdg_dirs

        while true; do
                printf "%b" "${Q} Do you want to create user directories? \n"
                printf "%b" "${C_P}(Documents, Pictures, Downloads, etc.)"
                printf "%b" "${N_F} [Y/n] -> "

                read -r ans
                : "${ans:=Y}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        [yY]) xdg_dirs=1 ;;
        [nN]) xdg_dirs=0 ;;
        esac

        jaq -i '.system.users.user.xdg_dirs = "'"${xdg_dirs}"'"' "${json_config}"
}
