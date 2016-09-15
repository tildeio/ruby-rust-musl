# Absolute root of the project
ROOT := $(shell cd $(dir $(firstword $(MAKEFILE_LIST))) && pwd)

HOST = x86_64-linux

# Extra flags we want when compiling libs
CFLAGS := -g -O0 -fPIC -ffunction-sections -fdata-sections

TARGET = $(ROOT)/$(HOST)

MUSL_VER = musl-1.1.15
MUSL_URL = https://www.musl-libc.org/releases/$(MUSL_VER).tar.gz
MUSL_DIR = $(HOST)/$(MUSL_VER)


all: musl

$(HOST):
	mkdir -p $(HOST)

#
#
# ==== musl ====
#
#

$(MUSL_VER).tar.gz: | $(HOST)
	curl -L "$(MUSL_URL)" > $(MUSL_VER).tar.gz

$(MUSL_DIR): $(MUSL_VER).tar.gz
	tar -xzv -C $(HOST) -f $<

$(HOST)/bin/musl $(MUSL_DIR)/lib/libc.a: | $(MUSL_DIR)
	cd $(MUSL_DIR) && \
		CFLAGS="$(CFLAGS)" ./configure --prefix=$(TARGET)/musl --disable-shared --enable-gcc-wrapper && \
		make && make install

$(HOST)/libc.a: $(MUSL_DIR)/lib/libc.a
	cp $< $@

musl: $(HOST)/bin/musl $(HOST)/libc.a



clean:
	rm -rf $(HOST)/*.a
	rm -rf $(MUSL_DIR)
	rm -rf $(HOST)/musl

.PHONY: all clean musl

.SUFFIXES:
