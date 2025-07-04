" Fix Alacritty terminal detection
if $TERM == "alacritty"
    set term=xterm-256color
endif

" Basic settings
set nocompatible              " Be iMproved, required
filetype off                  " required
filetype plugin indent on

" Initialize vim-plug
call plug#begin('~/.vim/plugged')
Plug 'liuchengxu/vim-which-key'        " Which-key for Vim
Plug 'tpope/vim-fugitive'              " Git integration
Plug 'preservim/nerdtree'              " File explorer
Plug 'itchyny/lightline.vim'           " Status line
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf.vim'                " Fuzzy finder vim integration
Plug 'machakann/vim-highlightedyank'   " Highlight yanked text
Plug 'kaarmu/typst.vim'
Plug 'SirVer/ultisnips'
Plug 'junegunn/goyo.vim'
" Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rust-lang/rust.vim'
call plug#end()

let g:netrw_browsex_viewer = "firefox"

" Basic settings
syntax enable                 " Enable syntax highlighting
set number relativenumber     " Relative line numbers
set hidden                    " Allow switching buffers without saving
set wildmenu                 " Command completion
set path+=**                 " Search down into subfolders
set showcmd                  " Show partial commands
set laststatus=2             " Always show statusline
set backspace=indent,eol,start " Make backspace work as expected

" Typst concealment settings
let g:typst_conceal = 1            " Enable basic concealment (italic, bold)
let g:typst_conceal_math = 1       " Enable math symbol concealment
let g:typst_conceal_emoji = 1      " Enable emoji concealment

" Other useful typst settings
let g:typst_pdf_viewer = ''        " Set your preferred PDF viewer
let g:typst_auto_open_quickfix = 1 " Auto-open error list if compilation fails
let g:typst_embedded_languages = ['python', 'rust', 'cpp']  " Add languages you commonly use
" Enable all syntax highlighting features
syntax enable
syntax on
let g:typst_syntax_highlight = 1

" Search highlighting
set hlsearch                 " Highlight search matches
set incsearch                " Show matches while typing
set ignorecase              " Case insensitive search
set smartcase               " Case sensitive if uppercase present

" Which Key configuration
let mapleader = " "          " Space as leader key
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>

" Press Space + / to clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Window management
" Use Alt+h/j/k/l to resize windows
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-j> :resize +2<CR>
nnoremap <M-k> :resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>
" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Quick splits
nnoremap <leader>- :split<CR>
nnoremap <leader>\ :vsplit<CR>


" Define which-key mappings
let g:which_key_map = {}
let g:which_key_map['f'] = {
      \ 'name': '+file',
      \ 'f': [':Files', 'find files'],
      \ 'r': [':History', 'recent files'],
      \ 'n': [':enew', 'new file'],
      \ }
let g:which_key_map['w'] = {
      \ 'name': '+windows',
      \ 'w': ['<C-W>w', 'other-window'],
      \ 'd': ['<C-W>c', 'delete-window'],
      \ '-': ['<C-W>s', 'split-window-below'],
      \ '|': ['<C-W>v', 'split-window-right'],
      \ '2': ['<C-W>v', 'layout-double-columns'],
      \ 'h': ['<C-W>h', 'window-left'],
      \ 'j': ['<C-W>j', 'window-below'],
      \ 'l': ['<C-W>l', 'window-right'],
      \ 'k': ['<C-W>k', 'window-up'],
      \ '=': ['<C-W>=', 'balance-windows'],
      \ }

call which_key#register('<Space>', "g:which_key_map")

" NERDTree settings
nnoremap <C-n> :NERDTreeToggle<CR>
" Show hidden files in NERDTree
let NERDTreeShowHidden=1

" FZF (Fuzzy Finder) settings
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>

" Color scheme settings
set background=dark        " PaperColor needs this BEFORE loading
if has('termguicolors')
    set termguicolors
endif

try
    colorscheme PaperColor
catch
    echo "PaperColor not found!"
    colorscheme default
endtry

" Your toggle function
function! ToggleBackground()
    if &background == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction

nnoremap <F5> :call ToggleBackground()<CR>

" Add after your colorscheme selection
" These are examples - adjust colors to your preference
highlight typstMarkup ctermfg=green guifg=#98c379
highlight typstMath ctermfg=blue guifg=#61afef
highlight typstFunction ctermfg=yellow guifg=#e5c07b

" Commands
command RS call UltiSnips#RefreshSnippets()
command VS source ~/.vimrc 

" Visual line movements for normal mode
noremap j gj
noremap k gk
" Visual line movements for visual mode
vnoremap j gj
vnoremap k gk
" End/beginning of visual line
noremap $ g$
noremap 0 g0
noremap ^ g^

nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

nnoremap <C-a> :TypstWatch<CR>

" Wrap at word boundaries rather than at the exact screen edge
set wrap
set linebreak
" Don't break words when wrapping indented lines
set breakindent
set display+=lastline " show as much of last line as possible
set display-=truncate
