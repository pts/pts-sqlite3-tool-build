#! /bin/sh --
#
# test.sh: test the behavior of sqlite3 tools
# by pts@fazekas.hu at Wed Dec  2 12:23:25 CET 2020
#
# The test succeeds iff it exist with 0. In this case, it also prints the
# last line containing `: OK for ' to stderr.
#
# Mostly full-text index (FTS3 and FTS4) behavior is tested.
#

set -ex

# Example: ./test.sh sqlite3
# Example: ./test.sh sqlite-amalgamation-*/sqlite3.*fts3ext{,.linux-*,.ubuntu*-*}
for SQLITE3_CMD in "$@"; do

test -f "$SQLITE3_CMD" || case "$SQLITE3_CMD" in *\*) continue ;; esac

rm -f test.exp test.out index.db3.tmp index.db3

rm -f index.db3.tmp index.db3

"$SQLITE3_CMD" -batch -init /dev/null/missing index.db3.tmp "
PRAGMA journal_mode = off;  -- For speedup.
PRAGMA synchronous = off;  -- For speedup.
PRAGMA temp_store = memory;  -- For speedup.
PRAGMA cache_size = -16384;  -- 16 MiB. For speedup.
BEGIN EXCLUSIVE;  -- Speedup by a factor of ~3.77.
-- The final version will have case sensitive matches in tags.
-- It's not possible to enforce UNIQUE(filename) in an fts4 table,
-- but we will manually ensure that there are no duplicate filenames.
CREATE VIRTUAL TABLE assoc USING fts4(filename, notindexed=filename, tags, matchinfo=fts3);
INSERT INTO assoc (filename, tags) VALUES
('dir1/file11', 'foo bar'),
('dir1/file12', 'foo bar'),
('dir2/file21', 'foo bar'),
('dir2/file22', 'foo bar'),
('dir2/dir23/file231', 'foo bar'),
('dir2/file24', 'foo bar'),
('dir3/file31', 'foo bar'),
('dir3/file32', 'foo foobar');
COMMIT;
-- TODO: Speedup: The final version will use an in-memory database up to
--       this point, and then .clone here.
" >/dev/null  # For pragma.
# TODO: Better move the journal file atomically?

rm -f index.db3-journal
mv -f index.db3.tmp index.db3

"$SQLITE3_CMD" -batch -init /dev/null/missing index.db3 "SELECT 1 FROM assoc WHERE tags MATCH 'NOT' AND rowid=0 AND rowid<rowid" >test.out 2>&1 ||:
cat >test.exp <<'END'
END
if cmp test.exp test.out >/dev/null; then
  IS_FTS3EXT=  # No extended FTS3 query syntax.
else
  cat >test.exp <<'END'
Error: malformed MATCH expression: [NOT]
END
  diff -U9999 test.exp test.out
  IS_FTS3EXT=1  # Uses extended FTS3 query syntax.
fi

if test "$IS_FTS3EXT"; then
  "$SQLITE3_CMD" -batch -init /dev/null/missing -separator " :: " index.db3 "SELECT tags, filename FROM assoc WHERE tags MATCH '(foo bar NOT baz) OR quux'" >test.out
else
  "$SQLITE3_CMD" -batch -init /dev/null/missing -separator " :: " index.db3 "SELECT tags, filename FROM assoc WHERE tags MATCH 'foo bar -baz'" >test.out
fi
cat >test.exp <<'END'
foo bar :: dir1/file11
foo bar :: dir1/file12
foo bar :: dir2/file21
foo bar :: dir2/file22
foo bar :: dir2/dir23/file231
foo bar :: dir2/file24
foo bar :: dir3/file31
END
diff -U9999 test.exp test.out

"$SQLITE3_CMD" -batch -init /dev/null/missing index.db3 "
PRAGMA synchronous = off;  -- For speedup if power outages are unexpected.
PRAGMA temp_store = memory;  -- For speedup.
PRAGMA cache_size = -16384;  -- 16 MiB. For speedup.
PRAGMA case_sensitive_like = true;
BEGIN EXCLUSIVE;  -- For speedup and synchronization.
-- Slow, sequential scan.
SELECT rowid, tags, filename FROM assoc WHERE filename LIKE 'dir2/%';
-- Result of the SELECT above:
--   3|foo bar|dir2/file21
--   4|foo bar|dir2/file22
--   5|foo bar|dir2/dir23/file231
--   6|foo bar|dir2/file24
-- dir2/file21 was removed, dir2/file24 was untagged.
DELETE FROM assoc WHERE rowid in (3, 6);
UPDATE assoc SET tags = 'bar quux' WHERE rowid = 5;
INSERT INTO assoc (filename, tags) VALUES
('dir2/file25', 'foo bar'),
('dir2/file26', 'foo bar');
-- Tags of dir2/file22 remain unchanged. In a typical index, most of
-- the tags would remain unchanged.
COMMIT;
" >test.out
cat >test.exp <<'END'
3|foo bar|dir2/file21
4|foo bar|dir2/file22
5|foo bar|dir2/dir23/file231
6|foo bar|dir2/file24
END
diff -U9999 test.exp test.out

if test "$IS_FTS3EXT"; then
  "$SQLITE3_CMD" -batch -init /dev/null/missing -separator " :: " index.db3 "SELECT tags, filename FROM assoc WHERE tags MATCH '(foo bar NOT baz) OR quux'" >test.out
  cat >test.exp <<'END'
foo bar :: dir1/file11
foo bar :: dir1/file12
foo bar :: dir2/file22
bar quux :: dir2/dir23/file231
foo bar :: dir3/file31
foo bar :: dir2/file25
foo bar :: dir2/file26
END
else
  "$SQLITE3_CMD" -batch -init /dev/null/missing -separator " :: " index.db3 "SELECT tags, filename FROM assoc WHERE tags MATCH 'foo bar -baz'" >test.out
  cat >test.exp <<'END'
foo bar :: dir1/file11
foo bar :: dir1/file12
foo bar :: dir2/file22
foo bar :: dir3/file31
foo bar :: dir2/file25
foo bar :: dir2/file26
END
fi

rm -f test.exp test.out index.db3.tmp index.db3

done  # for SQLITE3_CMD

: "$0" OK for: "$@" >&2

