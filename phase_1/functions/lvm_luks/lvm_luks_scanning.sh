function detect_lvm_luks()
{
        local scan_result=0
        local pv_list

        for i in $(pvs --headings none | awk '{ print $1 }'); do
                pv_list+=("${i}")
                printf "%b" "${INFO} ${C_P}A LVM is detected.${N_F}\n"
                printf "%b" "${WARN} ${i} is a Physical Volume (LVM).\n"
                printf "%b" "${WARN} Make sure it is not mounted in /mnt.\n\n"
                ((scan_result += 1))
        done

}
