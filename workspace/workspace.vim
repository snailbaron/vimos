"let g:workspace_path = 'C:/non-work/code/vim/workspace/workspace.vim'
let g:workspace_path = expand('%:p')
call append(line('$'), g:workspace_path)

let s:shortcuts = [
\   {
\       'app': 'fm', 
\       'name': 'File Manager'
\   },
\   {
\       'app': 'console',
\       'name': 'Console'
\   }
\]


function! Main()
    exe "%d"

    nmap <Esc> :q!<CR>
    nmap <CR> :call OnEnter()<CR>

    call append(line('$'), '| Shortcuts')
    call append(line('$'), '+-----------')
    for s in s:shortcuts
        call append(line('$'), '| ' . s['name'])
    endfor

endfunction

function! OnEnter()
    let col = col('.')
    let line = line('.')

    let sc_id = line('.') - 3
    if sc_id >= 0 && sc_id < len(s:shortcuts)
        "if col('.') - 3 >= 0 && col('.') - 3 < strlen(s:shortcuts[sc_id]['name'])
        execute 'source ../apps/' . s:shortcuts[sc_id]['app'] . '.vim'
        "endif
    endif

endfunction

call Main()
