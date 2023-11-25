# Feel free to modify this at will!
# Usefull commands and customized prompt

# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BLUE='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsa='ls -alFh'
alias cls='clear'
alias vi='vim'
alias k='kubectl'
alias k8s='kubectl config set-context --current --namespace '
alias t='terraform'
alias tf-yolo='terraform apply -auto-approve'
alias tf-fuckit='terraform destroy -auto-approve'
alias n='nomad'
alias c='consul'
alias v='vault'

# Retrieve git branch name from current directory
parse_git_branch() {
    git branch 2> /dev/null | grep \* | awk '{ print " git:(" $2 ")" }'
}

# Custom prompt
prompt_command() {
    RET=$?
    history -a
    export PS1="[\[${BLUE}\]\u\[${NC}\]@\[${YELLOW}\]\h\[${NC}\]:\[${RED}\]\W\[${GREEN}\]\$(parse_git_branch)\[${NC}\]] $ "
}

# Make Bash append rather than overwrite the history on disk:
shopt -s histappend
# A new shell gets the history lines from all previous shells
export PROMPT_COMMAND=prompt_command
# Don't put duplicate lines in the history.
export HISTCONTROL=ignoredups
export HISTFILE=/home/dev/.bash_history/history

# direnv allowed folders
direnv allow /terraform/proxmox-ha/ >/dev/null 2>&1
direnv allow /terraform/hashistack/ >/dev/null 2>&1
direnv allow /terraform/vault/ >/dev/null 2>&1
direnv allow /terraform/vault_pki/ >/dev/null 2>&1
direnv allow /terraform/vault_infra/ >/dev/null 2>&1
direnv allow /terraform/vault_consul/ >/dev/null 2>&1
direnv allow /terraform/vault_nomad/ >/dev/null 2>&1
direnv allow /terraform/vault_agent/ >/dev/null 2>&1
direnv allow /terraform/iam/ >/dev/null 2>&1
direnv allow /terraform/ >/dev/null 2>&1

# Hook direnv into shell
source <(direnv hook bash)

# Add Terraform autocompletion
complete -C /bin/terraform terraform t

# Add Nomad autocompletion
complete -C /bin/nomad nomad n

# Add Consul autocompletion
complete -C /bin/consul consul c

# Add Vault autocompletion
complete -C /bin/vault vault v

# Add bash completion
source /etc/bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
