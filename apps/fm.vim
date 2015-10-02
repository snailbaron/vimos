function! ShowDir()
    let files = glob("*", 0, 1)

    " Clear buffer
    exe "%d"

    call setline(1, 'Working directory: ' . getcwd())
    call setline(2, '')

    call setline(3, printf("%7s %s %10s %s", "dir", '---------', 0, '..'))

    let i = 0
    while i < len(files)
        let f = get(files, i)

        let perm = getfperm(f)
        let type = getftype(f)
        let size = getfsize(f)

        call setline(i+4, printf("%7s %s %10s %s", type, perm, size, f))

        let i += 1
    endwhile

    call cursor(3, line('.'))
endfunction

" Get information on file under cursor
function! GetFileInfo()
    let line = getline(line('.'))
    let matches = matchlist(line, '\s*\(\S\+\)\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(.*\S\+\)\s*$')

    let fileInfo = {
    \   'type': get(matches, 1),
    \   'name': get(matches, 4)
    \}

    return fileInfo
endfunction

function! OnEnter()
    let info = GetFileInfo()

    if info['type'] == 'dir'
        exe "chdir " . info['name']
        call ShowDir()
    endif
endfunction

function! Main()
    call ShowDir()
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <F5> :call ShowDir()<CR>
call ShowDir()
