#!/bin/bash

ARCHIVEPATH=$(HOME)/Projects/archive

prepare:
	mkdir -pv $(PROJECT)/configs
	mkdir -pv $(PROJECT)/outputs
	mkdir -pv $(PROJECT)/logs
	mkdir -pv $(PROJECT)/jobs
	mkdir -pv $(PROJECT)/dbs

clean:
	rm -vrf $(PROJECT)configs/*
	rm -vrf $(PROJECT)outputs/*
	rm -vrf $(PROJECT)logs/*
	rm -vrf $(PROJECT)jobs/*
	rm -vrf $(PROJECT)dbs/*

archive:
	mkdir -pv $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/configs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/outputs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/logs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/jobs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/dbs $(ARCHIVEPATH)/$(ARCHIVENAME)
