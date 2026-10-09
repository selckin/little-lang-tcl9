# Little (L) on Tcl/Tk 9.1.
#
# Downloads pristine Tcl/Tk sources, adds the L compiler (overlay/) and the
# Tcl core changes it needs (patches/), then builds L (an L-enabled tclsh)
# and L-gui (an L-enabled wish).  See README.md.

# Upstream sources (GitHub archives of the release tags, so the patch applies
# to exactly the tree it was made against).
TCL_TAG    = core-9-1-0
TCL_SHA256 = 4b6efbe457aa10515674b2570e5c2150998104c02a200020393094dc289de935
TK_TAG     = core-9-1-0
TK_SHA256  = 23a5509d15f24adc901e10f24e0291108735eba156560812067346f13ebf4a85
TCL_URL    = https://github.com/tcltk/tcl/archive/refs/tags/$(TCL_TAG).tar.gz
TK_URL     = https://github.com/tcltk/tk/archive/refs/tags/$(TK_TAG).tar.gz
TCL_PATCH  = patches/tcl-9.1.0-little.patch
TCL_VERSION = 9.1

# L version (returned by Lver(), and used for "package require L").
MAJOR = 1
MINOR = 0

PREFIX = /opt/little-lang

# PCRE2 (libpcre2-8) is found with pkg-config; set PCRE_DIR to use another
# build (a directory with include/pcre2.h and lib/libpcre2-8.*).
PCRE_DIR =

# Extra configure options, e.g. --enable-symbols.
TCL_CONFIGURE_OPTS =
TK_CONFIGURE_OPTS = --enable-xft --disable-xss

JOBS ?= $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)

HERE      := $(shell pwd)
DL        := $(HERE)/downloads
BUILD     := $(HERE)/build
SRC       := $(BUILD)/src
TCL_SRC   := $(SRC)/tcl
TK_SRC    := $(SRC)/tk
TCL_BUILD := $(BUILD)/tcl
TK_BUILD  := $(BUILD)/tk
STAGE     := $(BUILD)/stage
DIST      := $(HERE)/dist

PLATFORM := $(shell uname -s | tr A-Z a-z)-$(shell uname -m)
DIST_NAME = little-lang-$(MAJOR).$(MINOR)-tcl$(TCL_VERSION)-$(PLATFORM)

L     = $(STAGE)$(PREFIX)/bin/L
L_GUI = $(STAGE)$(PREFIX)/bin/L-gui

COMMON_CONFIGURE = --prefix=$(PREFIX) --disable-shared

all: L L-gui ## build L and L-gui

help: ## list targets
	@grep -h -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
	    awk 'BEGIN {FS = ":.*?## "}; {printf "make %-14s %s\n", $$1, $$2}'

#---------------------------------------------------------------------------
# Sources

$(DL)/tcl-$(TCL_TAG).tar.gz:
	mkdir -p $(DL)
	curl -sSfL -o $@.tmp $(TCL_URL)
	echo "$(TCL_SHA256)  $@.tmp" | sha256sum -c -
	mv $@.tmp $@

$(DL)/tk-$(TK_TAG).tar.gz:
	mkdir -p $(DL)
	curl -sSfL -o $@.tmp $(TK_URL)
	echo "$(TK_SHA256)  $@.tmp" | sha256sum -c -
	mv $@.tmp $@

fetch: $(DL)/tcl-$(TCL_TAG).tar.gz $(DL)/tk-$(TK_TAG).tar.gz ## download Tcl/Tk

# Pristine Tcl + overlay/tcl + the patch.  Re-run "make src" (after "make
# clean-src") when overlay/ or patches/ change.
$(TCL_SRC)/.prepared: $(DL)/tcl-$(TCL_TAG).tar.gz $(TCL_PATCH)
	rm -rf $(TCL_SRC)
	mkdir -p $(TCL_SRC)
	tar xzf $< -C $(TCL_SRC) --strip-components=1
	cp -R overlay/tcl/. $(TCL_SRC)/
	cd $(TCL_SRC) && patch -p1 --no-backup-if-mismatch < $(HERE)/$(TCL_PATCH)
	echo 'proc Lver {} { return "$(MAJOR).$(MINOR)" }' \
		> $(TCL_SRC)/library/Lver.tcl
	touch $@

$(TK_SRC)/.prepared: $(DL)/tk-$(TK_TAG).tar.gz
	rm -rf $(TK_SRC)
	mkdir -p $(TK_SRC)
	tar xzf $< -C $(TK_SRC) --strip-components=1
	touch $@

src: $(TCL_SRC)/.prepared $(TK_SRC)/.prepared ## unpack and patch the sources

#---------------------------------------------------------------------------
# Build

