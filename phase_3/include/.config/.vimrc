" NUMBERS
set number
set relativenumber

" CODE
syntax on
"colorscheme retrobox
set background=dark

" INDENT
set autoindent
set smartindent
set tabstop=8
set shiftwidth=8
set expandtab

set showmatch
set matchtime=2

set completeopt=menu,menuone,noselect
set omnifunc=syntaxcomplete#Complete

set laststatus=2

set errorformat=%f\:%l\:%c\:\ %m

set colorcolumn=80

" SMART SEARCH
set ignorecase
set smartcase
set incsearch 

" DISPLAY INVISIBLE CHARS
set list
set listchars=tab:»·,trail:·

" FOLDING
set foldmethod=syntax
set foldlevelstart=99

" AUTOCLOSE
"inoremap " ""<Left>
"inoremap ' ''<Left>
"inoremap ( ()<Left>
"inoremap [ []<Left>
"inoremap { {}<Left>

" HIGLIGHTING
set cursorline
set cursorcolumn

" SAFE SAVE
"set backup
"set backupdir=~/.vim/backup//
"set directory=~/.vim/swap//
"set undodir=~/.vim/undo//
