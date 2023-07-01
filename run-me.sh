#!/bin/bash

# echo "$(pwd)"
CMD0="$0"
CURR_DIR="$( cd "$( dirname $0)" && pwd )"


OUT_FILE_PATH="$CURR_DIR/out.txt"

function out_file_path {
    echo "$OUT_FILE_PATH"
}

function make_out_file {
    echo "this-is-out-file" > $OUT_FILE_PATH
    echo "generated $OUT_FILE_PATH"
}

if  [ ! "$1" ] ;then
    make_out_file
else
    $@
fi
