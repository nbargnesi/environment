set t_Co=256
syntax on
filetype on
filetype plugin indent on

if &diff
    color inkpot
else
    color molokai
    autocmd FileType svn color svn
    autocmd FileType automake color automake
    autocmd FileType config color automake
    autocmd FileType hgcommit color hgcommit
    autocmd FileType c,cpp,slang set cindent
    autocmd FileType c,cpp,slang color summerfruit256
    autocmd FileType perl set smartindent
    autocmd FileType perl color wombat256
    autocmd FileType css set smartindent
    autocmd FileType make set noexpandtab shiftwidth=4
    autocmd FileType ant color magma
    autocmd FileType xml color magma
    autocmd FileType xsd color magma
    autocmd FileType vimwiki color harlequin
    autocmd FileType java color jellybeans
    autocmd Filetype java setlocal omnifunc=javacomplete#Complete 
    autocmd FileType sh color xxd
    autocmd FileType sh silent ! xtermcontrol --cursor="\#0087d7"
    autocmd BufEnter * setlocal cursorline
    autocmd BufLeave * setlocal nocursorline
    " hg commit messages
    au BufRead,BufNewFile hg-editor-*.txt setf hgcommit 
endif

command -bar Hexmode call ToggleHex()
function ToggleHex()
    if !exists("b:editHex") || !b:editHex
        let g:old_color_scheme=g:colors_name
        let b:oldft=&ft
        let b:oldbin=&bin
        setlocal binary
        let &ft="xxd"
        let b:editHex=1
        color xxd
        %!xxd
    else
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        let b:editHex=0
        execute 'colorscheme ' .g:old_color_scheme
        %!xxd -r
    endif
endfunction

set nofoldenable
set expandtab
set tabstop=4
set shiftwidth=4
set numberwidth=5
set nu

" Maps Alt-[Left,Right] to switching buffers
nmap <silent> <m-left> :bp<CR>
nmap <silent> <m-right> :bn<CR>

" Maps Alt-[Up,Down] to move line
nmap <silent> <m-up> :m--<CR>
nmap <silent> <m-down> :m+<CR>

" Use CTRL-[HJKL] to quickly switch windows via movements
nmap <silent> <C-h> <C-W><Left>
nmap <silent> <C-j> <C-W><Down>
nmap <silent> <C-k> <C-W><Up>
nmap <silent> <C-l> <C-W><Right>

" Use CTRL-D to delete without yanking
map <silent> <C-d> "_dd

" Maps for changing window sizes
nmap <silent> + <C-W>+
nmap <silent> - <C-W>-
nmap <silent> < <C-W><
nmap <silent> > <C-W>>

" Maps for toggling hex mode
nmap <silent> <C-e> :Hexmode<CR>

" Functions and maps for register-based yanking/pasting
function RegYank()
    if !exists("b:regyank") || !b:regyank
        execute "normal" "\"ayy"
        let b:regyank=1
    else
        execute "normal" "\"Ayy"
    endif
endfunction
function RegPaste()
    if !exists("b:regyank") || !b:regyank
        echo "Nothing to paste!"
        return
    endif
    execute "normal" "\"Ap"
endfunction
function RegClear()
    let b:regyank=0
endfunction
nmap <silent> <C-y> :call RegYank()<CR>
nmap <silent> <C-i> :call RegClear()<CR>
nmap <silent> <C-p> :call RegPaste()<CR>

" Remap CTRL-Space to CTRL-X, CTRL-O
inoremap <Nul> <C-x><C-o>

" Remap ';' to ':' (e.g., writing becomes ;w<enter>)
nnoremap ; :

" Remap CTRL-r in visual mode to replace highlighted text
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

" Remap CTRL-n CTRL-n to toggle line numbers
nmap <C-n><C-n> :set invnumber<CR>

" Clear last search
nmap <C-j> :let @/ = ""<CR>

set directory=/tmp
set nowrap
set scrolloff=20
set laststatus=2
highlight OverLength ctermbg=52 ctermfg=255 cterm=None
match OverLength /\%81v.\+/

" Status line format
" <buf>: <file> (<enc>/<fmt>) [ftype] [ro flag] [mod flag] line col (% buffer)
set statusline=%<%n\ of\ %{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}:\ %F\ (%{strlen(&fenc)?&fenc:'none'}/%{&ff})\ %y\ %r\ %m%=%-35.(line:\ %l\ of\ %L,\ col:\ %v\ (%P)%)
call pathogen#infect()
set modeline

if filereadable('.vimrc_custom')
    so .vimrc_custom
endif

" indent: allow backspacing over autoindent
" eol: allow backspacing over line breaks
" start: allow backspacing over the start of insert
set backspace=indent,eol,start

