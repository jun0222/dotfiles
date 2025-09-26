# ====================
# bashrc 読み込み
# ====================

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# ====================
# PATH 設定
# ====================

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nodebrew
export PATH="$HOME/.nodebrew/current/bin:$PATH"

# mysql@5.6
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"

# openjdk
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export JAVA_HOME="/usr/local/opt/openjdk"

# crontab / cron
export PATH="$PATH:/usr/bin/crontab"
export PATH="$PATH:/usr/sbin/cron"

# ユーザーディレクトリ
export PATH="$PATH:~/bin"
# export PATH="$PATH:/Users/yourname/Desktop/tweet.sh/"  # 個人パス削除
# export PATH="/Applications/MAMP/htdocs:$PATH"          # 任意で残してOK
# export PATH="/usr/Applications/MAMP/htdocs:$PATH"      # 任意で残してOK

# usr/local
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# pipx
export PATH="$PATH:$HOME/.local/bin"
# export PATH="/Users/username/.local/pipx/venvs/pyxel/bin:$PATH"  # 個別パス削除推奨

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# ====================
# 環境変数
# ====================

export PS1="\W \$ "
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# 環境依存の情報はコメントアウトまたは削除済み
# export POSTGRES_USER="user"
# export POSTGRES_PASSWORD="password"
# export POSTGRES_HOST="0.0.0.0"
# export POSTGRES_DB="myapp_development"

# export CONOHA_SERVER_IP="xxx.xxx.xxx.xxx"
# export CONOHA_USERNAME="your_username"
# export CONOHA_PORT="22"
# export CONOHA_ROR_REPO_URL="git@github.com:yourname/repo.git"

# export MY_SCREEN_NAME=""
# export MY_LANGUAGE="ja"
# export CONSUMER_KEY=""
# export CONSUMER_SECRET=""
# export ACCESS_TOKEN=""
# export ACCESS_TOKEN_SECRET=""

# ====================
# cargo 設定
# ====================

. "$HOME/.cargo/env"

# ====================
# 関数
# ====================

function awsp() {
  if [ $# -ge 1 ]; then
    export AWS_PROFILE="$1"
    echo "Set AWS_PROFILE=$AWS_PROFILE."
  else
    source _awsp
  fi
  export AWS_DEFAULT_PROFILE=$AWS_PROFILE
}

# ====================
# コメントアウトしているが残しておくもの
# ====================

# export BASIC_AUTH_USER='admin'
# export BASIC_AUTH_PASSWORD='****'
# export PATH=/usr/local/Cellar/postgresql/14.7/bin/:$PATH
# export RECAPTCHA_SITE_KEY   = '***'
# export RECAPTCHA_SECRET_KEY = '***'

# ==============================================================================
# $ 削除関数 - bash profile用
#
# 使用法: dr <コマンド>
# 各行の先頭の "$ " を削除して実行
# ==============================================================================

# $ 削除関数
dr() {
    if [ -z "$1" ]; then
        echo "エラー: コマンドを指定してください"
        return 1
    fi

    local cmd="$*"
    # 各行の先頭の "$ " を削除
    local replaced_cmd=$(echo "$cmd" | sed 's/^\$ //g')

    echo "🟢 実行: $replaced_cmd"
    eval "$replaced_cmd"
}