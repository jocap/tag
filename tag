#!/bin/sh

# simple tagging system for hierarchical file systems

err() { echo "$@" 1>&2; exit 1; }
assert() { "$@" || err "$usage"; }

usage="usage: $0 file tags ...
   or: $0 -l file
   or: $0 -g tag"

assert [ $# -gt 0 ]

[ ! -e .index ] && touch .index

# parse arguments

case "$1" in
-l)
	assert [ $# -eq 2 ]
	export file=$2
	cat .index |
	perl -ne 'print "$1\n" if /^\Q${ENV{file}}\E\t(.*)/'
	return $?
	;;
-g)
	assert [ $# -eq 2 ]
	export tag=$2
	cat .index |
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
	echo "$file	$1" >> .index
	shift
done

tmp=$(mktemp)
cat .index | sort | uniq > "$tmp"
mv "$tmp" .index
