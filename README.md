# dl-ia-item.sh
The [official Internet Archive command line utility](https://archive.org/developers/internetarchive/cli.html) is very useful for downloading entire (or partial) items from the Archive. It has a few deficiences, however:

1. No rate limiting, so it will use as much of your download bandwidth as is available.
2. Broken downloads will not continue; Ctrl-C or network error 90% into a gigabyte file? Get ready to download the whole thing again.

`dl-ia-item.sh` is a simple Bash script to wrap the `ia` command to address these issues.

## Usage
```
Usage: dl-ia-item.sh [-r rate_limit] [-p wildcard_pattern] [-d] -i ia_item_id
 -d = dry run; show the wget commands which would be executed
 example rate limits:
   '-r 500k' -> limit to 500 kilobytes/second
   '-r 2M'   -> limit to 2 megabytes/second
 example wildcard: '-p *.jpg' to only download jpg files in item
 ```
 
