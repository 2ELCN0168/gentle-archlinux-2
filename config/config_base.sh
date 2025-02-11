# ---------------------------- #
# Template configuration file  #
# archlinux-gentle-installer-2 #
# ---------------------------- #

# Associative arrays declaration, do not edit #
declare -A volumes_volumes_list

# System #
system_uefi="1"
system_bootloader=""
system_grub_auth=""
system_kernel=""
system_hostname=""
system_domain_name=""
system_cpu_vendor=""
system_keymap=""
system_mkinitcpio_hooks=""
system_swap=""

# Users #
user_root_account=""

## User ##
user_active=""
user_username=""
user_groups=""
user_home_dir=""
user_administrator=""
user_xdg_dirs=""

# Pacman #
pacman_color=""
pacman_parallel_downloads=""

# Disk #
disk_encryption=""
disk_filesystem=""
disk_lvm=""
disk_contains_nvme=""
disk_btrfs_subvolumes=""
disk_btrfs_quotas=""
disk_drive=""

## Volumes ##
volumes_only_root=""
volumes_root_and_home=""
volumes_volumes_list=()

# Network #
network_manager=""
network_firewall=""
network_dns_1=""
network_dns_2=""
network_dns_over_tls=""

# Customization #
custom_motd=""
custom_issue=""
custom_issue_net=""
custom_ssh_banner=""
custom_tty_theme=""
custom_refind_theme=""
custom_sudo=""
custom_bash=""
custom_zsh=""

# Packages #
packages_install_net_tools=""
packages_install_help_tools=""
packages_install_monitoring_tools=""
packages_vim_nvim_configuration=""
packages_guest_agent=""
packages_base=(
        "base"
        "base-devel"
        "linux-firmware"
        "rust"
        "git"
        "systemctl-tui"
        "hdparm"
        "eza"
        "terminus-font"
        "openssh"
        "cryptsetup"
        "efibootmgr"
        "wget"
        "gdisk"
        "ntfs-3g"
        "neovim"
        "vim"
        "vi"
        "dos2unix"
        "tree"
        "fastfetch"
        "dhclient"
        "tmux"
        "arch-audit"
        "xdg-user-dirs"
        "arch-install-scripts"
)

packages_net_tools=(
        "bind-tools"
        "ldns"
        "nmon"
        "nethogs"
        "jnettop"
        "iptraf-ng"
        "tcpdump"
        "nmap"
)

packages_monitoring_tools=(
        "btop"
        "htop"
        "bmon"
        "iotop"
        "bottom"
)

packages_help_tools=(
        "texinfo"
        "tealdeer"
        "man"
        "man-pages"
)

packages_additional_packages=()
