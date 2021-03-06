" Calculator application for testing purposes.
" Has little to no use in practice.

let b:DISPLAY_WIDTH = 20

let b:reg_visible = '0'
let b:reg_memory = '0'
let b:action = ''
let b:has_dot = 0

" Perform specified action on provided arguments
function! Calc_DoAction(action, first, second)
    echo a:action . " " . a:first . " " . a:second

    let l:res = 0.0
    if a:action == '+'
        let l:res = str2float(a:first) + str2float(a:second)
    elseif a:action == '-'
        let l:res = str2float(a:first) - str2float(a:second)
    elseif a:action == '*'
        let l:res = str2float(a:first) * str2float(a:second)
    elseif a:action == '/'
        let l:res = str2float(a:first) / str2float(a:second)
    elseif a:action == ''
        let l:res = str2float(a:second)
    else
        return ''
    endif

    if l:res == float2nr(l:res)
        return printf('%d', float2nr(l:res))
    else
        return printf('%g', l:res)
    endif
endfunction

" Calculator key press
function! Calc_KeyPress(key)
    if a:key == '1' || a:key == '2' || a:key == '3' ||
            \a:key == '4' || a:key == '5' || a:key == '6' ||
            \a:key == '7' || a:key == '8' || a:key == '9'
        if b:reg_visible == '0'
            let b:reg_visible = ''
        endif
        let b:reg_visible = b:reg_visible . a:key
        call Calc_DisplayReg()
        call Calc_DisplayVisible()
    elseif a:key == '0'
        if b:reg_visible != '0'
            let b:reg_visible = b:reg_visible . a:key
        endif
        call Calc_DisplayReg()
        call Calc_DisplayVisible()
    elseif a:key == '<'
        if strlen(b:reg_visible) == 1
            let b:reg_visible = '0'
        else
            let b:reg_visible = b:reg_visible[0 : strlen(b:reg_visible) - 2]
        endif
        call Calc_DisplayReg()
        call Calc_DisplayVisible()
    elseif a:key == 'C'
        let b:reg_visible = '0'
        call Calc_DisplayReg()
        call Calc_DisplayVisible()
    elseif a:key == 'CE'
        let b:reg_memory = '0'
        let b:reg_visible = '0'
        let b:reg_action = ''
        call Calc_DisplayReg()
        call Calc_DisplayVisible()
    elseif a:key == '.'
        if !b:has_dot
            let b:reg_visible = b:reg_visible . a:key
            let b:has_dot = 1
        endif
        call Calc_DisplayReg()
        call Calc_DisplayVisible()
    elseif a:key == '+' || a:key == '-' || a:key == '*' || a:key == '/'
        let b:reg_memory = Calc_DoAction(b:action, b:reg_memory, b:reg_visible)
        let b:reg_visible = '0'
        let b:action = a:key
        call Calc_DisplayReg()
        call Calc_DisplayVisible()
    elseif a:key == '='
        let b:reg_visible = Calc_DoAction(b:action, b:reg_memory, b:reg_visible)
        call Calc_DisplayVisible()

        let b:reg_visible = '0'
        let b:reg_memory = ''
        let b:action = ''
        call Calc_DisplayReg()
    endif

endfunction

" Print number on calc display
function! Calc_DisplayReg()
    let l:buf = b:reg_memory
    if l:buf == '0'
        let l:buf = ''
    endif
    call setline(2, printf('| %24s <@%1s |', l:buf, b:action))
endfunction

function! Calc_DisplayVisible()
    let l:num = b:reg_visible
    if l:num == ''
        let l:num = '0'
    endif
    call setline(4, printf('| %24s <-  |', l:num))
endfunction

function! Calc_OnEnter()
    let line = line('.')
    let col = col('.')

    " If any of the buttons is pressed, process and return
    for btn in b:buttons
        if line >= btn[1] && line < btn[1] + btn[3] && col >= btn[2] && col < btn[2] + btn[4]
            call Calc_KeyPress(btn[0])
            return
        endif
    endfor
endfunction


nmap <CR> :call Calc_OnEnter()<CR>
nmap <Esc> :q!<CR>

let b:vis_help = [
\   '---+--------------------------------------------+----+',
\   '   |                Vimculator                  | -> |',
\   '---+                ----------                  +----+',
\   '   |                                            |',
\   "   | Oh-oh... You're about to VIMCULATE!        |",
\   '   |                                            |',
\   '   | Embrace your wildest dreams and reach your |',
\   '   | craziest goals with Vimculator - a simple  |',
\   '   | arithmetics tool for SMART people.         |',
\   '   |                                            |',
\   '   | Vimculator emulates your simple, average   |',
\   '   | calculator device. No fancy BULLSHIT like  |',
\   '   | square root, logarithms, memorization and  |',
\   '   | such. All you get is ONE register and FOUR |',
\   '   | basic arithmetic operations - and being a  |',
\   '   | SMART person you are, you know how to use  |',
\   '   | THE STUFF!                                 |',
\   '   |                                            |',
\   "   |          Vimculate RIGHT NOW!              |",
\   '   +--------------------------------------------+',
\]


