function mount_volumes()
{
        local volumes_table
        volumes_table="$(blkid -o value -s LABEL)"

        for i in "${volumes_table[@]}"; do
                if [[ "${i}" == "root" ]]; then
                        mount "$(blkid -L root)" "/mnt"
                fi
        done

        for i in "${volumes_table[@]}"; do
                if [[ "${i}" == "ESP" ]]; then
                        mount --mkdir "$(blkid -L ESP)" "/mnt/boot"
                fi

                if [[ "${i}" == "var" ]]; then
                        mount --mkdir "$(blkid -L var)" "/mnt/var"
                fi

                if [[ "${i}" == "var_log" ]]; then
                        mount --mkdir "$(blkid -L var_log)" "/mnt/var/log"
                fi

                if [[ "${i}" == "tmp" ]]; then
                        mount --mkdir "$(blkid -L tmp)" "/mnt/tmp"
                fi

                if [[ "${i}" == "usr" ]]; then
                        mount --mkdir "$(blkid -L usr)" "/mnt/usr"
                fi

                if [[ "${i}" == "home" ]]; then
                        mount --mkdir "$(blkid -L home)" "/mnt/home"
                fi
        done
}
