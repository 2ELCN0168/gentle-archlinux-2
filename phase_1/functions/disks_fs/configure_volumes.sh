function configure_volumes()
{
        # 1. Fetch if it's LVM or not. If yes, check if it's on multi-disks.
        # 2. Gather the total size available and display it.
        # 3. Ask the user if they want:
        # - All in root volume/partition ;
        # - Separate root/home volume/partition ;
        # - Separate everything and create their own mountpoints with custom 
        # sizes.
        #
        # NOTE:
        # That was a real pain to write. Just saying it.

        local what_to_do
        local lvm="$(jaq -r '.drives.lvm' ${json_config})"

        if [[ "${what_to_do}" -eq 1 ]]; then
                only_root
        elif [[ "${what_to_do}" -eq 2 ]]; then
                root_and_home
        elif [[ "${what_to_do}" -eq 3 ]]; then
                custom_volumes
        fi

}

function only_root()
{
        echo "hello"
}

function root_and_home()
{
        echo "hello"
}

function custom_volumes()
{
        echo "hello"
}
