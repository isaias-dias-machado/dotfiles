SHELL := /bin/bash
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
path := $(dir $(mkfile_path))

install: chp.sh chp.awk install.awk
	gawk -f install.awk ~/.bashrc $(path) >> ~/.bashrc	
	source $(path)chp.sh
