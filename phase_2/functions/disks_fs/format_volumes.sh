function format_volumes()
{
        local is_lvm filesystem disk

        is_lvm="$(jaq -r '.drive.lvm' "${json_config}")"
        filesystem="$(jaq -r '.drive.filesystem' "${json_config}")"
        disk="$(jaq -r '.drive.drive' "${json_config}")"

        declare -A volumes

        # Get every ["mountpoint"]="size".
        while IFS=$'\t' read -r mountpoint size; do
                volumes["${mountpoint}"]="${size}"
        done < <(jaq -r \
                '.drive.volumes.volumes_list[] | "\(.mountpoint)\t\(.size)"' \
                "${json_config}")

        if [[ "${is_lvm}" -eq 0 ]]; then
                format_no_lvm "${filesystem}" "${disk}" "${volumes[@]}"
        elif [[ "${is_lvm}" -eq 1 ]]; then
                format_lvm "${filesystem}" "${disk}" "${volumes[@]}"
        fi
}

function format_no_lvm()
{
        local filesystem disk volumes counter
        filesystem="${1}"
        disk="${2}"
        volumes="${3}"
        counter=2

        # The EFI partition should never have another label than "ESP".
        if [[ "${!volumes[*]}" =~ "/efi" ]]; then
                local efi_part
                efi_part="$(blkid -L ESP)"
        fi

        for i in "${!volumes[@]}"; do
                if [[ "${i}" == "/efi" ]]; then
                        mkfs.fat -F 32 "${efi_part}"
                        continue
                fi

                if ! mkfs."${filesystem}" "/dev/${disk}${counter}" \
                        1> "/dev/null" 2>&1; then
                        break
                else
                        ((counter++))
                fi
        done
}

function format_lvm()
{
        local filesystem disk volumes counter
        filesystem="${1}"
        disk="${2}"
        volumes="${2}"
        counter=2

        local has_efi has_boot
        has_efi=0
        has_boot=0

        for i in "${!volumes[@]}"; do
                if [[ "${i}" == "/boot" ]]; then
                        has_boot=1
                fi
                if [[ "${i}" == "/efi" ]]; then
                        has_efi=1
                fi
        done

        # if [[ "${has_efi}"

        for i in "${!volumes[@]}"; do
                if [[ "${i}" == "/efi" ]]; then
                        mkfs.fat -F 32 "$(blkid -L ESP)"
                fi
        done

        for i in "/dev/vg_archlinux/"*; do
                mkfs."${filesystem}" "/dev/vg_archlinux/${i}"
        done

}
