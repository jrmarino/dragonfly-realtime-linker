#!/bin/sh

DPATH=$(dirname $0)
MAP="$DPATH"/../rtld-elf/Symbol.map
AWKSCRIPT="${DPATH}/version_gen.awk"
VERDEF="${DPATH}/Versions.def"

DESTINO="$1"
if [ -z "$DESTINO" ]; then
	echo "missing destination folder (CLI argument 1)"
	exit 1
fi

cat "$MAP" |\
	/usr/bin/cpp - - |\
	/usr/bin/awk -v vfile="$VERDEF" -f "${AWKSCRIPT}" \
	> "${DESTINO}/Version.map"
