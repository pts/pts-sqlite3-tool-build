#
# Makefile for building sqlite-amalgamation-3160200 (SQLite 3.16.2)
# by pts@fazekas.hu at Tue Dec  1 16:02:23 CET 2020
#
# Linux targets tested with gcc 4.8.4 on Ubuntu 14.04, amd64.
#

# -DSQLITE_OMIT_DATETIME_FUNCS -DSQLUTE_OMIT_EXPLAIN -DSQLITE_OMIT_FOREIGN_KEY -DSQLITE_OMIT_GET_TABLE -DSQLITE_OMIT_LOCALTIME -DSQLITE_OMIT_PROGRESS_CALLBACK -DSQLITE_OMIT_WAL
DEFINES = -DSQLITE_ENABLE_FTS3 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_COMPILEOPTION_DIAGS -DSQLITE_OMIT_DEPRECATED -DSQLITE_OMIT_TRACE -DSQLITE_OMIT_AUTHORIZATION -DSQLITE_OMIT_GET_TABLE -DSQLITE_OMIT_PARSER_TRACE -DSQLITE_OMIT_POPEN -DSQLITE_OMIT_TEST_CONTROL -DSQLITE_OMIT_UTF16 -DHAVE_UTIME
WARNINGS = -W -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable -Wno-unused-value -Wno-unused-but-set-variable -Wno-unused-function -Wno-implicit-fallthrough
OPTS = -fdata-sections -ffunction-sections -Wl,--gc-sections -s -O2
SRCS = sqlite3.c shell.c
SRCSM = $(SRCS) #Makefile
# Changes the ELF operating system from System V to Linux.
OSFIX = && perl -pi -0777 -e 'die "bad ELF" if !s@\A(\x7F.LF[\1\2]\001\001)[\0\3]@$$1\003@' $@.tmp && mv -f $@.tmp $@
GCC = gcc
CC = $(GCC) $(OPTS)

CC_LINUX_I686_CMD = xstatic gcc -march=i686
CC_LINUX_I686_LIBS =

AMD64_MUSL_LIBDIR = /usr/lib/x86_64-linux-musl
AMD64_MUSL_INCLUDEDIR = /usr/include/x86_64-linux-musl
CC_LINUX_AMD64_CMD = gcc -fno-pic -fno-pie -fno-stack-protector -Wl,--build-id=none -static -nostdlib -nostdinc -isystem $(AMD64_MUSL_INCLUDEDIR) -m64 -march=x86-64
CC_LINUX_AMD64_LIBS = $(AMD64_MUSL_LIBDIR)/crt1.o $(AMD64_MUSL_LIBDIR)//libc.a

DEFAULT_EXECUTABLES = sqlite3.nofts3ext sqlite3.fts3ext
LINUXSTATIC_EXECUTABLES = sqlite3.nofts3ext.linux-i686 sqlite3.fts3ext.linux-i686 sqlite3.nofts3ext.linux-amd64 sqlite3.fts3ext.linux-amd64
EXECUTABLES = $(DEFAULT_EXECUTABLES) $(LINUXSTATIC_EXECUTABLES)
.PHONY: default clean
default: $(DEFAULT_EXECUTABLES)
linuxstatic: $(LINUXSTATIC_EXECUTABLES)
all: $(EXECUTABLES)

clean:
	-rm -f $(EXECUTABLES) $(EXECUTABLES:=.tmp)

sqlite3.nofts3ext: $(SRCSM)
	$(CC) $(WARNINGS) $(DEFINES) -o $@ $(SRCS) $(CC_LINUX_I686_LIBS)
sqlite3.fts3ext: $(SRCSM)
	$(CC) $(WARNINGS) $(DEFINES) -DSQLITE_ENABLE_FTS3_PARENTHESIS -o $@ $(SRCS) $(CC_LINUX_I686_LIBS)

sqlite3.nofts3ext.linux-i686: $(SRCSM)
	$(CC_LINUX_I686_CMD) $(OPTS) $(WARNINGS) $(DEFINES) -o $@.tmp $(SRCS) $(CC_LINUX_I686_LIBS) $(OSFIX)
sqlite3.fts3ext.linux-i686: $(SRCSM)
	$(CC_LINUX_I686_CMD) $(OPTS) $(WARNINGS) $(DEFINES) -DSQLITE_ENABLE_FTS3_PARENTHESIS -o $@.tmp $(SRCS) $(CC_LINUX_I686_LIBS) $(OSFIX)

sqlite3.nofts3ext.linux-amd64: $(SRCSM)
	$(CC_LINUX_AMD64_CMD) $(OPTS) $(WARNINGS) $(DEFINES) -o $@.tmp $(SRCS) $(CC_LINUX_AMD64_LIBS) $(OSFIX)
sqlite3.fts3ext.linux-amd64: $(SRCSM)
	$(CC_LINUX_AMD64_CMD) $(OPTS) $(WARNINGS) $(DEFINES) -DSQLITE_ENABLE_FTS3_PARENTHESIS -o $@.tmp $(SRCS) $(CC_LINUX_AMD64_LIBS) $(OSFIX)
