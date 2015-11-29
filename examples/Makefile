# This is the Makefile for EduTeX examples

include ../config.mk

PDF := helloworld.pdf utf.pdf chardef.pdf worksheet.pdf accent.pdf series.pdf

all: $(PDF)

clean:
	$(RM) $(RMFILES) $(PDF)

install: 
	install -d .  $(INSTALLDIR)/examples
	install -v -m 644 *.tex $(INSTALLDIR)/examples
	install -v -m 644 *.pdf $(INSTALLDIR)/examples

