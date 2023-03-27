# Feel free to modify this at will!
# Usefull commands and customized prompt
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

# Retrieve git branch name from current directory
parse_git_branch() {
    git branch 2> /dev/null | grep \* | awk '{ print " git:(" $2 ")" }'
}

# Custom prompt
export PS1="[\[\033[36m\]\u\[\033[00m\]@\[\033[33m\]\h\[\033[00m\]:\[\033[31m\]\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\]] $ "

# direnv hook
_direnv_hook() {
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  eval "$("/usr/local/sbin/direnv" export bash)";
  trap - SIGINT;
  return $previous_exit_status;
};
if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
  PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi

# direnv allowed folders
direnv allow /terraform/proxmox-ha/ >/dev/null 2>&1

source ~/.terraform-docs-completion
