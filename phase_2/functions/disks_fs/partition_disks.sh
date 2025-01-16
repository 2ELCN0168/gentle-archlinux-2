function partition_disks()
{
        local uefi="$(jaq -r '.system.uefi' ${json_config})"
        local _lvm="$(jaq -r '.drives.lvm' ${json_config})"
        local encryption="$(jaq -r '.drives.encryption' ${json_config})"
        local disk_list="$(jaq -r '.drives.selected_drives' ${json_config})"
        local first_disk="$(echo ${disk_list[@]} | cut -d ' ' -f 1)"
        

        # Create MBR/GPT partition table.
        for i in ${disk_list[@]}; do
                if [[ "${uefi}" -eq 1 ]]; then
                        # GPT
                        parted -s "/dev/${i}" mklabel gpt
                elif [[ "${uefi}" -eq 0 ]]; then
                        # MBR
                        parted -s "/dev/${i}" mklabel msdos
                fi
        done

        # Get either /boot or /efi partition size. If there is /boot AND /efi
        # use, /efi size. If there is only boot, use it. If there is none, the 
        # system cannot use LVM or LUKs.
        # Put the volume to use into a var.
        local efi_size="$(jaq -r '.drives.volumes.volumes_list[] | 
        select(.mountpoint == "/efi") | .size' ${json_config})"

        local boot_size="$(jaq -r '.drives.volumes.volumes_list[] | 
        select(.mountpoint == "/boot") | .size' ${json_config})"

        local boot_vol_size

        # If efi size is not empty.
        if [[ -n "${efi_size}" ]]; then
                boot_vol_size="${efi_size}"
        fi

        # If efi size is empty but boot size is not empty.
        if [[ -z "${efi_size}" && -n "${boot_size}" ]]; then
                boot_vol_size="${boot_size}"
        fi

        # If efi size is empty and boot size is empty too.
        if [[ -z "${efi_size}" && -z "${boot_size}" ]]; then
                boot_vol_size=""
        fi

        # Create a efi/boot partition outside the lvm or encrypted volume.
        # Then, create the "container" on the first disk.
        # Do not create partition on other disk, they will be used as is.
        # If there is no bootable partition outside a logical volume, 
        # the installation fails.
        if [[ "${_lvm}" -eq 1 || "${encryption}" -eq 1 ]]; then
                if [[ -z "${boot_vol_size}" ]]; then
                        exit 1
                fi
                if [[ "${uefi}" -eq 1 ]]; then
                        # /efi or /boot
                        sgdisk -n 1::+"${boot_vol_size}" -t 1:ef00 \
                        "/dev/${first_disk}"  
                        # Container partition
                        parted -s "/dev/${first_disk}" mkpart Archlinux \
                        "${boot_vol_size}" 100%
                elif [[ "${uefi}" -eq 0 ]]; then
                        # /boot
                        parted -s "/dev/${first_disk}" mkpart primary fat32 \
                        1Mib "${boot_vol_size}" 
                        # Container partition
                        parted -s "/dev/${first_disk}" mkpart primary \
                        "${boot_vol_size}" 100%
                fi
        fi

        # If there is only physical volumes (like partitions), check for 
        # $boot_vol_size and create the appropriate partition.
        if [[ "${_lvm}" -eq 0 || "${encryption}" -eq 0 ]]; then
                if [[ -z "${boot_vol_size}" ]]; then
                        continue
                fi
                if [[ "${uefi}" -eq 1 ]]; then
                        # /efi or /boot
                        sgdisk -n 1::+"${boot_vol_size}" -t 1:ef00 \
                        "/dev/${first_disk}"
                elif [[ "${uefi}" -eq 0 ]]; then
                        # /boot
                        parted -s "/dev/${first_disk}" mkpart primary fat32 \
                        1Mib "${boot_vol_size}"
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
