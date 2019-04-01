.DEFAULT_GOAL:=help
SHELL:=/bin/bash

# This is a utility Makefile

ARCHIVEPATH=$(HOME)/archive
ppDIR=$(HOME)/Projects/SAMpp
ooDIR=$(HOME)/Projects/SAMoo
rrDIR=$(HOME)/Projects/SAMrr

.PHONY: help sam config

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target> PROJECT=<yourprojectname>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Build

prepare: ## Create a new project by running <config> and <sam>
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

config: ## Building necessary files and folders for a new project
	cp sam.jsonnet $(PROJECT)/$(PROJECT).jsonnet
	awk '{gsub(/sam.libsonnet/,"$(PROJECT).libsonnet");}1' $(PROJECT)/$(PROJECT).jsonnet > tmp && mv tmp $(PROJECT)/$(PROJECT).jsonnet
	awk '{gsub(/hacks.libsonnet/,"$(PROJECT)_hacks.libsonnet");}1' $(PROJECT)/$(PROJECT).jsonnet > tmp && mv tmp $(PROJECT)/$(PROJECT).jsonnet

	cp sam.libsonnet $(PROJECT)/$(PROJECT).libsonnet
	cp hacks.libsonnet $(PROJECT)/$(PROJECT)_hacks.libsonnet

	cp prep_json_file.sh $(PROJECT)/prep_json_file.sh
	awk '{gsub(/sam.jsonnet/,"$(PROJECT).jsonnet");}1' $(PROJECT)/prep_json_file.sh > tmp && mv tmp $(PROJECT)/prep_json_file.sh
	chmod +x $(PROJECT)/prep_json_file.sh

	cp grid.R $(PROJECT)/$(PROJECT)_params_grid_generator.R
	chmod +x $(PROJECT)/$(PROJECT)_params_grid_generator.R
	
	rsync -r $(rrDIR)/* $(PROJECT)/rscripts/ --exclude .git

	cp sam_local_run.sh $(PROJECT)/$(PROJECT)_local_run.sh
	chmod +x $(PROJECT)/$(PROJECT)_local_run.sh
	
	cp sam_parallel_run.sh $(PROJECT)/$(PROJECT)_parallel_run.sh
	awk '{gsub(/yourprojectname/,"$(PROJECT)");}1' $(PROJECT)/$(PROJECT)_parallel_run.sh > tmp && mv tmp $(PROJECT)/$(PROJECT)_parallel_run.sh
	chmod +x $(PROJECT)/$(PROJECT)_parallel_run.sh

	cp r_job_temp.sh $(PROJECT)/r_job_temp.sh
	awk '{gsub(/yourprojectname/,"$(PROJECT)");}1' $(PROJECT)/r_job_temp.sh > tmp && mv tmp $(PROJECT)/r_job_temp.sh
	chmod +x $(PROJECT)/r_job_temp.sh

sam: ## Build SAMpp executable. Makefile will look for ../SAMpp directory first
	mkdir -pv $(PROJECT)/build
	cmake -DENABLE_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -H$(HOME)/Projects/SAMpp -B$(PROJECT)/build 
	make -C $(PROJECT)/build
	# TODO: Move SAM to the project directory as well


##@ Cleanup

veryclean: ## Remove all project files
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

clean: ## Remove all output files, i.e., configs, outputs, logs, jobs
	rm -vrf $(PROJECT)/configs/*
	rm -vrf $(PROJECT)/outputs/*
	rm -vrf $(PROJECT)/logs/*
	rm -vrf $(PROJECT)/jobs/*

remove: ## Delete the entire project directory
	rm -vrf $(PROJECT)

##@ Archiving

archive: ## Copy the entire project to the given destination <ARCHIVEPATH>
	mkdir -pv $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/build $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/configs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/outputs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/logs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/jobs $(ARCHIVEPATH)/$(ARCHIVENAME)
	mv -v $(PROJECT)/dbs $(ARCHIVEPATH)/$(ARCHIVENAME)
