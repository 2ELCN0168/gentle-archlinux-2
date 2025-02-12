function get_cpu_vendor()
{
        local vendor

        # Return if 'vendor_id' is set in the bash config.
        [[ -n "${system_cpu_vendor}" ]] && return
        [[ ! -f "/proc/cpuinfo" ]] && cpuinfo_error

        vendor="$(awk -F ': ' '/vendor_id/ { print $2; exit }' "/proc/cpuinfo")"

        case "${vendor}" in
        "GenuineIntel")
                printf "%b" "${INFO} ${C_C}INTEL CPU${N_F} detected."
                printf "%b" "\n\n"
                ;;
        "AuthenticAMD")
                printf "%b" "${INFO} ${C_R}AMD CPU${N_F} detected.\n\n"
                ;;
        *)
                cpuinfo_error
                ;;
        esac

        update_config "system_cpu_vendor" "${vendor}" "${bash_config}"
}

function cpuinfo_error()
{
        printf "%b" "${INFO} ${C_Y}Could not detect your CPU "
        printf "%b" "vendor. No microcode will be installed.${N_F}\n\n"
}
