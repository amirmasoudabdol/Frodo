.DEFAULT_GOAL:=help
SHELL:=/bin/bash

# This is a utility Makefile

SAMpp_DIR=$(HOME)/Projects/SAMpp
mvrandom_DIR=$(HOME)/Projects/mvrandom
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
	@echo "This is SAMoo, a handy toolset for preparing a new project using SAM."
	@echo "In the process of 'prepare'-ing a new project, this Makefile produces"
	@echo "several template files for configuring and running a SAM project on"
	@echo "your local machine or on Lisa cluster."
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target> parameter=value \033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo
	@echo "Example Usage:"
	@echo "    make prepare project=apollo path=HOME/Projects/"
	@echo "    make remove  project=apollo"

##@   [Parameters]

project: ## Project name
	@echo "The 'project' target is a parameter, example usage: 'make prepare project=apollo'"

path: ## Project path, defaults to ./projects/
	@echo "The 'project' target is a parameter, example usage: 'make prepare project=apollo path='~/projects/'"

##@ Build

prepare: ## Create a new project by running <config> and <sam>
	mkdir -pv $(path)/$(project)/build
	mkdir -pv $(path)/$(project)/configs
	
	mkdir -pv $(path)/$(project)/outputs
	mkdir -pv $(path)/$(project)/logs
	mkdir -pv $(path)/$(project)/jobs
	mkdir -pv $(path)/$(project)/dbs

	# Creating a separate directory for storing temporary file as well as analysis
	# Removing the project doesn't remove this folder.
	mkdir -pv $(path)/$(project)_analysis

	# Add some scripts here to generate template files for their projects
	$(MAKE) config

	# Making SAM
	$(MAKE) sam

config: ## Building necessary files and folders for a new project
	
	rsync -r $(rrDIR)/* $(path)/$(project)/rscripts/ --exclude .git

	cp sam_local_seq_run.sh $(path)/$(project)/$(project)_local_seq_run.sh
	chmod +x $(path)/$(project)/$(project)_local_seq_run.sh

	cp sam_local_par_run.sh $(path)/$(project)/$(project)_local_par_run.sh
	chmod +x $(path)/$(project)/$(project)_local_par_run.sh
	
	cp sam_lisa_par_run.sh $(path)/$(project)/$(project)_lisa_par_run.sh
	awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_lisa_par_run.sh > tmp && mv tmp $(path)/$(project)/$(project)_lisa_par_run.sh
	chmod +x $(path)/$(project)/$(project)_lisa_par_run.sh

	cp r_job_temp.sh $(path)/$(project)/r_job_temp.sh
	awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/r_job_temp.sh > tmp && mv tmp $(path)/$(project)/r_job_temp.sh
	chmod +x $(path)/$(project)/r_job_temp.sh

	cp to_sqlite.py $(path)/$(project)/$(project)_to_sqlite.py
	awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_to_sqlite.py > tmp && mv tmp $(path)/$(project)/$(project)_to_sqlite.py
	chmod +x $(path)/$(project)/$(project)_to_sqlite.py

	cp to_csv.py $(path)/$(project)/$(project)_to_csv.py
	awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_to_csv.py > tmp && mv tmp $(path)/$(project)/$(project)_to_csv.py
	chmod +x $(path)/$(project)/$(project)_to_csv.py

	# Configuration File and Scripts
	cp config_template.json $(path)/$(project)/$(project)_config_template.json
	awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_config_template.json > tmp && mv tmp $(path)/$(project)/$(project)_config_template.json

	cp prepare_config_files.py $(path)/$(project)/$(project)_prepare_config_files.py
	awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_prepare_config_files.py > tmp && mv tmp $(path)/$(project)/$(project)_prepare_config_files.py
	chmod +x $(path)/$(project)/$(project)_prepare_config_files.py

	# Prepare the Project Makefile
	cp ProjectMakefileTemplate $(path)/$(project)/Makefile
	awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/Makefile > tmp && mv tmp $(path)/$(project)/Makefile


sam: ## Build SAMrun executable. Makefile will look for ../SAMrun directory first
	mkdir -pv $(path)/$(project)/SAM
	rsync -r ${SAMpp_DIR}/ $(path)/$(project)/SAM/SAMpp/ --exclude .git --exclude build
	rsync -r ${mvrandom_DIR}/ $(path)/$(project)/SAM/mvrandom/ --exclude .git

	mkdir $(path)/$(project)/SAM/SAMpp/build
	cmake -DCMAKE_BUILD_TYPE=Release -H$(path)/$(project)/SAM/SAMpp -B$(path)/$(project)/SAM/SAMpp/build
	cmake --build $(path)/$(project)/SAM/SAMpp/build --parallel 10
	mv $(path)/$(project)/SAM/SAMpp/build/SAMrun $(path)/$(project)/

##@ Cleanup


clean: ## Remove all output files, i.e., configs, outputs, logs, jobs
	rm -vrf $(path)/$(project)/configs/*
	rm -vrf $(path)/$(project)/logs/*
	rm -vrf $(path)/$(project)/jobs/*

veryclean: clean ## Remove all project files
	rm -vrf $(path)/$(project)/outputs/*
	rm -vrf $(path)/$(project)/dbs/*
	rm -vrf $(path)/$(project)/slurm-*.out

remove: ## Delete the entire project directory
	rm -vrf $(path)/$(project)
