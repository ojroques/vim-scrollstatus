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

function! s:getBarSize(numberLines, numberVisibleLines) abort
  let l:barSize = (a:numberVisibleLines * s:size) / a:numberLines

  if l:barSize == 0
    let l:barSize = 1
  endif

  return l:barSize
endfunction

function! s:getPosition(firstLine, line, objectSize) abort
  let l:position = (a:line * (a:objectSize - 1)) / a:firstLine
  return l:position
endfunction

function! ScrollStatus() abort
  let l:numberLines = line('w$')
  let l:firstVisibleLine = line('w0') - 1
  let l:lastVisibleLine = line('w$') - 1
  let l:numberVisibleLines = l:lastVisibleLine - l:firstVisibleLine + 1
  let l:currentLine = line('.') - 1

  let l:barSize = getBarSize(l:numberLines, l:numberVisibleLines)
  let l:barPosition = getPosition(0, l:firstVisibleLine, s:size)
  let l:currentPosition = getPosition(l:firstVisibleLine, l:currentLine, s:barSize)

  let l:scrollStatus = []

  for i in range(s:size)
    call add(l:scrollStatus, s:symbol_track)
  endfor

  for i in range(l:barPosition, l:barPosition + l:barSize)
    l:scrollStatus[i] = s:symbol_bar
  endfor

  return l:scrollStatus
endfunction
