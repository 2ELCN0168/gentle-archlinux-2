function menu_disks()
{
        # May need to check if the list is not empty in the JSON config
        local disks_list is_list_empty
        local is_lvm

        disks_list="$(jaq -r '.drives.selected_drives' ${json_config})"
        is_lvm="$(jaq -r '.drives.lvm' ${json_config})"

        # If the table is empty in the JSON file, reset it in Bash
        if [[ "${disks_list#}" == "[]" ]]; then
               disks_list=()
        fi

        # Check if LVM is set to 1 if the disk list contains multiple names
        if [[ "${#disks_list[@]}" -gt 1 ]]; then
                if [[ "${is_lvm}" -ne 1 ]]; then
                        printf "%b" "${ERR} The disk list contains multiple "
                        printf "%b" "elements but LVM is not set to 1. "
                        printf "%b" "Exiting.\n"
                        exit 1
                fi
        fi

        # If the disks list is empty, set the var to 0
        if [[ "${#disks_list[@]}" -eq 0 ]]; then
                is_list_empty=1
        else
                is_list_empty=0 
        fi

        while true; do
                # Skip if the disks list was already filled
                [[ "${is_list_empty}" -eq 0 ]] && break

                display_disks ${disks_list[@]}

                local ans
                read -r ans
                : "${ans:=sda}"

                # Quit if q/Q is typed and the disks list is not empty
                [[ "${ans}" =~ ^[qQ]$ && "${#disks_list[@]}" -ne 0 ]] && break

                # Check if the selected drive is a block device
                if [[ ! -b "/dev/${ans}" ]]; then
                        invalid_answer
                        continue
                fi

                # Check if the device is already in the list
                if [[ "${disks_list[@]}" =~ "${ans}" ]]; then
                        printf "%b" "${WARN} The selected block device is "
                        printf "%b" "already in the list!\n"
                else
                        disks_list+=("${ans}")
                fi

                # Exit after one choice if LVM is set to 0
                if [[ "${is_lvm}" -eq 0 ]]; then
                break
                fi
        done

        for i in "${disks_list[@]}"; do
                jaq -i '.drives.selected_drives += ["'"${i}"'"]' \
                "${json_config}"
        done

        printf "%b" "${INFO} The selected disk(s) are: ${C_G}${disks_list[*]}"
        printf "%b" "${N_F}\n\n"
}

function display_disks()
{
        # $1 is an exclusion from the results.

        local exclusion="sr0|loop0"
        
        for a in "${@}"; do
                exclusion+="|${a}"
        done

        title "Disks" "${C_C}" 40
        
        lsblk -drno NAME | grep --invert-match --extended-regexp "${exclusion}"

        printf "%b" "\n────────────────────────────────────────\n\n"

        printf "%b" "${Q} Which drive do you want to use? (default=sda) "
        printf "%b" "Type \"[q]\" to finish selection -> "
}
