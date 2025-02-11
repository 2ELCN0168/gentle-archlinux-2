function create_lvm()
{
        local root_volume

        # Return if LVM is not wanted
        [[ "${disk_lvm}" -eq 0 ]] && return

        # declare -A volumes_list

        # If there was an encryption, the new root volume is /dev/mapper/root.
        if [[ "${disk_encryption}" -eq 1 ]]; then
                root_volume="/dev/mapper/root"
        elif [[ "${encryption}" -eq 0 ]]; then
                root_volume="/dev/${disk_drive}2"
        fi

        pvcreate "${root_volume}"
        vgcreate vg_archlinux "${root_volume}"

        local name
        local has_efi=0
        local has_boot=0

        for i in "${!volumes_volumes_list[@]}"; do
                if [[ "${i}" == "/efi" ]]; then
                        has_efi=1
                elif [[ "${i}" == "/boot" ]]; then
                        has_boot=1
                fi
        done

        for i in "${!volumes_volumes_list[@]}"; do
                name="$(echo "${i}" | sed 's/\//-/g' | cut -c 2-)"
                if [[ -z "${name}" ]]; then
                        name="root"
                fi

                # Skip efi volume if boot volume is also there.
                if [[ "${has_efi}" -eq 1 && "${has_boot}" -eq 1 &&
                        "${name}" == "efi" ]]; then
                        continue
                fi

                # Skip boot volume if there is no efi volume.
                if [[ "${has_efi}" -eq 0 && "${has_boot}" -eq 1 &&
                        "${name}" == "boot" ]]; then
                        continue
                fi

                lvcreate -L "${volumes_volumes_list[${i}]}" -n "${name}" \
                        vg_archlinux
        done
}
