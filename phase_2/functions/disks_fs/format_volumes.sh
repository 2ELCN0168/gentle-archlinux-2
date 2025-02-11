# TODO:
# This is very uncomplete

function format_volumes()
{
        if [[ "${disk_lvm}" -eq 0 ]]; then
                format_no_lvm
        elif [[ "${disk_lvm}" -eq 1 ]]; then
                format_lvm
        fi
}

function format_no_lvm()
{
        local counter
        counter=2

        # The EFI partition should never have another label than "ESP".
        if [[ "${!volumes_volumes_list[*]}" =~ "/efi" ]]; then
                local efi_part
                efi_part="$(blkid -L ESP)"
        fi

        for i in "${!volumes_volumes_list[@]}"; do
                if [[ "${i}" == "/efi" ]]; then
                        mkfs.fat -F 32 "${efi_part}"
                        continue
                fi

                if ! mkfs."${disk_filesystem}" "/dev/${disk_drive}${counter}" \
                        1> "/dev/null" 2>&1; then
                        break
                else
                        ((counter++))
                fi
        done
}

function format_lvm()
{
        local counter
        counter=2

        local has_efi has_boot
        has_efi=0
        has_boot=0

        for i in "${!volumes_volumes_list[@]}"; do
                if [[ "${i}" == "/boot" ]]; then
                        has_boot=1
                fi
                if [[ "${i}" == "/efi" ]]; then
                        has_efi=1
                fi
        done

        # if [[ "${has_efi}"

        for i in "${!volumes_volumes_list[@]}"; do
                if [[ "${i}" == "/efi" ]]; then
                        mkfs.fat -F 32 "$(blkid -L ESP)"
                fi
        done

        for i in "/dev/vg_archlinux/"*; do
                mkfs."${disk_filesystem}" "${i}" -L "$(basename "${i}")"
        done

}
