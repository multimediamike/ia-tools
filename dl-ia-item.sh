LIMIT_RATE=$1
ITEM=$2

for file in $(ia download --dry-run ${ITEM})
do
  wget --recursive --limit-rate=$LIMIT_RATE --continue --no-host-directories --cut-dirs=1 $file
done
