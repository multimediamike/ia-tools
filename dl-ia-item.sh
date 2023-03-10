#!/bin/bash

RATE_LIMIT=""

# check that the 'ia' tool is available
if ! command -v ia &> /dev/null
then
    echo "'ia' command could not be found"
    exit 1
fi

# parse arguments
while getopts 'r:i:h' opt; do
    case "$opt" in
        r)
            RATE_LIMIT="--limit-rate=$OPTARG"
            echo $RATE_LIMIT
            ;;
        i)
            ITEM=$OPTARG
            echo $ITEM
            ;;
        h)
            echo "Usage: $(basename $0) [-r rate_limit] -i ia_item_id"
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
    wget --recursive ${RATE_LIMIT} --continue --no-host-directories --cut-dirs=1 $file
done
