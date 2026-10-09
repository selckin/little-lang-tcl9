#!/bin/sh
#
# Demonstrate that the L examples work:
#   - every examples/*.l is compiled (and type-checked) with L --norun;
#   - pod2html.l renders the L reference manual;
#   - photos.l builds a gallery of generated images (needs ImageMagick);
#   - ci/gui-demo.l runs under L-gui if a display is available.
#
# usage: ci/run-examples.sh <path/to/L> <tcl-source-dir> [out-dir]

set -eu

L=$1
TCL_SRC=$2
OUT=${3:-build/examples-out}
HERE=$(cd "$(dirname "$0")/.." && pwd)

mkdir -p "$OUT"
OUT=$(cd "$OUT" && pwd)

echo "== L version: $(echo 'puts [Lver]' | "$L")"

for f in "$HERE"/examples/*.l; do
	echo "== compile $(basename "$f")"
	"$L" --norun "$f"
done

echo "== pod2html.l: render the L reference manual"
"$L" "$HERE/examples/pod2html.l" --title="L Programmer's Reference Guide" \
	"$TCL_SRC/doc/L/little.doc" > "$OUT/little.html"
size=$(wc -c < "$OUT/little.html")
echo "   wrote $OUT/little.html ($size bytes)"
test "$size" -gt 50000
grep -q '<title>L Programmer' "$OUT/little.html"

if command -v convert >/dev/null 2>&1 && command -v identify >/dev/null 2>&1
then
	echo "== photos.l: build a photo gallery"
	g="$OUT/gallery"
	rm -rf "$g"
	mkdir -p "$g"
	IM=convert
	command -v magick >/dev/null 2>&1 && IM=magick
	for c in red green blue orange; do
		$IM -size 800x600 "gradient:$c-white" "$g/$c.jpg"
	done
	mkdir -p "$OUT/home"
	(cd "$g" && HOME="$OUT/home" "$L" "$HERE/examples/photos.l" \
		--title="L on Tcl 9.1")
	ls -a "$g"
	test -s "$g/index.html"
	test ! -e "$g/~"
	for c in red green blue orange; do
		test -s "$g/.thumb-$c.jpg"
	done
	echo "   gallery in $g"
else
	echo "== photos.l: skipped (ImageMagick not installed)"
fi

L_GUI=$(dirname "$L")/L-gui
if [ -x "$L_GUI" ] && [ -n "${DISPLAY:-}" ]; then
	echo "== gui-demo.l under L-gui"
	"$L_GUI" "$HERE/ci/gui-demo.l" "$OUT/gui-demo.txt"
	cat "$OUT/gui-demo.txt"
	grep -q '^button pressed$' "$OUT/gui-demo.txt"
else
	echo "== gui-demo.l: skipped (no L-gui or no DISPLAY)"
fi

echo "== examples OK"
