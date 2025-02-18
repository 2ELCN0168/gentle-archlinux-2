function set_localtime()
{
        if ln -sf "/usr/share/zoneinfo/${system_localtime}" "/etc/localtime" \
                1> "/dev/null" 2>&1; then
                printf "%b" "${SUC} Localtime set to: ${C_P}${system_localtime}"
                printf "%b" "${N_F}\n\n"
        else
                printf "%b" "${ERR} Localtime could not be set to: "
                printf "%b" "${C_P}${system_localtime}"
                printf "%b" "${N_F}\n\n"
        fi

        systemctl enable systemd-timesyncd 1> "/dev/null" 2>&1

        timedatectl set-ntp true 1> "/dev/null" 2>&1
}
