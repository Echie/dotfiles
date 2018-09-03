#!/usr/bin/env bash

main() {
    # First things first, asking for sudo credentials
    ask_for_sudo
    # Installing Homebrew, the basis of anything and everything
    install_homebrew
    # Installing mas using brew as the requirement for login_to_app_store
    brew_install mas
    # Ensuring the user is logged in the App Store so that
    # install_packages_with_brewfile can install App Store applications
    # using mas cli application
    login_to_app_store
    # Cloning Dotfiles repository for install_packages_with_brewfile
    # to have access to Brewfile
    clone_dotfiles_repo
    # Installing all packages in Dotfiles repository's Brewfile
    install_packages_with_brewfile
    # Install oh-my-zsh
    install_oh_my_zsh
    # Make sure zsh is the default shell
    change_shell_to_zsh
    # Configuring git config files
    configure_git
    # Install scm breeze
    configure_scm_breeze
    # Configure spectacle
    configure_spectacle
    # Install global python packages
    pip_packages=(virtualenv pylint yapf)
    pip3_install "${pip_packages[@]}"
    # Configuring iTerm2
    configure_iterm2
    # Update /etc/hosts (Currently disabled)
    # update_hosts_file
    # Setting up macOS defaults
    setup_macOS_defaults
    # Updating login items
    update_login_items
}

DOTFILES_REPO=~/.dotfiles

function ask_for_sudo() {
    info "Prompting for sudo password..."
    if sudo --validate; then
        # Keep-alive
        while true; do sudo --non-interactive true; \
            sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
        success "Sudo credentials updated."
    else
        error "Obtaining sudo credentials failed."
        exit 1
    fi
}

function install_homebrew() {
    info "Installing Homebrew..."
    if hash brew 2>/dev/null; then
        success "Homebrew already exists."
    else
        url=https://raw.githubusercontent.com/echie/dotfiles/master/installers/homebrew_installer
        if /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
            success "Homebrew installation succeeded."
        else
            error "Homebrew installation failed."
            exit 1
        fi
    fi
}

function brew_install() {
    package_to_install="$1"
    info "brew install ${package_to_install}"
    if hash "$package_to_install" 2>/dev/null; then
        success "${package_to_install} already exists."
    else
        if brew install "$package_to_install"; then
            success "Package ${package_to_install} installation succeeded."
        else
            error "Package ${package_to_install} installation failed."
            exit 1
        fi
    fi
}

function login_to_app_store() {
    info "Logging into app store..."
    if mas account >/dev/null; then
        success "Already logged in."
    else
        open -a "/Applications/App Store.app"
        until (mas account > /dev/null);
        do
            sleep 3
        done
        success "Login to app store successful."
    fi
}

function clone_dotfiles_repo() {
    info "Cloning dotfiles repository into ${DOTFILES_REPO} ..."
    if test -e $DOTFILES_REPO; then
        substep "${DOTFILES_REPO} already exists."
        pull_latest $DOTFILES_REPO
    else
        url=https://github.com/echie/dotfiles.git
        if git clone "$url" $DOTFILES_REPO; then
            success "Cloned into ${DOTFILES_REPO}"
        else
            error "Cloning into ${DOTFILES_REPO} failed."
            exit 1
        fi
    fi
}

function install_packages_with_brewfile() {
    info "Installing packages within ${DOTFILES_REPO}/brew/macOS.Brewfile ..."
    if brew bundle --file=$DOTFILES_REPO/brew/macOS.Brewfile; then
        success "Brewfile installation succeeded."
    else
        error "Brewfile installation failed."
        exit 1
    fi
}

function install_oh_my_zsh() {
    info "Installing Oh My Zsh..."
    if hash brew 2>/dev/null; then
        success "Homebrew already exists."
    else
        url=https://raw.githubusercontent.com/echie/dotfiles/master/installers/oh_my_zsh_installer
        if sh -c "$(curl -fsSL ${url})"; then
            success "Oh My Zsh installation succeeded."
        else
            error "Oh My Zsh installation failed."
            exit 1
        fi
    fi
}

function change_shell_to_zsh() {
    info "Zsh shell setup..."
    if grep --quiet zsh <<< "$SHELL"; then
        success "Zsh shell already exists."
    else
        user=$(whoami)
        substep "Adding zsh executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet \
            "/usr/local/bin/zsh" /etc/shells; then
            substep "Zsh executable already exists in /etc/shells"
        else
            if echo /usr/local/bin/zsh | sudo tee -a /etc/shells > /dev/null;
            then
                substep "Zsh executable successfully added to /etc/shells"
            else
                error "Failed to add Zsh executable to /etc/shells"
                exit 1
            fi
        fi
        substep "Switching shell to Zsh for \"${user}\""
        if sudo chsh -s /usr/local/bin/zsh "$user"; then
            success "Zsh shell successfully set for \"${user}\""
        else
            error "Please try setting the Zsh shell again."
        fi
    fi
}

