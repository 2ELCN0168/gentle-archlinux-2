function create_luks()
{
        local encryption="$(jaq -r '.drives.encryption' ${json_config})"
        local disk_list="$(jaq -r '.drives.selected_drives' ${json_config})"
        disk_list="$(echo ${disk_list[@]} | cut -d ' ' -f 2-)"
        local first_disk="$(echo ${disk_list[@]} | cut -d ' ' -f 1)"

        if [[ "${encryption}" -eq 0 ]]; then
                return
        fi

        cryptsetup luksFormat "/dev/${first_disk}2"

        for i in ${disk_list[@]}; do
                cryptsetup luksFormat "/dev/${i}"
        done

}
