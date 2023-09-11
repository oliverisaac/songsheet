#!/usr/bin/env bash

set -eEuo pipefail
shopt -s inherit_errexit

function fix_apostrophes() {
	sed -e "s/’/'/g" # fix "fancy" apostrophes
}

function fix_CR() {
    tr  -d '\r' 
}

function sed() {
    if which gsed &>/dev/null; then
        gsed "$@"
    else
        command sed "$@"
    fi
}

function get_guide_url(){
    curl 'https://www.ignitechurchfm.com/lifegroups/' | grep -oEie 'https://s3.amazonaws.com/account-media/[^"]*pdf' | grep -v '1684508611' | sort -h | tail -n 1
}

if ! guide_url=$( get_guide_url ); then
    guide_url=""
fi

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
	jq --arg "guide_url" "$guide_url" --slurp '. | sort_by(.number) | { songs: ., guide_url: $guide_url } | tojson' |
	sed 's/^/var songs = JSON.parse(/; s/$/)/;'
