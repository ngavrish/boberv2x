#!/usr/bin/env bash

OPENWRT_TAG=v21.02.1

[ `basename $PWD` == openwrt_21 ] || { echo This script must be executed from openwrt_21 root directory; exit -1; }

[ -d openwrt ] || { git clone git@github.com:openwrt/openwrt.git --no-checkout || fail "ERROR: git clone failed. Aborting. "; }
pushd openwrt
git fetch
#git checkout ${OPENWRT_TAG} || fail "ERROR: git checkout failed. Aborting."

# Clean out the feeds
./scripts/feeds clean

./scripts/feeds update -a
./scripts/feeds install -a

popd > /dev/null
