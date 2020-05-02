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

By default the scrollbar is 20 characters long. You can change that with:
```vim
let g:scrollstatus_size = 12
```

You can also change the symbols used for the bar and background track, see example below. By default they are set to `░` for the track and `█` for the bar.

## Example

To reproduce the statusline from the screenshot:
```vim
let g:scrollstatus_symbol_track = '░'  " default symbol, can be omitted
let g:scrollstatus_symbol_bar = '█'    " default symbol, can be omitted
let g:airline_section_x = '%{ScrollStatus()}'
let g:airline_section_y = airline#section#create_right(['filetype'])
let g:airline_section_z = airline#section#create([
            \ '%#__accent_bold#%3l%#__restore__#/%L', ' ',
            \ '%#__accent_bold#%3v%#__restore__#/%3{virtcol("$") - 1}',
            \ ])
```
