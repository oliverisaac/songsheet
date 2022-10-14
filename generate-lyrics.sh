#!/usr/bin/env bash

set -eEuo pipefail

for f in songs/song.*.txt; do
    num=$(cut -d. -f2 <<<"$f")
    title=$(head -n 1 "$f" | sed -r -e 's/^.*?[.] *//')
    lyrics="$(tail -n +2 "$f")"
    jq_args=(
        -n
        --arg num "$num"
        --arg title "$title"
        --arg lyrics "$lyrics"
        '{ number: $num | tonumber, title: $title, lyrics: $lyrics }'
    )
    jq "${jq_args[@]}"
done |
    jq --slurp '. | sort_by(.number) | { songs: . } | tojson' | 
    sed 's/^/var songs = JSON.parse(/; s/$/)/;'
