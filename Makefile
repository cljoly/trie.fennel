fnl_files = $(wildcard *.fnl)
out_files = $(fnl_files:%.fnl=lua/%.lua)
test_files = $(wildcard tests/*.fnl)

all: $(out_files)

fmt: $(fnl_files)
	fnlfmt --fix $<

lua/%.lua: %.fnl lua/
	fennel --raw-errors --compile $< > $@

lua/:
	mkdir -p lua

clean:
	rm -rf lua

test: $(test_files)
	fennel $<

.PHONY: clean fmt all
