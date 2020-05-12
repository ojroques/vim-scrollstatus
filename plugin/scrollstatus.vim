" vim-scrollstatus
" Author: Oliver Roques

scriptencoding utf-8

if exists('g:loaded_scrollstatus') || &compatible
  finish
endif

let g:loaded_scrollstatus = 1

function! s:init() abort
  let s:size = get(g:, 'scrollstatus_size', 20)
  let s:symbol_track = get(g:, 'scrollstatus_symbol_track', '░')
  let s:symbol_bar = get(g:, 'scrollstatus_symbol_bar', '█')

  let s:numberLines = -1
  let s:firstVisibleLine = -1
  let s:lastVisibleLine = -1
  let s:numberVisibleLines = -1

  let s:binSize = 0
  let s:binBarStart = 0
  let s:barSize = 0

  let s:scrollStatus = []

  for i in range(s:size)
    call add(s:scrollStatus, s:symbol_track)
  endfor
endfunction

function! s:getBinSize(numberLines, containerSize) abort
  let l:binSize = float2nr(round(floor(a:numberLines) / a:containerSize))

  if l:binSize < 1
    return 1
  endif

  return l:binSize
endfunction

function! s:getBin(binSize, line, containerSize) abort
  let l:bin = a:line / a:binSize

  if l:bin > a:containerSize -1
    return a:containerSize - 1
  endif

  return l:bin
endfunction

function! s:getBarSize(numberLines, numberVisibleLines, containerSize) abort
  return float2nr(round(floor(a:numberVisibleLines * a:containerSize) / a:numberLines))
endfunction

function! s:isSameNumberLines() abort
  return line('$') == s:numberLines
endfunction

function! s:isSameWindow() abort
  return line('w0') - 1 == s:firstVisibleLine &&
        \ line('w$') - 1 == s:lastVisibleLine
endfunction

function! s:fillBar(binBarStart, barSize, symbol) abort
  for i in range(a:binBarStart, a:binBarStart + a:barSize)
    if i > s:size - 1
      break
    endif

    let s:scrollStatus[i] = a:symbol
  endfor
endfunction

function! ScrollStatus() abort
  if s:size <= 0
    finish
  endif

  if line('w$') < line('w0')
    return join(s:scrollStatus, '')
  endif

  if s:isSameNumberLines() && s:isSameWindow()
    return join(s:scrollStatus, '')
  endif

  if !s:isSameNumberLines()
    let s:numberLines = line('$')
    let s:binSize = s:getBinSize(s:numberLines, s:size)
  endif

  if !s:isSameWindow()
    let s:firstVisibleLine = line('w0') - 1
    let s:lastVisibleLine = line('w$') - 1
    let s:numberVisibleLines = s:lastVisibleLine - s:firstVisibleLine + 1
  endif

  call s:fillBar(s:binBarStart, s:barSize, s:symbol_track)

  let s:binBarStart = s:getBin(s:binSize, s:firstVisibleLine, s:size)
  let s:barSize = s:getBarSize(s:numberLines, s:numberVisibleLines, s:size)

  call s:fillBar(s:binBarStart, s:barSize, s:symbol_bar)

  return join(s:scrollStatus, '')
endfunction

call s:init()
