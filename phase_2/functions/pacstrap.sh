function pacstrap_installation()
{
        local packages

        packages+=("${packages_base_packages[@]}")
        packages+=("${packages_guest_agent}")

        if [[ "${packages_install_net_tools}" -eq 1 ]]; then
                packages+=("${packages_net_tools[@]}")
        fi

        if [[ "${packages_install_monitoring_tools}" -eq 1 ]]; then
                packages+=("${packages_monitoring_tools[@]}")
        fi

        if [[ "${packages_install_help_tools}" -eq 1 ]]; then
                packages+=("${packages_help_tools[@]}")
        fi

        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' "/etc/pacman.conf"

        if [[ "${disk_lvm}" -eq 1 ]]; then
                packages+=("lvm2")
        fi

        if [[ "${disk_encryption}" -eq 1 ]]; then
                packages+=("cryptsetup")
        fi

        case "${disk_filesystem}" in
        "xfs") packages+=("xfsprogs") ;;
        "ext4") packages+=("e2fsprogs") ;;
        "btrfs") packages+=("btrfs-progs") ;;
        esac

        if [[ "${system_bootloader}" == "grub" && "${system_uefi}" -eq 1 ]]; then
                packages+=("grub" "efibootmgr")
        elif [[ "${system_bootloader}" == "grub" && "${system_uefi}" -eq 0 ]]; then
                packages+=("grub")
        elif [[ "${system_bootloader}" == "refind" ]]; then
                packages+=("refind")
        fi

        case "${system_cpu_vendor}" in
        "AuthenticAMD") packages+=("amd-ucode") ;;
        "GenuineIntel") packages+=("intel-ucode") ;;
        esac

        case "${system_kernel}" in
        "linux") packages+=("linux" "linux-headers") ;;
        "linux-lts") packages+=("linux-lts" "linux-lts-headers") ;;
        "linux-hardened") packages+=("linux-hardened" "linux-hardened-headers") ;;
        "linux-zen") packages+=("linux-zen" "linux-zen-headers") ;;
        esac

        # NOTE: Must not double quote ${packages[@]}.

        pacstrap -K "/mnt" ${packages[@]}
}
