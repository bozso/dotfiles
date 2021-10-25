.PHONY: install
premake ?= cd configs/manage && premake5

install:
	$(premake) all

list_paths:
	$(premake) bin_paths

gen_path:
	$(premake) gen_path
