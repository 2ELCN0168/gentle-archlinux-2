function set_mkinitcpio()
{
        printf "%b" "${INFO} Making a backup: ${C_P}/etc/mkinitcpio.conf.bak"
        printf "%b" "${N_F}.\n"

        if cp -a "/etc/mkinitcpio.conf" "/etc/mkinitcpio.conf.bak"; then
                printf "%b" "${SUC} Successfully saved: ${C_P}"
                printf "%b" "/etc/mkinitcpio.conf.bak${N_F}.\n\n"
        else
                printf "%b" "${ERR} Could not save: ${C_P}"
                printf "%b" "/etc/mkinitcpio.conf.bak${N_F}.\n\n"
        fi

        local is_btrfs is_luks is_lvm hooks

        if [[ "${disk_filesystem}" == "btrfs" ]]; then
                is_btrfs="btrfs "
        fi

        if [[ "${disk_encryption}" -eq 1 ]]; then
                is_luks="sd-encrypt "
        fi

        if [[ "${disk_lvm}" -eq 1 ]]; then
                is_lvm="lvm2 "
        fi

        printf "%b" "${INFO} Updating: ${C_P}/etc/mkinitcpio.conf${N_F} with "
        printf "%b" "custom parameters.\n\n"

        hooks="HOOKS=(base systemd ${is_btrfs}autodetect modconf kms keyboard \
sd-vconsole ${is_luks}block ${is_lvm}filesystem fsck)"

        local tempfile
        tempfile="$(mktemp)"

        awk -v newLine="${hooks}" '
        !/^#/ && /HOOKS/ { 
                print newLine; 
                next 
        } 
        1
        ' "/etc/mkinitcpio.conf" 1> "${tempfile}" \
                && mv "${tempfile}" "/etc/mkinitcpio.conf"

        if mkinitcpio -P; then
                printf "%b" "${SUC} Successfully generated initramfs.\n\n"
        else
                printf "%b" "${ERR} Could not generate initramfs.\n\n"
        fi

}
