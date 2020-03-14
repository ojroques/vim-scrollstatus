" vim-scrollstatus
" Author: Oliver Roques

scriptencoding utf-8

if exists('g:loaded_scrollstatus') || &compatible
  finish
endif

let g:loaded_scrollstatus = v:true

let s:size = get(g:, 'scrollstatus_size', 20)
let s:symbol_track = get(g:, 'scrollstatus_symbol_track', '-')
let s:symbol_bar = get(g:, 'scrollstatus_symbol_bar', '|')
let s:symbol_cursor = get(g:, 'scrollstatus_symbol_cursor', '')

function! s:getBinSize(numberLines, containerSize) abort
  if a:containerSize <= 0
    finish
  endif

  let l:binSize = float2nr(floor(floor(a:numberLines) / a:containerSize))

  if l:binSize < 1
    return 1
  endif

  return l:binSize
endfunction

function! s:getBin(binSize, line, containerSize) abort
  if a:binSize <= 0
    finish
  endif

  let l:bin = a:line / a:binSize

  if l:bin > a:containerSize -1
    return a:containerSize - 1
  endif

  return l:bin
endfunction

function! ScrollStatus() abort
  if s:size <= 0
    finish
  endif

  let l:scrollStatus = []

  for i in range(s:size)
    call add(l:scrollStatus, s:symbol_track)
  endfor

  let l:numberLines = line('$')
  let l:firstVisibleLine = line('w0') - 1
  let l:lastVisibleLine = line('w$') - 1
  let l:numberVisibleLines = l:lastVisibleLine - l:firstVisibleLine + 1

  if l:numberVisibleLines <= 0
    return l:scrollStatus
  endif

  let l:binSize = s:getBinSize(l:numberLines, s:size)
  let l:binBarStart = s:getBin(l:binSize, l:firstVisibleLine, s:size)
  let l:binBarEnd = s:getBin(l:binSize, l:lastVisibleLine, s:size)

  for i in range(l:binBarStart, l:binBarEnd)
    let l:scrollStatus[i] = s:symbol_bar
  endfor

  if s:symbol_cursor != ''
    let l:currentLine = line('.') - 1
    let l:barSize = l:binBarEnd - l:binBarStart + 1
    let l:binWindowSize = s:getBinSize(l:numberVisibleLines, l:barSize)
    let l:binCursor = s:getBin(l:binWindowSize,
          \ l:currentLine - l:firstVisibleLine, l:barSize)
    let l:scrollStatus[l:binBarStart + l:binCursor] = s:symbol_cursor
  endif

  return join(l:scrollStatus, '')
endfunction
