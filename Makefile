#!/bin/bash

# This is a utility Makefile

ARCHIVEPATH=$(HOME)/archive
ppDIR=$(HOME)/Projects/SAMpp
ooDIR=$(HOME)/Projects/SAMoo
rrDIR=$(HOME)/Projects/SAMrr

help:
	@echo "Options: "
	@echo " - \`prepare\`: Prepare a project by running the following command after each other."
	@echo "   - \`config\`\tConfiguring necessary scripts and templates"
	@echo "   - \`sam\`\tBuild SAM's execcutable and place it at <project_yourprojectname>/build/"
	@echo " - \`clean\`\tClean the follwoing folders, outputs/, logs/, jobs/, configs/"
	@echo " - \`veryclean\`\tRemove almost everything inside the project folder."
	@echo " - \`remove\`\tRemove the entire project folder."
	@echo " - \`archive\`\tSave a copy of the project to another destination, set the ARCHIVEPATH variable in the command line."
	@echo ""
	@echo "Notes:"
	@echo " - Add the \`project_\` at the start of your project name."
	@echo ""
	@echo "Example:"
	@echo ""
	@echo "  > make <command> PROJECT=<project_yourprojectname>"


sam:
	mkdir -pv $(PROJECT)/build
	cmake -DENABLE_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -H$(HOME)/Projects/SAMpp -B$(PROJECT)/build 
	make -C $(PROJECT)/build

config:
	cp sam.jsonnet $(PROJECT)/$(PROJECT).jsonnet
	awk '{gsub(/sam.libsonnet/,"$(PROJECT).libsonnet");}1' $(PROJECT)/$(PROJECT).jsonnet > tmp && mv tmp $(PROJECT)/$(PROJECT).jsonnet
	awk '{gsub(/hacks.libsonnet/,"$(PROJECT)_hacks.libsonnet");}1' $(PROJECT)/$(PROJECT).jsonnet > tmp && mv tmp $(PROJECT)/$(PROJECT).jsonnet

	cp sam.libsonnet $(PROJECT)/$(PROJECT).libsonnet
	cp hacks.libsonnet $(PROJECT)/$(PROJECT)_hacks.libsonnet

	cp prep_json_file.sh $(PROJECT)/prep_json_file.sh
	awk '{gsub(/sam.jsonnet/,"$(PROJECT).jsonnet");}1' $(PROJECT)/prep_json_file.sh > tmp && mv tmp $(PROJECT)/prep_json_file.sh

	cp sam_local_run.sh $(PROJECT)/$(PROJECT)_local_run.sh
	cp sam_parallel_run.sh $(PROJECT)/$(PROJECT)_parallel_run.sh
	
	cp grid.R $(PROJECT)/$(PROJECT)_params_grid_generator.R

	rsync -r $(rrDIR)/* $(PROJECT)/rscripts/ --exclude .git

prepare:
	mkdir -pv $(PROJECT)/build
	mkdir -pv $(PROJECT)/configs
	mkdir -pv $(PROJECT)/outputs
	mkdir -pv $(PROJECT)/logs
	mkdir -pv $(PROJECT)/jobs
	mkdir -pv $(PROJECT)/dbs

	# Add some scripts here to generate template files for their projects
	$(MAKE) config

	# Making SAM
	$(MAKE) sam

veryclean:
	rm -vrf $(PROJECT)/build/*
	rm -vrf $(PROJECT)/configs/*
	rm -vrf $(PROJECT)/outputs/*
	rm -vrf $(PROJECT)/logs/*
	rm -vrf $(PROJECT)/jobs/*
	rm -vrf $(PROJECT)/dbs/*
	rm -vrf $(PROJECT)/rscripts/*
	rm -vrf $(PROJECT)/slurm-*.out
	rm -rvf $(PROJECT)/*.jsonnet
	rm -rvf $(PROJECT)/*.libsonnet
	rm -rvf $(PROJECT)/*.R
	rm -rvf $(PROJECT)/*.sh

clean:
	rm -vrf $(PROJECT)/configs/*
	rm -vrf $(PROJECT)/outputs/*
	rm -vrf $(PROJECT)/logs/*
	rm -vrf $(PROJECT)/jobs/

remove:
	rm -vrf $(PROJECT)

archive:
	mkdir -pv $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/build $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/configs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/outputs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/logs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/jobs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/dbs $(ARCHIVEPATH)/$(ARCHIVENAME)
