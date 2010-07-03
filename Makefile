PKGNAME=pkgnet
SRCDIR=$(shell pwd)
DATE=$(shell date)
INSTALLDIR=$(shell dirname $(SRCDIR))/bin
CHECKDIR=$(shell dirname $(SRCDIR))
RCALL=R CMD
PKGPDF=$(PKGNAME:=.pdf)
PKGDVI=$(PKGNAME:=.dvi)



.PHONY: svninfo
svninfo:
	cp inst/SVNINFO inst/SVNINFO.in
	sed -e "1,1s/.*/`date`/" inst/SVNINFO.in > inst/SVNINFO
	rm inst/SVNINFO.in

.PHONY: check
check: svninfo
	$(RCALL) check -o $(CHECKDIR) $(CURDIR)

.PHONY: build
build: svninfo
	$(RCALL) build $(SRCDIR)
	mv $(PKGNAME)*tar.gz $(shell dirname $(SRCDIR))/

.PHONY: install
install: svninfo
	mkdir -p $(INSTALLDIR)
	$(RCALL) INSTALL -l $(INSTALLDIR) $(SRCDIR)


.PHONY: checkcode
checkcode:
	$(RCALL) check  --no-codoc --no-vignettes --no-latex -o $(CHECKDIR) $(SRCDIR)

.PHONY: checkdoc
checkdoc:
	$(RCALL) check --no-tests --no-install -o $(CHECKDIR) $(SRCDIR)

.PHONY: cleanall
cleanall:
	- rm -f $(CHECKDIR) $(PKGPDF) $(PKGDVI)

.PHONY: uninstall
uninstall:
	- rm -R --force $(INSTALLDIR)

# package manuals

.PHONY: pdf
pdf: $(PKGPDF)

$(PKGPDF): $(SRCDIR:=/man/*.Rd)
	$(RCALL) Rd2pdf --no-preview -o $(shell dirname $(SRCDIR))/$(PKGPDF) $(SRCDIR)

.PHONY: dvi
dvi: $(PKGDVI)

$(PKGDVI): $(SRCDIR:=/man/*.Rd)
	$(RCALL) Rd2dvi --no-preview -o $(shell dirname $(SRCDIR))/$(PKGDVI) $(SRCDIR)
