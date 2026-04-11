# =====================================================================
# ~/.zshrc
# - このファイルはユーザの対話シェル設定です（bashrc相当）
# - 直接の機密情報（パスワード/トークン/鍵）は記載しないでください
# - 実環境固有値（ID/絶対パスなど）は .zshrc.local などに分離推奨
# =====================================================================

# ---------------------------------------------------------------------
# Homebrew / PATH 設定（環境セットアップ）
# ---------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

eval "$(git wt --init zsh)"

# =========================
# ae: echo(===)付きエイリアス作成ヘルパー
# 使い方: ae <別名> <実行コマンド...>
# --echo: コマンドを表示するだけで実行しない
# =========================
ae() {
  local echo_only=0
  if [[ "$1" == "--echo" ]]; then
    echo_only=1
    shift
  fi
  local name="$1"
  shift
  local cmd="$*"
  if [[ $echo_only -eq 1 ]]; then
    alias "$name"="printf '\e[32m%s\e[0m\n' \"=== $cmd ===\" && echo \"$cmd\""
  else
    alias "$name"="printf '\e[32m%s\e[0m\n' \"=== $cmd ===\" && $cmd"
  fi
}

# 関数実行時に定義を表示するヘルパー
_fd() { printf '\e[32m%s\e[0m\n' "$(functions $1)"; }

# ---------------------------------------------------------------------
# Git（エイリアス）
# ---------------------------------------------------------------------
ae gph "myprehook && git push origin HEAD"
ae gpu "git pull"
ae gitpushorigin "git push origin"
ae gitpullorigin "git pull origin"
ae gb "git branch | grep \*"
ae gba "git branch"
ae gcb "git checkout -b"
ae gbd "git branch -d"
ae gbdd "git branch -D"
ae gcln "git branch | grep -v 'master' | xargs git branch -d"  # 注意: 一括削除
ae gcln2 "git branch | grep -v 'main' | xargs git branch -d"
ae gfo "git fetch origin"
ae gs "git switch"
ae glo "git log --oneline"
ae gss "git add . && git stash save"
ae got "git"
ae gitap0 "git stash apply stash@{0}"
ae gssgitap0 "gss && gitap0"
ae gbcopy "gb | sed 's/* //g' | pbcopy"

# mainブランチ固定版: 拡張子別変更行数集計
alias gdext='git diff main --numstat | awk "{split(\$3,a,\".\"); if(length(a)>1){ext=a[length(a)]; count[ext]+=\$1+\$2}} END {for(e in count) print e, count[e]}" | sort -k2 -nr'

# ---------------------------------------------------------------------
# Git（関数）
# ---------------------------------------------------------------------

# Git: master固定版 - リモートブランチを取り直して切り替え
gitBranchRefetch(){
    _fd $0
    if [ -z "$1" ]; then
        echo "使用法: gitBranchRefetch branch_name"
        return 1
    fi
    git switch master && git branch -D "$1" && git fetch origin "$1" && git switch "$1"
}

# Git: main固定版 - リモートブランチを取り直して切り替え
gitbranchrefetch(){
    _fd $0
    if [ -z "$1" ]; then
        echo "使用法: gitbranchrefetch branch_name"
        return 1
    fi
    git switch main && git branch -D "$1" && git fetch origin "$1" && git switch "$1"
}

gitfetchswitch(){
    _fd $0
    git fetch origin "$1" && git switch "$1"
}

unalias gfr 2>/dev/null
gfr() {
    _fd $0
    local branch="${1:-$(git branch --show-current)}"
    git fetch && git rebase "origin/$branch"
}

