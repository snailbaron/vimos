" Calculator application for testing purposes.
" Has little to no use in practice.

let b:DISPLAY_WIDTH = 20

let b:reg_visible = ''
let b:reg_memory = ''
let b:action = ''

" Calculator key press
function! Calc_KeyPress(key)
    if a:key == '1' || a:key == '2' || a:key == '3' ||
            \a:key == '4' || a:key == '5' || a:key == '6' ||
            \a:key == '7' || a:key == '8' || a:key == '9' ||
            \a:key == '0'
        let b:reg_visible = b:reg_visible . a:key
        call Calc_DisplayVisible()
    elseif a:key == '+' || a:key == '-' || a:key == '*' || a:key == '/'
        if b:action == '+'
            let b:reg_memory += b:reg_visible
        elseif b:action == '-'
            let b:reg_memory -= b:reg_visible
        elseif b:action == '*'
            let b:reg_memory *= b:reg_visible
        elseif b:action == '/'
            let b:reg_memory /= b:reg_visible
        else
            let b:reg_memory = b:reg_visible
        endif
        let b:reg_visible = ''
        let b:action = a:key
        call Calc_DisplayReg()
        call Calc_DisplayVisible()
    elseif a:key == '='
        if b:action == '+'
            let b:reg_visible = b:reg_memory + b:reg_visible
        elseif b:action == '-'
            let b:reg_visible = b:reg_memory - b:reg_visible
        elseif b:action == '*'
            let b:reg_visible = b:reg_memory * b:reg_visible
        elseif b:action == '/'
            let b:reg_visible = b:reg_memory / b:reg_visible
        endif
        call Calc_DisplayVisible()

        let b:reg_visible = ''
        let b:reg_memory = ''
        let b:action = ''
        call Calc_DisplayReg()
    endif
endfunction

" Print number on calc display
function! Calc_DisplayReg()
    call setline(2, '| reg: ' . b:reg_memory)
endfunction

function! Calc_DisplayVisible()
    let l:num = b:reg_visible
    if l:num == ''
        let l:num = '0'
    endif
    call setline(4, '| ' . printf('%10s', l:num))
endfunction

function! Calc_OnEnter()
    let char = getline('.')[col('.') - 1]
    call Calc_KeyPress(char)
endfunction




call append(line('$'), '| ')
call append(line('$'), '+-----------------------------')
call append(line('$'), '|')
call append(line('$'), '+-----------------------------')
call append(line('$'), '')
call append(line('$'), '1 2 3 +')
call append(line('$'), '4 5 6 -')
call append(line('$'), '7 8 9 *')
call append(line('$'), '= 0 . /')
call append(line('$'), '')

nmap <CR> :call Calc_OnEnter()<CR>




" Calculator outline
" ==================
"
" +---------------------------+
" |                   1024 <@ |
" +---------------------------+
" |                     12 <- |
" +---------------------------+
" |                           |
" |  +---+ +---+ +---+ +---+  |
" |  | 1 | | 2 | | 3 | | + |  |
" |  +---+ +---+ +---+ +---+  |
" |                           |
" |  +---+ +---+ +---+ +---+  |
" |  | 4 | | 5 | | 6 | | - |  |
" |  +---+ +---+ +---+ +---+  |
" |                           |
" |  +---+ +---+ +---+ +---+  |
" |  | 7 | | 8 | | 9 | | * |  |
" |  +---+ +---+ +---+ +---+  |
" |                           |
" |  +---+ +---+ +---+ +---+  |
" |  | 0 | | . | | = | | / |  |
" |  +---+ +---+ +---+ +---+  |
" |                           |
" +---------------------------+
