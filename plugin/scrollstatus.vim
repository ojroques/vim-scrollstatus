" vim-scrollstatus
" Author: Oliver Roques

scriptencoding utf-8

if exists('g:loaded_scrollstatus') || &compatible
  finish
endif

let g:loaded_scrollstatus = v:true

function! s:init() abort
  let s:size = get(g:, 'scrollstatus_size', 20)
  let s:symbol_track = get(g:, 'scrollstatus_symbol_track', '-')
  let s:symbol_bar = get(g:, 'scrollstatus_symbol_bar', '|')
  let s:symbol_cursor = get(g:, 'scrollstatus_symbol_cursor', '')

  let s:line = 0
  let s:numberLines = 1
  let s:firstVisibleLine = 0
  let s:lastVisibleLine = 0

  let s:binSize = 1
  let s:binBarStart = 0
  let s:binBarEnd = 0

  let s:scrollStatus = []

  for i in range(s:size)
    call add(s:scrollStatus, s:symbol_track)
  endfor
endfunction

function! s:getBinSize(numberLines, containerSize) abort
  let l:binSize = float2nr(floor(floor(a:numberLines) / a:containerSize))

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

function! s:isSameWindow() abort
  return line('w0') - 1 == s:firstVisibleLine &&
        \ line('w$') - 1 == s:lastVisibleLine
endfunction

function! s:isSameNumberLines() abort
  return line('$') == s:numberLines
endfunction

function! s:isSameLine() abort
  return line('.') == s:line
endfunction

function! ScrollStatus() abort
  if s:size <= 0
    finish
  endif

  if line('w$') < line('w0')
    return s:scrollStatus
  endif

  if s:isSameLine() && s:isSameNumberLines() && s:isSameWindow()
    return s:scrollStatus
  endif

  if !s:isSameNumberLines()
    let s:numberLines = line('$')
    let s:binSize = s:getBinSize(s:numberLines, s:size)
  endif

  if !s:isSameWindow()
    let s:firstVisibleLine = line('w0') - 1
    let s:lastVisibleLine = line('w$') - 1
  endif

  for i in range(s:binBarStart, s:binBarEnd)
    let s:scrollStatus[i] = s:symbol_track
  endfor

  let s:binBarStart = s:getBin(s:binSize, s:firstVisibleLine, s:size)
  let s:binBarEnd = s:getBin(s:binSize, s:lastVisibleLine, s:size)

  for i in range(s:binBarStart, s:binBarEnd)
    let s:scrollStatus[i] = s:symbol_bar
  endfor

  if !s:isSameLine() && s:symbol_cursor != ''
    let s:line = line('.') - 1
    let l:barSize = s:binBarEnd - s:binBarStart + 1
    let l:binWindowSize =
          \ s:getBinSize(s:lastVisibleLine - s:firstVisibleLine + 1, l:barSize)
    let l:binCursor = s:getBin(l:binWindowSize,
          \ s:line - s:firstVisibleLine, l:barSize)
    let s:scrollStatus[s:binBarStart + l:binCursor] = s:symbol_cursor
  endif

  return join(s:scrollStatus, '')
endfunction

call s:init()
