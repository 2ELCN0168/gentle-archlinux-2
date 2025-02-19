# source "./phase_2/functions/"
source "./config/config.sh"
source "./config/text_formatting.sh"
source "./phase_2/functions/init_phase_2.sh"
source "./phase_2/functions/disks_fs/partition_disks.sh"
source "./phase_2/functions/disks_fs/create_luks.sh"
source "./phase_2/functions/disks_fs/create_lvm.sh"
source "./phase_2/functions/disks_fs/format_volumes.sh"
source "./phase_2/functions/disks_fs/mount_volumes.sh"
source "./phase_2/functions/pacstrap.sh"
source "./phase_2/functions/genfstab.sh"

function main()
{
        init_phase_2

        partition_disks

        create_luks

        create_lvm

        format_volumes

        mount_volumes

        pacstrap_installation

        generate_fstab

        cp -a "../gentle-archlinux-2" "/mnt/root"
        arch-chroot "/mnt" "/root/gentle-archlinux-2/phase_3/Archlinux_phase_3.sh"
}

main
