# This is the Makefile for EduTeX

include config.mk

MAKES   := tex.make examples.make priv.make
CLEAN   := $(MAKES:.make=.clean)
INSTALL := $(MAKES:.make=.install)

all: $(MAKES)

clean: $(CLEAN)

install: $(INSTALL) 

