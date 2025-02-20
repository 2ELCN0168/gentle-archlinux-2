function install_bootloader()
{
        case "${system_bootloader}" in
        "refind") install_refind ;;
        "grub") install_grub ;;
        "systemd-boot") install_systemd-boot ;;
        esac
}

function install_refind()
{
        local microcode root_line luks_beginning luks_ending is_btrfs uuid
        case "${system_cpu_vendor}" in
        "GenuineIntel") microcode=" initrd=intel-ucode.img" ;;
        "AuthenticAMD") microcode=" initrd=amd-ucode.img" ;;
        *) microcode="" ;;
        esac

        if [[ "${disk_encryption}" -eq 1 ]]; then
                root_line=""
                luks_beginning="rd.luks.name="
                if [[ "${disk_lvm}" -eq 0 ]]; then
                        luks_ending="=root root=/dev/mapper/root"
                elif [[ "${disk_lvm}" -eq 1 ]]; then
                        luks_ending="=root root=/dev/vg_archlinux/root"
                fi
        elif [[ "${disk_encryption}" -eq 0 ]]; then
                root_line="root=UUID="
        fi

        if [[ "${disk_filesystem}" == "btrfs" &&
                "${disk_btrfs_subvolumes}" -eq 1 ]]; then
                is_btrfs=" rootflags=subvol=@"
        else
                is_btrfs=""
        fi

        if [[ "${disk_encryption}" -eq 1 ]]; then
                uuid="$(blkid -o value -s UUID "/dev/${disk_drive}2")"
        else
                local get_name
                get_name="$(lsblk -nlo NAME,MOUNTPOINTS \
                        | awk -F " " '/\/$/ { print $1 }')"
                uuid="$(blkid -o value -s UUID /dev/*/"${get_name}")"
        fi

        printf "%b" "${INFO} Installing ${C_C}rEFInd${N_F}...\n"

        if refind-install 1> "/dev/null" 2>&1; then
                printf "%b" "${SUC} Installed: ${C_C}rEFInd${N_F}.\n"
        else
                printf "%b" "${ERR} Could not install ${C_C}rEFInd${N_F}.\n"
        fi

        local refind_line
        refind_line="\"Archlinux\" \"${root_line}${luks_beginning}${uuid}
${luks_ending} rw initrd=initramfs-${system_kernel}.img${is_btrfs}${microcode}\""

        if echo -e "${refind_line}" > "/boot/refind_linux.conf"; then
                printf "%b" "${SUC} Updated ${C_P}/boot/refind_linux.conf"
                printf "%b" "${N_F}.\n"
        else
                printf "%b" "${ERR} Could not update ${C_P}/boot/refind_linux"
                printf "%b" ".conf${N_F}.\n"
        fi

        # INFO:
        # This hook launches refind-install after a package update.

        if [[ ! -d "/etc/pacman.d/hooks/" ]]; then
                mkdir -p "/etc/pacman.d/hooks"
        fi

        printf "%b" "${INFO} Creating a pacman hook for ${C_C}rEFInd.${N_F}\n"

        cat <<- EOF 1> "/etc/pacman.d/hooks/refind.hook"
        [Trigger]
        Operation=Upgrade
        Type=Package
        Target=refind

        [Action]
        Description=Updating rEFInd to ESP...
        When=PostTransaction
        Exec=/usr/bin/refind-install
EOF

        # Remove spaces caused by heredocs >:(
        sed -i 's/^[ \t]*//' "/etc/pacman.d/hooks/refind.hook"

        if [[ -e "/etc/pacman.d/hooks/refind.hook" ]]; then
                printf "%b" "${SUC} Created a pacman hook for ${C_C}rEFInd"
                printf "%b" ".${N_F}\n"
        else
                printf "%b" "${ERR} Could not create a pacman hook for "
                printf "%b" "${C_C}rEFInd${N_F}\n"
        fi

        printf "%b" "\n"
}

