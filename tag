#!/bin/sh

# simple tagging system for hierarchical file systems

err() { echo "$@" 1>&2; exit 1; }
assert() { "$@" || err "$usage"; }

usage="usage: $0 file tags ...
       $0 -l [file]
       $0 -g tag"

assert [ $# -gt 0 ]

[ -z "$TAG_INDEX" ] && TAG_INDEX=.index

if [ ! -e "$TAG_INDEX" ]; then
	while true; do
		echo -n "$TAG_INDEX does not exist. Create it? (y/n) "
		read yn
		case "$yn" in
			[Yy]*) touch "$TAG_INDEX"; break ;;
			[Nn]*) echo 'Aborted.'; exit 1 ;;
			*) echo 'Please answer yes or no.'
		esac
	done
fi

# parse arguments

case "$1" in
-l)
	assert [ $# -lt 3 ]
	if [ $# -eq 1 ]; then
		cat "$TAG_INDEX"
		return 0
	else
		export file=$(readlink -f $2)
		cat "$TAG_INDEX" |
		perl -ne 'print "$1\n" if /^\Q${ENV{file}}\E\t(.*)/'
		return $?
	fi
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
file=$(readlink -f $1)
shift

while [ $# -gt 0 ]; do
	echo "$file	$1" >> "$TAG_INDEX"
	shift
done

tmp=$(mktemp)
cat "$TAG_INDEX" | sort | uniq > "$tmp"
mv "$tmp" "$TAG_INDEX"
