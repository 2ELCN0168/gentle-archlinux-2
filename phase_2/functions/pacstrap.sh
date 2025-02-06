function pacstrap_installation()
{
        local packages
        local _lvm encryption bootloader cpu filesystem uefi kernel
        _lvm="$(jaq -r '.drive.lvm' "${json_config}")"
        encryption="$(jaq -r '.drive.encryption' "${json_config}")"
        filesystem="$(jaq -r '.drive.filesystem' "${json_config}")"
        bootloader="$(jaq -r '.system.bootloader' "${json_config}")"
        cpu="$(jaq -r '.system.cpu_vendor' "${json_config}")"
        uefi="$(jaq -r '.system.uefi' "${json_config}")"
        kernel="$(jaq -r '.system.kernel' "${json_config}")"

        local base_packages net_tools monitoring_tools _zsh help_tools
        base_packages="$(jaq -r '.packages.base_packages' "${json_config}")"
        net_tools="$(jaq -r '.packages.install_net_tools' "${json_config}")"
        monitoring_tools="$(jaq -r '.packages.install_monitoring_tools' "${json_config}")"
        help_tools="$(jaq -r '.packages.install_help_tools' "${json_config}")"

        packages+=("${base_packages[@]}")

        if [[ "${net_tools}" -eq 1 ]]; then
                net_tools="$(jaq -r '.packages.net_tools' "${json_config}")"
                packages+=("${net_tools[@]}")
        fi

        if [[ "${monitoring_tools}" -eq 1 ]]; then
                monitoring_tools="$(jaq -r '.packages.monitoring_tools' "${json_config}")"
                packages+=("${monitoring_tools[@]}")
        fi

        if [[ "${help_tools}" -eq 1 ]]; then
                help_tools="$(jaq -r '.packages.help_tools' "${json_config}")"
                packages+=("${help_tools[@]}")
        fi

        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' "/etc/pacman.conf"

        if [[ "${_lvm}" -eq 1 ]]; then
                packages+=("lvm2")
        fi

        if [[ "${encryption}" -eq 1 ]]; then
                packages+=("cryptsetup")
        fi

        case "${filesystem}" in
        "xfs") packages+=("xfsprogs") ;;
        "ext4") packages+=("e2fsprogs") ;;
        "btrfs") packages+=("btrfs-progs") ;;
        esac

        if [[ "${bootloader}" == "grub" && "${uefi}" -eq 1 ]]; then
                packages+=("grub" "efibootmgr")
        elif [[ "${bootloader}" == "grub" && "${uefi}" -eq 0 ]]; then
                packages+=("grub")
        elif [[ "${bootloader}" == "refind" ]]; then
                packages+=("refind")
        fi

        case "${cpu}" in
        "AuthenticAMD") packages+=("amd-ucode") ;;
        "GenuineIntel") packages+=("intel-ucode") ;;
        esac

        case "${kernel}" in
        "linux") packages+=("linux" "linux-headers") ;;
        "linux-lts") packages+=("linux-lts" "linux-lts-headers") ;;
        "linux-hardened") packages+=("linux-hardened" "linux-hardened-headers") ;;
        "linux-zen") packages+=("linux-zen" "linux-zen-headers") ;;
        esac

        pacstrap -K "/mnt" "${packages[@]}"
}