function install_grub()
{
        local efi_path success

        efi_path="$(lsblk -no MOUNTPOINTS "$(blkid -L ESP)")"

        # For UEFI systems.
        if [[ "${system_uefi}" -eq 1 ]]; then
                if grub-install --target=x86_64-efi --efi-directory="${efi_path}" \
                        --bootloader-id=GRUB 1> "/dev/null" 2>&1; then
                        printf "%b" "${SUC} Successully installed ${C_B}GRUB"
                        printf "%b" "${N_F}.\n"
                        success=1
                else
                        success=0
                fi

                if [[ "${success}" -eq 0 ]]; then
                        if grub-install --target=x86_64-efi \
                                --efi-directory="${efi_path}" \
                                --bootloader-id=GRUB --removable \
                                --force 1> "/dev/null" 2>&1; then
                                printf "%b" "${SUC} Successully installed "
                                printf "%b" "${C_B}GRUB${N_F}.\n"
                        else
                                printf "%b" "${ERR} Could not install "
                                printf "%b" "${C_B}GRUB${N_F}.\n"
                        fi
                fi
        fi

        # For BIOS systems.
        if [[ "${system_uefi}" -eq 0 ]]; then
                if grub-install --target=i386-pc "/dev/${disk_drive}" \
                        1> "/dev/null" 2>&1; then
                        printf "%b" "${SUC} Successully installed "
                        printf "%b" "${C_B}GRUB${N_F}.\n"
                else
                        printf "%b" "${ERR} Could not install "
                        printf "%b" "${C_B}GRUB${N_F}.\n"
                fi
        fi

        # Backup /etc/default/grub.
        cp -a "/etc/default/grub" "/etc/default/grub.bak"

        local microcode root_line luks_beginning luks_ending is_btrfs uuid

        case "${system_cpu_vendor}" in
        "GenuineIntel") microcode=" initrd=intel-ucode.img" ;;
        "AuthenticAMD") microcode=" initrd=amd-ucode.img" ;;
        *) microcode="" ;;
        esac

        if [[ "${disk_encryption}" -eq 1 ]]; then
                root_line=""
                luks_beginning="rd.luks.name="
                if [[ "${disk_lvm}" -eq 0 ]]; then
                        luks_ending="=root root=/dev/mapper/root"
                elif [[ "${disk_lvm}" -eq 1 ]]; then
                        luks_ending="=root root=/dev/vg_archlinux/root"
                fi
                sed -i '/^\s*#\(GRUB_ENABLE_CRYPTODISK\)/ s/^#//' \
                        "/etc/default/grub"
        elif [[ "${disk_encryption}" -eq 0 ]]; then
                root_line="root=UUID="
        fi

        if [[ "${disk_filesystem}" == "btrfs" &&
                "${disk_btrfs_subvolumes}" -eq 1 ]]; then
                is_btrfs=" rootflags=subvol=@"
        else
                is_btrfs=""
        fi

        if [[ "${disk_encryption}" -eq 1 ]]; then
                uuid="$(blkid -o value -s UUID "/dev/${disk_drive}2")"
        else
                local get_name
                get_name="$(lsblk -nlo NAME,MOUNTPOINTS \
                        | awk -F " " '/\/$/ { print $1 }')"
                uuid="$(blkid -o value -s UUID /dev/*/"${get_name}")"
        fi

        local grub_line
        grub_line="\"${root_line}${luks_beginning}${uuid}
${luks_ending} rw initrd=initramfs-${system_kernel}.img${is_btrfs}${microcode}\""

        awk -v params="${grub_line}" \
                '/GRUB_CMDLINE_LINUX=""/{
                $0 = "GRUB_CMDLINE_LINUX=" params ""
        } 
        1' "/etc/default/grub" > tmpfile && mv tmpfile "/etc/default/grub"

        grub-mkconfig -o "/boot/grub/grub.cfg"

        printf "%b" "\n"
}

function install_systemd-boot()
{
        local microcode root_line luks_beginning luks_ending is_btrfs uuid
        local efi_path

        efi_path="$(lsblk -no MOUNTPOINTS "$(blkid -L ESP)")"

        case "${system_cpu_vendor}" in
        "GenuineIntel") microcode="initrd=intel-ucode.img" ;;
        "AuthenticAMD") microcode="initrd=amd-ucode.img" ;;
        *) microcode="" ;;
        esac

        if [[ "${disk_encryption}" -eq 1 ]]; then
                root_line=""
                luks_beginning="rd.luks.name="
                if [[ "${disk_lvm}" -eq 0 ]]; then
                        luks_ending="=root root=/dev/mapper/root"
                elif [[ "${disk_lvm}" -eq 1 ]]; then
                        luks_ending="=root root=/dev/vg_archlinux/root"
                fi
        elif [[ "${disk_encryption}" -eq 0 ]]; then
                root_line="root=UUID="
        fi

        if [[ "${disk_filesystem}" == "btrfs" &&
                "${disk_btrfs_subvolumes}" -eq 1 ]]; then
                is_btrfs=" rootflags=subvol=@"
        else
                is_btrfs=""
        fi

        if [[ "${disk_encryption}" -eq 1 ]]; then
                uuid="$(blkid -o value -s UUID "/dev/${disk_drive}2")"
        else
                local get_name
                get_name="$(lsblk -nlo NAME,MOUNTPOINTS \
                        | awk -F " " '/\/$/ { print $1 }')"
                uuid="$(blkid -o value -s UUID /dev/*/"${get_name}")"
        fi

        printf "%b" "${INFO} Installing: ${C_G}systemd-boot${N_F}.\n"

        local sd_boot_options
        sd_boot_options="${root_line}${luks_beginning}${uuid}${luks_ending} 
rw ${is_btrfs}"

        if bootctl --esp-path="${efi_path}" 1> "/dev/null" 2>&1; then
                printf "%b" "${SUC} Successfully installed: "
                printf "%b" "${C_G}systemd-boot${N_F}.\n"
        else
                printf "%b" "${ERR} Could not install: "
                printf "%b" "${C_G}systemd-boot${N_F}.\n"
                return
        fi

        {
                echo -e "title Archlinux"
                echo -e "linux /vmlinuz-${system_kernel}"
                echo -e "initrd /initramfs-${system_kernel}.img"
                if [[ -n "${microcode}" ]]; then
                        echo -e "initrd /${microcode}"
                fi
                echo -e "options ${sd_boot_options}"
        } > "/boot/loader/entries/arch.conf"

        if [[ ! -d "/etc/pacman.d/hooks" ]]; then
                mkdir -p "/etc/pacman.d/hooks"
        fi

        cat <<- EOF > "/etc/pacman.d/hooks/95-systemd-boot.hook"
                [Trigger]
                Type = Package
                Operation = Upgrade
                Target = systemd

                [Action]
                Description = Gracefully upgrading systemd-boot...
                When = PostTransaction
                Exec = /usr/bin/systemctl restart systemd-boot-update.service
EOF

        # Remove spaces caused by heredocs >:(
        sed -i 's/^[ \t]*//' "/etc/pacman.d/hooks/95-systemd-boot.hook"

}
