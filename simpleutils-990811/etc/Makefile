# Generated automatically from Makefile.in by configure.
# 
# Makefile.in for etc
#

prefix 		= /home/zhangtian/simplescalar
exec_prefix 	= ${prefix}

srcdir  = .

bindir  = ${exec_prefix}/bin
libdir  = ${exec_prefix}/lib
tooldir = $(libdir)
datadir = ${prefix}/share

mandir  = ${prefix}/man
man1dir = $(mandir)/man1
man2dir = $(mandir)/man2
man3dir = $(mandir)/man3
man4dir = $(mandir)/man4
man5dir = $(mandir)/man5
man6dir = $(mandir)/man6
man7dir = $(mandir)/man7
man8dir = $(mandir)/man8
man9dir = $(mandir)/man9
infodir = ${prefix}/info

SHELL = /bin/sh

INSTALL 	= /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA    = ${INSTALL} -m 644

MAKEINFO = `if [ -f ../texinfo/makeinfo/makeinfo ]; \
	then echo ../texinfo/makeinfo/makeinfo; \
	else echo makeinfo; fi`
TEXI2DVI = `if [ -f ../texinfo/util/texi2dvi ]; \
	then echo ../texinfo/util/texi2dvi; \
	else echo texi2dvi; fi`
TEXI2HTML = texi2html
DVIPS = dvips

# Where to find texinfo.tex to format documentation with TeX.
TEXIDIR = $(srcdir)/../texinfo

#### Host, target, and site specific Makefile fragments come in here.
###

INFOFILES = standards.info configure.info
DVIFILES = standards.dvi configure.dvi

all:

install:

uninstall:

info:
	for f in $(INFOFILES); do \
	  if test -f $(srcdir)/`echo $$f | sed -e 's/.info$$/.texi/'`; then \
	    if $(MAKE) "MAKEINFO=$(MAKEINFO)" $$f; then \
	      true; \
	    else \
	      exit 1; \
	    fi; \
	  fi; \
	done

install-info: info
	$(SHELL) $(srcdir)/../mkinstalldirs $(infodir)
	if test ! -f standards.info; then cd $(srcdir); fi; \
	if test -f standards.info; then \
	  for i in standards.info*; do \
	    $(INSTALL_DATA) $$i $(infodir)/$$i; \
	  done; \
	fi
	if test ! -f configure.info; then cd $(srcdir); fi; \
	if test -f configure.info; then \
	  for i in configure.info*; do \
	    $(INSTALL_DATA) $$i $(infodir)/$$i; \
	  done; \
	fi

dvi:
	for f in $(DVIFILES); do \
	  if test -f $(srcdir)/`echo $$f | sed -e 's/.dvi$$/.texi/'`; then \
	    if $(MAKE) "TEXI2DVI=$(TEXI2DVI)" $$f; then \
	      true; \
	    else \
	      exit 1; \
	    fi; \
	  fi; \
	done

standards.info: $(srcdir)/standards.texi $(srcdir)/make-stds.texi
	$(MAKEINFO) --no-split -I$(srcdir) -o standards.info $(srcdir)/standards.texi

standards.dvi: $(srcdir)/standards.texi
	TEXINPUTS=$(TEXIDIR):$$TEXINPUTS $(TEXI2DVI) $(srcdir)/standards.texi

standards.ps: standards.dvi
	$(DVIPS) standards.dvi -o standards.ps

# makeinfo requires images to be in the current directory.
configure.info: $(srcdir)/configure.texi $(srcdir)/configdev.tin $(srcdir)/configbuild.tin
	rm -f configdev.txt configbuild.txt
	cp $(srcdir)/configdev.tin configdev.txt
	cp $(srcdir)/configbuild.tin configbuild.txt
	$(MAKEINFO) -I$(srcdir) -o configure.info $(srcdir)/configure.texi
	rm -f configdev.txt configbuild.txt

# texi2dvi wants both the .txt and the .eps files.
configure.dvi: $(srcdir)/configure.texi $(srcdir)/configdev.tin $(srcdir)/configbuild.tin $(srcdir)/configdev.ein $(srcdir)/configbuild.ein
	rm -f configdev.txt configbuild.txt
	cp $(srcdir)/configdev.tin configdev.txt
	cp $(srcdir)/configbuild.tin configbuild.txt
	rm -f configdev.eps configbuild.eps
	cp $(srcdir)/configdev.ein configdev.eps
	cp $(srcdir)/configbuild.ein configbuild.eps
	TEXINPUTS=$(TEXIDIR):$$TEXINPUTS $(TEXI2DVI) $(srcdir)/configure.texi
	rm -f configdev.txt configbuild.txt
	rm -f configdev.eps configbuild.eps

# dvips requires images to be in the current directory
configure.ps: configure.dvi $(srcdir)/configdev.ein $(srcdir)/configbuild.ein
	rm -f configdev.eps configbuild.eps
	cp $(srcdir)/configdev.ein configdev.eps
	cp $(srcdir)/configbuild.ein configbuild.eps
	$(DVIPS) configure.dvi -o configure.ps
	rm -f configdev.eps configbuild.eps

configure.html: $(srcdir)/configure.texi
	$(TEXI2HTML) -split_chapter $(srcdir)/configure.texi

clean:
	rm -f *.aux *.cp *.cps *.dvi *.fn *.fns *.ky *.kys *.log
	rm -f *.pg *.pgs *.toc *.tp *.tps *.vr *.vrs
	rm -f configdev.txt configbuild.txt configdev.eps configbuild.eps
	rm -f configdev.jpg configbuild.jpg

mostlyclean: clean

distclean:   clean
	rm -f Makefile config.status config.cache

maintainer-clean realclean:   distclean
	rm -f *.info*

Makefile: $(srcdir)/Makefile.in $(host_makefile_frag) $(target_makefile_frag)
	$(SHELL) ./config.status

## these last targets are for standards.texi conformance
dist:
check:
installcheck:
TAGS:
