.DEFAULT_GOAL:=help
SHELL:=/bin/bash

# This is a utility Makefile

ARCHIVEPATH=$(HOME)/archive
ppDIR=$(HOME)/Projects/SAMpp
ooDIR=$(HOME)/Projects/SAMoo
rrDIR=$(HOME)/Projects/SAMrr

.PHONY: help sam config

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target> PROJECT=<yourprojectname> ARCHIVEPATH=<yourarchivedirectory>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Build

prepare: ## Create a new project by running <config> and <sam>
	mkdir -pv projects/$(PROJECT)/build
	mkdir -pv projects/$(PROJECT)/configs
	
	mkdir -pv projects/$(PROJECT)/outputs
	mkdir -pv projects/$(PROJECT)/logs
	mkdir -pv projects/$(PROJECT)/jobs
	mkdir -pv projects/$(PROJECT)/dbs

	# Add some scripts here to generate template files for their projects
	$(MAKE) config

	# Making SAM
	$(MAKE) sam

config: ## Building necessary files and folders for a new project
	cp sam.jsonnet projects/$(PROJECT)/$(PROJECT).jsonnet
	awk '{gsub(/sam.libsonnet/,"$(PROJECT).libsonnet");}1' projects/$(PROJECT)/$(PROJECT).jsonnet > tmp && mv tmp projects/$(PROJECT)/$(PROJECT).jsonnet
	awk '{gsub(/hacks.libsonnet/,"$(PROJECT)_hacks.libsonnet");}1' projects/$(PROJECT)/$(PROJECT).jsonnet > tmp && mv tmp projects/$(PROJECT)/$(PROJECT).jsonnet

	cp sam.libsonnet projects/$(PROJECT)/$(PROJECT).libsonnet
	cp hacks.libsonnet projects/$(PROJECT)/$(PROJECT)_hacks.libsonnet

	cp prep_json_file.sh projects/$(PROJECT)/prep_json_file.sh
	awk '{gsub(/sam.jsonnet/,"$(PROJECT).jsonnet");}1' projects/$(PROJECT)/prep_json_file.sh > tmp && mv tmp projects/$(PROJECT)/prep_json_file.sh
	chmod +x projects/$(PROJECT)/prep_json_file.sh

	cp grid.R projects/$(PROJECT)/$(PROJECT)_params_grid_generator.R
	chmod +x projects/$(PROJECT)/$(PROJECT)_params_grid_generator.R
	
	rsync -r $(rrDIR)/* projects/$(PROJECT)/rscripts/ --exclude .git

	cp sam_local_run.sh projects/$(PROJECT)/$(PROJECT)_local_run.sh
	chmod +x projects/$(PROJECT)/$(PROJECT)_local_run.sh
	
	cp sam_parallel_run.sh projects/$(PROJECT)/$(PROJECT)_parallel_run.sh
	awk '{gsub(/yourprojectname/,"$(PROJECT)");}1' projects/$(PROJECT)/$(PROJECT)_parallel_run.sh > tmp && mv tmp projects/$(PROJECT)/$(PROJECT)_parallel_run.sh
	chmod +x projects/$(PROJECT)/$(PROJECT)_parallel_run.sh

	cp r_job_temp.sh projects/$(PROJECT)/r_job_temp.sh
	awk '{gsub(/yourprojectname/,"$(PROJECT)");}1' projects/$(PROJECT)/r_job_temp.sh > tmp && mv tmp projects/$(PROJECT)/r_job_temp.sh
	chmod +x projects/$(PROJECT)/r_job_temp.sh

	cp to_sqlite.sh projects/$(PROJECT)/$(PROJECT)_to_sqlite.sh
	awk '{gsub(/yourprojectname/,"$(PROJECT)");}1' projects/$(PROJECT)/$(PROJECT)_to_sqlite.sh > tmp && mv tmp projects/$(PROJECT)/$(PROJECT)_to_sqlite.sh
	chmod +x projects/$(PROJECT)/$(PROJECT)_to_sqlite.sh

	cp to_sqlite.py projects/$(PROJECT)/$(PROJECT)_to_sqlite.py
	awk '{gsub(/yourprojectname/,"$(PROJECT)");}1' projects/$(PROJECT)/$(PROJECT)_to_sqlite.py > tmp && mv tmp projects/$(PROJECT)/$(PROJECT)_to_sqlite.py
	chmod +x projects/$(PROJECT)/$(PROJECT)_to_sqlite.py

	cp tables.sql projects/$(PROJECT)/tables.sql


sam: ## Build SAMpp executable. Makefile will look for ../SAMpp directory first
	mkdir -pv projects/$(PROJECT)/build
	cmake -DENABLE_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -H$(HOME)/Projects/SAMpp -Bprojects/$(PROJECT)/build 
	make -C projects/$(PROJECT)/build
	# TODO: Move SAM to the project directory as well


##@ Cleanup


clean: ## Remove all output files, i.e., configs, outputs, logs, jobs
	rm -vrf projects/$(PROJECT)/configs/*
	rm -vrf projects/$(PROJECT)/outputs/*
	rm -vrf projects/$(PROJECT)/logs/*
	rm -vrf projects/$(PROJECT)/jobs/*

veryclean: ## Remove all project files
	rm -vrf projects/$(PROJECT)/build/*
	rm -vrf projects/$(PROJECT)/configs/*
	rm -vrf projects/$(PROJECT)/outputs/*
	rm -vrf projects/$(PROJECT)/logs/*
	rm -vrf projects/$(PROJECT)/jobs/*
	rm -vrf projects/$(PROJECT)/dbs/*
	rm -vrf projects/$(PROJECT)/rscripts/*
	rm -vrf projects/$(PROJECT)/slurm-*.out
	rm -rvf projects/$(PROJECT)/*.jsonnet
	rm -rvf projects/$(PROJECT)/*.libsonnet
	rm -rvf projects/$(PROJECT)/*.R
	rm -rvf projects/$(PROJECT)/*.sh

remove: ## Delete the entire project directory
	rm -vrf projects/$(PROJECT)

##@ Archiving

archive: ## Copy the entire project to the given destination. You must provide both <PROJECT> <ARCHIVEPATH> parameters
	mkdir -pv $(ARCHIVEPATH)/$(PROJECT)
	cp -rv projects/$(PROJECT) $(ARCHIVEPATH)/$(PROJECT)
