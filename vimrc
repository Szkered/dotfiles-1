" Author: John Anderson (sontek@gmail.com)

" Don't load plugins if we aren't in Vim7
if version < 700
set noloadplugins
endif

"" Skip this file unless we have +eval
if 1

""" Settings 
set nocompatible						" Don't be compatible with vi

"""" Movement
" work more logically with wrapped lines
"noremap j gj
"noremap k gk

"""" Searching and Patterns
set ignorecase							" search is case insensitive
set smartcase							" search case sensitive if caps on 
set incsearch							" show best match so far
set hlsearch							" Highlight matches to the search 

"""" Display
set background=dark						" I use dark background
set lazyredraw							" Don't repaint when scripts are running
set scrolloff=3							" Keep 3 lines below and above the cursor
set ruler								" line numbers and column the cursor is on
"set number								" Show line numbering
set numberwidth=1						" Use 1 col + 1 space for numbers
"colorscheme tango						" Use tango colors

" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M

""" Windows
if exists(":tab")						" Try to move to other windows if changing buf
set switchbuf=useopen,usetab
else									" Try other windows & tabs if available
	set switchbuf=useopen
endif

"""" Messages, Info, Status
set shortmess+=a						" Use [+] [RO] [w] for modified, read-only, modified
set showcmd								" Display what command is waiting for an operator
set ruler								" Show pos below the win if there's no status line
set laststatus=2						" Always show statusline, even if only 1 window
set report=0							" Notify me whenever any lines have changed
set confirm								" Y-N-C prompt if closing with unsaved changes
set vb t_vb=							" Disable visual bell!  I hate that flashing.

"""" Editing
set backspace=2							" Backspace over anything! (Super backspace!)
set showmatch							" Briefly jump to the previous matching paren
set matchtime=2							" For .2 seconds
set formatoptions-=tc					" I can format for myself, thank you very much
set tabstop=4							" Tab stop of 4
set shiftwidth=4						" sw 4 spaces (used on auto indent)
set softtabstop=4						" 4 spaces as a tab for bs/del

" we don't want to edit these type of files
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp

"""" Coding
set history=100							" 100 Lines of history
set showfulltag							" Show more information while completing tags
filetype plugin on						" Enable filetype plugins
filetype plugin indent on				" Let filetype plugins indent for me
syntax on								" Turn on syntax highlighting

" set up tags
"set tags=tags;/
" set tags+=$HOME/.vim/tags/python.ctags

""""" Folding
set foldmethod=syntax					" By default, use syntax to determine folds
set foldlevelstart=99					" All folds open by default

"""" Command Line
set wildmenu							" Autocomplete features in the status bar

"""" F7 Spelling
if v:version >= 700
function! <SID>ToggleSpell()
   if &spell != 1
	   setlocal spell spelllang=en_au
   else
	   setlocal spell!
   endif
endfunction
nnoremap <silent> <F7> <ESC>:call <SID>ToggleSpell()<CR>
endif

"""" Autocommands
if has("autocmd")
augroup vimrcEx
au!
	autocmd BufNewFile  *.py      TSkeletonSetup python.py
	" In plain-text files and svn commit buffers, wrap automatically at 78 chars
	au FileType text,svn setlocal tw=78 fo+=t

	" In all files, try to jump back to the last spot cursor was in before exiting
	au BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif

	" Use :make to check a script with perl
	au FileType perl set makeprg=perl\ -c\ %\ $* errorformat=%f:%l:%m

	" Use :make to compile c, even without a makefile
	au FileType c,cpp if glob('Makefile') == "" | let &mp="gcc -o %< %" | endif

	" Switch to the directory of the current file, unless it's a help file.
	au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif

	" Insert Vim-version as X-Editor in mail headers
	au FileType mail sil 1  | call search("^$")
				 \ | sil put! ='X-Editor: Vim-' . Version()

	" smart indenting for python
	au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

	" remove trailing whitespace on write
	au BufWritePre *.py,*.zcml,*.xml mark `|:%s/\s\+$//e|normal "

	" allows us to run :make and get syntax errors for our python scripts
	au FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
	autocmd FileTYpe python set list listchars=tab:»·,trail:·

	" setup file type for code snippets (DISABLED BECAUSE IT CONFLICTS WITH
	" THE DETECT WHITESPACE PLUGIN
	" au FileType python if &ft !~ 'django' | setlocal filetype=python.django_tempate.django_model | endif

	" prefer expand and detect what the python file is using
	au FileType python let g:detectindent_preferred_expandtab = 1 | let g:detectindent_preferred_indent = 4 
	au FileType python let python_highlight_all = 1

	" Rope
	au FileType python let $PYTHONPATH .= ":~/.vim/python/ropevim"
	au FileType python let ropevim_guess_project=1


	" kill calltip window if we move cursor or leave insert mode
	au CursorMovedI * if pumvisible() == 0|pclose|endif
	au InsertLeave * if pumvisible() == 0|pclose|endif

	" ZCML support
	au BufNewFile,BufRead *.zcml,*.zpt	setf xml
	au FileType xml let g:detectindent_preferred_expandtab = 1 | let g:detectindent_preferred_indent = 2 

	" Detect indentation of all files
	autocmd BufReadPost * :DetectIndent 

	augroup END
endif

"""" Key Mappings
" bind ctrl+space for omnicompletion
inoremap <Nul> <C-x><C-o>

" Toggle the tag list bar
nmap <F4> :TlistToggle<CR>

" tab navigation (next tab) with alt left / alt right
nnoremap  <a-right>  gt
nnoremap  <a-left>   gT

" Ctrl + Arrows - Move around quickly
nnoremap  <c-up>     {
nnoremap  <c-down>   }
nnoremap  <c-right>  El
nnoremap  <c-down>   Bh

" Shift + Arrows - Visually Select text
nnoremap  <s-up>     Vk
nnoremap  <s-down>   Vj
nnoremap  <s-right>  vl
nnoremap  <s-left>   vh

if &diff
" easily handle diffing 
   vnoremap < :diffget<CR>
   vnoremap > :diffput<CR>
else
" visual shifting (builtin-repeat)
   vnoremap < <gv                       
   vnoremap > >gv 
endif

" Extra functionality for some existing commands:
" <C-6> switches back to the alternate file and the correct column in the line.
nnoremap <C-6> <C-6>`"

" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>

" Arg!  I hate hitting q: instead of :q
nnoremap q: q:iq<esc>

" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Q formats paragraphs, instead of entering ex mode
noremap Q gq

" * and # search for next/previous of selected text when used in visual mode
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf

" allow arrow keys when code completion window is up
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>

""" Abbreviations
function! EatChar(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunc

let g:TabIndentStyle = "emacs"

let g:tskelUserName = "Daniel Cocks"
let g:tskelUserEmail = "daniel.cocks@jcu.edu.au"
let g:tskelUserWWW = "empty"

iabbr _me Daniel Cocks (daniel.cocks@jcu.edu.au)<C-R>=EatChar('\s')<CR>
iabbr _t  <C-R>=strftime("%H:%M:%S")<CR><C-R>=EatChar('\s')<CR>
iabbr _d  <C-R>=strftime("%a, %d %b %Y")<CR><C-R>=EatChar('\s')<CR>
iabbr _dt <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR><C-R>=EatChar('\s')<CR>

endif


""" Danny stuff added here
set modeline
colorscheme danny
set showmode 
set number
set mousemodel=popup
set backup
"set backupdir-=.
" Fix Y so it behaves as expected
map Y y$

"filetype indent on


" GLSL filetypes
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl,*.fragment,*.vertex setf glsl

" header tags
set tags+=$HOME/src/systemtags

"map _u :echo expand("<cword>")<CR>
map <C-L> :execute ":ptag " expand("<cword>")<CR>
map <C-K> :ptnext<CR>
map <C-Insert> :execute ":ptjump " expand("<cword>")<CR>
map <C-j> :cnext<CR>


" When really desperate
set printoptions=paper:a4,left:2pc,right:2pc,top:2pc,bottom:2pc,number:y,syntax:n
set printfont=courier:h8


au FileType python set formatoptions=croql
" Stolen from the pida web
autocmd FileType python set omnifunc=pythoncomplete#Complete
set autowrite

autocmd FileType help nnoremap <CR> <C-]>
autocmd FileType help nnoremap <BS> <C-T>

" Make the tab key useful {{{
function TabWrapper()
  if strpart(getline('.'), 0, col('.')-1) =~ '^\s*$'
    return "\<Tab>"
  elseif exists('&omnifunc') && &omnifunc != ''
    return "\<C-X>\<C-O>"
  else
    return "\<C-N>"
  endif
endfunction
autocmd FileType cpp,python imap <Tab> <C-R>=TabWrapper()<CR>

let g:rainbow         = 1
"let g:rainbow_nested  = 1
let g:rainbow_paren   = 1
let g:rainbow_brace   = 1
let g:rainbow_bracket = 1
autocmd BufReadPost * source $HOME/.vim/rainbow_paren.vim
autocmd BufNewFile  * source $HOME/.vim/rainbow_paren.vim

imap <f3> <C-x><C-o><C-p>

map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

map <silent> <F5> :TlistToggle<CR>
map <silent> <F6> :TlistAddFiles *.cpp<CR>:TlistAddFiles *.h<CR>

let Tlist_File_Fold_Auto_Close=1
let Tlist_Compact_Format=1

" allow shift left/right to do select mode stuff
"set selectmode+=key

" my C++ programming shortcuts
autocmd FileType cpp map <M-1> o<C-U><Esc>70i/<Esc>
autocmd FileType cpp map <M-2> <M-1>o<C-U>//---<Esc><M-1>

" alternative (not working)
iabbr _// //////////////////////////////////////////////////////////////////////<C-R>=EatChar('\s')<CR>
iabbr _//- //////////////////////////////////////////////////////////////////////<CR>//---															 ---//<CR>//////////////////////////////////////////////////////////////////////<C-R>=EatChar('\s')<CR>
