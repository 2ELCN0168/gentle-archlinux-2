function create_luks()
{
        # TODO:
        #
        
        local encryption="$(jaq -r '.drives.encryption' ${json_config})"
        local disk_list="$(jaq -r '.drives.selected_drives' ${json_config})"
        local first_disk="$(echo ${disk_list[@]} | cut -d ' ' -f 1)"
        disk_list="$(echo ${disk_list[@]} | cut -d ' ' -f 2-)"

        if [[ "${encryption}" -eq 0 ]]; then
                return
        fi

        cryptsetup luksFormat "/dev/${first_disk}2"

        for i in ${disk_list[@]}; do
                cryptsetup luksFormat "/dev/${i}"
        done

        # dd bs=512 count=4 if="/dev/random iflag=fullblock" |
        # install -m 0600 "/dev/stdin" "/etc/cryptsetup-keys.d/system_keyfile.key"
}
