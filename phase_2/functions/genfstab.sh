function generate_fstab()
{
        genfstab -U "/mnt" > "/mnt/etc/fstab"
}
