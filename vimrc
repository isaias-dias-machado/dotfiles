syntax enable
filetype plugin indent on
set t_Co=256
set termguicolors
set number
set relativenumber
set formatoptions-=ro
set tabstop=8
set shiftwidth=8
set softtabstop=8
set noexpandtab
set listchars=tab:\ \ ,space:·
set nolist
set textwidth=80
set laststatus=2
set noesckeys
"set statusline=%F
set wildmenu
set wildmode=list:longest,full
set pumheight=4

" backup
set noswapfile
set nobackup
set nowritebackup
set undodir=$HOME/.vim/undovim
set undolevels=1000         " How many undos
set undoreload=10000 
set undofile


set ignorecase
set smartcase

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

nnoremap <Leader>w :e ~/mywiki/wiki.md<CR>
nnoremap <Leader>b :ls<CR>:b
nnoremap <Leader>m :make<CR>:cope 11<CR>
nnoremap <Leader>r :make run<CR> :cope<CR>
nnoremap <Leader>st :term tree --gitignore
nnoremap <Leader>sf :find 
nnoremap <Leader>ss :sfind 
nnoremap <Leader>sg :vimgrep //j ./**/* <bar> :copen 20<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>
nnoremap <Leader>swg :exe 'vimgrep /' . expand('<cword>') . '/j ./**/* <bar> :copen 20'<CR>
vnoremap <Leader>svg y:vimgrep "<c-r>"" ./**/* <bar> :cope 20 <CR> 
nnoremap <Leader>h :term man 
nnoremap <Leader>j :tjump /
nnoremap <Leader>ps :!maim -s -q "$HOME/Dropbox/mywiki/images"<CR>
nnoremap <Leader>so :so ~/.vim/sessions/
nnoremap <Leader>sm :mksession! ~/.vim/sessions/
nnoremap <Leader>l :so ~/.vim/vimrc<CR>
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

nnoremap <Leader>k :Argsd<CR> 
function! Argsd()
    let prompt = 'Select an argument:'
    let arg_list = map(argv(), 'v:key + 1 . ". " . v:val')
    let chosen_arg = inputlist([prompt] + arg_list)
    if chosen_arg
        execute chosen_arg . 'argd'
    endif
endfunction
command! Argsd call Argsd()
" linuxy style indent options:
" -brf: braces on function definition line 
" -npsl: dont break procedure type
" -pal: pointer align left
nnoremap <Leader>f :w<CR>:!indent -kr -i8 -ut -pal %<CR>

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
"Plug 'skywind3000/asyncrun.vim'
Plug 'lervag/wiki.vim'
Plug 'preservim/vim-markdown'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'

call plug#end()

"My plugins
set viminfo+=!
source ~/.vim/plugins/session_manager.vim

" Basic config

" if strftime("%H") >= 7 && strftime("%H") <= 18
"     colorscheme shine
" else
" endif
colorscheme shine
colorscheme desert

set grepprg="rg"

"" ctags
"set omnifunc=ccomplete#Complete
set tags=/home/isaias/.vim/system.ctags/tags,tags;/home/isaias
"set completeopt-=preview


" Finding files
set path=$VIMRUNTIME,$HOME,$HOME/.vim,$HOME/projects,$HOME/.config,$HOME/Dropbox/,$HOME/Dropbox/MyVaultDrive,$HOME/Dropbox/MyVaultDrive/6*,$VIMRUNTIME/colors,$HOME/Dropbox/mywiki,$HOME/lib,$HOME/bin,./**,

set hidden!
set nohlsearch
set incsearch
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


"==============================lsp=====================================
let g:lsp_diagnostics_enabled = 0         " disable diagnostics support
let g:lsp_document_code_action_signs_enabled = 0
inoremap <expr> <CR> pumvisible() ? "\<C-e>\<CR>" : "\<CR>"

" allow folding
" set foldnestmax=0
" set foldmethod=expr
"     \ foldexpr=lsp#ui#vim#folding#foldexpr()
"     \ foldtext=lsp#ui#vim#folding#foldtext()


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
