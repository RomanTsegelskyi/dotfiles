" => General {{{
colorscheme badwolf
filetype indent on		" load filetype specific indent files
filetype plugin on
syntax enable			" enable syntax processing
set clipboard=unnamed   " Use the OS clipboard by default (on versions compiled with `+clipboard`)
set shell=/bin/sh
" }}}
" => VIM user interface {{{ 

set tabstop=4			" number of visual spaces per TAB
set softtabstop=4		" number of spaces in tab when editing
set shiftwidth=4		" indenting is 4 spaces
set expandtab			" replace tab by spaces
set autoindent			" autoindent
set smartindent			" improved autoindent
set cindent				" special indent rules for C
set number              " show line numbers
set showcmd             " show command in bottom bar
if ('mac') || has('unix')
    set cursorline          " highlight current line
endif
set showmatch			" highlight matching [{()}]
set lazyredraw          " redraw only when we need to.

set backspace=indent,eol,start

" Different cursor in different modes
if has('mac') || has ('unix')
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}
" => Completion {{{
set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set omnifunc=syntaxcomplete#Complete
let g:neocomplete#enable_at_startup = 1
" }}}
" => Launch Config {{{
call pathogen#infect()                      " use pathogen
if has('mac') || has ('unix') 
  autocmd VimEnter * call AirlineInit()       " initialize airline
endif
" }}}
" => Searching {{{
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " Ignore case when searching...
set smartcase           " ...unless we type a capital
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" }}}
" => Scrolling {{{
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
" }}}
" => Folding {{{
set foldenable          " enable folding
set foldlevel=10         " to have everything folded set to 0
" space open/closes folds
nnoremap <space> za
set foldmethod=indent   " fold based on indent level
" }}}
" => Movement {{{
" move to beginning/end of line
nnoremap B ^
nnoremap E $

" }}}
" => CtrlP {{{
" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" }}}
" => Editing mappings {{{ 
" Insert empty line using Enter
nmap <CR> o<Esc>k

let mapleader=","       " leader is comma

" jk is escape
inoremap jk <esc>

" paste without indent
set pastetoggle=<leader>p

" save session
nnoremap <leader>s :mksession<CR>

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" open ag.vim
nnoremap <leader>a :Ag

" fast save
nmap <leader>w :w!<cr>

" fast exit
nmap <leader>q :q!<cr>

" fast exit and save is needed
nmap <leader>x :x<cr>
" }}}
" => Autogroups {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                \:call <SID>StripTrailingWhitespaces()
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
    au FileType go nmap <leader>r <Plug>(go-run)
    au FileType go nmap <leader>b <Plug>(go-build)
    au FileType go nmap <leader>t <Plug>(go-test)
    au FileType go nmap <leader>c <Plug>(go-coverage)
    au FileType go nmap <Leader>ds <Plug>(go-def-split)
    au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
    au FileType go nmap <Leader>dt <Plug>(go-def-tab)
    au FileType go nmap <Leader>gd <Plug>(go-doc)
    au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
    au FileType go nmap <Leader>gi <Plug>(go-import)
    au FileType go nmap <Leader>s <Plug>(go-implements)
    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap <Leader>e <Plug>(go-rename)
augroup END
" }}}
" => Backups {{{ 
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
" }}}
" => Misc {{{
set modelines=1			" check final line for modelline
" }}}
" => Helper functions {{{
" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
" }}}
" => Instant Markdown {{{
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 1
" }}}
" => Airline {{{
function! AirlineInit()
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#branch#enabled = 1
    let g:airline#extensions#tagbar#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline_powerline_fonts=1
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:Powerline_symbols = "fancy"
    set laststatus=2
    let g:airline_section_a = airline#section#create(['mode'])
    let g:airline_section_b = airline#section#create_left(['branch', 'hunks', '%f'])
    let g:airline_section_c = airline#section#create(['filetype'])
    let g:airline_section_x = airline#section#create(['%P'])
    let g:airline_section_y = airline#section#create(['%B'])
    let g:airline_section_z = airline#section#create_right(['%l','%c'])
endfunction
" }}}
"  => BufferManagement {{{
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden
"
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>
"
" Move to the next buffer
nmap <leader>l :bnext<CR>
"
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
"
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>
"
" Show all open buffers and their status
nmap <leader>bl :ls<CR>
"  }}}
"  => Go Options {{{
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
"  }}}
" vim:foldmethod=marker:foldlevel=0
