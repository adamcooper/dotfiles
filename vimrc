syntax enable         " Turn on syntax highlighting allowing local overrides
set encoding=utf-8

" Vundle requirments
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Tools
Plugin 'tpope/vim-dispatch'

" Formatting - Colors & Styles
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'nathanaelkane/vim-indent-guides'

" Tools - Search & Files
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
\ }
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
let g:ctrlp_map='<F11>'
nnoremap <leader>f :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>
" nnoremap <leader>m :CtrlPMRUFiles<CR>
" nnoremap <leader>t :CtrlPTag<CR>

Plugin 'corntrace/bufexplorer'
Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" Tools - Formatting
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'

" Tools - Git
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'
Plugin 'mattn/gist-vim.git'

" Tools - Copy Pasta
"Plugin 'svermeulen/vim-easyclip' " changes vim d an p too much
Plugin 'vim-scripts/YankRing.vim'

" Tools - Snippets
Plugin 'ervandew/supertab'
" Plugin 'Shougo/neosnippet.vim'
" Plugin 'Shougo/neosnippet-snippets'

" Languages

Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=5
let g:syntastic_javascript_checkers = ['eslint']
" this disables a lot of warnings for angular -
" https://github.com/scrooloose/syntastic/issues/612
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ,"trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]

" Languages - RAML
Plugin 'awochna/vim-raml'

" Langagues - GO
Plugin 'fatih/vim-go.git'

" Lanagues - Text
Plugin 'tpope/vim-markdown.git'
Plugin 'vim-scripts/csv.vim.git'

" Languages - Ruby
Plugin 'tpope/vim-bundler.git'
Plugin 'tpope/vim-rails.git'
Plugin 'thoughtbot/vim-rspec.git'
Plugin 'vim-ruby/vim-ruby.git'

" Languages - HTML / CSS / JS
Plugin 'tpope/vim-haml.git'
Plugin 'kchmck/vim-coffee-script.git'
Plugin 'pangloss/vim-javascript.git'

Plugin 'mxw/vim-jsx.git'
let g:jsx_ext_required = 0

"Plugin 'cakebaker/scss-syntax.vim.git', { 'directory': 'scss' }
Plugin 'slim-template/vim-slim.git'

"Plugin 'jgdavey/tslime.vim.git', { 'directory': 'tslime_2' }
"Plugin 'jgdavey/vim-turbux.git', { 'directory': 'turbux' }
"Plugin 'majutsushi/tagbar.git', { 'directory': 'tagbar' }

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required (:help filetype-plugin)

set number            " Show line numbers
set ruler             " Show line and column number
set clipboard=unnamed

let mapleader=","

"" Color Scheme
set background=dark
colorscheme solarized
call togglebg#map("<F5>")

" Allow backgrounding buffers without writing them, and remember marks/undo
" for background buffers
set hidden

" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode
set colorcolumn=80                " put a line marker at the 80th column

"" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the first column when wrap is
                                  " off and the line continues beyond the left of the screen
" Searching
set hlsearch                      " highlight matches
set incsearch                     " incremental searching
set ignorecase                    " searches are case insensitive...
set smartcase                     " ... unless they contain at least one capital letter
nnoremap <leader><space> :noh<cr> " clear search

" edit mode
map <leader>e :noh<enter>:NERDTreeClose<enter>:ccl<enter><C-w>=

" Removes trailing spaces
function! TrimWhiteSpace()
  %s/\s*$//
  ''
  :retab
:endfunction
map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>

" highlight current line
set cursorline
hi CursorLine cterm=NONE ctermbg=black

""
"" Disable swap files
""
set nobackup
set nowritebackup
set noswapfile

""
"" Tab Completion
""
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" allow mouse clicks
set mouse=a

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
" set noequalalways

" Navigate between split windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Same split settings as tmux
map <C-w>- :sp<cr>
map <C-w>\| :vs<cr>

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make set noexpandtab

  " Set the Ruby filetype for a number of common Ruby files without .rb
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby

  " " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript commentstring=//\ %s

  " remember last position in file
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
  "
  au FileWritePre * :call TrimWhiteSpace()
  au FileAppendPre * :call TrimWhiteSpace()
  au FilterWritePre * :call TrimWhiteSpace()
  au BufWritePre * :call TrimWhiteSpace()
endif


""
"" Ack
""
map <leader>F :Ack<space>

" disable cursor keys in normal mode
map <Left>  <nop>
map <Right> <nop>
map <Up>    <nop>
map <Down>  <nop>

imap jj <esc>

" Copy Paste settings - EasyClip
"
" share yank buffer across vims
" let g:EasyClipShareYank = 1
" toggle formatting on a block of pasted text
" nmap <leader>cf <plug>EasyClipToggleFormattedPaste

" ng to nerdtree
let g:NERDTreeWinSize=40
let g:NERDTreeChDirMode=2
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=1
let g:NERDTreeMouseMode=2
map <Leader>n :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>

" signify (git diff) settings
let g:signify_vcs_list = ['git']
let g:signify_disable_by_default = 1

" navigate buffers
map <A-h> :bp<CR>
map <A-l> :bn<CR>

" move lines up and down
map <A-j> :m +1 <CR>
map <A-k> :m -2 <CR>

if filereadable("zeus.json")
  let g:turbux_command_rspec = 'zeus rspec'
  let g:turbux_command_cucumber = 'zeus cucumber'
endif

" Run a ruby file in another pane
:map <Leader>r :w\|:call Send_to_Tmux("ruby ".expand("%")."\n")<CR>

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  " let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  " let g:ctrlp_use_caching = 0
endif
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
