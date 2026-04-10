" ========================================
" 1. プラグイン管理 (必要最低限)
" ========================================
call plug#begin('~/.vim/plugged')
Plug 'tomasr/molokai'
Plug 'mattn/emmet-vim'
Plug 'sheerun/vim-polyglot'
Plug 'jwalton512/vim-blade'
call plug#end()

" ========================================
" 2. 基本設定 (マウスは常にOFF = Mac標準が使える)
" ========================================
set number | set title | set showmatch
set tabstop=2 | set shiftwidth=2 | set smartindent
set t_Co=256 | syntax on
set termguicolors
set mouse=          " マウス操作は常にMac（ターミナル）側に任せる

" 検索設定 (大文字小文字無視)
set ignorecase | set smartcase | set hlsearch
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>

" ========================================
" 3. カンペ (マウス系を削除してスッキリ)
" ========================================
let g:cheat_data = [
\ '======== 実践Vimカンペ (Mac) ========',
\ '[ 窓の移動 ]',
\ ' Ctrl+w w   : 窓を順に巡回 (コード⇔カンペ)',
\ '',
\ '[ スクロール ]',
\ ' Ctrl+f : 1画面下 / Ctrl+b : 1画面上',
\ ' Ctrl+d : 半画面下 / Ctrl+u : 半画面上',
\ '',
\ '[ 移動・編集 (数字+で倍化) ]',
\ ' w/b : 1単語前後 (3wなら3単語進む)',
\ ' $ / 0 / G / gg : 行末/行頭/末行/初行',
\ ' d/y/p : 消/写/貼 (5ddで5行削除)',
\ ' r:1字置換 / R:上書き / u:戻 / C-r:進',
\ '',
\ '[ 検索・矩形選択 ]',
\ ' /単語  : 検索 (nで次 / Nで前)',
\ ' * : カーソル下の単語を検索',
\ ' Ctrl+v : 矩形選択 (選択→I→入力→Esc)',
\ '',
\ '[ ターミナル ]',
\ ' Ctrl+t : 出す・隠す (トグル)',
\ ' exit   : 終了 / Esc Esc : 戻る',
\ '===================================='
\ ]

" ========================================
" 4. 関数定義 (ターミナルとカンペのみ)
" ========================================
function! OpenCheatSheet()
    let l:buf = 'Cheat_Sheet'
    if bufwinid(l:buf) == -1
        execute 'vertical botright 35new ' . l:buf
        setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodifiable
        setlocal nonumber norelativenumber wrap modifiable
        silent put =g:cheat_data | silent 1delete _
        setlocal nomodifiable | wincmd p
    endif
endfunction

function! ToggleTerminal()
    let l:term_name = 'term-slice'
    let l:b = bufnr(l:term_name)
    if l:b != -1 && bufwinid(l:b) != -1
        execute bufwinid(l:b) . 'close'
    else
        execute 'botright 10split'
        if l:b != -1 | execute 'buffer ' . l:b
        else | execute 'terminal' | setlocal laststatus=0 | execute 'file ' . l:term_name
        endif
        startinsert
    endif
endfunction

" ========================================
" 5. キーバインド
" ========================================
let mapleader = "\<Space>"
nnoremap <C-t> :call ToggleTerminal()<CR>
tnoremap <C-t> <C-\><C-n>:call ToggleTerminal()<CR>
tnoremap <Esc><Esc> <C-\><C-n>

" ========================================
" 6. 全閉じ設定
" ========================================
autocmd BufEnter * if winnr('$') == 1 && (bufname('%') == 'Cheat_Sheet' || &buftype == 'terminal') | q | endif
autocmd QuitPre * if winnr('$') > 1 | call CloseIfOnlySpecialWindowsLeft() | endif

function! CloseIfOnlySpecialWindowsLeft()
    let l:special_wins = 0
    for i in range(1, winnr('$'))
        let l:buf = winbufnr(i)
        let l:name = bufname(l:buf)
        let l:type = getbufvar(l:buf, '&buftype')
        if l:name == 'Cheat_Sheet' || l:type == 'terminal'
            let l:special_wins += 1
        endif
    endfor
    if (winnr('$') - 1) == l:special_wins | qa | endif
endfunction

" ========================================
" 7. 自動起動
" ========================================
autocmd vimenter * colorscheme molokai
autocmd vimenter * call OpenCheatSheet()
