#! /bin/bash

# Created on: 2024-12-27
# Author: 2ELCN0168
# Github: https://github.com/2ELCN0168
# NOTE: This part only sets up the JSON configuration file.

# source "./phase_1/functions/"
source "./config/text_formatting.sh"
source "./phase_1/functions/greetings.sh"
source "./phase_1/functions/lvm_luks/lvm_luks_scanning.sh"
source "./phase_1/functions/bios_uefi.sh"
source "./phase_1/functions/cpu_scan.sh"
source "./phase_1/functions/menu_bootloader.sh"
source "./phase_1/functions/lvm_luks/menu_luks.sh"
source "./phase_1/functions/lvm_luks/menu_lvm.sh"
source "./phase_1/functions/disks_fs/menu_fs.sh"
source "./phase_1/functions/disks_fs/menu_disks.sh"
source "./phase_1/functions/menu_swap.sh"
source "./phase_1/functions/disks_fs/configure_volumes.sh"
source "./phase_1/functions/menu_net_manager.sh"
source "./phase_1/functions/menu_kernel.sh"
source "./phase_1/functions/menu_guest_agents.sh"
source "./phase_1/functions/menu_hostname_fqdn.sh"
source "./phase_1/functions/menu_root_account.sh"
source "./phase_1/functions/menu_vconsole.sh"
source "./phase_1/functions/configure_pacman.sh"
source "./phase_1/functions/configure_mkinitcpio.sh"
source "./phase_1/functions/configure_vim_nvim.sh"
source "./phase_1/functions/configure_user.sh"
source "./phase_1/functions/configure_firewall.sh"
source "./phase_1/functions/configure_tty_theme.sh"
source "./phase_1/functions/configure_issue.sh"
source "./phase_1/functions/configure_motd.sh"

function main()
{

        text_formatting

        trap '
                echo -e "\n\n${C_B}:. ${C_R}Program has been killed! \c"
                echo -e "Installation aborted. \c"
                echo -e "Exiting with code 1. ${C_B} .:${N_F}\n\n"
                exit 1
        ' INT

        export opt_c=0 # Full mode
        export opt_e=0 # Hardening mode
        export opt_h=0 # Help
        export opt_m=0 # Minimal mode
        local total_options

        # Create the file if it doesn't exist.
        if [[ ! -e "./config/config.json" ]]; then
                cp -a "./config/config_template.json" "./config/config.json"
        fi

        export json_config="./config/config.json"

        while getopts "cehm" opt; do
                case "${opt}" in
                c) opt_c=1 ;;
                e) opt_e=1 ;;
                h) opt_h=1 ;;
                m) opt_m=1 ;;
                ?) opt_h=1 ;;
                esac
        done

        total_options=$((opt_c + opt_e + opt_h + opt_m))

        if [[ "${total_options}" -gt 1 ]]; then
                printf "%b" "${C_R}You can only use one option.${N_F}\n"
                exit 2
        fi

        # Initialization
        greetings

        # Detect LVM or LUKS partitions that can cause troubles
        detect_lvm_luks

        bios_uefi

        get_cpu_vendor

        menu_bootloader

        menu_luks

        menu_lvm

        menu_fs

        menu_disks

        menu_swap

        configure_volumes

        menu_net_manager

        menu_kernel

        menu_guest_agents

        menu_hostname

        menu_domain_name

        menu_vconsole

        configure_pacman

        configure_mkinitcpio

        configure_vim_nvim

        configure_user

        configure_firewall

        configure_tty_theme

        configure_issue

        configure_motd

        #configure_ssh

        #configure_dns

        bash "./phase_2/Archlinux_phase_2.sh"
}

main "${@}"
