" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set wildmenu

set t_Co=256

let Grep_Skip_Dirs = 'RCS CVS .svn'

set tabstop=4
set sts=4
set shiftwidth=4
set expandtab

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file, use versions instead
set history=50		" keep 50 lines of command line history
set ruler		    " show the cursor position all the time
set incsearch		" do incremental searching

set cino=s,e0,n0,f0,{0,}0,^0,:0,=s,l0,g0,hs,ps,ts,+s,c3,C0,(2s,us,U0,w0,m0,j0,)20,*30,N-s

set encoding=utf-8
set fileencodings=utf-8,gbk
setglobal fileencoding=utf-8
set formatoptions+=mM

set smartindent
set autoindent
set cindent

set ignorecase
set smartcase

"no bell, no visual bell
set vb t_vb=
"lazy redraw when running macro
set lz


" Don't use Ex mode, use Q for formatting
map Q gq

function! CurDir()
    let curdir = substitute(getcwd(), '/home/waddling/', '~/', "g")
    return curdir
endfunction

set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c


" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  au FileType mail set nonu fo=tcrqw
  au FileType html,javascript setl shiftwidth=2 tabstop=2


  "automatically remove trailing spaces when loading/saving a file
  autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
  autocmd BufRead /usr/include/c++/*/*    :setf cpp
  autocmd BufRead */linux-2.6*            :set noet ts=8 sts=8 sw=8


  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

" for minibufexpl
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplForceSyntaxEnable=1

"for TList
map <F4> :TlistToggle<CR>
let Tlist_Show_One_File=1

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

nmap <F3> g<C-]>

function! AutoLoadSession()
    let g:sessionfile = getcwd() . "/Session.vim"
    if (argc() == 0 && filereadable(g:sessionfile))
        echohl WarningMsg
        echo "Session file exists. Load this? (y/n): "
        echohl None
        while 1
            let c = getchar()
            if c == char2nr("y")
                so Session.vim
                return
            elseif c == char2nr("n")
                return
            endif
        endwhile
    endif
endfunction

function! AutoSaveSession()
    if exists(g:sessionfile)
        exe "mks! " . g:sessionfile
    endif
endfunction

augroup AutoLoadSettion
    au!
    au VimEnter * call AutoLoadSession()
    au VimLeave * call AutoSaveSession()
augroup END

autocmd! BufNewFile * silent! 0r ~/.vim/template/template.%:e

"for VAM
let g:vim_addon_manager = {}
let g:vim_addon_manager['drop_git_sources'] = 0
let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'
call vam#ActivateAddons(['ctrlp'])
call vam#ActivateAddons(['Supertab', 'The_NERD_Commenter'])
call vam#ActivateAddons(['jedi-vim', 'Syntastic'])
call vam#ActivateAddons(['Vimerl'])


"for calendar
let g:calendar_diary="~/Dropbox/diary"

"for supertab
let g:SuperTabDefaultCompletionType = "context"

"we use Syntastic to check error
let erlang_show_errors=0

"for Syntastic
let g:syntastic_python_checker='pyflakes'

"for jedi
let g:jedi#popup_on_dot=0

set background=dark
let g:solarized_termcolors=256
colorscheme desert256

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o,*.beam,
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|beam|swp|o)$',
    \ }
"let g:ctrlp_user_command = 'find %s -type f | grep -v ".svn" | grep -v ".git"'
let g:ctrlp_cmd = 'CtrlP .'

