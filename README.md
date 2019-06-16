TAG(1) - General Commands Manual

### NAME

**tag** - a simple tagging system

### SYNOPSIS

**tag**
*file*
*tags&nbsp;...*  
**tag**
**-l**&nbsp;\[*file*]  
**tag**
**-g**&nbsp;*tag*

### DESCRIPTION

**tag**
is a simple tagging system for hierarchical file systems.

-	Tags are stored as file&#8211;tag pairs in the file specified by
	`TAG_INDEX`.

-	If
	`TAG_INDEX`
	does not exist,
	**tag**
	asks if you want to create it.

-	If
	`TAG_INDEX`
	is unset, then the local file
	`.index`
	is used.
	In other words,
	**tag**
	is local to the current directory by default.

-	If you want a global tag index for your own user, define and export
	`TAG_INDEX`
	as something like
	`$HOME/.index`.

-	If you want to switch between multiple project-local tag indices
	depending on what directory you are in, you can use something like
	direnv(1).

### INTERFACE

*file* *tags ...*

> add
> *tags*
> to
> *file*

**-l** \[*file*]

> list all tags \[of
> *file*],
> one per line

**-g** *tag*

> list all file&#8211;tag pairs whose tag matches
> *tag*

### EXAMPLES

Add multiple tags to the file or directory
`t`:

	$ tag t prog pl=c

List all tags of
`t`:

	$ tag -l t
	pl=c
	prog

List files and directories with
`pl=`
tags:

	$ tag -g pl= | column -t
	/home/john/prj/watch  pl=c
	/home/john/prj/rn     pl=c
	/home/john/prj/t      pl=c
	/home/john/prj/tag    pl=sh

### LIMITATIONS

-	In the file&#8211;tag pairs in
	`TAG_INDEX`,
	the file and the tag are separated by a tab character.
	As such,
	**tag**
	does not support files with tabs in their names.

### AUTHORS

John Ankarstr&#246;m &lt;[john@ankarstrom.se](mailto:john@ankarstrom.se)&gt;

OpenBSD 6.4 - June 16, 2019
