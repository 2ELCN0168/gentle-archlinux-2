function configure_firewall()
{
        local frw="$(jaq -r '.network.firewall' ${json_config})"

        # Exit if it's already set in the JSON config
        [[ -n "${frw}" ]] && return

        local ans frw
        while true; do
                printf "%b" "${Q} Do you want to enable nftables with a "
                printf "%b" "default configuration? [Y/n] -> "

                read -r ans
                : "${ans:=Y}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[yYnN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        if [[ "${ans}" =~ ^[yY]$ ]]; then
                printf "%b" "${INFO} nftables will be enabled.\n\n"
                frw=1
        elif [[ "${ans}" =~ ^[nN]$ ]]; then
                printf "%b" "${INFO} nftables will be disabled.\n\n"
                frw=0
        fi

        jaq -i '.network.firewall = "'"${frw}"'"' "${json_config}"
}