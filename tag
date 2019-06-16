#!/bin/sh

# simple tagging system for hierarchical file systems

err() { echo "$@" 1>&2; exit 1; }
assert() { "$@" || err "$usage"; }

usage="usage: $0 file tags ...
   or: $0 -l file
   or: $0 -g tag"

assert [ $# -gt 0 ]

[ -z "$TAG_INDEX" ] && TAG_INDEX=.index

[ ! -e "$TAG_INDEX" ] && touch "$TAG_INDEX"

# parse arguments

case "$1" in
-l)
	assert [ $# -eq 2 ]
	export file=$2
	cat "$TAG_INDEX" |
	perl -ne 'print "$1\n" if /^\Q${ENV{file}}\E\t(.*)/'
	return $?
	;;
-g)
	assert [ $# -eq 2 ]
	export tag=$2
	cat "$TAG_INDEX" |
	perl -ne 'print if /^([^\t]*)\t([^\t]*\Q${ENV{tag}}\E.*$)/'
	return $?
	;;
--)
	shift
	# continue
	;;
-*)
	err "invalid option $1"
	;;
*)
	# continue
	;;
esac

# tag file

assert [ $# -gt 1 ]
file=$1
shift

while [ $# -gt 0 ]; do
	echo "$file	$1" >> "$TAG_INDEX"
	shift
done

tmp=$(mktemp)
cat "$TAG_INDEX" | sort | uniq > "$tmp"
mv "$tmp" "$TAG_INDEX"
