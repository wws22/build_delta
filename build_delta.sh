#!/usr/bin/env bash

function usage {
    echo "Usage: ${0##*/} <ver1dir> <ver2dir> <target>"
    exit 65;
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
if [[ _$(which xadeltadir) == "_" ]]; then
    usage
fi

echo Here $VER1 $VER2 $TARGET