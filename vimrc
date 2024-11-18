set nocompatible
set tabstop=8
set shiftwidth=8
set softtabstop=8
set expandtab
set listchars=tab:\ \ ,space:·
set nolist
set textwidth=80
set laststatus=2
set formatoptions-=cro
"set statusline=%F

" Mappings
let mapleader=" "
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-c> <Esc>
vnoremap <Leader>p "_dP
noremap <Leader>zi <c-w>_ \| <c-w>\|
noremap <Leader>zo <c-w>=

nnoremap <Leader>b :ls<CR>:b
nnoremap <Leader>m :AsyncRun -cwd=<root> make<CR>:cope 9<CR>
nnoremap <Leader>sf :find ./**/*
nnoremap <Leader>ss :sfind ./**/*
nnoremap <Leader>sg :vimgrep //j ./**/* <bar> :copen 20<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>
nnoremap <Leader>swg :exe 'vimgrep /' . expand('<cword>') . '/j ./**/* <bar> :copen 20'<CR>
vnoremap <Leader>svg y:vimgrep "<c-r>"" ./**/*<CR> 
nnoremap <Leader>d :term gdb -q 
nnoremap <Leader>t :term bash<CR>
nnoremap <Leader>h :term man 
nnoremap <Leader>st :term tree --gitignore
nnoremap <Leader>j :tjump /
nnoremap <Leader>ps :!maim -s -q "$HOME/Dropbox/mywiki/images"<CR>
nnoremap <Leader>so :so ~/.vim/sessions/
nnoremap <Leader>sm :mksession! ~/.vim/sessions/
"fly args
nnoremap <Leader>a :Args<CR> 
function! Args()
    let prompt = 'Select an argument:'
    let arg_list = map(argv(), 'v:key + 1 . ". " . v:val')
    let chosen_arg = inputlist([prompt] + arg_list)
    if chosen_arg
        execute 'argument ' . chosen_arg
    endif
endfunction
command! Args call Args()

" linuxy style indent options:
" -brf: braces on function definition line 
" -npsl: dont break procedure type
nnoremap <Leader>f :execute 'w <bar> !indent -kr -i8' . expand('%')<CR>L
"" Emacs bindings
" start of line
noremap! <C-A>		<Home>
" back one character
noremap! <C-B>		<Left>
" delete character under cursor
noremap! <C-D>		<Del>
" end of line
noremap! <C-E>		<End>
" forward one character
noremap! <C-F>		<Right>
" recall newer command-line
noremap! <C-N>		<Down>
" recall previous (older) command-line
noremap! <C-P>		<Up>
" back one word
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \| PlugInstall --sync | source $MYVIMRC
            \| endif

call plug#begin()

" List your plugins here
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'mbbill/undotree'
Plug 'skywind3000/asyncrun.vim'
Plug 'lervag/wiki.vim'
Plug 'preservim/vim-markdown'

call plug#end()

"My plugins
set viminfo+=!
source ~/.vim/plugins/find_project_root.vim
source ~/.vim/plugins/session_manager.vim

" Basic config
syntax enable
filetype plugin indent on
set t_Co=256
set termguicolors

" if strftime("%H") >= 7 && strftime("%H") <= 18
"     colorscheme shine
" else
" endif
colorscheme shine

set grepprg="rg"

"" ctags
"set omnifunc=ccomplete#Complete
set tags=/home/isaias/.vim/system.ctags/tags,tags;/home/isaias
"set completeopt-=preview

let g:netrw_keepdir=0
let g:netrw_localrmdir='rm -rf '
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_liststyle = 0
let g:netrw_browsex_viewer="xdg-open"

set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*.d

set number
set relativenumber

set ignorecase
set smartcase

" Finding files
set path=$VIMRUNTIME,$HOME,$HOME/.vim,$HOME/projects,$HOME/.config,$HOME/Dropbox/,$HOME/Dropbox/MyVaultDrive,$HOME/Dropbox/MyVaultDrive/6*,$VIMRUNTIME/colors,$HOME/Dropbox/mywiki,$HOME/lib,$HOME/bin,

    " Add the current directory and all its subdirectories to the path on startup
    autocmd VimEnter * if index(split(&path, ','), expand('%:p:h') . '/**') == -1 |
                \ let &path = FindProjectRoot() . '/**,' . &path |
                \ endif

" backup
set undodir=$HOME/.vim/undovim
set noswapfile
set nobackup
set nowritebackup
set undolevels=1000         " How many undos
set undoreload=10000 
set undofile

set hidden!
set nohlsearch
set incsearch

"""""""""""""" ALE """"""""""""""""
let g:ale_lint_on_save=1
let g:ale_set_balloons=1
let g:ale_enabled=0

set omnifunc=ale#completion#OmniFunc

" Quick fix opts
autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

" Spell checking
set encoding=utf-8
set spellfile=~/.vim/spell/misc.utf-8.add
set spell spelllang=pt,en
set nospell

" Wiki options
set foldenable
let g:wiki_root = '~/Dropbox/mywiki/'
let g:markdown_recommended_style = 0
let g:vim_markdown_folding_disabled = 0
let g:vim_markdown_folding_level = 1
let g:vim_markdown_override_foldtext = 1
set conceallevel=2
