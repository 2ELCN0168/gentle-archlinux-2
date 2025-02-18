function generate_locales()
{
        local locale=("en_US.UTF-8 UTF-8")

        case "${system_locales}" in
        "fr")
                locale=("fr_FR.UTF-8 UTF-8")
                sed -i '/^\s*#\(fr_FR.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                ;;
        "gb")
                locale=("en_GB.UTF-8 UTF-8")
                sed -i '/^\s*#\(en_GB.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                ;;
        "ja")
                locale=("ja_JP.UTF-8 UTF-8")
                sed -i '/^\s*#\(ja_JP.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                ;;
        "ko")
                locale=("ko_KR.UTF-8 UTF-8")
                sed -i '/^\s*#\(ko_KR.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                ;;
        "ru")
                locale=("ru_RU.UTF-8 UTF-8")
                sed -i '/^\s*#\(ru_RU.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                ;;
        "zh")
                locale=(
                        "zh_HK.UTF-8 UTF-8"
                        "zh_HK.UTF-8 UTF-8"
                )
                sed -i '/^\s*#\(zh_HK.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                sed -i '/^\s*#\(zh_CN.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                ;;
        esac

        printf "%b" "${INFO} The following locales will be generated:\n"
        for i in "${locale[@]}"; do
                printf "%b" "  ${C_P}${i}${N_F}\n"
        done
        printf "%b" "\n"

        if locale-gen 1> "/dev/null" 2>&1; then
                printf "%b" "${SUC} Locales generated successfully.\n\n"
        else
                printf "%b" "${ERR} Locales could not be generated.\n\n"
        fi
}
