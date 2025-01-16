function configure_volumes()
{
        # 1. Fetch if it's LVM or not. If yes, check if it's on multi-disks.
        # 2. Gather the total size available and display it.
        # 3. Ask the user if they want:
        # - All in root volume/partition ;
        # - Separate root/home volume/partition ;
        # - Separate everything and create their own mountpoints with custom 
        # sizes.
        #
        # NOTE:
        # That was a real pain to write. Just saying it.

        local drives="$(jaq -r '.drives.selected_drives' ${json_config})"

        local volumes_list
        volumes_list="$(jaq -r '.drives.volumes.volumes_list | 
        length' ${json_config})"

        # Return if volumes are already set in the JSON file.
        if [[ "${volumes_list}" -gt 0 ]]; then
                return
        fi

        local ans

        printf "%b" "${WARN} If you plan to use ${C_C}LVM${N_F} or "
        printf "%b" "${C_R}LUKS${N_F}. It is ${C_R}MANDATORY${N_F} to have "
        printf "%b" "either a ${C_C}/efi${N_F} or a ${C_R}/boot${N_F} "
        printf "%b" "volume! Otherwise, it will fails!\n\n"

        printf "%b" "${WARN} Schemes with the ${C_C}[LVM/LUKS]${N_F} are safe "
        printf "%b" "to use with ${C_C}LVM${N_F} or ${C_R}LUKS${N_F}.\n\n"

        while true; do
                title "Volumes" "${C_C}" 40

                printf "%b" "[0] - ${C_R}Everything on /${N_F}\n"

                printf "%b" "[1] - ${C_R}Separate / and /home${N_F}\n"

                printf "%b" "[2] - ${C_Y}/ /home /boot${N_F} [LVM/LUKS]\n"

                printf "%b" "[3] - ${C_Y}/ /home /boot /efi ${N_F} [LVM/LUKS] "
                printf "%b" "${C_C}[EFI only!]${N_F}\n"

                printf "%b" "[4] - ${C_G}/ /home /var /tmp /usr /boot${N_F} "
                printf "%b" "[LVM/LUKS]\n"

                printf "%b" "[5] - ${C_G}/ /home /var /tmp /usr /boot "
                printf "%b" "/efi ${N_F}(default ${C_C}[EFI only!]${N_F}) "
                printf "%b" "[LVM/LUKS]\n"


                printf "%b" "[6] - ${C_G}/ /home /var /var/log /tmp /usr /boot"
                printf "%b" "${N_F} [LVM/LUKS]\n"

                printf "%b" "[7] - ${C_G}/ /home /var /var/log /tmp /usr /boot "
                printf "%b" "/efi ${C_C}[EFI only!]${N_F} [LVM/LUKS]\n\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} How do you want to organize your volumes? -> "
                
                read -r ans
                : "${ans:=2}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[0-7]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done


        case "${ans}" in
                0) add_volume "/" ;;
                1) add_volume "/ /home" ;;
                2) add_volume "/ /home /boot" ;;
                3) add_volume "/ /home /boot /efi" ;;
                4) add_volume "/ /home /var /tmp /usr /boot" ;;
                5) add_volume "/ /home /var /tmp /usr /boot /efi" ;;
                6) add_volume "/ /home /var /var/log /tmp /usr /boot /efi" ;;
                7) add_volume "/ /home /var /var/log /tmp /usr /boot /efi" ;;
        esac

}

function add_volume()
{
        local volume_list="${1}"
        
        local ans sanitized_ans

        local total_size total_size_h drive_size
        total_size=0

        for a in ${drives[@]}; do
                drive_size="$(lsblk --bytes -drno SIZE /dev/${a})"
                total_size=$((total_size + drive_size))
        done

        for i in ${volume_list[@]}; do
                while true; do
                        
                        total_size_h=$(awk "BEGIN { print ${total_size} / 1024 / 1024 / 1024 }")

                        printf "%b" "${INFO} Available space: ${C_P}${total_size_h}Gib${N_F}.\n\n"
                        
                        printf "%b" "${Q} Define the size for ${C_P}${i}${N_F} "
                        printf "%b" "(ex: 25Gib or 512Mib) -> "

                        read -r ans

                        if [[ "${ans}" =~ ^([0-9]+)([gGmM][iI][bB])$ ]]; then
                                sanitized_ans="${BASH_REMATCH[1]}"
                                unit="${BASH_REMATCH[2],,}"

                                case "${unit}" in
                                        g)
                                                sanitized_ans=$((sanitized_ans * 1024 * 1024 * 1024))
                                                ;;
                                        m)
                                                sanitized_ans=$((sanitized_ans * 1024 * 1024))
                                                ;;
                                esac


                                printf "%b" "${INFO} ${C_P}${i}${N_F} will be "
                                printf "%b" "the size of ${C_P}${ans^^}${N_F}."
                                printf "%b" "\n\n"
                                total_size=$((total_size - sanitized_ans))
                                break
                        else
                                invalid_answer
                        fi
                done

                jaq -i '.drives.volumes.volumes_list += [
                        {
                                "mountpoint": "'"${i}"'",
                                "size": "'"${ans}"'"
                        }
                ]' "${json_config}"
        done
}
