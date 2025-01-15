function partition_disks()
{
        local _lvm="$(jaq -r '.drives.lvm' ${json_config})"
        local encryption="$(jaq -r '.drives.encryption' ${json_config})"
        local uefi="$(jaq -r '.system.uefi' ${json_config})"
        local disk_list="$(jaq -r '.drives.selected_drives' ${json_config})"

        local counter=0

        set -- "${disk_list}"
        local primary_disk="${1}"

        if [[ "${uefi}" -eq 1 ]]; then
                printf "%b" "${INFO} Creating two partitions for ${C_C}GPT"
                printf "%b" "${N_F} disk on ${C_P}${primary_disk}${N_F}.\n"

                silent parted -s "/dev/${primary_disk}" mklabel gpt
                silent sgdisk -n 1::+512M -t 1:ef00 "${primary_disk}"
        elif [[ "${uefi}" -eq 0 ]]; then
                printf "%b" "${INFO} Creating two partitions for ${C_R}MBR"
                printf "%b" "${N_F} disk on ${C_P}${primary_disk}${N_F}.\n"

                silent parted -s "${primary_disk}" mklabel msdos
                silent parted -s "${primary_disk}" mkpart primary fat32 1Mib 512Mib
        fi
}
