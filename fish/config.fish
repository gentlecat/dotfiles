set PATH /usr/local/sbin $PATH

# Perl
set -x PERL_MM_OPT "INSTALL_BASE=$HOME/perl5"
eval (perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)

# Android tools
set PATH ~/Library/Android/sdk/platform-tools $PATH

# Add directory with "subl" command to lunch Sublime Text
set PATH /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/ $PATH

# Golang
set -x GOPATH ~/workspace/go
set PATH $GOPATH/bin $PATH

# fuck
eval (thefuck --alias | tr '\n' ';')

####################
# Helper functions #
####################

function docker-bash
	docker exec -it $argv /bin/bash
end

function docker-sh
    docker exec -it $argv /bin/sh
end

function docker-clean
	echo "Removing containers..."
	docker rm -f (docker ps -a -q)
	echo "Removing images..."
	docker rmi -f (docker images -q)
	docker ps -a | cut -c-12 | xargs docker rm
end
