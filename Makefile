fnl_files = $(wildcard *.fnl)
out_files = $(fnl_files:%.fnl=lua/%.lua)
fnl_test_files = $(wildcard tests/*.fnl)

all: $(out_files)

fmt: $(fnl_files)
	fnlfmt --fix $<

lua/%.lua: %.fnl lua/
	@echo "-- Copyright 2023 Clément Joly <foss@131719.xyz>" > $@
	@echo "" >> $@
	@echo "-- This Source Code Form is subject to the terms of the Mozilla Public" >> $@
	@echo "-- License, v. 2.0. If a copy of the MPL was not distributed with this" >> $@
	@echo "-- file, You can obtain one at http://mozilla.org/MPL/2.0/." >> $@
	fennel --raw-errors --globals "" --compile $< >> $@

lua/:
	mkdir -p lua

clean:
	rm -rf lua

test: $(fnl_test_files)
	fennel $<

.PHONY: test clean fmt all
