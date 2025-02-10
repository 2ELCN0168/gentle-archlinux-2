function menu_disks()
{
        # May need to check if the list is not empty in the JSON config
        local _drive is_nvme

        if [[ -n "${disk_drive}" && "${disk_drive}" =~ ^nvme.*$ ]]; then
                update_config "disk_contains_nvme" "1" "${bash_config}"
        else
                update_config "disk_contains_nvme" "0" "${bash_config}"
        fi

        # Return if already set in bash config.
        [[ -n "${disk_drive}" ]] && return

        while true; do

                title "Disks" "${C_C}" 40

                lsblk -drno NAME

                printf "%b" "\n────────────────────────────────────────\n\n"

                printf "%b" "${Q} Which drive do you want to use? (default=sda)"
                printf "%b" " -> "

                local ans
                read -r ans
                : "${ans:=sda}"

                # Check if the selected drive is a block device
                if [[ ! -b "/dev/${ans}" ]]; then
                        invalid_answer
                        continue
                fi

                _drive="${ans}"

                printf "%b" "${INFO} The selected disk is: "
                printf "%b" "${C_G}${_drive}${N_F}\n\n"
                break
        done

        # If there is a nvme, add nvme flag.
        if [[ "${_drive}" =~ ^nvme.*$ ]]; then
                update_config "disk_contains_nvme" "1" "${bash_config}"
        else
                update_config "disk_contains_nvme" "0" "${bash_config}"
        fi

        update_config "disk_drive" "${_drive}" "${bash_config}"
}
