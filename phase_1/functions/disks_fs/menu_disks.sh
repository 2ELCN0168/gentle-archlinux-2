function menu_disks()
{
        # May need to check if the list is not empty in the JSON config
        local _drive is_nvme

        _drive="$(jaq -r '.drive.drive' "${json_config}")"

        # Skip if the disk is already set in the JSON config
        [[ -n "${_drive}" ]] && return

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

                printf "%b" "${INFO} The selected disk is: "
                printf "%b" "${C_G}${_drive}${N_F}\n\n"
                break
        done

        # If there is a nvme, add nvme flag.
        if [[ "${_drive}" =~ ^nvme.*$ ]]; then
                is_nvme=1
        else
                is_nvme=0
        fi

        jaq -i '.drive.contains_nvme = "'"${is_nvme}"'"' "${json_config}"
        jaq -i '.drive.drive = "'"${_drive}"'"' "${json_config}"
}
