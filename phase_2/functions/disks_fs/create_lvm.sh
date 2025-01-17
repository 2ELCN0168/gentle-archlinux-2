function create_lvm()
{
        local disk_list
        disk_list="$(jaq -r '.system.drives.selected_drives' ${json_config})"
        local first_disk
        first_disk="$(echo ${disk_list[@]} | cut -d ' ' -f 1)"
        disk_list="$(echo ${disk_list[@]} | cut -d ' ' -f 2-)"

        declare -A volumes_list
        
        while IFS=$'\t' read -r mountpoint size; do
                volumes["${mountpoint}"]="${size}"
        done < <(cat ${json_config}) |
        jaq -r '.drives.volumes.volumes_list[] | "\(.mountpoint)\t\(.size)"'

        pvcreate "/dev/${first_disk}"

        
        local pv_list
        for i in ${disk_list[@]}; do
                pvcreate "/dev/${i}"
                pv_list+=("/dev/${i}")
        done

        vgcreate vg_archlinux ${pv_list[@]}

        lvcreate -L 15G -n root vg_archlinux
}
