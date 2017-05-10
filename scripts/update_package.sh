#!/bin/bash

PKG_DIR=$(pwd)/..

get_latest_release_tag() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

update_knot_resolver() {
	last_hash=$(git ls-remote https://gitlab.labs.nic.cz/knot/resolver.git|grep "refs/heads/master"|awk '{print $1}')
	sed -i "s|PKG_VERSION:=.*|PKG_VERSION:=${last_hash}|" $PKG_DIR/knot-resolver/Makefile
	echo knot-resolver updated
}

update_knot_resolver_forward() {
	last_hash=$(git ls-remote https://gitlab.labs.nic.cz/knot/resolver.git|grep "refs/heads/full-forward-master"|awk '{print $1}')
	sed -i "s|PKG_VERSION:=.*|PKG_VERSION:=${last_hash}|" $PKG_DIR/knot-resolver-fullforward/Makefile
	echo knot-resolver-forward updated
}

update_knot() {
	echo "NI"
}

update_youtube_dl() {
	last_tag=$(get_latest_release_tag "rg3/youtube-dl")
	sed -i "s|PKG_VERSION:=.*|PKG_VERSION:=${last_tag}|" $PKG_DIR/youtube-dl/Makefile
}

commit_changes() {
	for item in $(git status |grep "modified"|grep -v "build_all.sh"|grep -v "update_package.sh"|awk '{print $2}')
	do
	name=$(echo $item|awk -F'/' '{print $2}')
	git commit $item -m "$name:update package"
	done
}

update_knot_resolver_forward
update_knot_resolver
update_youtube_dl
commit_changes
