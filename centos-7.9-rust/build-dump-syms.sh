#!/usr/bin/env bash

# echo "$(pwd)"
CMD0="$0"
CURR_DIR="$( cd "$( dirname $0)" && pwd )"
WORK_DIR=${DUMP_SYMS_WORK_DIR:-"${CURR_DIR}/dump_syms_build"}
WORK_STAGE_DIR=${DUMP_SYMS_STAGE_DIR:-"${CURR_DIR}/dump_syms_stage"}

DOWNLOAD_URL="https://github.com/mozilla/dump_syms/archive/refs/tags/v2.2.1.tar.gz"
WORK_TAR="${WORK_DIR}/dump_syms-2.2.1.tar.gz"
WORK_SRC="${WORK_DIR}/dump_syms-2.2.1"

mkdir -p ${WORK_DIR}
cd "${WORK_DIR}"

function help {
    echo "Usage:"
    echo "  $CMD0 [Command]"
    echo "Command:"
    echo "  build       default. Auto fetching, unpacking, and building"
    echo "  build_once  build only once"
    echo "  rebuild     force rebuild by delete src/"
    echo "  fetch       downloading .tar"
    echo "  clean       delete src/ and stage/"
    echo "  clean_all   delete src/, stage/ and .tar "
}


function exit_msg {
    echo "failed: $@" >&2
    exit 1
}

function fail2die {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "failed: $@" >&2
        exit 1
    fi
}

# todo: dont repeat the configure options list
function build {

    if [[ ! -f "$WORK_TAR" ]]; then
        echo "none exist work tar $WORK_TAR"
        fetch
    fi

    if [[ ! -d "$WORK_SRC" ]]; then
        echo "none exist work src $WORK_SRC"
        unpack
    fi

    local work_src_path=$WORK_SRC
    if  [ ! "$work_src_path" ] ;then
        exit_msg "empty work_src_path"
    fi


    if  [ ! "$WORK_STAGE_DIR" ] ;then
        exit_msg "empty WORK_STAGE_DIR var"
    fi
    mkdir -p $WORK_STAGE_DIR

    echo "building path: $work_src_path"

    fail2die cd "$work_src_path"

    fail2die cargo build --release

    fail2die cp $WORK_SRC/target/release/dump_syms $WORK_STAGE_DIR/

    echo "builded target: $WORK_STAGE_DIR"
}




function clean_all {
    clean

    echo "deleting tar $WORK_TAR"
    rm -rf $WORK_TAR

    echo "deleting work $WORK_DIR"
    rm -rf $WORK_DIR
}

function clean {
    echo "deleting src $WORK_SRC"
    rm -rf $WORK_SRC

    echo "deleting stage $WORK_SRC"
    rm -rf $WORK_STAGE_DIR
}

function fetch {
    echo "fetching url: $DOWNLOAD_URL"
    # wget $DOWNLOAD_URL
    curl -L $DOWNLOAD_URL --output $WORK_TAR
    echo "saved to $WORK_TAR"
}

function unpack {
    echo "unpacking tar $WORK_TAR"
    fail2die tar xf $WORK_TAR
    echo "unpacking tar done"
}

function rebuild {
    echo rebuild
    clean
    # FORCE_REBUILD="1"
    build
}


function build_once {
    if [[ ! -d "$WORK_STAGE_DIR" ]]; then
        echo "rebuild stage for none exist $WORK_STAGE_DIR"
        rebuild
    else
        echo "skip build stage for exist $WORK_STAGE_DIR"
    fi
}

function install_bin {
    fail2die cp $WORK_STAGE_DIR/dump_syms /usr/local/bin/
}

RUN_FUN=${1:-"build"}
$RUN_FUN


