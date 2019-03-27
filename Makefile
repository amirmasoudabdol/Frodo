#!/bin/bash

# This is a utility Makefile

ARCHIVEPATH=$(HOME)/archive

sam:
	mkdir -pv $(PROJECT)/build
	cmake -DENABLE_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -H$(HOME)/Projects/SAMpp -B$(PROJECT)/build 
	make -C $(PROJECT)/build

config:
	cp sam.jsonnet $(PROJECT)/$(PROJECT).jsonnet
	sed -ie 's/sam.libsonnet/$(PROJECT).libsonnet/g' $(PROJECT)/$(PROJECT).jsonnet
	sed -ie 's/hacks.libsonnet/$(PROJECT)_hacks.libsonnet/g' $(PROJECT)/$(PROJECT).jsonnet

	cp sam_local_run.sh $(PROJECT)/$(PROJECT)_local_run.sh
	cp sam_parallel_run.sh $(PROJECT)/$(PROJECT)_local_run.sh
	cp grid.R $(PROJECT)/$(PROJECT)_params_grid_generator.R

prepare:
	mkdir -pv $(PROJECT)/build
	mkdir -pv $(PROJECT)/configs
	mkdir -pv $(PROJECT)/outputs
	mkdir -pv $(PROJECT)/logs
	mkdir -pv $(PROJECT)/jobs
	mkdir -pv $(PROJECT)/dbs

	# Making SAM
	$(MAKE) sam

	# Add some scripts here to generate template files for their projects
	$(MAKE) config

clean:
	rm -vrf $(PROJECT)/build/*
	rm -vrf $(PROJECT)/configs/*
	rm -vrf $(PROJECT)/outputs/*
	rm -vrf $(PROJECT)/logs/*
	rm -vrf $(PROJECT)/jobs/*
	rm -vrf $(PROJECT)/dbs/*
	rm -vrf $(PROJECT)/slurm-*.out
	rm -rvf $(PROJECT)/*.jsonnet
	rm -rvf $(PROJECT)/*.libsonnet
	rm -rvf $(PROJECT)/*.R
	rm -rvf $(PROJECT)/*.sh

archive:
	mkdir -pv $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/build $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/configs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/outputs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/logs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/jobs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/dbs $(ARCHIVEPATH)/$(ARCHIVENAME)
