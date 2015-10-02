
" Workspace initialization.
" Must be run only once.
function! Init()
    let g:workspace_dir = getcwd()
    let g:workspace_file = g:workspace_dir . '/workspace.vim'
endfunction

" Workspace start function.
" Must be run every time when workspace is executed.
function! Start()
    execute 'chdir ' . g:workspace_dir
endfunction

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

    "call append(line('$'), 'workspace: ' . g:workspace_dir)
    "call append(line('$'), 'cwd: ' . getcwd())
endfunction

function! OnEnter()
    let col = col('.')
    let line = line('.')

    let sc_id = line('.') - 4
    if sc_id >= 0 && sc_id < len(s:shortcuts)
        execute 'source ../apps/' . s:shortcuts[sc_id]['app'] . '.vim'
        "endif
    endif

endfunction


" Execution starts here
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists('g:guard_workspace')
    call Init()
    let g:guard_workspace = 1
endif

call Start()
call Main()
