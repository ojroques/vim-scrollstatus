# vim-scrollstatus

A scrollbar for Vim statusline.

![vim-scrollstatus](demo.gif)

## Installation

With [vim-plug](https://github.com/junegunn/vim-plug), in your `.vimrc`:

```vim
call plug#begin()
Plug 'ojroques/vim-scrollstatus'
call plug#end()
```

## Usage
With [vim-airline](https://github.com/vim-airline/vim-airline):
```vim
let g:airline_section_x = '%{ScrollStatus()}'
```

With [lightline.vim](https://github.com/itchyny/lightline.vim):
```vim
let g:lightline = {
  \ 'active': {
  \   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype', 'charvaluehex']]
  \ },
  \ 'component_function': {'percent': 'ScrollStatus'},
  \ }
```

By default the scrollbar is 20 characters long. You can set another value with:
```vim
let g:scrollstatus_size = 12
```

By default the symbols are set to `░` for the track and `█` for the bar. To change them:
```vim
let g:scrollstatus_symbol_track = '-'
let g:scrollstatus_symbol_bar = '|'
```

## Example

To reproduce the statusline from the screenshot:
```vim
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'ojroques/vim-scrollstatus'
call plug#end()

let g:airline_section_x = '%{ScrollStatus()} '
let g:airline_section_y = airline#section#create_right(['filetype'])
let g:airline_section_z = airline#section#create([
            \ '%#__accent_bold#%3l%#__restore__#/%L', ' ',
            \ '%#__accent_bold#%3v%#__restore__#/%3{virtcol("$") - 1}',
            \ ])
```
