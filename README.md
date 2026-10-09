# Little (L) on Tcl/Tk 9.1

[Little](https://github.com/bitkeeper-scm/little-lang) ("L") is a
compiled-to-bytecode language that draws on C (syntax, types, structs) and
Perl (hashes, regular expressions).  The L compiler generates Tcl bytecode
and uses the Tcl calling convention, so L and Tcl code mix freely and L can
use the whole Tcl/Tk library and Tk widgets.

The original little-lang was a fork of Tcl/Tk 8.6 (2016).  This repository
ports it to **Tcl/Tk 9.1**.  Instead of carrying a forked Tcl tree it holds
only the L-specific bits; the build downloads pristine Tcl/Tk 9.1.0 sources
and adds them:

| Path | Contents |
|---|---|
| `overlay/tcl/` | Files added to the Tcl tree: the L compiler (`generic/L*`), its runtime library (`library/libl.tcl`), the L test suite (`tests/l-*.test`, `tests/langbench`) and documentation (`doc/L`, `doc/l-paper`). |
| `patches/tcl-9.1.0-little.patch` | Changes to Tcl core files (L bytecodes, the `#lang L` parser hook, the `undef` value, PCRE2 regexps, build system, ...). |
| `examples/` | L programs from the original repository. |
| `ci/` | Example runner and a small Tk demo used by CI. |
| `docs/PORTING.md` | Notes on the 9.1 port: design decisions and pitfalls. |

Tk needs no changes: L-gui is a stock Tk 9.1 `wish` linked against the
L-enabled Tcl.

## Building

Requirements: a C compiler, make, curl, pkg-config and PCRE2
(`libpcre2-dev` on Debian/Ubuntu, `pcre2` on Homebrew); for L-gui also the
X11 and Xft development files (`libx11-dev libxft-dev`).  bison and flex are
only needed to regenerate the parser (`make regen`).

```sh
make            # download Tcl/Tk 9.1.0, patch, build L and L-gui
make test       # run the L test suite
make test-core  # run Tcl's own test suite against the patched Tcl
make examples   # compile all examples, run the runnable ones
make dist       # binary tarball in dist/
make install    # install to PREFIX (default /opt/little-lang)
make help       # all targets
```

The result is staged in `build/stage/opt/little-lang`:

* `bin/L` - tclsh with L.  `L foo.l` runs an L program (`.l` files are
  always L; `--L`/`-L` forces L for other files).  The Tcl library is
  embedded in the executable, so it can be moved anywhere.
* `bin/L-gui` - wish with L.
* `doc/little.html` - the L reference manual (`make doc`).

## Using L

```c
void main()
{
	string	line, w;
	int	count{string};

	while (line = <stdin>) {
		foreach (w in split(line)) {
			unless (defined(count{w})) count{w} = 0;
			count{w}++;
		}
	}
	foreach (w in sort(keys(count))) printf("%s %d\n", w, count{w});
}
```

L code can be embedded in Tcl scripts after a `#lang L` line (and back with
`#lang tcl`), or evaluated with the `L` command.  See `doc/little.html` for
the language reference.

## Differences from the Tcl 8.6 based little-lang

* Regular expressions use **PCRE2** instead of the end-of-life PCRE1.  Some
  compile error messages differ.  In the L tclsh, PCRE is the default engine
  for all of Tcl's `regexp`/`regsub` (set `TCL_REGEXP_CLASSIC` in the
  environment, or use `interp regexp {} classic`, for Tcl's own engine);
  `regexp -type pcre|classic` and `regsub -type`/`-submatches` select per call.
* Tcl 9 semantics apply to Tcl-level code called from L: e.g. `string
  bytelength` is gone, octal needs a `0o` prefix, some error messages changed,
  and `~` in file names is no longer expanded to the home directory (use
  `getenv("HOME")`; `examples/photos.l` was updated for this).
* Only leading arguments that are L options (`--norun`, `--poly`, ...) or
  `--long` options are taken as options before the script name; other
  `-options` behave as with a stock tclsh.

## CI

`.github/workflows/ci.yml` builds L and L-gui on Ubuntu, runs the L and
Tcl test suites, runs the examples (photos.l with ImageMagick-generated
images, and a Tk demo under Xvfb) and uploads the binary tarball, the test
logs and the example output as workflow artifacts.

## License

Same as Tcl/Tk (BSD-style); see `license.terms`.  Parts not encumbered by
the Tcl license are also available under the Apache License 2.0, as the
original little-lang.
