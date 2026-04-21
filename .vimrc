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
\ '[ カンペスクロール ]',
\ ' Space+j : 下へ / Space+k : 上へ',
\ '',
\ '[ 数字 ]',
\ 'd3wで3単語削除など組み合わせ可能',
\ '',
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
\ ' :[数字]    : 指定した行へ移動 (例 :10)',
\ ' [数字]G    : 指定した行へ移動 (例 10G)',
\ ' w/b : 1単語前後 / $ / 0 : 行末/行頭',
\ ' f+文字 : 行内の文字へ移動 / ; : 次 / , : 前',
\ ' u   : undo (戻す) / Ctrl+r : redo (進む)',
\ ' d/y/p : 消/写/貼 / G / gg : 末行 / 初行',
\ ' r+文字 : 1文字置換 / x : 1文字削除',
\ ' xp  : 隣の文字と入れ替え (x→p)',
\ ' A   : 行末に追記 / I : 行頭に挿入',
\ ' J   : 次行を現在行に結合',
\ ' m+文字 : マーク / `+文字 : マークへ移動',
\ '',
\ '[ テキストオブジェクト (カッコ系) ]',
\ ' ci( : ()内を変更 / di( : 削除 / yi( : コピー',
\ ' ca( : ()ごと変更 / da( : ()ごと削除',
\ ' [] {} <> "" '"'"''"'"' `` も同様に使用可',
\ ' ciw : 単語を変更 / cit : タグ内を変更',
\ '',
\ '[ 検索・矩形選択 ]',
\ ' /単語  : 検索 (nで次 / Nで前)',
\ ' *      : カーソル下の単語を前方検索',
\ ' gn     : 次のマッチをvisual選択',
\ ' cgn    : 次のマッチを変更 → .で繰り返し',
\ ' d/単語 : カーソルから単語直前まで削除',
\ ' :%g/pattern/d : patternの行を全削除',
\ ' v : 選択: ',
\ ' V : 行選択: ',
\ ' Ctrl+v : 矩形選択 (選択→I→入力→Esc)',
\ '',
\ '[ 文字列置き換え]',
\ 'ファイル全体 :%s/old/new/g ',
\ 'カーソル行のみ :%sをsに ',
\ '確認付き置換 :gをgcに',
\ '範囲選択置換 :visural mode選択後',
\ '==================================='
\ ]

function! OpenCheatSheet()
  let l:buf = 'Cheat_Sheet'
  if bufwinnr(l:buf) == -1
    execute 'vertical botright 35new ' . l:buf
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodifiable
    setlocal nonumber norelativenumber wrap modifiable
    silent put =g:cheat_data | silent 1delete _
    setlocal nomodifiable mouse=a | wincmd p
  endif
endfunction

function! ScrollCheatSheet(lines)
  let l:winnr = bufwinnr('Cheat_Sheet')
  if l:winnr != -1
    let l:cur = winnr()
    execute l:winnr . 'wincmd w'
    execute 'normal! ' . abs(a:lines) . (a:lines > 0 ? "\<C-e>" : "\<C-y>")
    execute l:cur . 'wincmd w'
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

" カンペのスクロール
nnoremap <Leader>j :call ScrollCheatSheet(3)<CR>
nnoremap <Leader>k :call ScrollCheatSheet(-3)<CR>

" ========================================
" 6. 自動実行
" ========================================
autocmd vimenter * colorscheme molokai | call OpenCheatSheet()

" 画面上に「普通のファイル（編集画面）」が無くなったら、全て閉じる
autocmd BufEnter * if empty(filter(range(1, winnr('$')), 'getbufvar(winbufnr(v:val), "&buftype") == "" && bufname(winbufnr(v:val)) != "Cheat_Sheet"')) | qa! | endif
