#!/usr/bin/env bash

# Default configuration (file) to use
config_name="bpir2"

SOURCE="https://git.openwrt.org/openwrt/openwrt.git"
MIRROR="https://github.com/bkukanov/openwrt.git"
RELEASE="latest"
TARGET="mediatek/mt7622"
OPENWRT_TAG=7fd1ca96a13112a7ea214b3baf076cd81d712378
DESTINATION="."
FILES=""
COMMAND=""
VERBOSE=false

##############################################
die() { echo "$*" 1>&2 ; exit 1; }

source_download(){
    [ -d openwrt ] || { git clone ${SOURCE} || fail "ERROR: git clone failed. Aborting. "; }
    cd openwrt
    git pull
    git fetch -t
    # echo "src-git boberv2x git@github.com:ngavrish/boberv2x.git" >> feeds.conf.default
    cd ../
}

source_fetch() {
    [ `basename $PWD` == openwrt_21 ] || { echo This script must be executed from openwrt_21 root directory; exit -1; }

    [ -d openwrt ] || { source_download || fail "ERROR: git clone failed. Aborting. "; }
    cd openwrt
    git checkout ${OPENWRT_TAG} || fail "ERROR: git checkout failed. Aborting."
    make distclean
    ./scripts/feeds clean
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    cd ../
    image_configure
}

image_build() {
    echo "make image"

    [ `basename $PWD` == openwrt_21 ] || { echo This script must be executed from openwrt_21 root directory; exit -1; }
    [ -d openwrt ] || { source_download || fail "ERROR: can't download the openwrt "; }
    # source_fetch
    cd openwrt
    make defconfig
    make download
    # make -j9 V=s
    make -j9
    # cd ../
}

image_configure(){
    echo "copy patches"

    [ `basename $PWD` == openwrt_21 ] || { echo This script must be executed from openwrt_21 root directory; exit -1; }
    cp patches/600-regdb-21-ITS.patch                               openwrt/package/firmware/wireless-regdb/patches/600-regdb-21-ITS.patch
    cp patches/998-ath9k_allow_11p.patch                            openwrt/package/kernel/mac80211/patches/ath/998-ath9k_allow_11p.patch
    cp patches/999-Enable-queueing-in-all-4-ACs-BE-BK-VI-VO.patch   openwrt/package/kernel/mac80211/patches/ath/999-Enable-queueing-in-all-4-ACs-BE-BK-VI-VO.patch
    cp patches/999-Get-hw-queue-pending-stats-from-ath9k-via-netlink.patch  openwrt/package/kernel/mac80211/patches/ath/999-Get-hw-queue-pending-stats-from-ath9k-via-netlink.patch
    cp patches/999-ITS-G5D-channels-fix.patch                       openwrt/package/kernel/mac80211/patches/ath/999-ITS-G5D-channels-fix.patch
    cp ./patches/iperf/*.patch                                      openwrt/feeds/packages/net/iperf/patches

    cp ./configs/${config_name}                                     openwrt/.config
}
# Help information
######################################################

usage() {
cat <<-HELP
usage: $(basename "$0") [options]
This script must be executed from openwrt_21 root directory

Action options:
    -b      Build the image
    -d      Only download/fetch image builder from ${SOURCE}

Config options:
    -h	  Print this help
HELP
}

while [ -n "$1" ]; do
    case $1 in
    -d) source_fetch; exit 0;;
    -b) image_build; exit 0;;
    -c) image_configure; exit 0 ;;
    -h) usage; exit 0 ;;
    *)
        usage
        die "Unknown option '$1'"
        ;;
    esac
    shift
done