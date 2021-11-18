.PHONY: install
plz ?= please

.PHONY: install

help:
	$(premake) --help

install:
	$(plz) build

gen_path: install
	python gen_paths.py
