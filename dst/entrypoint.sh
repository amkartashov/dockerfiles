#!/bin/sh

shard=$1

[ -z "$shard" ] && shard=Master

./dontstarve_dedicated_server_nullrenderer -offline -disabledatacollection -persistent_storage_root /data -cluster server -shard $shard
