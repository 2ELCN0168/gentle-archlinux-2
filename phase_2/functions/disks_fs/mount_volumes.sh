function mount_volumes()
{
        local volumes_table
        volumes_table="$(blkid -o value -s LABEL)"

        # NOTE:
        # I need the array splitting below.

        for i in ${volumes_table[@]}; do
                if [[ "${i}" == "root" ]]; then
                        mount "$(blkid -L root)" "/mnt"
                        mount_log "${i}" "/mnt"
                fi
        done

        for i in ${volumes_table[@]}; do
                if [[ "${i}" == "boot" ]]; then
                        mount --mkdir "$(blkid -L boot)" "/mnt/boot"
                        mount_log "${i}" "/mnt/boot"
                fi

                if [[ "${i}" == "ESP" ]]; then
                        mount --mkdir "$(blkid -L ESP)" "/mnt/efi"
                        mount_log "${i}" "/mnt/efi"
                        mkdir -p "/mnt/efi/arch"
                        mount --bind "/mnt/efi/arch" "/mnt/boot"
                        mount_log "${i}" "/mnt/boot"
                fi

                if [[ "${i}" == "var" ]]; then
                        mount --mkdir "$(blkid -L var)" "/mnt/var"
                        mount_log "${i}" "/mnt/var"
                fi

                if [[ "${i}" == "var_log" ]]; then
                        mount --mkdir "$(blkid -L var_log)" "/mnt/var/log"
                        mount_log "${i}" "/mnt/var/log"
                fi

                if [[ "${i}" == "tmp" ]]; then
                        mount --mkdir "$(blkid -L tmp)" "/mnt/tmp"
                        mount_log "${i}" "/mnt/tmp"
                fi

                if [[ "${i}" == "usr" ]]; then
                        mount --mkdir "$(blkid -L usr)" "/mnt/usr"
                        mount_log "${i}" "/mnt/usr"
                fi

                if [[ "${i}" == "home" ]]; then
                        mount --mkdir "$(blkid -L home)" "/mnt/home"
                        mount_log "${i}" "/mnt/home"
                fi

                printf "%b" "\n"
        done
}

function mount_log()
{
        printf "%b" "${INFO} Mounting ${C_P}${1}${N_F} to ${C_P}${2}${N_F}.\n"
}
