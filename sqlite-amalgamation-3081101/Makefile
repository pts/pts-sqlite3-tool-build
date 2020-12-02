#
# Makefile for building sqlite-amalgamation-3081101 (SQLite 3.8.11.1)
# by pts@fazekas.hu at Tue Dec  1 16:02:23 CET 2020
#
# Linux targets tested with gcc 4.8.4 on Ubuntu 14.04, amd64.
#

# -DSQLITE_OMIT_DATETIME_FUNCS -DSQLUTE_OMIT_EXPLAIN -DSQLITE_OMIT_FOREIGN_KEY -DSQLITE_OMIT_GET_TABLE -DSQLITE_OMIT_LOCALTIME -DSQLITE_OMIT_PROGRESS_CALLBACK -DSQLITE_OMIT_WAL
DEFINES = -DSQLITE_ENABLE_FTS3 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_COMPILEOPTION_DIAGS -DSQLITE_OMIT_DEPRECATED -DSQLITE_OMIT_TRACE -DSQLITE_OMIT_AUTHORIZATION -DSQLITE_OMIT_GET_TABLE -DSQLITE_OMIT_PARSER_TRACE -DSQLITE_OMIT_POPEN -DSQLITE_OMIT_TEST_CONTROL -DSQLITE_OMIT_UTF16 -DHAVE_UTIME
WARNINGS = -W -Wall -Wextra -Wno-maybe-uninitialized -Wno-unused-parameter -Wno-unused-variable -Wno-unused-value -Wno-unused-but-set-variable -Wno-unused-function -Wno-implicit-fallthrough
OPTS = -fdata-sections -ffunction-sections -Wl,--gc-sections -s -O2
SRCS = sqlite3.c shell.c
SRCSM = $(SRCS) #Makefile
# Changes the ELF operating system from System V to Linux.
OSFIX = && perl -pi -0777 -e 'die "bad ELF" if !s@\A(\x7F.LF[\1\2]\001\001)[\0\3]@$$1\003@' $@.tmp && mv -f $@.tmp $@
GCC = gcc
CC = $(GCC) $(OPTS)

AMD64_MUSL_LIBDIR = /usr/lib/x86_64-linux-musl
AMD64_MUSL_INCLUDEDIR = /usr/include/x86_64-linux-musl
CC_LINUX_I686_CMD = xstatic gcc -march=i686
CC_LINUX_I686_LIBS =
CC_LINUX_AMD64_CMD = gcc -fno-pic -fno-pie -fno-stack-protector -Wl,--build-id=none -static -nostdlib -nostdinc -isystem $(AMD64_MUSL_INCLUDEDIR) -m64 -march=x86-64
CC_LINUX_AMD64_LIBS = $(AMD64_MUSL_LIBDIR)/crt1.o $(AMD64_MUSL_LIBDIR)/libc.a

# Contains clang-3.5.0, target is x86_64-apple-darwin12.
DARWIN_PREFIX = docker run -v "$$PWD:/workdir" -w /workdir -u "$$(id -u):$$(id -g)" --network none --rm andrewd/osxcross@sha256:dd3d60a9721bc20fb380a7435f7ebcdeb7b6371e69aecadb742bf76d083d5481 sh -c 'for P in /opt/osxcross/target/bin/x86_64-apple-darwin*-"$$0"; do test -f "$$P" && exec "$$P" "$$@"; done; exec "$$0" "$$@"'
CLANG_WARNINGS = -Wno-unknown-warning-option -Wno-missing-field-initializers
CLANG_OPTS = -dead_strip -O2
CLANG_DARWIN_I686_CMD = $(DARWIN_PREFIX) clang -m32 -march=i686
CLANG_DARWIN_I686_LIBS = libgcc.darwin-i386.a -mmacosx-version-min=10.5 -nostdlib -lSystem -lcrt1.10.5.o
CLANG_DARWIN_AMD64_CMD = $(DARWIN_PREFIX) clang -m64
CLANG_DARWIN_AMD64_LIBS = -mmacosx-version-min=10.5 -nostdlib -lSystem -lcrt1.10.5.o

DEFAULT_EXECUTABLES = sqlite3.nofts3ext sqlite3.fts3ext
LINUXSTATIC_EXECUTABLES = sqlite3.nofts3ext.linux-i686 sqlite3.fts3ext.linux-i686 sqlite3.nofts3ext.linux-amd64 sqlite3.fts3ext.linux-amd64
DARWIN_EXECUTABLES = sqlite3.nofts3ext.darwin-i686 sqlite3.fts3ext.darwin-i686 sqlite3.nofts3ext.darwin-amd64 sqlite3.fts3ext.darwin-amd64
EXECUTABLES = $(DEFAULT_EXECUTABLES) $(LINUXSTATIC_EXECUTABLES) $(DARWIN_EXECUTABLES)
.PHONY: default clean
default: $(DEFAULT_EXECUTABLES)
linuxstatic: $(LINUXSTATIC_EXECUTABLES)
darwin: $(DARWIN_EXECUTABLES)
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

sqlite3.nofts3ext.darwin-i686: $(SRCSM)
	$(CLANG_DARWIN_I686_CMD) $(CLANG_OPTS) $(WARNINGS) $(CLANG_WARNINGS) $(DEFINES) -o $@ $(SRCS) $(CLANG_DARWIN_I686_LIBS)
	$(DARWIN_PREFIX) strip $@
sqlite3.fts3ext.darwin-i686: $(SRCSM)
	$(CLANG_DARWIN_I686_CMD) $(CLANG_OPTS) $(WARNINGS) $(CLANG_WARNINGS) $(DEFINES) -DSQLITE_ENABLE_FTS3_PARENTHESIS -o $@ $(SRCS) $(CLANG_DARWIN_I686_LIBS)
	$(DARWIN_PREFIX) strip $@

sqlite3.nofts3ext.darwin-amd64: $(SRCSM)
	$(CLANG_DARWIN_AMD64_CMD) $(CLANG_OPTS) $(WARNINGS) $(CLANG_WARNINGS) $(DEFINES) -o $@ $(SRCS) $(CLANG_DARWIN_AMD64_LIBS)
	$(DARWIN_PREFIX) strip $@
sqlite3.fts3ext.darwin-amd64: $(SRCSM)
	$(CLANG_DARWIN_AMD64_CMD) $(CLANG_OPTS) $(WARNINGS) $(CLANG_WARNINGS) $(DEFINES) -DSQLITE_ENABLE_FTS3_PARENTHESIS -o $@ $(SRCS) $(CLANG_DARWIN_AMD64_LIBS)
	$(DARWIN_PREFIX) strip $@
