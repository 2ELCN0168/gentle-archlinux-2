cd "/root/gentle-archlinux-2"

source "./config/config.sh"
source "./phase_3/functions/hwclock.sh"
source "./phase_3/functions/set_localtime.sh"
source "./phase_3/functions/generate_locales.sh"
source "./phase_3/functions/set_hostname.sh"
source "./phase_3/functions/set_hosts.sh"
source "./phase_3/functions/set_vconsole.sh"
source "./phase_3/functions/set_pacman.sh"
source "./phase_3/functions/set_mkinitcpio.sh"
source "./phase_3/functions/set_root_account.sh"
source "./phase_3/functions/set_vim_nvim.sh"
source "./phase_3/functions/set_environment.sh"
source "./phase_3/functions/create_user.sh"

function main()
{
        # Load order :
        # 1 - Must be loaded before 2
        # 2 - Must be loaded after 1

        _hwclock

        set_localtime

        generate_locales

        set_hostname

        set_hosts

        set_vconsole

        set_pacman

        set_mkinitcpio

        set_root_account

        if [[ "${packages_vim_nvim_configuration}" -eq 1 ]]; then
                set_vim_nvim # 1
        fi

        set_environment # 1

        create_user # 2

}

main
