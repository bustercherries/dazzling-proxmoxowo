#!/bin/bash

##in case of any error without pipeline, exit the script
set -e

## exit if there is unbound (unused) variable 
set -u

## importnant viariables
working_dir=$1
lock_file="tmp/script-lock-file"
cmd_rm="rm -f"
cmd_mv="mv"
cmd_find=(find . -maxdepth 1 -type f -name "*.config*" -printf "%p\n")
config_file_name="config"

## Removing lock file - used in many cases
function remove_lock_file() {
    if [ -f "$lock_file" ]; then
        $cmd_rm "$lock_file" || {
            echo "Cannot remove lock file; ${lock_file}" >$2;
            exit 4
        }
    fi
}

## Checking if lock file exists
if [ -e "${lock_file}" ]; then
    echo "Lock file exists; another instance is running? ${lock_file}" >$2;
    exit 1
fi

## create a lock file
touch "${lock_file}" || {
    echo "Cannot create lock file - exiting; ${lock_file}" >$2;
    exit 2
}

## go to working dir
cd "$working_dir" || {
    echo "Cannot change directory to ${working_dir}" >$2;
    remove_lock_file
    exit 3
}



## finishing work
echo "Script finished successfully"
remove_lock_file