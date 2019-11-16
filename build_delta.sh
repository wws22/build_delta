#!/usr/bin/env bash

function usage {
    echo "Usage: ${0##*/} <ver1dir> <ver2dir> <target>"
    exit 65;
}
UNEXPECTED_ERROR=66;

function cleanup {
    if [[ _$XDIFF != "_" && -d $XDIFF ]]; then
        echo Remove directory $XDIFF
        rm -rf $XDIFF
    fi
}

# Print usage info
case "$3" in
"") usage; exit $WRONG_USAGE;;
-*) VER1=./$1; echo $VER1;;
-*) VER2=./$2; echo $VER2;;
-*) TARGET=./$3; echo $TARGET;;

* ) VER1=$1; VER2=$2; TARGET=$3;;

esac

# check dirs
if [[ ! -d $VER1 || ! -d $VER2 ]]; then
    usage
fi

# check xdeltadir presence
which xdeltadir 2&>1 >/dev/null
if [[ $? != 1 ]]; then
    echo 'Please install xdelta package at first! Example:'
    echo '$sudo apt-get install xdelta'
    exit $UNEXPECTED_ERROR;
fi

# setup temporary dir for xdelta
NUM="$RANDOM$RANDOM$RANDOM"01234578; NUM=${NUM:1:8};
XDIFF="xdiff_$NUM"                                     # Directory name

mkdir -p $XDIFF
if [[ _$XDIFF != "_" && ! -d $XDIFF ]]; then
    echo "Can't create temporary directory $XDIFF for xdelta files"
    cleanup
    exit $UNEXPECTED_ERROR;
fi

echo Here $VER1 $VER2 $TARGET $XDIFF

cleanup

