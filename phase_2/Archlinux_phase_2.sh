# source "./phase_2/functions/"
source "./config/text_formatting.sh"
source "./phase_2/functions/init_phase_2.sh"
source "./phase_2/functions/disks_fs/partition_disks.sh"

function main()
{
        init_phase_2

        partition_disks
}

main
