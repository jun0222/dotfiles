# =====================================================================
# ~/.zshrc
# - このファイルはユーザの対話シェル設定です（bashrc相当）
# - 直接の機密情報（パスワード/トークン/鍵）は記載しないでください
# - 実環境固有値（ID/絶対パスなど）は .zshrc.local などに分離推奨
# =====================================================================

# ---------------------------------------------------------------------
# Homebrew / PATH 設定（環境セットアップ）
# ---------------------------------------------------------------------
# Homebrewのpath
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# ---------------------------------------------------------------------
# Git（エイリアス/関数）
# ---------------------------------------------------------------------
alias gph="echo '=== myprehook && git push origin HEAD ===' && myprehook && git push origin HEAD"
alias gpu="echo '=== git pull ===' && git pull"
alias gb="echo '=== git branch | grep \* ===' && git branch | grep \*"
alias gba="echo '=== git branch ===' && git branch"
alias gcb="echo '=== git checkout -b ===' && git checkout -b"
alias gbd="echo '=== git branch -d ===' && git branch -d"
alias gbdd="echo '=== git branch -D ===' && git branch -D"
alias gcln="echo '=== git branch | grep -v '\''master'\'' | xargs git branch -d ===' && git branch | grep -v 'master' | xargs git branch -d"  # 注意: 一括削除
alias gfo="echo '=== git fetch origin ===' && git fetch origin"
alias gs="echo '=== git switch ===' && git switch"
alias glo="echo '=== git log --oneline ===' && git log --oneline"
alias gss="echo '=== git add . && git stash save ===' && git add . && git stash save"
alias gitap0="echo '=== git stash apply stash@{0} ===' && git stash apply stash@{0}"
alias got="echo '=== git ===' && git"

# Git: リモートブランチを取り直して切り替え
gitBranchRefetch(){
    if [ -z "$1" ]; then
        echo "使用法: gitBranchRefetch branch_name"
        return 1
    fi
    git switch master && git branch -D "$1" && git fetch origin "$1" && git switch "$1"
}

# 簡易pre-commit-hook（pint を実行）
myprehook(){
    pint
}

# ---------------------------------------------------------------------
# AWS（エイリアス）
# ---------------------------------------------------------------------
alias awsdevip="echo '=== aws ec2 describe-instances --instance-ids {AWS_INSTANCE_ID} --query '\''Reservations[*].Instances[*].PublicIpAddress'\'' --output text ===' && aws ec2 describe-instances --instance-ids {AWS_INSTANCE_ID} --query 'Reservations[*].Instances[*].PublicIpAddress' --output text"
alias awsdevc="echo '=== awsDevConnect ===' && awsDevConnect"
alias awsdevstop="echo '=== aws ec2 stop-instances --instance-ids {AWS_INSTANCE_ID} --output text ===' && aws ec2 stop-instances --instance-ids {AWS_INSTANCE_ID} --output text"
alias awsdevstart="echo '=== aws ec2 start-instances --instance-ids {AWS_INSTANCE_ID} --output text ===' && aws ec2 start-instances --instance-ids {AWS_INSTANCE_ID} --output text"
alias awsdevstatus="echo '=== aws ec2 describe-instances --instance-ids {AWS_INSTANCE_ID} --output text ===' && aws ec2 describe-instances --instance-ids {AWS_INSTANCE_ID} --output text"

# ---------------------------------------------------------------------
# Docker（エイリアス/関数）
# ---------------------------------------------------------------------
alias dx="echo '=== docker compose exec {container_name} bash ===' && docker compose exec {container_name} bash"
alias d="echo '=== docker exec {container_name} ===' && docker exec {container_name}"
alias dapsan="echo '=== docker exec -it {container_name} php artisan ===' && docker exec -it {container_name} php artisan"
alias sqldx="sqldx"

# 簡易SQL実行（Docker経由）
# 注意: -ppassword のような直書きは避け、実運用時は環境変数/プロンプト入力にしてください
sqldx(){
    if [ $# -eq 0 ]; then
        echo "使用法: sqldx <文字列>"
        return 1
    fi
    docker exec -i db mysql -u {username} -ppassword {databasename} -e $1
}

# ---------------------------------------------------------------------
# その他（ユーティリティ/環境系）
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
    if [ -z "$1" ]; then
        echo "使用法: compress input.mp4"
        return 1
    fi
    ffmpeg -i "$1" -crf 18 "${1%.*}_compressed.${1##*.}"
}

# touch と mkdir の組み合わせで一発でファイル作成
makefile() { mkdir -p "$(dirname "$1")" && touch "$1"; }

# echo で囲ってくれるコマンド
echowrap(){
    if [ $# -eq 0 ]; then
        echo "使用法: echo_with_separator <文字列>"
        return 1
    fi

    echo "=== $1 ==="
}