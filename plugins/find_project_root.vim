function! FindProjectRoot() abort
    let l:path = getcwd() 
    while l:path !=# "/" && l:path !=# ""
        " Check if 'tags' file or '.git' directory exists in the current directory
        if filereadable(l:path . '/tags') || isdirectory(l:path . '/.git')
            return l:path
        endif
        " Move up one directory
        let l:path = fnamemodify(l:path, ':h')
    endwhile
    " Return empty string if no project root is found
    return ""
endfunction
