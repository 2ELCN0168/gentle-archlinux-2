function menu_fs()
{
        local filesystem

        # Return if 'disk_filesystem' is set in the bash config.
        [[ -n "${disk_filesystem}" ]] && return

        while true; do
                title "Filesystem" "${C_C}" 40

                printf "%b" "[0] - ${C_Y}BTRFS${N_F}\n"
                printf "%b" "[1] - ${C_C}XFS${N_F} (default)\n"
                printf "%b" "[2] - ${C_R}EXT3${N_F}\n"
                printf "%b" "[3] - ${C_R}EXT4${N_F}\n"
                printf "%b" "\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Which filesystem do you want to use? "
                printf "%b" "[0/1/2/3] -> "

                local ans
                read -r ans
                : "${ans:=1}"

                if [[ "${ans}" =~ ^[0-3]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
        0) filesystem="btrfs" ;;
        1) filesystem="xfs" ;;
        2) filesystem="ext3" ;;
        3) filesystem="ext4" ;;
        esac

        printf "%b" "${INFO} You chose ${C_W}${filesystem^^}${N_F}.\n"

        update_config "disk_filesystem" "${filesystem}" "${bash_config}"
}
