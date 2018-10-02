#!/usr/bin/env bash

DOTFILES_ROOT=$(pwd -P)

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

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

link_fish_config () {
  local overwrite_all=false backup_all=false skip_all=false

  src="$DOTFILES_ROOT/fish/config.fish"
  dst="$HOME/.config/fish/config.fish"
  link_file "$src" "$dst"
}

# See https://packagecontrol.io/docs/syncing.
# Keep in mind that this will completely overwrite the existing configuration.
configure_sublime_text () {
  local overwrite_all=false backup_all=false skip_all=false

  subl_data_root="$HOME/Library/Application Support/Sublime Text 3"
  rm -rf subl_data_root
  success "removed $subl_data_root (if it existed)"
  mkdir -p "$subl_data_root"

  # Installing Package Control
  packages_root="$subl_data_root/Installed Packages"
  mkdir -p "$packages_root"
  curl -s -o "$packages_root/Package Control.sublime-package" \
       "https://packagecontrol.io/Package Control.sublime-package"

  # Configuring
  src="$DOTFILES_ROOT/sublime_text"
  dst="$subl_data_root/Packages"
  mkdir -p "$dst"
  link_file "$src" "$dst/User"
}


echo ''

install_dotfiles
link_fish_config
configure_sublime_text

echo ''
echo '  All ready!'
