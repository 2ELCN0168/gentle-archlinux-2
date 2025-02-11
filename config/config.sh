# ---------------------------- #
# Template configuration file  #
# archlinux-gentle-installer-2 #
# ---------------------------- #

# Associative arrays declaration, do not edit #
declare -A volumes_volumes_list

# System #
system_uefi="1"
system_bootloader="refind"
system_grub_auth=""
system_kernel="linux"
system_hostname="localhost"
system_domain_name="home.arpa"
system_cpu_vendor="AuthenticAMD"
system_keymap="us-acentos"
system_mkinitcpio_hooks="base systemd autodetect modconf kms keyboard sd-vconsole block lvm2 filesystems fsck"
system_swap="swapfile"

# Users #
user_root_account=""

## User ##
user_active="1"
user_username="cute-lizard"
user_groups=""
user_home_dir=""
user_administrator=""
user_xdg_dirs=""

# Pacman #
pacman_color="1"
pacman_parallel_downloads="8"

# Disk #
disk_encryption="0"
disk_filesystem="xfs"
disk_lvm="1"
disk_contains_nvme="1"
disk_btrfs_subvolumes=""
disk_btrfs_quotas=""
disk_drive="nvme0n1"

## Volumes ##
volumes_only_root=""
volumes_root_and_home=""
volumes_volumes_list=(
        ["/home"]="3gib"
        ["/efi"]="2gib"
        ["/boot"]="2gib"
        ["/"]="1gib"
)

# Network #
network_manager="systemd-networkd"
network_firewall="1"
network_dns_1=""
network_dns_2=""
network_dns_over_tls=""

# Customization #
custom_motd="1"
custom_issue="1"
custom_issue_net=""
custom_ssh_banner=""
custom_tty_theme="synthwave86.sh"
custom_refind_theme=""
custom_sudo=""
custom_bash=""
custom_zsh=""

# Packages #
packages_install_net_tools=""
packages_install_help_tools=""
packages_install_monitoring_tools=""
packages_vim_nvim_configuration="1"
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
