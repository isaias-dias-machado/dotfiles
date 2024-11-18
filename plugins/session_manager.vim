" Session manager: Save session and viminfo in separate locations

" Only save buffers, windows, and tab pages, excluding global settings, options, mappings, etc.
set sessionoptions-=options " Prevent saving and restoring options
set sessionoptions-=localoptions " Exclude local buffer options (optional)
set sessionoptions-=folds " Exclude fold settings (optional)
set sessionoptions+=globals " Saves global variables
set sessionoptions+=winpos,resize " Include tabs and window layout

source ~/.vim/plugins/find_project_root.vim
autocmd BufWinLeave,QuitPre * call UpdateSession(fnamemodify(FindProjectRoot(), ':t'))

function! UpdateSession(session_name)
  let l:session_file = expand('~/.vim/sessions/') . a:session_name
  let l:viminfo_dir = expand('~/.vim/sessions/viminfo/')
  let l:viminfo_file = l:viminfo_dir . a:session_name . '.viminfo'

  " Create viminfo directory if it doesn't exist
  if !isdirectory(l:viminfo_dir)
    call mkdir(l:viminfo_dir, 'p')
  endif

  " Save session
  if filereadable(l:session_file)
    execute 'mksession! ' . l:session_file

    " Save viminfo to the corresponding file
    let l:old_viminfofile = &viminfofile
    let &viminfofile = l:viminfo_file
    wviminfo!
    let &viminfofile = l:old_viminfofile
  endif
endfunction

" Restore viminfo after loading a session
autocmd SessionLoadPost * call LoadSessionViminfo(FindProjectRoot()) | so ~/.vim/vimrc

function! LoadSessionViminfo(session_name)
  let l:viminfo_file = expand('~/.vim/sessions/viminfo/') . a:session_name . '.viminfo'

  " Restore viminfo if the file exists
  if filereadable(l:viminfo_file)
    let l:old_viminfofile = &viminfofile
    let &viminfofile = l:viminfo_file
    rviminfo!
    let &viminfofile = l:old_viminfofile
  endif
endfunction

" Automatically reload .vimrc every time a session is loaded
autocmd SessionLoadPost * source $MYVIMRC