function! Move(widget, y, x, offset, dir)
    " Get maximum line length
    let max_len = 0
    for l in a:widget
        if strlen(l) > max_len
            let max_len = strlen(l)
        endif
    endfor

    " Move widget
    let r = range(a:offset, max_len)
    if a:dir == 'left'
        let r = reverse(r)
    endif
    for i in r
        " Draw one position of widget
        for j in range(len(a:widget))
            " Draw line j of widget
            let widget_line = a:widget[j]
            if strlen(widget_line) < max_len
                for k in range(max_len - strlen(widget_line))
                    let widget_line .= ' '
                endfor
            endif

            let ss = matchstr(widget_line, '.\{' . i . '\}$')

            let orig_line = getline(a:y + j)
            if len(orig_line) < a:x
                let suffix = ''
                for k in range(a:x - len(orig_line))
                    let suffix = suffix . ' '
                endfor
                call setline(a:y + j, orig_line . suffix)
            endif

            let prefix = matchstr(getline(a:y + j), '^.\{' . (a:x - 1) . '\}')
            call setline(a:y + j, prefix . ss)
        endfor
        redraw
        sleep 20m
    endfor
endfunction

function! Repeat(s, times)
    let l:t = ''
    for i in range(a:times)
        let l:t = l:t . a:s
    endfor
    return l:t
endfunction

let b:dir = 'right'
function! Test()
    call Move(b:vis_help, 7, 33, 5, b:dir)
    if b:dir == 'right'
        let b:dir = 'left'
    elseif b:dir == 'left'
        let b:dir = 'right'
    endif
endfunction

nnoremap H :call Test()<CR>

let b:buttons = [
\   [ 'CE', 7, 4, 3, 12 ],
\   [ 'C', 7, 18, 3, 5 ],
\   [ '<', 7, 25, 3, 5 ],
\   [ '7', 11, 4, 3, 5 ],
\   [ '8', 11, 11, 3, 5 ],
\   [ '9', 11, 18, 3, 5 ],
\   [ '/', 11, 25, 3, 5 ],
\   [ '4', 15, 4, 3, 5 ],
\   [ '5', 15, 11, 3, 5 ],
\   [ '6', 15, 18, 3, 5 ],
\   [ '*', 15, 25, 3, 5 ],
\   [ '1', 19, 4, 3, 5 ],
\   [ '2', 19, 11, 3, 5 ],
\   [ '3', 19, 18, 3, 5 ],
\   [ '-', 19, 25, 3, 5 ],
\   [ '0', 23, 4, 3, 5 ],
\   [ '.', 23, 11, 3, 5 ],
\   [ '=', 23, 18, 3, 5 ],
\   [ '+', 23, 25, 3, 5 ],
\]

" Initialize vimculator
for i in range(29)
    call append(line('$'), '')
endfor
for i in range(1, 30)
    call setline(i, '|' . Repeat(' ', 30) . '|')
endfor
call setline(7, '|' . Repeat(' ', 30) . '+----+')
call setline(8, '|' . Repeat(' ', 30) . '| -> |')
call setline(9, '|' . Repeat(' ', 30) . '+----+')
for i in [1, 3, 5, 30]
    call setline(i, '+' . Repeat('-', 30) . '+')
endfor
call cursor(2, 28)
execute "normal! R<@"
call cursor(4, 28)
execute "normal! R<-"
call setline(27, printf('|  %-27s |', "Press 'H' for Help"))
call setline(28, printf('|  %-27s |', 'Have fun!'))

for btn in b:buttons
    call cursor(btn[1], btn[2])
    execute "normal! R+"
    for i in range(btn[4] - 2)
        execute "normal! lR-"
    endfor
    execute "normal! lR+"

    for i in range(btn[3] - 2)
        call cursor(btn[1] + i + 1, btn[2])
        execute "normal! R|"
        for j in range(btn[4] - 2)
            execute "normal! lR "
        endfor
        execute "normal! lR|"
    endfor
        
    call cursor(btn[1] + btn[3] - 1, btn[2])
    execute "normal! R+"
    for i in range(btn[4] - 2)
        execute "normal! lR-"
    endfor
    execute "normal! lR+"

    call cursor( btn[1] + (btn[3] - 1) / 2, btn[2] + 2 )
    execute "normal! R" . btn[0]
endfor

call Calc_DisplayVisible()

