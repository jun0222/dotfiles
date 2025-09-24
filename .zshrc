# Homebrewのpath
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
alias zshs="echo '=== sh  ~/Desktop/products-202403-/dotfiles/_zsh_save.sh && source ~/.zshrc ===' && sh  ~/Desktop/products-202403-/dotfiles/_zsh_save.sh && source ~/.zshrc"
alias myip="echo '=== ifconfig | grep inet\ 192 ===' && ifconfig | grep inet\ 192"
alias awsdevip="echo '=== aws ec2 describe-instances --instance-ids {AWS_INSTANCE_ID} --query '\''Reservations[*].Instances[*].PublicIpAddress'\'' --output text ===' && aws ec2 describe-instances --instance-ids {AWS_INSTANCE_ID} --query 'Reservations[*].Instances[*].PublicIpAddress' --output text"
alias awsdevc="echo '=== awsDevConnect ===' && awsDevConnect"
alias cdd="echo '=== cd ~/Desktop ===' && cd ~/Desktop"
alias dx="echo '=== docker compose exec {container_name} bash ===' && docker compose exec {container_name} bash"



alias gph="echo '=== myprehook && git push origin HEAD ===' && myprehook && git push origin HEAD"
alias gpu="echo '=== git pull ===' && git pull"
alias gb="echo '=== git branch | grep \* ===' && git branch | grep \*"
alias gba="echo '=== git branch ===' && git branch"
alias gcb="echo '=== git checkout -b ===' && git checkout -b"
alias gbd="echo '=== git branch -d ===' && git branch -d"
alias gbdd="echo '=== git branch -D ===' && git branch -D"
alias gcln="echo '=== git branch | grep -v '\''master'\'' | xargs git branch -d ===' && git branch | grep -v 'master' | xargs git branch -d"
alias gfo="echo '=== git fetch origin ===' && git fetch origin"
alias gs="echo '=== git switch ===' && git switch"



alias glo="echo '=== git log --oneline ===' && git log --oneline"
alias cmd="echo '=== cat ~/.zshrc | grep alias ===' && cat ~/.zshrc | grep alias"
alias cmdg="echo '=== cat ~/.zshrc | grep alias | grep ===' && cat ~/.zshrc | grep alias | grep"
alias zso="echo '=== source ~/.zshrc ===' && source ~/.zshrc"
alias zvi="echo '=== vi  ~/Desktop/products-202403-/dotfiles/.zshrc ===' && vi  ~/Desktop/products-202403-/dotfiles/.zshrc"
alias ls="echo '=== ls -la ===' && ls -la"
alias sl="echo '=== ls -la ===' && ls -la"
alias cmv="echo '=== compress ===' && compress"
alias mkfile="echo '=== makefile ===' && makefile"



alias gss="echo '=== git add . && git stash save ===' && git add . && git stash save"
alias ew="echowrap"
alias d="docker exec {container_name}"
alias gitap0="git stash apply stash@{0}"
alias zshsave="zshs && zshs && sh  ~/Desktop/products-202403-/dotfiles/_save.sh"
alias dapsan="echo '=== docker exec -it {container_name} php artisan ===' && docker exec -it {container_name} php artisan"
alias awsdevstop="aws ec2 stop-instances --instance-ids {AWS_INSTANCE_ID} --output text"
alias awsdevstart="aws ec2 start-instances --instance-ids {AWS_INSTANCE_ID} --output text"
