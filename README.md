# fertilize -- retry the same thing, expect different results


## SYNOPSIS

Sometimes spawning a child process is not successful.
This attempts to `fertilize` the *process* by being stubborn,
retrying a number of times before eventually giving up.
Therefore this isn't quite the same as "crazy",
which people like to quote.


## MOTIVATION

The following is just a use-case.
Retrying stuff can be justified / useful, even with computers...

Sometimes (and in some cases often) `rsync` will fail to sync
(due to "Broken pipe" or something).
There is a [known bug](https://bugzilla.samba.org/show_bug.cgi?id=5478)
the solution for which is to keep retrying...
That's exactly what this script does.

Call it like you otherwise would `rsync`.
The only difference being that if you pass a number as the very first argument,
it will run that many number of times.  If you give it 0, it will run forever
until done.  If no number is provided, it will use some hardcoded default,
which supposedly has better chances than the otherwise usual rsync once.


## EXAMPLE

All about `rsync`...

    fertilize 3 rsync something /dev/null

Spawns `rsync something /dev/null` and probably fails 3 times in a row.
It could be because the `something` is missing or `/dev/null` doesn't allow it.

Be careful with `fertilize 0 something` - it easily becomes an infinite loop...
So be convinced the `something` is likely to exit with a status of `0`.
Zero (being success) is fitting for an exit, it otherwise goes on for infinity.

Back to the motivation / use-case...

This was prompted by a need to move some files from HFS to NTFS.  NTFS because
it's the most reliable file-system that I can currently mount with both Mac OS
and Linux.  Cut & paste produced some weird errors and rsync periodically does
the broken pipe thing.  The NTFS-3G driver, being kind of slow, made it worse.
I wish I could just use ZFS...

So here is how I tend to move files:

    fertilize 999 rsync -ptr --partial --size-only --remove-source-files --stats {source} {target}/

It preserves permissions (if possible) and the timespamps,
syncs the files recursively, removes whatever is synced,
and provides stats in the end.

The stats are those of the last run and only if successful up to attempt `999`,
so they are just indicator of overall success, especially useful if your prompt
doesn't display exit status.  The source directories are kept around - as there
doesn't seem to be an option for removing them as well.  I don't use `--progress`
with this - it would print a line every second.  Maybe there is or will be
some other way to pass on child process stdout (without doing console.log)?

Of-course rsync is useful for all kinds of copying and stuff --
like keeping files in sync, backup, etc.


## INSTALL

With the [npm](http://npmjs.org) prerequisite, do `npm install -g fertilize`.


## LICENSE

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

