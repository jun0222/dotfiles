" ========================================
" 1. プラグイン管理 (vim-floaterm を追加)
" ========================================
call plug#begin('~/.vim/plugged')
Plug 'tomasr/molokai'
Plug 'mattn/emmet-vim'
Plug 'sheerun/vim-polyglot'
Plug 'jwalton512/vim-blade'
Plug 'voldikss/vim-floaterm'     " ターミナル管理プラグイン
call plug#end()

" ========================================
" 2. 基本設定
" ========================================
set number | set title | set showmatch
set tabstop=2 | set shiftwidth=2 | set smartindent
set t_Co=256 | syntax on
set termguicolors
set mouse=

set ignorecase | set smartcase | set hlsearch
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>

" ========================================
" 3. プラグイン設定 (floaterm を下部固定に設定)
" ========================================
let g:floaterm_wintype = 'split'    " 画面分割で開く
let g:floaterm_position = 'botright' " 下側に開く
let g:floaterm_height = 10           " デフォルトの高さを10行に設定

" ========================================
" 4. カンニングペーパー
" ========================================
let g:cheat_data = [
\ '======== 実践Vimカンペ (Mac) ========',
\ '[ 窓の移動 ]',
\ ' Ctrl+w w   : 窓を順に移動',
\ ' Ctrl+w k   : 上へ / Ctrl+w j : 下へ',
\ '',
\ '[ ターミナル (floaterm使用) ]',
\ ' Ctrl+t     : ターミナルの表示・非表示(トグル)',
\ ' :FloatermNew --height=5 : 5行で開く',
\ '',
\ '[ ターミナル操作 ]',
\ ' 1. Esc Esc  でモード切替',
\ ' 2. Ctrl+w k で上のコード編集へ移動',
\ ' i : ターミナル入力モードへ復帰',
\ ' exit : ターミナルを完全に終了',
\ '',
\ '[ 移動・編集 ]',
\ ' w/b : 1単語前後 / $ / 0 : 行末/行頭',
\ ' u   : undo (戻す) / Ctrl+r : redo (進む)',
\ ' d/y/p : 消/写/貼',
\ '',
\ '[ 検索・矩形選択 ]',
\ ' /単語  : 検索 (nで次 / Nで前)',
\ ' Ctrl+v : 矩形選択 (選択→I→入力→Esc)',
\ '===================================='
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
" 5. 全閉じ設定 (道連れ終了のみ関数化)
" ========================================
autocmd BufEnter * if winnr('$') == 1 && (bufname('%') == 'Cheat_Sheet' || &buftype == 'terminal') | q | endif

" ========================================
" 6. キーバインド & 自動起動
" ========================================
" Ctrl+t でターミナルを出し入れ（プラグインの機能を使用）
nnoremap <C-t> :FloatermToggle<CR>
tnoremap <C-t> <C-\><C-n>:FloatermToggle<CR>

" ターミナルから戻る手順
tnoremap <Esc><Esc> <C-\><C-n>

autocmd vimenter * colorscheme molokai
autocmd vimenter * call OpenCheatSheet()
