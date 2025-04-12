#!/usr/bin/env bash

DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
source $DIR/ns_util.sh

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

no_error=true

function successfully_installed() {
    local exit_code=$1
    local content=$2
    local prefix_success=${3:-"Successfully installed"}
    local prefix_failure=${4:-"Failed to install"}

    if [[ $exit_code -eq 0 ]]; then
        success "$prefix_success $content."
        return 0
    else
        error "Error: $prefix_failure $content."
        no_error=false
        return 1
    fi
}

function create_symlink() {
    local src=$1
    local dest=$2
    if has_file "$dest"; then
        if [[ $(realpath "$dest") == $(realpath "$src") ]]; then
            return
        else
            warning "Warning: $dest exists, but not linked to $src."
            no_error=false
            return 1
        fi
    else
        mkdir -p "$(dirname $dest)"
        ln -s "$src" "$dest"
        successfully_installed $? "$dest to $src" "Linked" "Failed to link"
    fi
}

function link_files() {
    create_symlink "$DIR/nsl" "$HOME/.local/bin/nsl"
    create_symlink "$DIR/nsp" "$HOME/.local/bin/nsp"
    create_symlink "$DIR/zsh/_nsl" "$ZSH_CUSTOM/completions/_nsl"
    create_symlink "$DIR/zsh/_nsp" "$ZSH_CUSTOM/completions/_nsp"
}

function main() {
    link_files

    if [[ $no_error == true ]]; then
        success "All have been installed."
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
