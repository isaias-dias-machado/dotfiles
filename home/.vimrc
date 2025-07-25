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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'HiPhish/guile.vim'
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
Plug 'lervag/wiki.vim'
Plug 'preservim/vim-markdown'
Plug 'lervag/vimtex'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'jvirtanen/vim-hcl'

call plug#end()

" fzf
nnoremap <leader>p :Files .<CR>
nnoremap <leader>d :Dir<CR>

command! Dir call fzf#run({
  \ 'source': 'find . -type d',
  \ 'sink':   'edit',
  \ 'options': '--prompt "explore: " --preview "ls -p {}"'
  \ })

" Wiki options
set foldenable
" let g:wiki_root = '/mnt/c/Users/isepidm/Dropbox/mywiki/'
let g:markdown_recommended_style = 0
let g:vim_markdown_folding_disabled = 0
let g:vim_markdown_folding_level = 1
let g:vim_markdown_override_foldtext = 1
set conceallevel=2

"=============================vimtex===================================
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:tex_conceal='abdmg'
let g:vimtex_quickfix_enabled = 0

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
