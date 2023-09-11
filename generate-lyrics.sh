#!/usr/bin/env bash

set -eEuo pipefail
shopt -s inherit_errexit

function fix_apostrophes() {
	sed -e "s/’/'/g" # fix "fancy" apostrophes
}

function fix_CR() {
    tr  -d '\r' 
}

for f in songs/song.*.txt; do
	num=$(cut -d. -f2 <<<"$f")
	title=$(head -n 1 "${f}" | fix_apostrophes | fix_CR | sed -r -e 's/^.*?[.] *//')
	lyrics="$(tail -n +2 "${f}" | fix_apostrophes | fix_CR )"
	jq_args=(
		-n
		--arg num "${num}"
		--arg title "${title}"
		--arg lyrics "${lyrics}"
		'{ number: $num | tonumber, title: $title, lyrics: $lyrics }'
	)
	jq "${jq_args[@]}"
done |
	jq --slurp '. | sort_by(.number) | { songs: . } | tojson' |
	sed 's/^/var songs = JSON.parse(/; s/$/)/;'
