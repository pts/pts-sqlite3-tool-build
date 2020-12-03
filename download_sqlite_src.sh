#! /bin/sh --
set -ex

for URL in \
    https://sqlite.org/sqlite-amalgamation-3_6_0.zip \
    https://sqlite.org/sqlite-source-3_6_0.zip \
    https://sqlite.org/sqlite-amalgamation-3_6_7.zip \
    https://sqlite.org/sqlite-source-3_6_7.zip \
    https://sqlite.org/sqlite-amalgamation-3_6_23_1.zip \
    https://sqlite.org/2013/sqlite-amalgamation-3080200.zip \
    https://sqlite.org/2015/sqlite-amalgamation-3081101.zip \
    https://sqlite.org/2017/sqlite-amalgamation-3160200.zip \
    https://sqlite.org/2018/sqlite-amalgamation-3220000.zip \
    https://sqlite.org/2020/sqlite-amalgamation-3330000.zip \
; do
  F="${URL##*/}"
  test -f "$F" && continue
  if wget -nv -O "$F".tmp "$URL"; then
    mv -f "$F".tmp "$F"
  else
    rm -f "$F".tmp
    : Aborting, ignoring subsequent downloads.
    false  # Abort.
  fi
done

: "$0" OK. >&2
