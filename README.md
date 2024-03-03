# dl-ia-item.sh
The [official Internet Archive command line utility](https://archive.org/developers/internetarchive/cli.html) is very useful for downloading entire (or partial) items from the Archive. It has a few deficiences, however:

1. No rate limiting, so it will use as much of your download bandwidth as is available.
2. Broken downloads will not continue; Ctrl-C or network error 90% into a gigabyte file? Get ready to download the whole thing again.

This repository contains a few utilities to address these issues.

## Getting The ia Tool
The tools in this repo assume that the [official Internet Archive command line utility](https://archive.org/developers/internetarchive/cli.html) is downloaded and can be executed out of the `$PATH`:
```
$ curl -LOs https://archive.org/download/ia-pex/ia
$ chmod +x ia
$ mv ia </some/place/in/PATH>
```

## dl-ia-item.sh
`dl-ia-item.sh` is a simple Bash script to wrap the `ia` command to allow rate-limiting and resuming large file downloads.

```
Usage: dl-ia-item.sh [-r rate_limit] [-p wildcard_pattern] [-d] -i ia_item_id
 -d = dry run; show the wget commands which would be executed
 example rate limits:
   '-r 500k' -> limit to 500 kilobytes/second
   '-r 2M'   -> limit to 2 megabytes/second
 example wildcard: '-p *.jpg' to only download jpg files in item
 ```
 
## dl-ia-video-dvd-item.sh
`dl-ia-video-dvd-item.sh` is like `dl-ia-item.sh` except that it is tuned for downloading IA items that contain video DVD ISOs. It does this by ignoring generated MP4 or OGV video streams, or any JPG video thumbnails. It also does not honor the wildcard option.

```
Usage: dl-ia-video-dvd-item.sh [-r rate_limit] [-d] -i ia_item_id
 -d = dry run; show the wget commands which would be executed
 example rate limits:
   '-r 500k' -> limit to 500 kilobytes/second
   '-r 2M'   -> limit to 2 megabytes/second
```
 
