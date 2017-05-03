#!/bin/bash

PKG_DIR=$(pwd)/..

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
last_hash=aaaaaaaaaaaaaa
echo "NI"
}

update_youtube_dl() {
echo "NI"

}



update_knot_resolver_forward
update_knot_resolver
