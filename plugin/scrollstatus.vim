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
let s:enable_window_pos = get(g:, 'scrollstatus_enable_window_pos', v:true)

function! s:getBarSize(numberLines, numberVisibleLines) abort
  if a:numberLines == 0
    finish
  endif

  let l:barSize = (a:numberVisibleLines * s:size) / a:numberLines

  if l:barSize == 0
    let l:barSize = 1
  endif

  return l:barSize
endfunction

function! s:getPosition(numberLines, line, objectSize) abort
  if a:numberLines == 0 || a:objectSize == 0
    finish
  endif

  let l:binSize = float2nr(round(floor(a:numberLines) / floor(a:objectSize)))
  let l:position = a:line / l:binSize

  return l:position
endfunction

function! ScrollStatus() abort
  if s:size == 0
    finish
  endif

  let l:numberLines = line('$')
  let l:firstVisibleLine = line('w0') - 1
  let l:lastVisibleLine = line('w$') - 1
  let l:numberVisibleLines = l:lastVisibleLine - l:firstVisibleLine + 1
  let l:currentLine = line('.') - 1

  let l:barSize = s:getBarSize(l:numberLines, l:numberVisibleLines)
  let l:barPosition = s:getPosition(l:numberLines, l:firstVisibleLine, s:size)
  let l:currentPosition = s:getPosition(l:numberVisibleLines, l:currentLine - l:firstVisibleLine, l:barSize)

  let l:scrollStatus = []

  for i in range(s:size)
    call add(l:scrollStatus, s:symbol_track)
  endfor

  for i in range(l:barPosition, l:barPosition + l:barSize)
    if i >= s:size
      break
    endif
    let l:scrollStatus[i] = s:symbol_bar
  endfor

  return join(l:scrollStatus, '')
endfunction
