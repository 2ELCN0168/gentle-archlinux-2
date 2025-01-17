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

        for i in ${!volumes_list[@]}; do
                name="$(echo ${!volumes_list[${i}]} | sed 's/\//-/g' | cut -c 2-)"
                if [[ -z "${name}" ]]; then
                        name="root"
                fi
                lvcreate -L ${volumes_list[${i}]} -n "${name}" vg_archlinux
        done
}
