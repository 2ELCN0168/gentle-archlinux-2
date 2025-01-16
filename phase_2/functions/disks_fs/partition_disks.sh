function partition_disks()
{
        local uefi="$(jaq -r '.system.uefi' ${json_config})"
        local _lvm="$(jaq -r '.drives.lvm' ${json_config})"
        local encryption="$(jaq -r '.drives.encryption' ${json_config})"
        local disk_list="$(jaq -r '.drives.selected_drives' ${json_config})"
        local first_disk="$(echo ${disk_list[@]} | cut -d ' ' -f 1)"
        

        # Create partition table GPT or MBR
        for i in ${disk_list[@]}; do
                if [[ "${uefi}" -eq 1 ]]; then
                        # GPT
                        parted -s "/dev/${i}" mklabel gpt
                elif [[ "${uefi}" -eq 0 ]]; then
                        # MBR
                        parted -s "/dev/${i}" mklabel msdos
                fi
        done

        # Create a efi/boot partition outside the lvm or encrypted volume.
        # Then, create the "container" on the first disk.
        # Do not create partition on other disk, they will be used as is.
        if [[ "${_lvm}" -eq 1 || "${encryption}" -eq 1 ]]; then
                if [[ "${uefi}" -eq 1 ]]; then
                        # /efi
                        sgdisk -n 1::+512M -t 1:ef00 "/dev/${first_disk}"  
                        # Container partition
                        parted -s "/dev/${first_disk}" mkpart Archlinux \
                        600Mib 100%
                elif [[ "${uefi}" -eq 0 ]]; then
                        # /boot
                        parted -s "/dev/${first_disk}" mkpart primary fat32 \
                        1Mib 512Mib
                        # Container partition
                        parted -s "/dev/${first_disk}" mkpart primary \
                        600Mib 100%
                fi
        fi

        

        # local _lvm="$(jaq -r '.drives.lvm' ${json_config})"
        # local encryption="$(jaq -r '.drives.encryption' ${json_config})"
        # local uefi="$(jaq -r '.system.uefi' ${json_config})"
        # local disk_list="$(jaq -r '.drives.selected_drives' ${json_config})"
        #
        # local counter=0
        #
        # set -- "${disk_list}"
        # local primary_disk="${1}"
        #
        # if [[ "${uefi}" -eq 1 ]]; then
        #         printf "%b" "${INFO} Creating partition table for ${C_C}GPT"
        #         printf "%b" "${N_F} disks on ${C_P}${disk_list}${N_F}.\n"
        #
        #         for i in ${disk_list[@]}; do
        #                 parted -s "/dev/${i}" mklabel gpt
        #         done
        # elif [[ "${uefi}" -eq 0 ]]; then
        #         printf "%b" "${INFO} Creating partition table for ${C_R}MBR"
        #         printf "%b" "${N_F} disks on ${C_P}${disk_list}${N_F}.\n"
        #
        #         for i in ${disk_list[@]}; do
        #                 parted -s "/dev/${i}" mklabel msdos
        #         done
        # fi
        #
        # # TODO:
        # # Get all the volume names and their size before creating them
        #
        # # Create the partitions only if there is no logical volume (LVM or LUKS)
        # if [[ "${_lvm}" -eq 0 && "${encryption}" -eq 0 ]]; then
        #         declare -A volumes
        #
        #         while IFS=$'\t' read -r mountpoint size; do
        #                 volumes["${mountpoint}"]="${size}"
        #         done < <(cat ${json_config} |
        #         jaq -r '.drives.volumes.volumes_list[] | "\(.mountpoint)\t\(.size)"')
        # fi
        #
        # # Gather /efi size, if not declare that there is no /efi volume.
        # efi_part_size="$(jaq -r '.drives.volumes.volumes_list[] | 
        # select(.mountpoint == "/efi") | .size' ${json_config})"
        #
        # local is_uefi_vol
        #
        # if [[ -n "${efi_part_size}" ]]; then
        #         is_uefi_vol=1
        # else
        #         is_uefi_vol=0
        # fi
        #
        # # Create only one another partition on the primary disk if there is 
        # # a need for logical volumes.
        # # /boot must be outside a logical volume.
        # if [[ "${_lvm}" -eq 1 || "${encryption}" -eq 1 ]]; then
        #         # For UEFI/GPT
        #         if [[ "${uefi}" -eq 1 ]]; then
        #                 sgdisk -n 1::+${efi_part_size} -t 1:ef00 \
        #                 "/dev/${primary_disk}"
        #                 parted -s "/dev/${primary_disk}" mkpart Archlinux \
        #                 600Mib 100% 
        #         # For BIOS/MBR
        #         elif [[ "${uefi}" -eq 0 ]]; then
        #                 parted -s "/dev/${primary_disk}" mkpart primary fat32 \
        #                 1Mib 512Mib
        #                 parted -s "/dev/${primary_disk}" mkpart primary \
        #                 512Mib 100%
        #         fi
        # fi
        #
}
