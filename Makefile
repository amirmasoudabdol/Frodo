.DEFAULT_GOAL:=help
SHELL:=/bin/bash

# This is a utility Makefile

archivepath=$(HOME)/archive
ppDIR=$(HOME)/Projects/SAMpp
ooDIR=$(HOME)/Projects/SAMoo
rrDIR=$(HOME)/Projects/SAMrr

.PHONY: help sam config

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target> project=<yourprojectname> archivepath=<yourarchivedirectory>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Build

prepare: ## Create a new project by running <config> and <sam>
	mkdir -pv projects/$(project)/build
	mkdir -pv projects/$(project)/configs
	
	mkdir -pv projects/$(project)/outputs
	mkdir -pv projects/$(project)/logs
	mkdir -pv projects/$(project)/jobs
	mkdir -pv projects/$(project)/dbs

	# Add some scripts here to generate template files for their projects
	$(MAKE) config

	# Making SAM
	$(MAKE) sam

config: ## Building necessary files and folders for a new project
	
	rsync -r $(rrDIR)/* projects/$(project)/rscripts/ --exclude .git

	cp sam_local_seq_run.sh projects/$(project)/$(project)_local_seq_run.sh
	chmod +x projects/$(project)/$(project)_local_seq_run.sh

	cp sam_local_par_run.sh projects/$(project)/$(project)_local_par_run.sh
	chmod +x projects/$(project)/$(project)_local_par_run.sh
	
	cp sam_parallel_run.sh projects/$(project)/$(project)_parallel_run.sh
	awk '{gsub(/yourprojectname/,"$(project)");}1' projects/$(project)/$(project)_parallel_run.sh > tmp && mv tmp projects/$(project)/$(project)_parallel_run.sh
	chmod +x projects/$(project)/$(project)_parallel_run.sh

	cp r_job_temp.sh projects/$(project)/r_job_temp.sh
	awk '{gsub(/yourprojectname/,"$(project)");}1' projects/$(project)/r_job_temp.sh > tmp && mv tmp projects/$(project)/r_job_temp.sh
	chmod +x projects/$(project)/r_job_temp.sh

	cp to_sqlite.sh projects/$(project)/$(project)_to_sqlite.sh
	awk '{gsub(/yourprojectname/,"$(project)");}1' projects/$(project)/$(project)_to_sqlite.sh > tmp && mv tmp projects/$(project)/$(project)_to_sqlite.sh
	chmod +x projects/$(project)/$(project)_to_sqlite.sh

	cp to_sqlite.py projects/$(project)/$(project)_to_sqlite.py
	awk '{gsub(/yourprojectname/,"$(project)");}1' projects/$(project)/$(project)_to_sqlite.py > tmp && mv tmp projects/$(project)/$(project)_to_sqlite.py
	chmod +x projects/$(project)/$(project)_to_sqlite.py

	# Configuration File and Scripts
	cp config_template.json projects/$(project)/$(project)_config_template.json
	awk '{gsub(/yourprojectname/,"$(project)");}1' projects/$(project)/$(project)_config_template.json > tmp && mv tmp projects/$(project)/$(project)_config_template.json

	cp params.py projects/$(project)/$(project)_params.py
	awk '{gsub(/yourprojectname/,"$(project)");}1' projects/$(project)/$(project)_params.py > tmp && mv tmp projects/$(project)/$(project)_params.py

	cp prepare_config_files.py projects/$(project)/$(project)_prepare_config_files.py
	awk '{gsub(/yourprojectname/,"$(project)");}1' projects/$(project)/$(project)_prepare_config_files.py > tmp && mv tmp projects/$(project)/$(project)_prepare_config_files.py
	chmod +x projects/$(project)/$(project)_prepare_config_files.py

	# Prepare the Project Makefile
	cp ProjectMakefileTemplate projects/$(project)/Makefile
	awk '{gsub(/yourprojectname/,"$(project)");}1' projects/$(project)/Makefile > tmp && mv tmp projects/$(project)/Makefile

	cp tables.sql projects/$(project)/tables.sql


sam: ## Build SAMrun executable. Makefile will look for ../SAMrun directory first
	mkdir -pv projects/$(project)/build
	cmake -DCMAKE_BUILD_TYPE=Release -H$(HOME)/Projects/SAMrun -Bprojects/$(project)/build 
	make -j8 -C projects/$(project)/build

##@ Cleanup


clean: ## Remove all output files, i.e., configs, outputs, logs, jobs
	rm -vrf projects/$(project)/configs/*
	rm -vrf projects/$(project)/logs/*
	rm -vrf projects/$(project)/jobs/*

veryclean: clean ## Remove all project files
	rm -vrf projects/$(project)/build/*
	rm -vrf projects/$(project)/outputs/*
	rm -vrf projects/$(project)/dbs/*
	rm -vrf projects/$(project)/rscripts/*
	rm -vrf projects/$(project)/slurm-*.out
	rm -rvf projects/$(project)/*.json
	rm -rvf projects/$(project)/*.R
	rm -rvf projects/$(project)/*.sh

remove: ## Delete the entire project directory
	rm -vrf projects/$(project)

##@ Archiving

archive: ## Copy the entire project to the given destination. You must provide both <PROJECT> <archivepath> parameters
	mkdir -pv $(archivepath)/$(project)
	cp -rv projects/$(project) $(archivepath)/$(project)
