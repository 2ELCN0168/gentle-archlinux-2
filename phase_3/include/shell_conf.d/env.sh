export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"
export GREP_COLORS="mt=01;91"
export EDITOR="vim"
export VISUAL="vim"
export GIT_EDITOR="vim"
export SUDO_PROMPT=$'\n\033[92;1m[?] \033[0;97mEnter your password:\n\033[94m[>] \033[0m'

# Init colors
LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;31:ex=01;32:mi=00;31:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:'

# Compressed archives
LS_COLORS+='*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:'
LS_COLORS+='*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.gz=01;31:*.bz2=01;31:*.xz=01;31:'
LS_COLORS+='*.zst=01;31:*.tzst=01;31:*.rpm=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.rar=01;31:'

# Pictures and multimedia
LS_COLORS+='*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:'
LS_COLORS+='*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:'
LS_COLORS+='*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:'
LS_COLORS+='*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:'
LS_COLORS+='*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:'
LS_COLORS+='*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:'
LS_COLORS+='*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:'
LS_COLORS+='*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:'
LS_COLORS+='*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:'

# Documents
LS_COLORS+='*.pdf=01;31:*.ps=01;31:*.eps=01;31:*.tex=01;32:*.doc=01;34:*.docx=01;34:*.rtf=01;34:'
LS_COLORS+='*.odt=01;34:*.ods=01;34:*.odp=01;34:*.ppt=01;35:*.pptx=01;35:*.xlsx=01;34:*.csv=01;33:'
LS_COLORS+='*.tsv=01;33:*.json=01;33:*.xml=01;33:*.yml=01;33:*.yaml=01;33:*.ini=01;33:*.toml=01;33:'
LS_COLORS+='*.md=01;37:*.markdown=01;37:*.rst=01;37:*.log=01;37:*.txt=00:*.README=00;37:*.LICENSE=00;37:'

# Code
LS_COLORS+='*.c=01;33:*.cpp=01;33:*.h=00;33:*.hpp=00;33:*.py=01;32:*.ipynb=01;32:*.js=01;32:*.jsx=01;32:'
LS_COLORS+='*.ts=01;32:*.tsx=01;32:*.sh=01;32:*.bash=01;32:*.zsh=01;32:*.lua=01;32:*.pl=01;32:*.pm=01;32:'
LS_COLORS+='*.rb=01;32:*.php=01;32:*.go=01;32:*.rs=01;32:*.java=01;32:*.scala=01;32:*.class=01;32:*.o=00;32:'
LS_COLORS+='*.so=00;32:*.html=01;35:*.css=01;35:*.scss=01;35:*.sass=01;35:*.less=01;35:*.json=01;33:'

# Binaries
LS_COLORS+='*.out=01;32:*.exe=01;32:*.com=01;32:*.bin=01;32:*.apk=01;32:*.jar=01;32:*.deb=01;31:'
LS_COLORS+='*.rpm=01;31:*.run=01;32:*.msi=01;31:*.bat=01;32:*.dll=01;32:*.vbs=01;32:*.ps1=01;32:'

# Versionning and other
LS_COLORS+='*.gitignore=01;35:*.gitattributes=01;35:*.gitmodules=01;35:*.gpg=01;36:*.key=01;36:*.pem=01;36:'
LS_COLORS+='*.crt=01;36:*.csr=01;36:*.asc=01;36:*.env=01;33:*.dockerfile=01;35:*.yml=01;33:*.yaml=01;33:'

export LS_COLORS
