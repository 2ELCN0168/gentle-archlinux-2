function create_lvm()
{
        local disk_list
        disk_list="$(jaq -r '.drives.selected_drives' ${json_config})"
        local first_disk
        first_disk="$(echo ${disk_list[@]} | cut -d ' ' -f 1)"
        disk_list="$(echo ${disk_list[@]} | cut -d ' ' -f 2-)"

        declare -A volumes_list
        
        while IFS=$'\t' read -r mountpoint size; do
                volumes_list["${mountpoint}"]="${size}"
        done < <(cat ${json_config} |
        jaq -r '.drives.volumes.volumes_list[] | "\(.mountpoint)\t\(.size)"')

        pvcreate "/dev/${first_disk}2"

        
        local pv_list
        for i in ${disk_list[@]}; do
                pvcreate "/dev/${i}"
                pv_list+=("/dev/${i}")
        done

        vgcreate vg_archlinux ${pv_list[@]}

        local has_efi=0
        local has_boot=0
        for i in "${!volumes_list[@]}"; do
                if [[ "${i}" == "/efi" ]]; then
                        has_efi=1
                elif [[ "${i}" == "/boot" ]]; then
                        has_boot=1
                fi
        done

        for i in "${!volumes_list[@]}"; do
                name="$(echo ${i} | sed 's/\//-/g' | cut -c 2-)"
                if [[ -z "${name}" ]]; then
                        name="root"
                fi

                # Skip efi volume if boot volume is also there.
                if [[ "${has_efi}" -eq 1 && "${has_boot}" -eq 1 && "${name}" == "efi" ]]; then
                        continue
                fi

                # Skip boot volume if there is no efi volume.
                if [[ "${has_efi}" -eq 0 && "${has_boot}" -eq 1 && "${name}" == "boot" ]]; then
                        continue
                fi

                lvcreate -L "${volumes_list[${i}]}" -n "${name}" vg_archlinux
        done
}
