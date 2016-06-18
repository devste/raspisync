# Top-level Makefile for Raspisync

.PHONY: all prepare build clean
all: build

prepare:
	$(MAKE) -C buildroot BR2_EXTERNAL=../br2_external_raspisync raspi2sync_defconfig

build:
	$(MAKE) -C buildroot

clean:
	$(MAKE) -C buildroot clean
