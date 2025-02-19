"================vim-plug======================

call plug#begin('~/.vim/plugged')
	Plug 'tpope/vim-fugitive'
	Plug 'morhetz/gruvbox'
	Plug 'git://git.wincent.com/command-t.git'
	Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
	Plug 'bling/vim-airline' 
	Plug 'preservim/nerdtree'
	Plug 'tpope/vim-abolish'
	Plug 'Lokaltog/vim-easymotion'
	Plug 'ronakg/quickr-cscope.vim'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'wakatime/vim-wakatime'
	Plug 'github/copilot.vim'

call plug#end()

"============!vim-plug========================

"============VIM setting======================
let mapleader=" "
nnoremap <SPACE> <Nop>
"============!VIM setting=====================

"============CoC setting======================

"============!CoC setting=====================

"============ctrlp setting====================
set runtimepath^=~/.vim/bundle/ctrlp.vim


"============fugitive setting=================
"Firt two for merge
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>

"============Gruvbox setting==================
set background=dark
colorscheme gruvbox

"============Comment settting=================
func! CmtOn()    "주석 on
exe "'<,'>norm i//"
endfunc
func! CmtOff()    "주석 off
	exe "'<,'>norm 2x"
	endfunc
	vmap <c-j> <esc>:call CmtOn() <cr>
	vmap <c-x> <esc>:call CmtOff() <cr>
	nmap <c-j> <esc>v:call CmtOn() <cr>
	nmap <c-x> <esc>v:call CmtOff() <cr>
"==============================================================

"======================vim default setting=====================
set ruler "horizontal line
set wrap
set number "line number (<-> set nonumber)
set tabstop=4 " 탭문자는 4컬럼 크기로 보여주기
set shiftwidth=4 " 문단이나 라인을 쉬프트할 때 4컬럼씩 하기
set autoindent " 자동 들여쓰기
syntax on " 적절히 Syntax에 따라 하일라이팅 해주기
set cindent " C 언어 자동 들여쓰기
set showmatch       " 매치되는 괄호의 반대쪽을 보여줌
set title           " 타이틀바에 현재 편집중인 파일을 표시
set smartindent " 좀더 똑똑한 들여쓰기를 위한 옵션이다.
set ignorecase
set incsearch
set showcmd
set nowrap
set laststatus=2
set autoindent " 자동으로 들여쓰기를 한다.
set ts=4 "Tab space
set sw=4
set hlsearch "highlight search
set cursorline
set relativenumber  "show relative line number
syntax enable
" highlight Comment term=bold cterm=bold ctermfg=2

"=====================buffer navigation=======
",1을 누르면 1번 버퍼로 이동
map ,1 :b!1<CR>
map ,2 :b!2<CR>
map ,3 :b!3<CR>
map ,4 :b!4<CR>
map ,5 :b!5<CR>
map ,6 :b!6<CR>
map ,7 :b!7<CR>
map ,8 :b!8<CR>
map ,9 :b!9<CR>
map ,0 :b!0<CR>

"=====================Nerdtree setting=======
"keybind NERDTREE
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

autocmd VimEnter * NERDTree | wincmd p
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let NERDTreeShowHidden=1

"=====================ctags 설정 ============
set tags=./tags ",/usr/src/tags

let g:easytags_async=1
let g:easytags_auto_highlight = 0
let g:easytags_include_members = 1
let g:easytags_dynamic_files = 1


"==================== cscope 설정 ===========
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  " else add the database pointed to by environment variable 
  elseif $CSCOPE_DB != "" 
    cs add $CSCOPE_DB
  endif
endfunction
au BufEnter /* call LoadCscope()

"================== Tlist 설정 ==========
nnoremap <silent> <F8> :Tlist<CR>
let Tlist_Use_Right_Window = 1

"================== 읽은 곳 부터 다시 읽기 =======
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

"================== NEOVIM terminal setting ======
" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>
