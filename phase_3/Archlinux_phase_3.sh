source "./phase_3/functions/hwclock.sh"
source "./phase_3/functions/set_localtime.sh"
source "./phase_3/functions/generate_locales.sh"
source "./phase_3/functions/set_hostname.sh"
source "./phase_3/functions/set_hosts.sh"
source "./phase_3/functions/set_vconsole.sh"
source "./phase_3/functions/set_pacman.sh"

function main()
{
        _hwclock

        set_localtime

        generate_locales

        set_hostname

        set_hosts

        set_vconsole

        set_pacman
}

main
