#!/bin/bash

# This is a utility Makefile

ARCHIVEPATH=$(HOME)/archive

sam:
	mkdir -pv $(PROJECT)/build
	cmake -DENABLE_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -H$(HOME)/Projects/SAMpp -B$(PROJECT)/build 
	make -C $(PROJECT)/build

prepare:
	mkdir -pv $(PROJECT)/build
	mkdir -pv $(PROJECT)/configs
	mkdir -pv $(PROJECT)/outputs
	mkdir -pv $(PROJECT)/logs
	mkdir -pv $(PROJECT)/jobs
	mkdir -pv $(PROJECT)/dbs

	# Add some scripts here to generate template files for their projects

clean:
	rm -vrf $(PROJECT)/build/*
	rm -vrf $(PROJECT)/configs/*
	rm -vrf $(PROJECT)/outputs/*
	rm -vrf $(PROJECT)/logs/*
	rm -vrf $(PROJECT)/jobs/*
	rm -vrf $(PROJECT)/dbs/*
	rm -vrf $(PROJECT)/slurm-*.out

archive:
	mkdir -pv $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/configs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/outputs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/logs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/jobs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/dbs $(ARCHIVEPATH)/$(ARCHIVENAME)
