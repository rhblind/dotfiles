set         nocompatible            " This should always go first!
filetype    off

" Plugins
call plug#begin('~/.vim/plugged')
" Visual stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdtree'

" Command-line fuzzy finder
" https://github.com/junegunn/fzf.vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Intellisense engine + full language server protocol support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Elixir plugins
Plug 'elixir-editors/vim-elixir'
call plug#end()

filetype    plugin indent on

let         g:airline_theme='papercolor'

" Color and fonts
syntax      enable
colorscheme alduin
set         termguicolors
set         t_ut=""                 " fixes bug in background redraw on wls.exe
set         background=dark
set         guifont=MesloLGS\ NF:h12
set         laststatus=2            " always display the status line

" Global settings
" set         macmeta                 " macOS meta support
set         nofoldenable            " disable code folding
set         noswapfile              " don't write swap files
set         nobackup                " don't write backup files
set         nobackup                " never create vim backup files
set         title                   " change the terminal title
set         hidden                  " hide buffers instead of closing them
set         mouse=a                 " enable mouse scrolling
set         autoindent              " enable autoindent
set         smartindent             " do smart indenting
set         expandtab               " insert spaces instead of tabs
set         smarttab                " when on a <TAB> in front of a line insert `shiftwidth` number of spaces
set         softtabstop=4           " number of spaces <TAB> counts for in editing operations
set         tabstop=4               " number of spaces to insert for <TAB>
set         shiftwidth=4            " number of spaces to use for each autoindent
set         nowrap                  " disable line wrapping
set         showmatch               " match braces
set         matchtime=3             " match braces time
set         undolevels=100          " undo levels
set         incsearch               " do incremental searching
set         number                  " show line numbers
set         modeline                " If 'modeline' is on 'modelines' gives the number of lines that is checked for set commands.
set         guioptions-=RLrl        " hide scrollbars
set         guioptions-=T           " hide toolbar
set         guioptions-=l           " hide left scrollbar
set         guioptions-=L           " hide left scrollbar even if there is a vertical split
set         guioptions-=r           " hide right scrollbar
set         guioptions-=R           " hide right scrollbar even if there is a vertical split
set         noeb vb t_vb=           " DON'T BEEP!
set         smartcase               " ignore case is search string is in lowercase, else case-sensitive
set         hlsearch                " highlight search terms
set         incsearch               " show search matches while typing
set         autowrite               " automatically write a file when leaving a modified buffer.
set         clipboard=unnamed       " make clipboard behave as expected

" global ignore pattern
set         wildignore=*.o,.git,*.swp,*.swo,*~,*.pyc,build,*.egg,*.egg/*,*.egg-info/*,dist,pyshared,.tox,.env,**/node_modules/**,**/bower_components/**,

" Autocommands
autocmd!    BufWritePost ~/.config/nvim/init.vim  source %          " source this file whenever it is written to
" autocmd     BufNewFile,BufRead *.html set filetype=htmldjango       " always use htmldjango for html files
autocmd     BufWritePre * :%s/\s\+$//e                              " remove trailing spaces before saving buffer
autocmd     BufRead,BufNewFile *.scss set ft=scss.css
autocmd     BufNewFile,BufRead *.yml set filetype=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab
autocmd     InsertEnter,InsertLeave * set cul!

" Keybindings
let         mapleader = " "|                    " remap <leader> to <space>
map         <leader>f mzgg=G`z|                 " reformat the entire file
nnoremap    <leader>. :|                        " <leader>. writes `:`
nmap        <leader>nt :NERDTreeToggle %<CR>|   " open NERDTree with ',nt'
nmap        <leader>l :set list!<CR>|           " use <leader>l to toggle display of whitespaces
vmap        Q gq|                               " reformat paragraph
nmap        Q gqap|                             " reformat paragraph

nmap        <leader>bn :enew<CR>|               " create a new empty buffer
nmap        <leader>j :bnext<CR>|               " next buffer
nmap        <leader>k :bprevious<CR>|           " previous buffer
nmap        <leader>bq :bp <BAR> bd #<CR>|      " close the current buffer and move to the previous one

nmap        <silent><silent> <leader>p :set paste<CR>"*p:set nopaste<CR> "Toggle paste when pasting text
vnoremap    <silent> # :call VisualSelection('b')<CR> " pressing # in visual mode search for the current selection

noremap     <leader>n :nohl<CR>|                " clear highligh from last search in normal mode
vnoremap    <leader>s :sort<CR>|                " <leader>s sorts stuff in visual mode

imap        jj <ESC>                            " use `jj` as <ESC>

" Move lines up or down using <C-j> or <C-k>
nnoremap    <C-j> :m .+1<CR>==|                 " move one line up in normal mode
nnoremap    <C-k> :m .-2<CR>==|                 " move one line down in normal mode
inoremap    <C-j> <ESC>:m .+1<CR>==gi|          " move one line up in insert mode
inoremap    <C-k> <ESC>:m .-2<CR>==gi|          " move one line down in insert mode
vnoremap    <C-j> :m '>+1<CR>gv=gv|             " move one line up in visual mode
vnoremap    <C-k> :m '<-2<CR>gv=gv|             " move one line down in visual mode

"
" Plugin configurations
"

" Airline
let         g:airline#extensions#tabline#enabled = 1        " automatically displays all buffers when there's only one tab open
let         g:airline#extensions#tabline#fnamemod = ':t'    " only display filename in the tablist
let         g:airline#extensions#coc#enabled = 1            " enable coc integration for airline
let         g:airline#extensions#ale#enabled = 1            " ale linting engine
