function partition_disks()
{
        local uefi _lvm encryption _drive efi_size boot_size boot_vol_size

        uefi="$(jaq -r '.system.uefi' "${json_config}")"
        _lvm="$(jaq -r '.drive.lvm' "${json_config}")"
        encryption="$(jaq -r '.drive.encryption' "${json_config}")"
        _drive="$(jaq -r '.drive.drive' "${json_config}")"

        # Create MBR/GPT partition table.
        if [[ "${uefi}" -eq 1 ]]; then
                # GPT
                # parted -s "/dev/${i}" mklabel gpt
                sgdisk -Z "/dev/${_drive}"
                sgdisk -o "/dev/${_drive}"
        elif [[ "${uefi}" -eq 0 ]]; then
                # MBR
                parted -s "/dev/${_drive}" mklabel msdos
        fi

        # Get either /boot or /efi partition size. If there is /boot AND /efi
        # use, /efi size. If there is only boot, use it. If there is none, the
        # system cannot use LVM or LUKs.
        # Put the volume to use into a var.
        efi_size="$(jaq -r '.drive.volumes.volumes_list[] | 
        select(.mountpoint == "/efi") | .size' "${json_config}")"

        boot_size="$(jaq -r '.drive.volumes.volumes_list[] | 
        select(.mountpoint == "/boot") | .size' "${json_config}")"

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

        # Convert $boot_vol_size to mib if needed.
        if [[ "${boot_vol_size}" =~ ^.*[gG][iI][bB]$ ]]; then
                local boot_vol_size_sanitized
                boot_vol_size_sanitized="$(echo "${boot_vol_size}" \
                        | tr -d "[:alpha:]")"

                local boot_vol_size_mib=$((boot_vol_size_sanitized * 1000))
                boot_vol_size="${boot_vol_size_mib}mib"
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
                        sgdisk -n 1::+"${boot_vol_size}" -t 1:ef00 -c 1:"ESP" \
                                "/dev/${_drive}"
                        # Container partition
                        # parted -s "/dev/${first_disk}" mkpart Archlinux \
                        # "${boot_vol_size}" 100%
                        sgdisk -n 2::: -t 2:8300 -c 2:"Archlinux" \
                                "/dev/${_drive}"
                elif [[ "${uefi}" -eq 0 ]]; then
                        # /boot
                        parted -s "/dev/${_drive}" mkpart primary fat32 \
                                1Mib "${boot_vol_size}"
                        # Container partition
                        parted -s "/dev/${_drive}" mkpart primary \
                                "${boot_vol_size}" 100%
                fi
        fi

        # If there is only physical volumes (like partitions), check for
        # $boot_vol_size and create the appropriate partition.
        if [[ "${_lvm}" -eq 0 && "${encryption}" -eq 0 ]]; then
                if [[ -n "${boot_vol_size}" ]]; then
                        if [[ "${uefi}" -eq 1 ]]; then
                                # /efi or /boot
                                sgdisk -n 1::+"${boot_vol_size}" -t 1:ef00 -c 1:"ESP" \
                                        "/dev/${_drive}"
                        elif [[ "${uefi}" -eq 0 ]]; then
                                # /boot
                                parted -s "/dev/${_drive}" mkpart primary fat32 \
                                        1Mib "${boot_vol_size}"
                        fi
                fi
        fi

        # Create the rest of the partitions if there is no lvm or encryption
        if [[ "${_lvm}" -eq 0 && "${encryption}" -eq 0 ]]; then
                declare -A volumes

                while IFS=$'\t' read -r mountpoint size; do
                        volumes["${mountpoint}"]="${size}"
                done < <(cat ${json_config} \
                        | jaq -r '.drive.volumes.volumes_list[] | "\(.mountpoint)\t\(.size)"')

                local partnum
                # Start at partition number 2 if there was a boot volume created
                if [[ -z "${boot_vol_size}" ]]; then
                        partnum=1
                elif [[ -n "${boot_vol_size}" ]]; then
                        partnum=2
                fi

                for i in "${!volumes[@]}"; do
                        if [[ "${uefi}" -eq 1 ]]; then
                                # Use sgdisk
                                sgdisk -n "${partnum}"::+"${volumes[${i}]}" \
                                        -t "${partnum}":8300 "/dev/${_drive}"
                        elif [[ "${uefi}" -eq 0 ]]; then
                                # TODO:
                                # Use sfdisk
                                echo "Nothing yet"
                        fi
                        ((partnum++))
                done
        fi
}
