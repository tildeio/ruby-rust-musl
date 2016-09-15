# Absolute root of the project
ROOT := $(shell cd $(dir $(firstword $(MAKEFILE_LIST))) && pwd)

HOST = x86_64-linux
RS_HOST = x86_64-unknown-linux-musl

DEP_DIR ?= $(ROOT)/deps/$(HOST)

COMPILER = $(DEP_DIR)/musl/bin/musl-gcc -g
LD_OPTS = -Wl,--gc-sections -Wl,--version-script ./rustextension.map
DEPS = $(addprefix $(DEP_DIR)/, libc.a)
DIST ?= target/dist
CARGO_EXTRA_ARGS = --release
CARGO_BUILD_DIR = release

TARGET  ?= $(DIST)/$(HOST)
OBJ_DIR := $(TARGET)/objs

all: $(TARGET)/librustextension.so

clean:
	rm -rf $(TARGET)
	rm -rf target/$(RS_HOST)/release/librustextension-*.a


#
#
# ===== extension =====
#
#

Cargo.lock:

$(DEPS): | $(OBJ_DIR)

$(ROOT)/bin/ld:
	mkdir -p bin
	ln -s `which gold` $@

$(TARGET)/librustextension.a: $(TARGET) Cargo.lock
	$(CARGO_EXTRA_ENV) cargo build --verbose $(CARGO_EXTRA_ARGS) --target $(RS_HOST)
	cp target/$(RS_HOST)/$(CARGO_BUILD_DIR)/librustextension.a $(TARGET)/librustextension.a

$(TARGET)/objs/rustextension.timestamp: $(TARGET)/librustextension.a $(DEPS) | $(OBJ_DIR)
	cd $(OBJ_DIR) && echo "../librustextension.a $(DEPS)" | xargs -n 1 ar x
	touch $@

$(TARGET)/librustextension.so: $(TARGET)/objs/rustextension.timestamp | $(ROOT)/bin/ld
	PATH="$(ROOT)/bin:${PATH}" $(COMPILER) --shared -Wall -o $@ $(TARGET)/objs/*.o $(LD_OPTS)

$(OBJ_DIR):
	mkdir -p $@
	rm -rf $@/*.o

$(TARGET):
	mkdir -p $@


.PHONY: all clean

.SUFFIXES:
