#!/bin/bash

LOCAL_REPO_PATH="/experimental-repo"
META_REPO_URL="https://api.github.com/repos/ja-pa/turris-os-experimental/releases/latest"


get_repo_tag() {
	curl --silent $META_REPO_URL |grep tag_name|awk -F'"' '{print $4}'
}

download_repo_last() {
	repo_path="$1"
	if [ -d "$repo_path" ]; then
		cd $repo_path
		curl --silent  $META_REPO_URL| grep "browser_download_url" | awk -F'"' '{print $4}'|xargs wget
	else
		echo "Error"
	fi
}

add_opkg_repo() {
	echo "TBD"
}

add_updater_repo() {
	echo "TBD"
}

main() {
echo "main"
[ ! -d "$LOCAL_REPO_PATH" ] && mkdir -p $LOCAL_REPO_PATH

last_tag=$(get_repo_tag)
local_tag=$(cat $LOCAL_REPO_PATH/tag)
if [ -e "$LOCAL_REPO_PATH/tag" ] && [ "$last_tag" == "$local_tag" ]; then
	echo "aaa"
else
	echo "aaa"
fi

}
