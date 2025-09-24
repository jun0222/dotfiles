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


