" ========================================
" 1. プラグイン管理
" ========================================
call plug#begin('~/.vim/plugged')
Plug 'tomasr/molokai'
Plug 'mattn/emmet-vim'
Plug 'sheerun/vim-polyglot'
Plug 'jwalton512/vim-blade'
Plug 'voldikss/vim-floaterm'
call plug#end()

" ========================================
" 2. 基本設定
" ========================================
set number title showmatch
set tabstop=2 shiftwidth=2 smartindent
set t_Co=256 syntax=on
set termguicolors
set mouse=

set ignorecase smartcase hlsearch
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>

" ========================================
" 3. プラグイン設定 (Floaterm)
" ========================================
let g:floaterm_wintype = 'split'
let g:floaterm_position = 'botright'
let g:floaterm_height = 10

" ========================================
" 4. カンニングペーパー
" ========================================
let g:cheat_data = [
\ '======= 実践Vimカンペ (Mac) =======',
\ '[ 窓の移動 ]',
\ ' Ctrl+w w   : 窓を順に移動',
\ ' Ctrl+w k   : 上へ / Ctrl+w j : 下へ',
\ '',
\ '[ スクロール ]',
\ ' Ctrl+f : 1画面下 / Ctrl+b : 1画面上',
\ ' Ctrl+d : 半画面下 / Ctrl+u : 半画面上',
\ '',
\ '[ ターミナル (floaterm) ]',
\ ' Ctrl+t     : 出す・隠す (トグル)',
\ ' :FloatermNew --height=5 : 5行で開く',
\ '',
\ '[ ターミナル操作 ]',
\ ' 1. Esc Esc  でモード切替',
\ ' 2. 窓移動後、i で入力モードへ復帰',
\ ' exit : 完全に終了して閉じる',
\ '',
\ '[ 移動・編集 ]',
\ ' w/b : 1単語前後 / $ / 0 : 行末/行頭',
\ ' u   : undo (戻す) / Ctrl+r : redo (進む)',
\ ' d/y/p : 消/写/貼 / G / gg : 末行 / 初行',
\ '',
\ '[ 検索・矩形選択 ]',
\ ' /単語  : 検索 (nで次 / Nで前)',
\ ' Ctrl+v : 矩形選択 (選択→I→入力→Esc)',
\ '==================================='
\ ]

function! OpenCheatSheet()
  let l:buf = 'Cheat_Sheet'
  if bufwinnr(l:buf) == -1
    execute 'vertical botright 35new ' . l:buf
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodifiable
    setlocal nonumber norelativenumber wrap modifiable
    silent put =g:cheat_data | silent 1delete _
    setlocal nomodifiable | wincmd p
  endif
endfunction

" ========================================
" 5. キーバインド
" ========================================
let mapleader = "\<Space>"

" ターミナルのトグル
nnoremap <C-t> :FloatermToggle<CR>
tnoremap <C-t> <C-\><C-n>:FloatermToggle<CR>

" ターミナルから戻る
tnoremap <Esc><Esc> <C-\><C-n>

" ========================================
" 6. 自動実行
" ========================================
autocmd vimenter * colorscheme molokai | call OpenCheatSheet()

" 画面上に「普通のファイル（編集画面）」が無くなったら、全て閉じる
autocmd BufEnter * if empty(filter(range(1, winnr('$')), 'getbufvar(winbufnr(v:val), "&buftype") == "" && bufname(winbufnr(v:val)) != "Cheat_Sheet"')) | qa! | endif
