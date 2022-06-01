# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

export PATH="/usr/local/Cellar/gettext/0.20.1/bin:$PATH"
export PATH="/usr/local/opt/postgresql@11/bin:$PATH"

# If you need to have openjdk first in your PATH run:
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
# export JAVA_11_HOME=$(/usr/libexec/java_home -v11)

# alias java8='export JAVA_HOME=$JAVA_8_HOME'
# alias java11='export JAVA_HOME=$JAVA_11_HOME'

# Default to Java 11
# java11


# For compilers to find openjdk you may need to set:
# export CPPFLAGS="-I/usr/local/opt/openjdk/include"

# Path to your oh-my-zsh installation.
export ZSH=/Users/teemu/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
    git
    kubectl
    docker
    docker-compose
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias zshc="code ~/.zshrc"
alias d='docker'
alias dc='docker-compose'

alias docker_cleancont='docker ps -a -q | xargs docker rm'
alias docker_cleanimg='docker images --filter "dangling=true" -q | xargs docker rmi'

alias auth_oma='gcloud config set account teemu1huovinen@gmail.com && gcloud config set project echie-prod && gcloud container clusters get-credentials cluster-1 --region europe-north1-a'
alias auth_swappie_prod='gcloud config set account teemu@swappie.com && gcloud config set project swappie-prod && gcloud container clusters get-credentials cluster-2 --region europe-west3'
alias auth_swappie_staging='gcloud config set account teemu@swappie.com && gcloud config set project swappie-staging && gcloud container clusters get-credentials cluster-3 --region europe-west3'

dshell() {
    docker exec -it "$1" bash
}

dcshell() {
    docker-compose exec "$1" bash
}

git_delete_branch() {
    git branch -D "$1" && git push origin ":$1"
}

zstyle ':completion:*' special-dirs true

[ -s "/Users/teemu/.scm_breeze/scm_breeze.sh" ] && source "/Users/teemu/.scm_breeze/scm_breeze.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

export GOPATH="${HOME}/.go"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

zle_highlight=('paste:none')

eval "$(nodenv init -)"