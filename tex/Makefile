# This is the Makefile for EduTeX format

include ../config.mk

FORMAT := edutex.fmt
SRC    := edutex.fmt.tex

all: $(FORMAT)

clean:
	$(RM) $(RMFILES) $(FORMAT)  

install:
	install -d . $(INSTALLDIR)/tex
	install -v -m 644 *.tex $(INSTALLDIR)/tex
	install -v -m 644 edutex.fmt $(INSTALLDIR)/tex 
