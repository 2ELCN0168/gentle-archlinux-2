function menu_kernel()
{
        # TODO:
        # At systemd-boot installation, check for initramfs name
        # (cf. the same file in the original gentle-archlinux)
        
        local kernel="$(jaq -r '.system.kernel' ${json_config})"

        # Return if it's already set in the JSON config
        [[ -n "${kernel}" ]] && return

        while true; do
                title "Kernel" "${C_C}" 40

                printf "%b" "[0] - ${C_C}linux${N_F} (default)\n"
                printf "%b" "[1] - ${C_P}linux-lts${N_F}\n"
                printf "%b" "[2] - ${C_R}linux-hardened${N_F}\n"
                printf "%b" "[3] - ${C_Y}linux-zen${N_F}\n"

                printf "%b" "────────────────────────────────────────\n\n"

                printf "%b" "${Q} Which Linux kernel do you want to use? "
                printf "%b" "[0/1/2/3] -> "

                local ans
                read -r ans
                : "${ans:=0}"

                if [[ "${ans}" =~ ^[0-2]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        case "${ans}" in
                0)
                        printf "%b" "${INFO} You chose the standard Linux "
                        printf "%b" "kernel.\n\n"
                        kernel="linux"
                        ;;
                1)
                        printf "%b" "${INFO} You chose the LTS Linux "
                        printf "%b" "kernel. Useful for servers.\n\n"
                        kernel="linux-lts"
                        ;;
                2)
                        printf "%b" "${INFO} You chose the hardened Linux "
                        printf "%b" "kernel. I see you're a paranoid, don't "
                        printf "%b" "worry, we're three.\n\n"
                        kernel="linux-hardened"
                        ;;
                3)
                        printf "%b" "${INFO} You chose the zen Linux kernel."
                        printf "%b" "\n\n"
                        kernel="linux-zen"
                        ;;
        esac

        jaq -i '.system.kernel = "'"${kernel}"'"' "${json_config}"
}
