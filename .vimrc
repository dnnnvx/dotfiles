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
