#!/usr/bin/env python3

import os
import pathlib
import shutil


def link(src_path: str, dst_path: str):
    """
    :param src_path: Either directory or a file.
    :param dst_path: Directory where the link should be created.
    """
    print(f"Linking {src_path} to {dst_path}")

    # Backup and clean up if exists
    src = pathlib.Path(dst_path)
    if src.exists():
        if src.is_symlink():
            print(f"Replacing previous symlink at {dst_path}")
            os.remove(dst_path)
        elif src.is_dir():
            print(f"Backing up directory {dst_path}")
            shutil.move(dst_path, dst_path + ".backup")
            shutil.rmtree(dst_path, ignore_errors=True)
        elif src.is_file():
            print(f"Backing up file {dst_path}")
            shutil.move(dst_path, dst_path + ".backup")
            os.remove(dst_path)

    os.symlink(src_path, dst_path, target_is_directory=True)


if __name__ == "__main__":
    dotfiles_root = pathlib.Path(__file__).parent.resolve()
    home = pathlib.Path.home()
    xdg_config_home = os.path.join(home, ".config")

    # Vim
    link(f"{dotfiles_root}/vim/vimrc.txt", f"{home}/.vimrc")
    link(f"{dotfiles_root}/vim/data", f"{home}/.vim")

    # Git
    os.makedirs(f"{xdg_config_home}/git", exist_ok=True)
    link(f"{dotfiles_root}/git/gitconfig.txt", f"{xdg_config_home}/git/config")
    link(f"{dotfiles_root}/git/gitignore_global.txt", f"{xdg_config_home}/git/ignore")

    # Atuin
    link(f"{dotfiles_root}/atuin", f"{xdg_config_home}/atuin")

    # Fish
    link(f"{dotfiles_root}/fish", f"{xdg_config_home}/fish")

    # Ghostty
    link(f"{dotfiles_root}/ghostty", f"{xdg_config_home}/ghostty")

    # Helix
    link(f"{dotfiles_root}/helix", f"{xdg_config_home}/helix")

    # Zed
    link(f"{dotfiles_root}/zed", f"{xdg_config_home}/zed")

    # dig
    link(f"{dotfiles_root}/digrc.txt", f"{home}/.digrc")

    print("Done!")
