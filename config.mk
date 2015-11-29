INSTALLDIR := /opt/edutex

TEX          := pdftex
SH           := sh
RM           := rm -f 

RMFILES      := *.dvi *.fls *.log #*.pdf

TEXFLAGS     := -recorder -shell-escape -file-line-error  
TEXOUTPUT    := -output-format pdf
TEXFMT       := -fmt=edutex

MAKE_PATH    := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TEX_PATH     := $(MAKE_PATH)tex/
TEX_FONT     := $(MAKE_PATH)tex/fonts/
TEX_FORMAT   := $(MAKE_PATH)tex/


### RULES ###
%.make: %
	@echo $(CURR_PATH)
	make -C $<
	touch $@

%.clean: %
	make -C $< clean
	$(RM)  $<.make

%.install: %
	make -C $< install


%.fmt: %.fmt.tex
	export TEXINPUTS=.:$(TEX_PATH):$(TEXINPUTS)&& \
	pdftex -ini $(TEXFLAGS) $<&& \
	mv $@.fmt $@
	#export TFMFONTS=.:$(TEX_FONT):$(TFMFONTS)&& \
	export ENCFONTS=.:$(TEX_FONT):$(ENCFONTS) && \
	export TEXFONTMAPS=.:$(TEX_FONT):$(TEXFONTMAPS) && \
	export T1FONTS=.:$(TEX_FONT):$(T1FONTS) && \
	export TFMFONTS=.:$(TEX_FONT):$(TFMFONTS) && \

%.pdf: %.tex $(FORMAT)
	export TEXINPUTS=.:$(TEX_PATH):$(TEXINPUTS)&& \
	export TEXFORMATS=.:$(TEX_FORMAT):$(TEXFORMATS) && \
	pdftex $(TEXFMT) $(TEXOUTPUT) $(TEXFLAGS) $<
	#export TFMFONTS=.:$(TEX_FONT):$(TFMFONTS)&& \
	export ENCFONTS=.:$(TEX_FONT):$(ENCFONTS) && \
	export TEXFONTMAPS=.:$(TEX_FONT):$(TEXFONTMAPS) && \
	export T1FONTS=.:$(TEX_FONT):$(T1FONTS) && \
	export TFMFONTS=.:$(TEX_FONT):$(TFMFONTS) && 
