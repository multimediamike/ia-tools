#!/bin/bash

RATE_LIMIT=""
DRY_RUN=""

# check that the 'ia' tool is available
if ! command -v ia &> /dev/null
then
    echo "'ia' command could not be found"
    exit 1
fi

# parse arguments
while getopts 'r:i:p:dh' opt; do
    case "$opt" in
        d)
            DRY_RUN="echo "
            ;;
        h)
            echo "Usage: $(basename $0) [-r rate_limit] [-p wildcard_pattern] [-d] -i ia_item_id"
            echo " -d = dry run; show the wget commands which would be executed"
            echo " example rate limits:"
            echo "   '-r 500k' -> limit to 500 kilobytes/second"
            echo "   '-r 2M'   -> limit to 2 megabytes/second"
            echo " example wildcard: '-p *.jpg' to only download jpg files in item"
            exit 0
            ;;
        i)
            ITEM=$OPTARG
            ;;
        p)
            PATTERN="--glob=$OPTARG"
            ;;
        r)
            RATE_LIMIT="--limit-rate=$OPTARG"
            ;;
    esac
done

# ensure that an item ID was specified
if [ -z "${ITEM}" ]; then
    echo "no item ID specified; exiting"
    exit 1
fi

# get the list of download URLs via the ia tool
for file in $(ia download --dry-run ${PATTERN} ${ITEM})
do
    ${DRY_RUN}wget --recursive ${RATE_LIMIT} --continue --no-host-directories --cut-dirs=1 $file
done
