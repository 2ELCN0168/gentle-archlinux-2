function configure_mkinitcpio()
{
        # There is no need to check if the variables are empty or not because at this point,
        # it should be filled either by the user or by the script questions.

        local _btrfs _luks _lvm

        # The filesystem must be btrfs only (just for the hook)
        if [[ "${disk_filesystem}" == "btrfs" ]]; then
                _btrfs="btrfs "
        elif [[ "${disk_filesystem}" != "btrfs" ]]; then
                _btrfs=""
        fi

        if [[ "${disk_encryption}" -eq 1 ]]; then
                _encryption="sd-encrypt "
        elif [[ "${disk_encryption}" -eq 0 ]]; then
                _encryption=""
        fi

        if [[ "${disk_lvm}" -eq 1 ]]; then
                _lvm="lvm2 "
        elif [[ "${disk_lvm}" -eq 0 ]]; then
                _lvm=""
        fi

        local hooks

        hooks="base systemd ${_btrfs}autodetect modconf kms keyboard sd-vconsole ${_encryption}block ${_lvm}filesystems fsck"

        update_config "system_mkinitcpio_hooks" "${hooks}" "${bash_config}"

        printf "%b" "${INFO} Changed initcpio hooks to: ${C_P}${hooks}${N_F}.\n\n"
}
