# fertilize -- retry the same thing, expect different results


# SYNOPSIS

Sometimes spawning a child process is not successful.
This attempts to `fertilize` the *process* by being stubborn,
retrying a number of times before eventually giving up.
Therefore this isn't quite the same as "crazy",
which people like to quote.


# MOTIVATION

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


# EXAMPLE

    fertilize 3 rsync something /dev/null

Spawns `rsync something /dev/null` and probably fails 3 times in a row.
It could be because the `something` is missing or `/dev/null` doesn't allow it.

Be careful with `fertilize 0 something` - it easily becomes an infinite loop...
So be convinced the `something` is likely to exit with a status of `0`.
Zero (being success) is fitting for an exit, it otherwise goes on for infinity.


## INSTALL

With the [npm](http://npmjs.org) prerequisite, do `npm install -g fertilize`.


## LICENSE

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

