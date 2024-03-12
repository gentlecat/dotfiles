set -g fish_user_paths "/opt/homebrew/bin" $fish_user_paths
set -g fish_user_paths "/opt/homebrew/sbin" $fish_user_paths

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -x EDITOR vim
set -x LC_ALL "en_US.UTF-8"
set -x LANG "en_US.UTF-8"
set -x LANGUAGE "en_US"

set -x HOMEBREW_NO_ANALYTICS 1
set -x HOMEBREW_INSTALL_FROM_API true

####################
# Helper functions #
####################

if type -q python3
	# Create an HTTP server serving current directory on port 8080
	function serve
		python3 -m http.server --bind=localhost 8080
	end
end

if type -q docker
	function docker-bash
		docker exec -it $argv /bin/bash
	end

	function docker-sh
		docker exec -it $argv /bin/sh
	end

	function docker-clean
		docker system prune -a -f
	end
end

###########
# Aliases #
###########

if type -q eza
	alias ls=eza
end
alias l="ls -alF"

if type -q git
	alias g=git
end

if type -q code
	alias c=code
end

if type -q python3
	alias python=python3
end

alias ws="cd ~/workspace/"

alias brew-sync="cd ~/workspace/dotfiles; brew update; brew upgrade --display-times; brew upgrade --cask; brew bundle -v; brew cleanup; brew bundle cleanup -v --force --zap"

alias mosh-tor="mosh tor -- tmux a"

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v
	if [ (count $argv) -eq 0 ]
		vim .
	else
		vim "$argv"
	end
end

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o
	if [ (count $argv) -eq 0 ]
		open .
	else
		open "$argv"
	end
end

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre
	tree -aC -I '.git|node_modules' --dirsfirst "$argv" | less -FRNX
end
