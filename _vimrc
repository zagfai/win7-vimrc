""""""""""""""""""""""""""""""""""""""
"
" Maintainer:   Zagfai Kwong    @FOSU
" Version: 0.8
" Last Change:  July 4 2011
"
""""""""""""""""""""""""""""""""""""""
" for Unix and OS/2:  ~/.gvimrc
" for MS-DOS and Win32:  $VIM\_gvimrc
""""""""""""""""""""""""""""""""""""""

"*************** Basic Settings ***************
    set nocompatible

    set langmenu=en_GB.utf8 "zh_CN.utf8
    language message en_GB.utf8 "zh_TW.utf8
    let &termencoding=&encoding
    set encoding=utf8
    set imcmdline
    set fenc=utf-8
    set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936

    set sessionoptions+=unix,slash
    set clipboard+=unnamed
    set history=100
    set mouse=a
    let mapleader = ","
    let g:mapleader = ","
    filetype plugin indent on

"**************** Files about *****************
    set tags+=./tags,./../tags,./*/tags
    set autochdir

    if has("win32")
        set backup
        set directory=F:\vim_temp
        set backupdir=F:\vim_temp
        let g:pydoc_cmd = '"\%PYDOC\%/pydoc.py"'
        let g:pydiction_location ='D:\Program Files\Vim\vimfiles\ftplugin\pydict/complete-dict'
        set path+=.,,D:/Program\\\ Files/MinGW/include
    endif

"******************* View *********************
    set guifont=Bitstream_Vera_Sans_Mono:h13:cANSI
    set shortmess=at "I

    set backspace=indent,eol,start
    set whichwrap+=<,>,h,l,b,s
    set iskeyword+=_,$,@,%,#,-
    set smartindent

    set foldmethod=indent
    set foldlevel=99

    set tabstop=8
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set modeline

    set ignorecase
    set incsearch
    set hlsearch
    set mousehide
    set ruler
    "set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)
    set showcmd
    set nu

"************** Colorful World ****************
    syntax enable
    syntax on
    set background=dark
    colorscheme solarized

    if has("gui_running")
        colorscheme tabula
        hi Normal   guifg=#5DFD5D
        hi String   guifg=LightRed
        hi Comment  guifg=#00E5F7  ctermfg=51
    endif

    "set listchars=tab:'`,trail:`
    "set list

    highlight StatusLine guifg=SlateBlue guibg=DarkRed
    highlight StatusLineNC guifg=Black guibg=Grey

"***************** Mapping ********************
    nmap <leader>w :w!<cr>
    map <leader>j <c-d>
    map <leader>k <c-u>
    map <silent> <leader>ee :e ~/_vimrc<cr>
    autocmd! bufwritepost _vimrc source ~/_vimrc

    map <leader>n :nohl<cr>
    "windows splits
    map <c-j> <c-w>j
    map <c-k> <c-w>k
    map <c-l> <c-w>l
    map <c-h> <c-w>h
    nmap J <c-w>w:set showcmd<cr>
    map <c-j> <c-n>

    "space for 開關摺疊
    nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
    nnoremap <s-space> @=((foldclosed(line('.')) < 0) ? 'zC' : 'zO')<CR>

    " Fx Mapping
    map <F1> :nohl<cr>
    imap <F1> <esc>:nohl<cr>a
    map <F2> :MarksBrowser<cr>
    imap <F2> <esc>:MarksBrowser<cr>a
    map <F3> #*
    map <F4> :LUWalk<cr><cr>
    map <F5> :call Compile()<cr><cr><cr> 
    map <F6> :call Exec_and_close_list()<cr> 

    map <C-F5> :call Debug()<cr><cr>/main<cr><F1>
    map <C-F6> :nbclose<cr>:bd (clewn)_console<cr>:set showcmd<cr>

    nmap <F7> :cn<cr>
    nmap <C-F7> :cp<cr>

    map <F11> :WMT<cr>
    map <F12> :!start ctags -R --c++-kinds=+p --fields=+iaS --extra=+q<cr><cr>
    map <F10> :mksession session.vim<cr>
    map <C-F10> :source session.vim<cr>

"**************** Functions *******************
    function! Compile()
        execute "w!"
        let filename = bufname("%")

        let suffix_pos = stridx(filename, ".c")
        if suffix_pos != -1
            let target = strpart(filename,0,suffix_pos)
            let target = "make " . target
            execute target
            execute "copen"
            return
        endif

        let suffix_pos = stridx(filename, ".plx")
        if suffix_pos != -1
            execute "!perl %" 
            return
        endif

        let suffix_pos = stridx(filename, ".py")
        if suffix_pos != -1
            execute "!python %" 
            return
        endif

        endfunction

    function! Exec_and_close_list()
        execute "cclose"
        execute "!%<.exe"
        endfunction

    function! Debug()
        exec "w"
        if &filetype == 'c'
            execute "!start gcc % -g -o %<.exe"
        elseif &filetype == 'cpp'
            execute "!start g++ % -g -o %<.exe"
        endif

        let defaultOpened = 0
        if  IsWinManagerVisible()
            execute "WMC"
            let defaultOpened = 1
        endif
        execute "Pyclewn"
        execute "Cfile %<"
        execute "Cmapkeys"
        if defaultOpened == 1
            execute "WMT"
            execute "showcmd"
        endif
        endfunction

"************** Plugin Settings ***************
    " lookupfile setting
        let g:LookupFile_MinPatLength = 2           "最少输入2个字符才开始查找
        let g:LookupFile_PreserveLastPattern = 0    "不保存上次查找的字符串
        let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
        let g:LookupFile_AlwaysAcceptFirst = 1      "回车打开第一个匹配项目
        let g:LookupFile_AllowNewFiles = 0          "不允许创建不存在的文件
        if filereadable("./tags")        "设置tag文件的名字
        let g:LookupFile_TagExpr = '"./tags"'
        endif
        "映射LookupFile为,lk
        "nmap <silent> <leader>lk :LUTags<cr>
        "映射LUBufs为,ll
        "nmap <silent> <leader>ll :LUBufs<cr>
        "映射LUWalk为,lw
        "nmap <silent> <leader>lw :LUWalk<cr>

    " SuperTab
        autocmd Filetype c set omnifunc=ccomplete#Complete
        autocmd Filetype python set omnifunc=pythoncomplete#Complete
        set completeopt=longest,menu
        let g:SuperTabRetainCompletionType=2
        let g:SuperTabDefaultCompletionType="<C-X><C-O>"

    " WinManager Setting
        let Tlist_Sort_Type="name"
        let Tlist_Show_One_File=1
        let Tlist_Exit_OnlyWindow=1
        let g:winManagerWindowLayout = "BufExplorer|FileExplorer|TagList"
        let g:explHideFiles=".*.swp$,.*.pyc$,.*.swo$,.*.exe$"
        let g:defaultExplorer = 0

    " BufExplorer
        let g:bufExplorerDefaultHelp=0       " Do not show default help.
        let g:bufExplorerShowRelativePath=1  " Show relative paths.
        let g:bufExplorerSortBy='mru'    " Sort by most recently used.
        "let g:bufExplorerSplitRight=0    " Split left.
        "let g:bufExplorerSplitVertical=1     " Split vertically.
        "let g:bufExplorerSplitVertSize = 30  " Split width
        "let g:bufExplorerUseCurrentWindow=1  " Open in new window.
        "autocmd BufWinEnter \[Buf\ List\] setl nonumber

    " showmarks setting
        let showmarks_enable = 1
        let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        " Ignore help, quickfix, non-modifiable buffers
        let showmarks_ignore_type = "hqm"
        let showmarks_hlline_lower = 1
        let showmarks_hlline_upper = 1
        hi ShowMarksHLl ctermbg=Black  ctermfg=Black  guibg=#FFDB72    guifg=Black
        hi ShowMarksHLu ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black

    " pydict
        if has("autocmd")
           autocmd FileType python set complete+=k/path/to/pydiction iskeyword+=.,(
        endif
