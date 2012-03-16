set nocompatible      " Use vim, no vi defaults
syntax enable         " Turn on syntax highlighting allowing local overrides
set encoding=utf-8

runtime bundle/core/pathogen/autoload/pathogen.vim
call pathogen#infect('~/.dotfiles/vim/bundle/tools')
call pathogen#infect('~/.dotfiles/vim/bundle/langs')
call pathogen#infect('~/.dotfiles/vim/bundle/colors')
filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

set number            " Show line numbers
set ruler             " Show line and column number
set clipboard=unnamed

let mapleader=","

"" Color Scheme
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


" Removes trailing spaces
function! TrimWhiteSpace()
  %s/\s*$//
  ''
  :retab
:endfunction
autocmd FileWritePre * :call TrimWhiteSpace()
autocmd FileAppendPre * :call TrimWhiteSpace()
autocmd FilterWritePre * :call TrimWhiteSpace()
autocmd BufWritePre * :call TrimWhiteSpace()
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
set wildignore+=*.o,*.obj,*.rbc,*.class,vendor/gems/*
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*.jpg,*.jpeg,*.gif,*.png
set wildignore+=*.zip,*.apk
set wig=tmp/*,log/*,db/sphinx/*,*.gif,*.png,*.jpg


" allow mouse clicks
set mouse=a

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" Navigate between split windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

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
endif


""
"" Ack
""
map <leader>F :Ack<space>

" Set powerline status bar to unicode to work around terminal hacks
let g:Powerline_symbols="unicode"
if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  " Start the status line
  set statusline=%f\ %m\ %r

  " Add fugitive
  set statusline+=%{fugitive#statusline()}

  " Finish the statusline
  set statusline+=Line:%l/%L[%p%%]
  set statusline+=Col:%v
  set statusline+=Buf:#%n
  set statusline+=[%b][0x%B]
endif

" disable cursor keys in normal mode
map <Left>  <nop>
map <Right> <nop>
map <Up>    <nop>
map <Down>  <nop>

" copy selection to clipboard
vmap <leader>y "*y
vmap <leader>p "*gP


" CTR-P plugin settings
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files', 'find %s -type f']
"let g:ctrlp_custom_ignore = {'dir': '\.git$\'}
"let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']
"let g:ctrlp_user_command = ['.hg/', 'hg --cwd %s locate -I .']
"let g:ctrlp_user_command = { 'types': { 1: ['.git/', 'cd %s && git ls-files'], 2: ['.hg/', 'hg --cwd %s locate -I .'], }, 'fallback': 'find %s -type f' }

" succombing to nerdtree
let g:NERDTreeWinSize=40
let g:NERDTreeChDirMode=2
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=1
let g:NERDTreeMouseMode=2
map <Leader>n :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>


" Run rspec in zsh
" :map ;t :w\|:call Send_to_Tmux("rspec ".expand("%")."\n")
"
" Macros
"
" Convert rspec errors output into a CSV format
" let @r = 'I"2Ea","lxA"j@r'
