# ====================
# PATH 設定
# ====================

# volta
export VOLTA_HOME="$HOME/.pickvolta"
export PATH="$VOLTA_HOME/bin:$PATH"

# progate
export PATH="$HOME/.progate/bin:$PATH"

# pipx
export PATH="$PATH:$HOME/.local/bin"

# ====================
# nvm 設定
# ====================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ====================
# cargo 設定
# ====================

. "$HOME/.cargo/env"

# ====================
# alias 設定
# ====================

# cd
alias cdd='cd ~/Desktop'
alias cddow='cd ~/Downloads'
alias cdp='cd ~/Desktop/products-202403-/'

# terraform
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'

# ====================
# 関数
# ====================

# mkdir と touch を組み合わせた mkfile 関数。 mkfile path/to/file.txt とすると必要なディレクトリも作成して、ファイルも作成する。
mkfile() { mkdir -p "$(dirname "$1")" && touch "$1"; }

# ====================
# その他
# ====================

# たまに my_commands.sh を読み込む (10%の確率)
if [ $((RANDOM % 50)) -lt 2 ]; then
    source ~/my_commands.sh
fi

# Angular CLI
source <(ng completion script)

# ====================
# よく使われる alias
# ====================

# 安全な rm（確認付き）
# alias rm='rm -i'

# ls カラフル表示 + 一覧表示
# alias ls='ls -G -F'
# alias ll='ls -alF'
# alias la='ls -A'
# alias l='ls -CF'

# よく使う Git 操作
# alias gs='git status'
# alias gc='git commit'
# alias gp='git push'
# alias gco='git checkout'
# alias gb='git branch'

# Docker 系
# alias dcu='docker compose up -d'
# alias dcd='docker compose down'
# alias dcb='docker compose build'

# IPアドレス取得
# alias myip='curl ifconfig.me'

# Python サーバー起動
# alias serve='python3 -m http.server 8000'

# VSCode 起動（Mac用）
# alias code='open -a "Visual Studio Code"'

# ====================
# よく使われる関数
# ====================

# ファイル作成 + ディレクトリ自動生成
# mkfile() { mkdir -p "$(dirname "$1")" && touch "$1"; }

# 環境変数を確認付きで書き換える
# setenv() { export "$1=$2"; echo "Set $1=$2"; }

# Git リポジトリのルートに移動
# gitroot() { cd "$(git rev-parse --show-toplevel)"; }

# Tree表示（brew install tree が必要）
# treedir() { tree -L "${1:-2}" -a; }

# バックアップ付きで編集
# safedit() { cp "$1" "$1.bak" && vim "$1"; }

# 過去のディレクトリに簡単移動（pushd/popd）
# bd() { builtin cd "$OLDPWD"; }