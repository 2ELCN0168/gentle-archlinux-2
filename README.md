# Welcome!

This is the second version of my previous script *gentle-archlinux*.

This is a much cleaner version, easier to maintain for me, and safer to use for you.

## Improvements list

- JSON configuration! Finally there is two real stages in the script. The first one asks the questions and fill a JSON file based on the template. The second does the installation based on what's inside the JSON file. Isn't that nice?

- Even more! You can manually fill some parts (or all) in the JSON file to skip automatically the question during the script. There is (work in progress) a Wiki about how to set each option and their dependencies.

- Generate the configuration only. It is possible to skip the installation part and only generate the configuration file. Then, you can reuse it, but beware, some options are specific to the machine where you generated the configuration.

## What's inside?

Well, the best thing to do is probably to take a look at the JSON template to see every options. Then, you can watch inside the Wiki to have more explanations about what is happening.

But here are some cool options :
- Support for XFS, EXT3, EXT4, BTRFS *(subvolumes)* ;
- Support for LVM on multi/single disk(s) ;
- Support encryption with LUKS ;
- Choose your bootloader *(GRUB/REFIND/systemd-boot)* ;
- Bash/Zsh customization *(Or not, you choose!)* ;
- Configurations for tmux, vim, neovim, that are deployable on servers with no external dependencies ;
- TTY themes ;
- A lot of aliases and custom functions *(even aliases to switch TTY theme!)* ;
- Choose the packages you want ;
- Minimal mode and Hardened mode ;
- And, you can completely press "Enter" during all the script because it has cool default options (not recommended but it works)...

## How to use it?

Boot to an Archlinux live medium, then:

```
pacman -Sy git jaq
git clone https://github.com/2ELCN0168/gentle-archlinux-2
cd gentle-archlinux-2
./Archlinux.sh
```

You can have a list of the options if you do:

```
./Archlinux.sh -h
```

Try it in a VM!

## Found a bug or want an improvement?

Feel free to contact me.