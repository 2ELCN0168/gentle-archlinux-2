function configure_mkinitcpio()
{
        # There is no need to check if the variables are empty or not because at this point,
        # it should be filled either by the user or by the script questions.

        local _btrfs _luks _lvm

        _btrfs="$(jaq -r '.drive.filesystem' "${json_config}")"
        _luks="$(jaq -r '.drive.encryption' "${json_config}")"
        _lvm="$(jaq -r '.drive.lvm' "${json_config}")"

        # The filesystem must be btrfs only (just for the hook)
        if [[ "${_btrfs}" == "btrfs" ]]; then
                _btrfs="btrfs "
        elif [[ "${_btrfs}" != "btrfs" ]]; then
                _btrfs=""
        fi

        if [[ "${_luks}" -eq 1 ]]; then
                _encryption="sd-encrypt "
        elif [[ "${_luks}" -eq 0 ]]; then
                _encryption=""
        fi

        if [[ "${_lvm}" -eq 1 ]]; then
                _lvm="lvm2 "
        elif [[ "${_lvm}" -eq 0 ]]; then
                _lvm=""
        fi

        local hooks

        hooks="base systemd ${_btrfs}autodetect modconf kms keyboard sd-vconsole ${_encryption}block ${_lvm}filesystems fsck"

        jaq -i '.system.initcpio_hooks = "'"${hooks}"'"' "${json_config}"

        printf "%b" "${INFO} Changed initcpio hooks to: ${C_P}${hooks}${N_F}.\n\n"
}