$(TCL_BUILD)/Makefile: $(TCL_SRC)/.prepared
	mkdir -p $(TCL_BUILD)
	cd $(TCL_BUILD) && $(TCL_SRC)/unix/configure $(COMMON_CONFIGURE) \
	    --with-system-libtommath=no --enable-pcre=default \
	    $(if $(PCRE_DIR),--with-pcre=$(PCRE_DIR)) $(TCL_CONFIGURE_OPTS)

tcl: $(TCL_BUILD)/Makefile ## build the L-enabled Tcl
	$(MAKE) -C $(TCL_BUILD) -j$(JOBS) binaries tcltest

$(TK_BUILD)/Makefile: $(TK_SRC)/.prepared $(TCL_BUILD)/Makefile
	mkdir -p $(TK_BUILD)
	cd $(TK_BUILD) && $(TK_SRC)/unix/configure $(COMMON_CONFIGURE) \
	    --with-tcl=$(TCL_BUILD) $(TK_CONFIGURE_OPTS)

tk: tcl $(TK_BUILD)/Makefile ## build Tk against it
	$(MAKE) -C $(TK_BUILD) -j$(JOBS) binaries

L: tcl ## build and stage L (bin/L)
	$(MAKE) -C $(TCL_BUILD) INSTALL_ROOT=$(STAGE) \
	    install-binaries install-libraries
	mv $(STAGE)$(PREFIX)/bin/tclsh$(TCL_VERSION) $(L)

L-gui: L tk ## build and stage L-gui (bin/L-gui)
	$(MAKE) -C $(TK_BUILD) INSTALL_ROOT=$(STAGE) \
	    install-binaries install-libraries
	mv $(STAGE)$(PREFIX)/bin/wish$(TCL_VERSION) $(L_GUI)

#---------------------------------------------------------------------------
# Tests

test: test-l ## run the L test suite

test-l: tcl ## run the L test suite
	ERROR_ON_FAILURES=1 $(MAKE) -C $(TCL_BUILD) test-l \
	    TESTFLAGS="$(TESTFLAGS)"

# The Tcl core suite, with Tcl's own RE engine as default (as for stock Tcl).
test-core: tcl ## run the Tcl core test suite
	TCL_REGEXP_CLASSIC=1 ERROR_ON_FAILURES=1 $(MAKE) -C $(TCL_BUILD) test-tcl \
	    TESTFLAGS="-notfile 'l-*.test' $(TESTFLAGS)"

examples: L ## compile all examples and run the runnable ones
	./ci/run-examples.sh $(L) $(TCL_SRC)

#---------------------------------------------------------------------------
# Docs and distribution

doc: L ## build the L reference (little.html)
	mkdir -p $(STAGE)$(PREFIX)/doc
	cd $(TCL_SRC)/doc/L && $(L) ./pod2html.l \
	    --title="L Programmer's Reference Guide" little.doc \
	    > $(STAGE)$(PREFIX)/doc/little.html

dist: all doc ## make a binary tarball in dist/
	rm -rf $(BUILD)/$(DIST_NAME)
	mkdir -p $(DIST) $(BUILD)/$(DIST_NAME)
	cp -R $(STAGE)$(PREFIX)/. $(BUILD)/$(DIST_NAME)/
	rm -rf $(BUILD)/$(DIST_NAME)/lib/*.a $(BUILD)/$(DIST_NAME)/lib/pkgconfig \
	    $(BUILD)/$(DIST_NAME)/lib/*.sh
	cp -R examples $(BUILD)/$(DIST_NAME)/
	cp README.md license.terms $(BUILD)/$(DIST_NAME)/
	tar czf $(DIST)/$(DIST_NAME).tar.gz -C $(BUILD) $(DIST_NAME)
	@echo "created $(DIST)/$(DIST_NAME).tar.gz"

install: all doc ## install to $(PREFIX)
	cp -R $(STAGE)$(PREFIX)/. $(DESTDIR)$(PREFIX)/

#---------------------------------------------------------------------------
# Development helpers

# Regenerate the pregenerated L parser/scanner (needs bison/flex) and copy
# them back into overlay/.
regen: $(TCL_BUILD)/Makefile ## regenerate L parser/scanner into overlay/
	$(MAKE) -C $(TCL_BUILD) L-gen
	cp $(TCL_SRC)/generic/Lgrammar-pregen.c $(TCL_SRC)/generic/Lgrammar.h \
	    $(TCL_SRC)/generic/Lscanner-pregen.c overlay/tcl/generic/

clean: ## remove builds (keeps downloads)
	rm -rf $(BUILD) $(DIST)

clean-src: ## remove the unpacked sources (forces re-patching)
	rm -rf $(SRC)

distclean: clean ## also remove downloads
	rm -rf $(DL)

.PHONY: all help fetch src tcl tk L L-gui test test-l test-core examples \
	doc dist install regen clean clean-src distclean
