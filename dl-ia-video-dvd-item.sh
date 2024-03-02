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
while getopts 'r:i:dh' opt; do
    case "$opt" in
        d)
            DRY_RUN="echo "
            ;;
        h)
            echo "Usage: $(basename $0) [-r rate_limit] [-d] -i ia_item_id"
            echo " example rate limits:"
            echo "   '-r 500k' -> limit to 500 kilobytes/second"
            echo "   '-r 2M'   -> limit to 2 megabytes/second"
            exit 0
            ;;
        i)
            ITEM=$OPTARG
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
for file in $(ia download --dry-run ${ITEM})
do
    # derive the filename's extension from the URL and make sure it's not
    # a pre-generated video or a JPG thumbnail
    filename=$(basename -- $file)
    extension=${filename##*.}
    if ! [[ "$extension" =~ ^(jpg|mp4|ogv|gif)$ ]]; then
        ${DRY_RUN}wget --recursive ${RATE_LIMIT} --continue --no-host-directories --cut-dirs=1 $file
    else
        echo "(skipping $file)"
    fi
done
