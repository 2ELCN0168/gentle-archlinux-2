function format_volumes()
{
        local _drive _lvm filesystem
        _drive="$(jaq -r '.drive.drive' "${json_config}")"
        _lvm="$(jaq -r '.drive.lvm' "${json_config}")"
        filesystem="$(jaq -r '.drive.filesystem' "${json_config}")"

        declare -A volumes_list

        while IFS=$'\t' read -r mountpoint size; do
                volumes_list["${mountpoint}"]="${size}"
        done < <(jaq -r \
                '.drive.volumes.volumes_list[] | "\(.mountpoint)\t\(.size)"' \
                "${json_config}")

        local has_boot_vol=0
        local has_efi=0

        for i in "${!volumes_list[@]}"; do
                if [[ "${i}" == "/efi" ]]; then
                        has_boot_vol=1
                        has_efi=1
                elif [[ "${i}" == "/boot" ]]; then
                        has_boot_vol=1
                fi
        done

        if [[ "${has_boot_vol}" -eq 1 ]]; then
                mkfs.fat -F 32 -l "ESP" "/dev/${_drive}1" 1> "/dev/null"
        fi

        for i in "${!volumes_list[@]}"; do
                # Skip efi volume.
                if [[ "${i}" == "/efi" ]]; then
                        continue
                fi
                # Skip boot volume if no efi volume.
                if [[ "${i}" == "/boot" && "${has_efi}" -eq 0 ]]; then
                        continue
                fi

                if [[ "${_lvm}" -eq 1 ]]; then
                        mkfs."${filesystem}" "/dev/vg_archlinux${i}" 1> "/dev/null"
                        if [[ "${i}" == "/" ]]; then
                                mkfs."${filesystem}" "/dev/vg_archlinux/root" 1> "/dev/null"
                        fi
                elif [[ "${_lvm}" -eq 0 ]]; then
                        echo "TODO"
                fi
        done
}
