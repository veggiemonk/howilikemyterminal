# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export LANG=en_US.UTF-8

#
# Oh My ZSH https://ohmyz.sh/
# 
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell" #if you use starship, it can be ""

DISABLE_UPDATE_PROMPT="true"
# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Display date for `history`
HIST_STAMPS="yyyy-mm-dd"
HIST_IGNORE_DUPS=true
HIST_IGNORE_SPACE=true # a space before the command will not write it to history

plugins=(
  docker
  git
  kubectl
  zsh-autosuggestions
  zsh-completions
  fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Auto download plugins 
[ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ] && \
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

[ ! -d $ZSH_CUSTOM/plugins/zsh-completions ] && \
	git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions

[ ! -d $ZSH_CUSTOM/plugins/fast-syntax-highlighting ] && \
	git clone https://github.com/zdharma/fast-syntax-highlighting $ZSH_CUSTOM/plugins/fast-syntax-highlighting

#
# Local binaries
#
[ ! -d ~/bin ] && mkdir ~/bin
export PATH="$HOME/bin:$PATH"

##
# Repositories
#
[ ! -d ~/code ] && mkdir ~/code

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Quick edit aliases
alias ez="vim ~/.zshrc && source ~/.zshrc"
alias es="vim ~/.ssh/config"
alias eg="vim ~/.gitconfig"
alias ep="vim ~/.config/starship.toml"

# clear the screen
alias c="clear"
# go to repositories
alias repo="cd ~/code"
alias path='echo -e ${PATH//:/\\n}' # print $PATH 1 per line
# Go back to root of repo
alias gro="cd $(git rev-parse --show-toplevel)"
# List used ports
alias ports="sudo lsof -PiTCP -sTCP:LISTEN"
# open current dir with VScode
alias co="code ."

# replace ls with exa
alias ls='exa'
alias l='exa -lbF --git'
alias ll='exa -l --git'
alias llm='exa -lbGF --git --sort=modified'
alias la='exa -la --git'
alias lS='exa -1'
alias lt='exa --tree --level=2'

# Answering common questions
common_question(){
  # TODO: replace this with the link to a repo
    echo " Font: https://github.com/be5invis/Iosevka"
    echo
    echo " prompt: https://starship.rs/"
    echo 
    echo " cat replacement:       https://github.com/sharkdp/bat "
    echo " find replacement:      https://github.com/sharkdp/fd "
    echo " grep replacement:      https://github.com/BurntSushi/ripgrep "
    echo " ls replacement:        https://github.com/ogham/exa "
    echo " git diff replacement:  https://github.com/dandavison/delta"
    echo 
    echo "How do you get that completion thing ?"
    echo
    echo "👉 Install oh-my-zsh"
    echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)'
    echo
    echo 'git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions'
    echo 'git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions'
    echo 'git clone https://github.com/zdharma/fast-syntax-highlighting $ZSH_CUSTOM/plugins/fast-syntax-highlighting'
    echo
    echo 'add this line to your .zshrc '
    echo "plugins+=(zsh-autosuggestions zsh-completions fast-syntax-highlighting)"
    echo
    echo "How do you get that history search"
    echo "👉  fzf: https://github.com/junegunn/fzf"
    echo 
    echo "How do you see all the file tree on github ?"
    echo "👉 https://github.com/EnixCoda/Gitako"
    echo
}

##
# PYTHON
#
alias python="python3"
alias p="python3"
alias pip="pip3"
export PATH="$(python -m site --user-base)/bin":$PATH
#pipx completions
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"
# Created by `pipx` 
export PATH="$PATH:/Users/$USER/.local/bin"

##
# GOLANG
#
export GOPATH="${HOME}/go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# GOLANG COMPANY SETUP
# export GOPROXY=https://gomodproxy.company.com
# export GONOSUMDB=git.company.com

##
# JAVA
#
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

##
# NodeJS - NVM
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

##
# KUBERNETES
#
## No need thanks to the zsh plugin
# alias k=kubectl
# [ ! -f ~/.kubectlk_comp ] && kubectl completion zsh | sed 's/kubectl/k/g'> ~/.kubectlk_comp
# # k autocomplete
# source ~/.kubectlk_comp

alias kp="kubectl get pods"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kga="kubectl get all"
alias -g OY="-o yaml"           # kp mypod OY ==> kubectl get pod mypod -o yaml

# TODO: try k9s

update_k8s_context() {
gcloud container clusters list \
  --project="$1" \
  --filter="resourceLabels[env]=production" --format="value[delimiter=' '](name,zone)" \
  | xargs -n 2 sh -c 'gcloud container clusters get-credentials $1 --region=$2 --project=gke-xpn-1' sh
}

# Run action container locally
action-container() {
  set -x
  docker run --rm -i -w /workspace -e HOME=/workspace \
        -v $(pwd):/workspace \                                  # mount current dir
        -v ${HOME}/.docker:/workspace/.docker \                 # mount docker creds
        -v ${HOME}/.config/gcloud:/workspace/.config/gcloud \   # mount gcloud creds
        "$@"
  set +x
}

##
# PROMPT
#

# autocomplete
autoload -U compinit; compinit

# Fuzzy finder:  https://github.com/junegunn/fzf
# `ctrl+r` keymap for fuzzy history search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# gcloud completion
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# starship prompt: https://starship.rs/
eval "$(starship init zsh)"


