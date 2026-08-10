let mapleader = ","

" -----------------------------------------------------------------------------
" General
" -----------------------------------------------------------------------------
set number
set relativenumber
filetype plugin indent on
set autoread
au FocusGained,BufEnter * silent! checktime

" -----------------------------------------------------------------------------
" UI
" -----------------------------------------------------------------------------
syntax enable
if has('termguicolors')
  set termguicolors
endif
set background=dark

set ignorecase
set smartcase
set hlsearch
set incsearch
set scrolloff=7
set wildmenu
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set backspace=eol,start,indent
set mouse=a

" -----------------------------------------------------------------------------
" Indent
" -----------------------------------------------------------------------------
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent
set wrap

" Return to last edit position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" -----------------------------------------------------------------------------
" Window / tab keymaps (mirrors nvim/lua/core/keymaps/window.lua, tab.lua)
" -----------------------------------------------------------------------------
map <leader>wv <C-w>v
map <leader>wh <C-w>s
map <leader>wc :close<cr>
map <leader>wco :only<cr>
map <leader>we <C-w>=

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>t] :tabnext<cr>
map <leader>t[ :tabprevious<cr>
map ]t :tabnext<cr>
map [t :tabprevious<cr>

" -----------------------------------------------------------------------------
" Misc
" -----------------------------------------------------------------------------
map <silent> <leader><cr> :noh<cr>

" Don't close window when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction
map <leader>bd :Bclose<cr>
