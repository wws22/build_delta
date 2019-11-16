#!/usr/bin/env bash

function usage {
    echo "Usage: ${0##*/} <ver1dir> <ver2dir> <target>"
    exit 65;
}
UNEXPECTED_ERROR=66

function cleanup {
    if [[ _$XDIFF != "_" && -d $XDIFF ]]; then
        echo "Removing temporary directory '$XDIFF'"
        rm -rf $XDIFF
    fi
    rm -f xdeltadir.log
}

function create_patch_script {
    cat - <<EOFiLe > "$TARGET.sh"
#!/usr/bin/env bash

echo This is line one.
EOFiLe
    if [[ $? != 0 ]]; then
        rm -f "$TARGET.sh"
        echo "Can't create '$TARGET.sh' script!"
        cleanup
        exit $UNEXPECTED_ERROR;
    fi
    chmod +x "$TARGET.sh"
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
which xdeltadir >/dev/null 2>&1
if [[ $? != 0 ]]; then
    echo 'Please install xdelta package at first! Example:'
    echo '$sudo apt-get install xdelta'
    exit $UNEXPECTED_ERROR;
fi

# setup temporary dir for xdelta
NUM="$RANDOM$RANDOM$RANDOM"01234578; NUM=${NUM:1:8};
XDIFF="xdiff_$NUM"                                     # Directory name

#echo "Creating temporary directory '$XDIFF'"
mkdir -p $XDIFF
if [[ _$XDIFF != "_" && ! -d $XDIFF ]]; then
    echo "Can't create temporary directory '$XDIFF' for xdelta files"
    cleanup
    exit $UNEXPECTED_ERROR;
fi

# Build xdelta
xdeltadir delta $VER1 $VER2 $XDIFF
if [[ $(ls -ac1 $XDIFF |wc -l) -lt 3 ]]; then
    echo "Something wrong! Your delta has zero files"
    cleanup
    exit $UNEXPECTED_ERROR;
fi

# Create archive
create_patch_script
tar -czf "$TARGET.tar.gz" $XDIFF "$TARGET.sh"
rm -f "$TARGET.sh"

echo "'$XDIFF' '$TARGET'"
cleanup

