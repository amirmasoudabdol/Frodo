.DEFAULT_GOAL:=help
SHELL:=/bin/bash

# This is a utility Makefile

archivepath=$(HOME)/archive
ppDIR=$(HOME)/Projects/SAMpp
ooDIR=$(HOME)/Projects/SAMoo
rrDIR=$(HOME)/Projects/SAMrr

path=""
ifeq ($(path),"")
	path=$(shell pwd)/projects
else
	path=$(path)
endif

.PHONY: help sam config

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target> name=<yourprojectname> path=<projectpath> archivepath=<yourarchivedirectory>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Build

project: ## Create a new project by running <config> and <sam>
	mkdir -pv $(path)/$(name)/build
	mkdir -pv $(path)/$(name)/configs
	
	mkdir -pv $(path)/$(name)/outputs
	mkdir -pv $(path)/$(name)/logs
	mkdir -pv $(path)/$(name)/jobs
	mkdir -pv $(path)/$(name)/dbs

	# Creating a separate directory for storing temporary file as well as analysis
	# Removing the project doesn't remove this folder.
	mkdir -pv $(path)/$(name)_analysis

	# Add some scripts here to generate template files for their projects
	$(MAKE) config

	# Making SAM
	$(MAKE) sam

config: ## Building necessary files and folders for a new project
	
	rsync -r $(rrDIR)/* $(path)/$(name)/rscripts/ --exclude .git

	cp sam_local_seq_run.sh $(path)/$(name)/$(name)_local_seq_run.sh
	chmod +x $(path)/$(name)/$(name)_local_seq_run.sh

	cp sam_local_par_run.sh $(path)/$(name)/$(name)_local_par_run.sh
	chmod +x $(path)/$(name)/$(name)_local_par_run.sh
	
	cp sam_lisa_par_run.sh $(path)/$(name)/$(name)_lisa_par_run.sh
	awk '{gsub(/yourprojectname/,"$(name)");}1' $(path)/$(name)/$(name)_lisa_par_run.sh > tmp && mv tmp $(path)/$(name)/$(name)_lisa_par_run.sh
	chmod +x $(path)/$(name)/$(name)_lisa_par_run.sh

	cp r_job_temp.sh $(path)/$(name)/r_job_temp.sh
	awk '{gsub(/yourprojectname/,"$(name)");}1' $(path)/$(name)/r_job_temp.sh > tmp && mv tmp $(path)/$(name)/r_job_temp.sh
	chmod +x $(path)/$(name)/r_job_temp.sh

	cp to_sqlite.sh $(path)/$(name)/$(name)_to_sqlite.sh
	awk '{gsub(/yourprojectname/,"$(name)");}1' $(path)/$(name)/$(name)_to_sqlite.sh > tmp && mv tmp $(path)/$(name)/$(name)_to_sqlite.sh
	chmod +x $(path)/$(name)/$(name)_to_sqlite.sh

	cp to_sqlite.py $(path)/$(name)/$(name)_to_sqlite.py
	awk '{gsub(/yourprojectname/,"$(name)");}1' $(path)/$(name)/$(name)_to_sqlite.py > tmp && mv tmp $(path)/$(name)/$(name)_to_sqlite.py
	chmod +x $(path)/$(name)/$(name)_to_sqlite.py

	# Configuration File and Scripts
	cp config_template.json $(path)/$(name)/$(name)_config_template.json
	awk '{gsub(/yourprojectname/,"$(name)");}1' $(path)/$(name)/$(name)_config_template.json > tmp && mv tmp $(path)/$(name)/$(name)_config_template.json

	cp params.py $(path)/$(name)/$(name)_params.py
	awk '{gsub(/yourprojectname/,"$(name)");}1' $(path)/$(name)/$(name)_params.py > tmp && mv tmp $(path)/$(name)/$(name)_params.py

	cp prepare_config_files.py $(path)/$(name)/$(name)_prepare_config_files.py
	awk '{gsub(/yourprojectname/,"$(name)");}1' $(path)/$(name)/$(name)_prepare_config_files.py > tmp && mv tmp $(path)/$(name)/$(name)_prepare_config_files.py
	chmod +x $(path)/$(name)/$(name)_prepare_config_files.py

	# Prepare the Project Makefile
	cp ProjectMakefileTemplate $(path)/$(name)/Makefile
	awk '{gsub(/yourprojectname/,"$(name)");}1' $(path)/$(name)/Makefile > tmp && mv tmp $(path)/$(name)/Makefile


sam: ## Build SAMrun executable. Makefile will look for ../SAMrun directory first
	mkdir -pv $(path)/$(name)/build
	cmake -DCMAKE_BUILD_TYPE=Release -H$(HOME)/Projects/SAMrun -B$(path)/$(name)/build 
	cmake --build $(path)/$(name)/build --parallel 10

##@ Cleanup


clean: ## Remove all output files, i.e., configs, outputs, logs, jobs
	rm -vrf $(path)/$(name)/configs/*
	rm -vrf $(path)/$(name)/logs/*
	rm -vrf $(path)/$(name)/jobs/*

veryclean: clean ## Remove all project files
	rm -vrf $(path)/$(name)/build/*
	rm -vrf $(path)/$(name)/outputs/*
	rm -vrf $(path)/$(name)/dbs/*
	rm -vrf $(path)/$(name)/rscripts/*
	rm -vrf $(path)/$(name)/slurm-*.out
	rm -rvf $(path)/$(name)/*.json
	rm -rvf $(path)/$(name)/*.R
	rm -rvf $(path)/$(name)/*.sh

remove: ## Delete the entire project directory
	rm -vrf $(path)/$(name)

##@ Archiving

archive: ## Copy the entire project to the given destination. You must provide both <PROJECT> <archivepath> parameters
	mkdir -pv $(archivepath)/$(name)
	cp -rv $(path)/$(name) $(archivepath)/$(name)
