#!/usr/bin/env bash

DOTFILES_ROOT="$( cd "$(dirname "$0")" ; pwd -P )"
XDG_CONFIG_HOME="$HOME/.config"

set -e


info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  mkdir -p "$XDG_CONFIG_HOME/git"
  link_file "$DOTFILES_ROOT/git/gitconfig.txt" "$XDG_CONFIG_HOME/git/config"
  link_file "$DOTFILES_ROOT/git/gitignore_global.txt" "$XDG_CONFIG_HOME/git/ignore"

  link_file "$DOTFILES_ROOT/vim/vimrc.txt" "$HOME/.vimrc"
  link_file "$DOTFILES_ROOT/vim/data" "$HOME/.vim"
}

link_fish_config () {
  info 'installing fish config'
  local overwrite_all=false backup_all=false skip_all=false

  link_file "$DOTFILES_ROOT/fish" "$XDG_CONFIG_HOME/fish"
}

echo ''

install_dotfiles
link_fish_config

echo ''
echo '  All ready!'
