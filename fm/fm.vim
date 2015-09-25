function! ByteCountToString(byteCount)
    if a:byteCount >= 1024 * 1024 * 1024
        let num = a:byteCount / (1024 * 1024 * 1024) . 'G'
    elseif a:byteCount >= 1024 * 1024
        let num = a:byteCount / (1024 * 1024) . 'M'
    elseif a:byteCount >= 1024
        let num = a:byteCount / 1024 . 'K'
    else
        let num = a:byteCount . 'B'
    endif

    return num
endfunction


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

function! SelectDir()
    let line = getline(line('.'))
    let matches = matchlist(line, '\s*\(\S\+\)\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(.*\S\+\)\s*$')

    let type = get(matches, 1)
    let fileName = get(matches, 4)

    if type == 'dir'
        exe "chdir " . fileName
        call ShowDir()
    endif
endfunction

nmap <CR> :call SelectDir()<CR>