function configure_git() {
    username="Teemu Huovinen"
    email="teemu.huovinen@hotmail.fi"

    info "Configuring git..."
    if cp ${DOTFILES_REPO}/git/.gitignore_global ~/.gitignore_global && \
    cp ${DOTFILES_REPO}/git/gitconfig ~/gitconfig; then
        success "Git configuration succeeded."
    else
        error "Git configuration failed."
    fi
}

function configure_scm_breeze() {
    info "Configuring scm_breeze..."
    if git clone git://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze && \
       ~/.scm_breeze/install.sh && \
       source ~/.zshrc; then
        success "Scm breeze configuration succeeded."
    else
        error "Scm breeze configuration failed."
    fi
}

function configure_spectacle() {
    info "Configuring up spectacle..."
    if cp ${DOTFILES_REPO}/spectacle/Shortcuts.json ~/Library/Application\ Support/Spectacle/Shortcuts.json; then
        success "Spectacle successfully configured."
    else
        error "Spectacle configuration failed"
    fi
}

function pip3_install() {
    packages_to_install=("$@")

    for package_to_install in "${packages_to_install[@]}"
    do
        info "pip3 install ${package_to_install}"
        if pip3 --quiet show "$package_to_install"; then
            success "${package_to_install} already exists."
        else
            if pip3 install "$package_to_install"; then
                success "Package ${package_to_install} installation succeeded."
            else
                error "Package ${package_to_install} installation failed."
                exit 1
            fi
        fi
    done
}

function configure_iterm2() {
    info "Configuring iTerm2..."
    if \
        defaults write com.googlecode.iterm2 \
            LoadPrefsFromCustomFolder -int 1 && \
        defaults write com.googlecode.iterm2 \
            PrefsCustomFolder -string "${DOTFILES_REPO}/iTerm2";
    then
        success "iTerm2 configuration succeeded."
    else
        error "iTerm2 configuration failed."
        exit 1
    fi
    substep "Opening iTerm2"
    if osascript -e 'tell application "iTerm" to activate'; then
        substep "iTerm2 activation successful"
    else
        error "Failed to activate iTerm2"
        exit 1
    fi
}

function update_hosts_file() {
    info "Updating /etc/hosts"

    if grep --quiet "someonewhocares" /etc/hosts; then
        success "/etc/hosts already updated."
    else
        substep "Backing up /etc/hosts to /etc/hosts_old"
        if sudo cp /etc/hosts /etc/hosts_old; then
            substep "Backup succeeded."
        else
            error "Backup failed."
            exit 1
        fi
        substep "Appending ${DOTFILES_REPO}/hosts/hosts content to /etc/hosts"
        if test -e ${DOTFILES_REPO}/hosts/hosts; then
            cat ${DOTFILES_REPO}/hosts/hosts | \
                sudo tee -a /etc/hosts > /dev/null
            success "/etc/hosts updated."
        else
            error "Failed to update /etc/hosts"
            exit 1
        fi
    fi
}

function setup_macOS_defaults() {
    info "Updating macOS defaults..."

    current_dir=$(pwd)
    cd ${DOTFILES_REPO}/macOS
    if bash defaults.sh; then
        cd $current_dir
        success "macOS defaults setup succeeded."
    else
        cd $current_dir
        error "macOS defaults setup failed."
        exit 1
    fi
}

function update_login_items() {
    info "Updating login items..."
    login_item /Applications/Dropbox.app
    login_item /Applications/Spectacle.app
    success "Login items successfully updated."
}

function login_item() {
    path=$1
    hidden=${2:-false}
    name=$(basename "$path")

    # "¬" charachter tells osascript that the line continues
    if osascript &> /dev/null << EOM
tell application "System Events" to make login item with properties ¬
{name: "$name", path: "$path", hidden: "$hidden"}
EOM
then
    success "Login item ${name} successfully added."
else
    error "Adding login item ${name} failed."
    exit 1
fi
}

function pull_latest() {
    info "Pulling latest changes in ${1} repository..."
    if git -C $1 pull origin master &> /dev/null; then
        success "Pull successful in ${1} repository."
    else
        error "Please pull the latest changes in ${1} repository manually."
    fi
}

function coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;
}

function info() {
    coloredEcho "$1" blue "========>"
}

function substep() {
    coloredEcho "$1" magenta "===="
}

function success() {
    coloredEcho "$1" green "========>"
}

function error() {
    coloredEcho "$1" red "========>"
}

main "$@"
