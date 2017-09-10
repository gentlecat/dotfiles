set PATH /usr/local/sbin $PATH


# Android tools
set PATH ~/Library/Android/sdk/platform-tools $PATH

# Add directory with "subl" command to lunch Sublime Text
set PATH /Applications/Sublime\ Text.app/Contents/SharedSupport/bin $PATH

# Golang
set -x GOPATH ~/workspace/go
set PATH $GOPATH/bin $PATH

# fuck
eval (thefuck --alias | tr '\n' ';')

####################
# Helper functions #
####################

function serve
    python3 -m http.server --bind=localhost 8080
end

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

function cleanup
	rm "/Users/roman/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.RecentDocuments.sfl"
	rm "/Users/roman/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments.sfl"
	rm -r "/Users/roman/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments"
end
