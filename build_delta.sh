#!/usr/bin/env bash

function usage {
    echo "Usage: ${0##*/} <ver1dir> <ver2dir> <target_name>"
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
########################################################################## Patcher
    echo "#!/usr/bin/env bash
#
PATCH_DIR='$XDIFF'" > "$TARGET.sh"
    cat - <<'EOFiLe' >> "$TARGET.sh"
function usage {
    echo "Usage: ${0##*/} <old_version_dir>"
    exit 65;
}
UNEXPECTED_ERROR=66

function aborting {
    if [[ _$XDIFF != "_" && -d $XDIFF ]]; then
        echo "Removing temporary directory '$XDIFF'"
        rm -rf $XDIFF
    fi
    rm -f xdeltadir.log
    echo "Patching aborted!"
    exit $UNEXPECTED_ERROR;
}

# Print usage info
case "$1" in
"") usage; exit $WRONG_USAGE;;
-*) VER1=./$1; echo $VER1;;
* ) VER1=$1; ;;
esac

# check dirs
if [[ ! -d $VER1 || ! -d $PATCH_DIR ]]; then
    usage
fi

# check xdeltadir presence
which xdeltadir >/dev/null 2>&1
if [[ $? != 0 ]]; then
    echo 'Please install xdelta package at first! Example:'
    echo '$sudo apt-get install xdelta'
    exit $UNEXPECTED_ERROR;
fi

# setup temporary dir for V2
NUM="$RANDOM$RANDOM$RANDOM"01234578; NUM=${NUM:1:8};
XDIFF="xpatch_$NUM"                                     # Directory name

#echo "Creating temporary directory '$XDIFF'"
mkdir -p $XDIFF
if [[ _$XDIFF != "_" && ! -d $XDIFF ]]; then
    echo "Can't create temporary directory '$XDIFF' for xdelta files"
    aborting
fi

# Build V2
xdeltadir patch $PATCH_DIR $VER1 $XDIFF
if [[ $? -gt 0 || $(ls -ac1 $XDIFF |wc -l) -lt 3 ]]; then
    echo "Something wrong! New version directory is almost empty"
    aborting
fi

### NB! Put here commands to store some files from v1. Something like this:
#cp -f $VER1/prefereces.ini $XDIFF/

# Copy rights for VER1 directory to VER2 directory
chmod $(stat -c '%a %n' $VER1 |cut -d' ' -f1) $XDIFF

# Remove VER1 directory
rm -rf $VER1

# Remove unused log
rm -f xdeltadir.log

# Rename VER2 directory back (as VER1)
mv -f $XDIFF $VER1

echo "Patching completed."
EOFiLe
########################################################################## End of the Patcher

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

if [[ $(echo $TARGET |grep -ve '\/' |grep -ve '^~' |wc -l) != 1 ]]; then
    echo "ERROR: <target_name> it is not a PATH! Please do not use '/'"
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

cleanup

