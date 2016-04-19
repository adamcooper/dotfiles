syntax enable         " Turn on syntax highlighting allowing local overrides
set encoding=utf-8

" Setup Dein  ----------------------------------------------------------{{{
" If Dein is not installed, do it first
if (!isdirectory(expand("$HOME/.dotfiles/vim/repos/github.com/Shougo/dein.vim")))
  call system(expand("mkdir -p $HOME/.dotfiles/vim/repos/github.com"))
  call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.dotfiles/vim/repos/github.com/Shougo/dein.vim"))
endif
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.dotfiles/vim/repos/github.com/Shougo/dein.vim
endif

" Required:
  call dein#begin(expand('~/.dotfiles/vim'))
  let pluginsExist = 0

" Required:
  call dein#add('Shougo/dein.vim')

" Tools
  call dein#add('tpope/vim-dispatch')

" Formatting - Colors & Styles
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('bling/vim-airline')
  call dein#add('nathanaelkane/vim-indent-guides')

" Tools - Search & Files
  call dein#add('scrooloose/nerdtree')
  call dein#add('mileszs/ack.vim')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('corntrace/bufexplorer')

" Tools - Formatting
  call dein#add('tpope/vim-commentary')
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-surround')

" Tools - Git
  call dein#add('tpope/vim-git')
  call dein#add('tpope/vim-fugitive')
  call dein#add('mattn/gist-vim.git')

" Tools - Copy Pasta
" call dein#add("svermeulen/vim-easyclip") " changes vim d an p too much
" call dein#add('vim-scripts/YankRing.vim')

" Tools - Snippets
"   call dein#add('Shougo/neosnippet.vim')
"   call dein#add('Shougo/neosnippet-snippets')

" Languages

" Langagues - GO
  call dein#add('fatih/vim-go.git')

" Lanagues - Text
  call dein#add('tpope/vim-markdown.git')
  call dein#add('vim-scripts/csv.vim.git')

" Languages - Ruby
  call dein#add('tpope/vim-bundler.git')
  call dein#add('tpope/vim-rails.git')
  call dein#add('thoughtbot/vim-rspec.git')
  call dein#add('vim-ruby/vim-ruby.git')

" Languages - HTML / CSS / JS
  call dein#add('tpope/vim-haml.git')
  call dein#add('kchmck/vim-coffee-script.git')
  call dein#add('pangloss/vim-javascript.git')
" call dein#add('cakebaker/scss-syntax.vim.git', { 'directory': 'scss' })
  call dein#add('slim-template/vim-slim.git')
"

" call dein#add('ervandew/supertab.git', { 'directory': 'supertab' })
" call dein#add('majutsushi/tagbar.git', { 'directory': 'tagbar' })
" call dein#add('jgdavey/tslime.vim.git', { 'directory': 'tslime_2' })
" call dein#add('jgdavey/vim-turbux.git', { 'directory': 'turbux' })


  if dein#check_install()
    call dein#install()
  endif
  call dein#end()


" Required:
filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)
" }}}


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

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

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

" copy selection to clipboard
vmap <leader>y "*y
vmap <leader>p "*gP
" Copy Paste settings - EasyClip
"
" share yank buffer across vims
" let g:EasyClipShareYank = 1
" toggle formatting on a block of pasted text
" nmap <leader>cf <plug>EasyClipToggleFormattedPaste

" CTR-P plugin settings
" let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']
" let g:ctrlp_clear_cache_on_exit = 1
" let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'

" succombing to nerdtree
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
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