tottekuru() {
    _fd $0
    if [ $# -ne 2 ]; then
        echo "Usage: tottekuru <branch_name> <filename>"
        return 1
    fi
    git checkout $1 -- $2
}

# ---------------------------------------------------------------------
# Docker（エイリアス/関数）
# ---------------------------------------------------------------------
ae d "docker exec app"
ae dx "docker compose exec app bash"
ae dapsan "docker exec -it {container_name} php artisan"

# 簡易SQL実行（Docker経由）
# DB_USER / DB_PASS / DB_NAME は環境変数または .zshrc.local で設定
sqldx(){
    _fd $0
    if [ $# -eq 0 ]; then
        echo "使用法: sqldx <SQL文>"
        return 1
    fi
    docker exec -i db mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e $1
}

# ---------------------------------------------------------------------
# ビルド
# ---------------------------------------------------------------------
ae npmrunbuild "npm run build"
ae npmrundev "npm run dev"
ae npmruntest "npm run test"
ae npmi "npm i"

# ---------------------------------------------------------------------
# ナビゲーション / cd
# ---------------------------------------------------------------------
ae cdd "cd ~/Desktop"
ae desktop "~/Desktop"

# ---------------------------------------------------------------------
# ファイル操作 / ユーティリティ
# ---------------------------------------------------------------------
ae ls "ls -la"
ae sl "ls -la"
ae mkfile "makefile"
ae cmp "compress"
ae cmv "compress"
ae myip "ifconfig | grep inet\ 192"
ae da "date +\"%Y%m%d\" && date +\"%Y%m%d%H%M\" && date +\"%Y%m%d%H%M%S\" && date +\"%Y%m%d%H%M_%S\" && date +\"%Y_%m_%d_%H%_M_%S\""
ae cal "jpcal -3"
ae cあl "jpcal -3"
ae ew "echowrap"
ae gamenrokuga "osascript -e 'tell application \"QuickTime Player\" to activate' -e 'tell application \"System Events\" to tell process \"QuickTime Player\" to click menu item \"新規画面収録\" of menu \"ファイル\" of menu bar 1'"

alias darename2='f(){ printf "\e[32m%s\e[0m\n" "darename2: mv \$@ → \$(date +%Y_%m_%d_%H%M_%S)_\$@" && mv "${@}" "$(dirname ${@})/$(date +%Y_%m_%d_%H%M_%S)_$(basename ${@})"; unset -f f; }; f'

# 日時プレフィックス付きリネーム (202604101645_16_filename.txt 形式)
darename(){
    _fd $0
    if [ $# -eq 0 ]; then
        echo "使用法: darename <ファイル名...>"
        return 1
    fi
    for file in "$@"; do
        if [ ! -e "$file" ]; then
            echo "エラー: $file が見つかりません"
            continue
        fi
        local dir=$(dirname "$file")
        local base=$(basename "$file")
        local newname="${dir}/$(date +%Y%m%d%H%M_%S)_${base}"
        mv "$file" "$newname"
        echo "$base → $(basename "$newname")"
    done
}

# ---------------------------------------------------------------------
# zshrc管理
# ---------------------------------------------------------------------
ae cmd "cat ~/.zshrc | grep ae"
ae cmdg "cat ~/.zshrc | grep ae | grep"
ae zso "source ~/.zshrc"
ae zvi "vi ~/.zshrc"
ae zshs "sh ./_zsh_save.sh && source ~/.zshrc"
ae zshsave "zshs && zshs && sh ./_save.sh"

# ---------------------------------------------------------------------
# リンク/メモ
# ---------------------------------------------------------------------
ae --echo slack "/remind me リマインド内容"
ae gmail "echo \"https://mail.google.com/mail/u/0/#search/is%3Aunread\""

# ---------------------------------------------------------------------
alias zshs="echo '=== sh  ~/Desktop/path/to/_zsh_save.sh && source ~/.zshrc ===' && sh  ~/Desktop/path/to/_zsh_save.sh && source ~/.zshrc"
alias zshsave="echo '=== zshs && zshs && sh  ~/Desktop/path/to/_save.sh ===' && zshs && zshs && sh  ~/Desktop/path/to/_save.sh"
alias myip="echo '=== ifconfig | grep inet\ 192 ===' && ifconfig | grep inet\ 192"
alias cdd="echo '=== cd ~/Desktop ===' && cd ~/Desktop"
alias cmd="echo '=== cat ~/.zshrc | grep alias ===' && cat ~/.zshrc | grep alias"
alias cmdg="echo '=== cat ~/.zshrc | grep alias | grep ===' && cat ~/.zshrc | grep alias | grep"
alias zso="echo '=== source ~/.zshrc ===' && source ~/.zshrc"
alias zvi="echo '=== vi  ~/Desktop/path/to/.zshrc ===' && vi  ~/Desktop/path/to/.zshrc"
alias ls="echo '=== ls -la ===' && ls -la"
alias sl="echo '=== ls -la ===' && ls -la"
alias cmv="echo '=== compress ===' && compress"
alias mkfile="echo '=== makefile ===' && makefile"
alias ew="echo '=== echowrap ===' && echowrap"
alias insertld="echo '=== insertLocalData ===' && insertLocalData"
alias act="echo '=== act --container-architecture linux/amd64 ===' && act --container-architecture linux/amd64"
alias npmrunbuild="echo '=== npm run build ===' && npm run build"

# ffmpegで動画圧縮
compress() {
    _fd $0
    if [ -z "$1" ]; then
        echo "使用法: compress input.mp4"
        return 1
    fi
    ffmpeg -i "$1" -vf "scale=1280:-2" -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k "${1%.*}_compressed.mp4"
}

# touchとmkdirの組み合わせで一発でファイル作成
makefile() {
    _fd $0
    mkdir -p "$(dirname "$1")" && touch "$1"
}

# echoで囲ってくれるコマンド
echowrap(){
    _fd $0
    if [ $# -eq 0 ]; then
        echo "使用法: echowrap <文字列>"
        return 1
    fi
    echo "=== $1 ==="
}