pts-sqlite3-tool-build: build scripts for the sqlite3 tool
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
pts-sqlite3-tool-build is a set of Makefiles and other build scripts to
compile and build the sqlite3(1) command-line tool with the FTS3 and FTS4
extensions enabled. By default, it builds native executables with gcc, but
it can also build statically linked executables for Linux i386 (i686) and
amd64.

Build dependencies:

* GCC (gcc) with a linker. Tested with GCC 4.8.4.
* Git (git), to clone the repo. Alternatively, download and extract the
  pts-sqlite3-tool-build repo in a different way.
* wget, to download sqlite-amalgamation-*.zip . Alternative download tools
  (such as curl) also work.
* GNU Make (make).
* Perl (perl). It is needed only for building statically linked executables
  for Linux.

To build native executables on Linux or other Unix:

  $ git clone https://github.com/pts/pts-sqlite3-tool-build
  $ cd pts-sqlite3-tool-build
  $ wget -qO sqlite-amalgamation-3330000.zip https://sqlite.org/2020/sqlite-amalgamation-3330000.zip
  $ unzip sqlite-amalgamation-3330000.zip
  Archive:  sqlite-amalgamation-3330000.zip
    inflating: sqlite-amalgamation-3330000/sqlite3.c
    inflating: sqlite-amalgamation-3330000/shell.c
    inflating: sqlite-amalgamation-3330000/sqlite3ext.h
    inflating: sqlite-amalgamation-3330000/sqlite3.h
  $ make -C sqlite-amalgamation-3330000
  gcc ...
  gcc ...
  $ ls -l sqlite-amalgamation-3330000/sqlite3.*fts3ext
  -rwxrwxr-x 1 user user 986704 Dec  2 11:05 sqlite-amalgamation-3330000/sqlite3.fts3ext
  -rwxrwxr-x 1 user user 986704 Dec  2 11:04 sqlite-amalgamation-3330000/sqlite3.nofts3ext

To build statically linked executables for Linux i386 (i686) with
[minilibc686](https://github.com/pts/minilibc686) (recommended):

  $ sudo apt-get install make unzip wget git
  $ git clone https://github.com/pts/pts-sqlite3-tool-build
  $ cd pts-sqlite3-tool-build
  $ wget -qO sqlite-amalgamation-3330000.zip https://sqlite.org/2020/sqlite-amalgamation-3330000.zip
  $ unzip sqlite-amalgamation-3330000.zip
  Archive:  sqlite-amalgamation-3330000.zip
    inflating: sqlite-amalgamation-3330000/sqlite3.c
    inflating: sqlite-amalgamation-3330000/shell.c
    inflating: sqlite-amalgamation-3330000/sqlite3ext.h
    inflating: sqlite-amalgamation-3330000/sqlite3.h
  $ make -C sqlite-amalgamation-3330000 sqlite3.fts3ext.linux-i686-mini sqlite3.nofts3ext.linux-i686-mini
  minicc --gcc=4.8 --uclibc ...
  ...
  $ ls -l sqlite-amalgamation-3330000/sqlite3.*fts3ext.linux-i686-mini
  -rwxrwxr-x 1 user user 896432 Nov 18 17:00 sqlite-amalgamation-3330000/sqlite3.fts3ext.linux-i686-mini
  -rwxrwxr-x 1 user user 896496 Nov 18 17:00 sqlite-amalgamation-3330000/sqlite3.nofts3ext.linux-i686-mini

To build statically linked executables for Linux i386 (i686) and amd64 on
Ubuntu 14.04 amd64:

  $ sudo apt-get install gcc-4.8 gcc-4.8-multilib make perl unzip wget git
  $ git clone https://github.com/pts/pts-sqlite3-tool-build
  $ cd pts-sqlite3-tool-build
  $ wget -qO sqlite-amalgamation-3330000.zip https://sqlite.org/2020/sqlite-amalgamation-3330000.zip
  $ unzip sqlite-amalgamation-3330000.zip
  Archive:  sqlite-amalgamation-3330000.zip
    inflating: sqlite-amalgamation-3330000/sqlite3.c
    inflating: sqlite-amalgamation-3330000/shell.c
    inflating: sqlite-amalgamation-3330000/sqlite3ext.h
    inflating: sqlite-amalgamation-3330000/sqlite3.h
  $ make -C sqlite-amalgamation-3330000 all GCC=gcc-4.8
  gcc-4.8 ...
  ...
  $ ls -l sqlite-amalgamation-3330000/sqlite3.*fts3ext.*
  -rwxrwxr-x 1 user user 1001536 Dec  2 11:07 sqlite-amalgamation-3330000/sqlite3.fts3ext.linux-amd64
  -rwxrwxr-x 1 user user 1003364 Dec  2 11:06 sqlite-amalgamation-3330000/sqlite3.fts3ext.linux-i686
  -rwxrwxr-x 1 user user 1001536 Dec  2 11:07 sqlite-amalgamation-3330000/sqlite3.nofts3ext.linux-amd64
  -rwxrwxr-x 1 user user 1003300 Dec  2 11:05 sqlite-amalgamation-3330000/sqlite3.nofts3ext.linux-i686

## Source timestamps

```
touch -d '2008-07-16 14:52:32 +0000' sqlite3-nofts3ext-3.6.0
touch -d '2008-12-16 18:00:15 +0000' sqlite3-nofts3ext-3.6.7
touch -d '2010-03-31 11:55:30 +0000' sqlite3-fts3ext-3.6.23.1 sqlite3-nofts3ext-3.6.23.1
touch -d '2013-12-06 15:05:16 +0000' sqlite3-fts3ext-3.8.2 sqlite3-nofts3ext-3.8.2
touch -d '2015-07-29 20:06:58 +0000' sqlite3-fts3ext-3.8.11.1 sqlite3-nofts3ext-3.8.11.1
touch -d '2017-01-06 16:52:14 +0000' sqlite3-fts3ext-3.16.2 sqlite3-nofts3ext-3.16.2
touch -d '2018-01-22 18:57:31 +0000' sqlite3-fts3ext-3.22.0 sqlite3-nofts3ext-3.22.0
touch -d '2020-08-14 13:42:48 +0000' sqlite3-fts3ext-3.33.0 sqlite3-nofts3ext-3.33.0
```

__END__
