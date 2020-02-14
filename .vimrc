"more characters will be sent to the screen for redrawing
set ttyfast

"time waited for key press(es) to complete. It makes for a faster key response
set ttimeout
set ttimeoutlen=50

"make backspace behave properly in insert mode
set backspace=indent,eol,start

"display incomplete commands
set showcmd

"a better menu in command mode
set wildmenu
set wildmode=longest:full,full

"hide buffers instead of closing them even if they contain unwritten changes
set hidden

"disable soft wrap for lines
set nowrap

"always display the status line
set laststatus=2

"display line numbers on the left side
set number

"highlight current line
set cursorline

"display text width column
"set colorcolumn=81

"new splits will be at the bottom or to the right side of the screen
set splitbelow
set splitright

"always set autoindenting on
set autoindent

"incremental search
set incsearch

"highlight search
set hlsearch

"searches are case insensitive unless they contain at least one capital letter
set ignorecase
set smartcase

"you need this to always display the status line
set laststatus=2

"modifiedflag, charcount, filepercent, filepath
set statusline=%=%m\ %c\ %P\ %f

set encoding=utf-8
set fileencoding=utf-8
autocmd Filetype go setlocal tabstop=2 shiftwidth=2 softtabstop=2
" ts - show existing tab with 4 spaces width
" sw - when indenting with '>', use 4 spaces width
" sts - control <tab> and <bs> keys to match tabstop

set shiftwidth=2
filetype plugin indent on


"vim-go
filetype plugin indent on
au filetype go inoremap <buffer> . .<C-x><C-o>

"vim-airline
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
