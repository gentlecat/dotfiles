# rbenv
status --is-interactive; and source (rbenv init -|psub);

# Golang
set -x GOPATH ~/workspace/go
set -x GODEV ~/workspace/golang
set -x GOROOT_BOOTSTRAP (go env GOROOT)
set PATH $GOPATH/bin $PATH

# fuck
eval (thefuck --alias | tr '\n' ';')

alias git=hub
alias g=git

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
