.DEFAULT_GOAL:=help
SHELL:=/bin/bash

<b>:=\033[1m
</b>:=\033[0m

# This is a utility Makefile

SAMpp_DIR=$(HOME)/Projects/SAMpp
mvrandom_DIR=$(HOME)/Projects/mvrandom
ooDIR=$(HOME)/Projects/SAMoo
rrDIR=$(HOME)/Projects/SAMrr

currentdatetime:=$(shell date '+%Y-%m-%d_%H-%M%p')

path=""
ifeq ($(path),"")
	path=$(shell pwd)/projects
else
	path=$(path)
endif

.PHONY: help

help:  ## Display this help
	@printf "This is SAMoo, a handy toolset for preparing a new project using SAM.\n"
	@printf "In the process of 'prepare'-ing a new project, this Makefile produces\n"
	@printf "several template files for configuring and running a SAM project on\n"
	@printf "your local machine or on Lisa cluster.\n\n"
	@printf "$(<b>) > Make sure that this Makefile knows where SAM and other $(</b>)\n"
	@printf "$(<b>)   dependencies are located. $(</b>)\n"
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
	@printf '$(<b>) > Preparing $(project)... $(</b>)\n'
	@mkdir -pv $(path)/$(project)/build
	@mkdir -pv $(path)/$(project)/configs
	
	@mkdir -pv $(path)/$(project)/outputs
	@mkdir -pv $(path)/$(project)/logs
	@mkdir -pv $(path)/$(project)/jobs
	@mkdir -pv $(path)/$(project)/dbs

	@$(MAKE) config

	@$(MAKE) sam

config: ## Building necessary files and folders for a new project
	
	@printf '$(<b>) > Prepare a copy of SAM for $(project)... $(</b>)\n'
	@rsync -r $(rrDIR)/* $(path)/$(project)/rscripts/ --exclude .git

	@printf '$(<b>) > Preparing project files... $(</b>)\n'

	@cp sam_local_seq_run.sh $(path)/$(project)/$(project)_local_seq_run.sh
	@chmod +x $(path)/$(project)/$(project)_local_seq_run.sh

	@cp sam_local_par_run.sh $(path)/$(project)/$(project)_local_par_run.sh
	@chmod +x $(path)/$(project)/$(project)_local_par_run.sh
	
	@cp sam_lisa_par_run.sh $(path)/$(project)/$(project)_lisa_par_run.sh
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_lisa_par_run.sh > tmp && mv tmp $(path)/$(project)/$(project)_lisa_par_run.sh
	@chmod +x $(path)/$(project)/$(project)_lisa_par_run.sh

	@cp r_job_temp.sh $(path)/$(project)/r_job_temp.sh
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/r_job_temp.sh > tmp && mv tmp $(path)/$(project)/r_job_temp.sh
	@chmod +x $(path)/$(project)/r_job_temp.sh

	@cp to_sqlite.py $(path)/$(project)/$(project)_to_sqlite.py
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_to_sqlite.py > tmp && mv tmp $(path)/$(project)/$(project)_to_sqlite.py
	@chmod +x $(path)/$(project)/$(project)_to_sqlite.py

	@cp to_csv.py $(path)/$(project)/$(project)_to_csv.py
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_to_csv.py > tmp && mv tmp $(path)/$(project)/$(project)_to_csv.py
	@chmod +x $(path)/$(project)/$(project)_to_csv.py

	@cp config_template.json $(path)/$(project)/$(project)_config_template.json
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_config_template.json > tmp && mv tmp $(path)/$(project)/$(project)_config_template.json

	@cp prepare_config_files.py $(path)/$(project)/$(project)_prepare_config_files.py
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/$(project)_prepare_config_files.py > tmp && mv tmp $(path)/$(project)/$(project)_prepare_config_files.py
	@chmod +x $(path)/$(project)/$(project)_prepare_config_files.py

	@cp ProjectMakefileTemplate $(path)/$(project)/Makefile
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/Makefile > tmp && mv tmp $(path)/$(project)/Makefile


sam: ## Build SAMrun executable. Note: This will update SAM source directory and rebuild it
	@printf '$(<b>) > Copying SAM... $(</b>)\n'
	@mkdir -pv $(path)/$(project)/SAM
	@rsync -r ${SAMpp_DIR}/ $(path)/$(project)/SAM/SAMpp/ --exclude-from=.rsync-exclude-list
	@rsync -r ${mvrandom_DIR}/ $(path)/$(project)/SAM/mvrandom/ --exclude-from=.rsync-exclude-list

	@printf '$(<b>) > Building SAM... $(</b>)\n'
	@mkdir -pv $(path)/$(project)/SAM/SAMpp/build
	@cmake -DCMAKE_BUILD_TYPE=Release -H$(path)/$(project)/SAM/SAMpp -B$(path)/$(project)/SAM/SAMpp/build
	@cmake --build $(path)/$(project)/SAM/SAMpp/build --parallel 10
	@mv $(path)/$(project)/SAM/SAMpp/build/SAMrun $(path)/$(project)/

compress: ## Zip everything in the <project>
	@printf '$(<b>) > Compressing $(project)... $(</b>)\n'
	7z a $(project)_$(currentdatetime).zip $(path)/$(project)/

##@ Cleanup

clean: ## Remove all output files, i.e., configs, outputs, logs, jobs
	@printf '$(<b>) > Cleaning up configs/*, logs/*, and jobs/*... $(</b>)\n'
	@rm -rf $(path)/$(project)/configs/*
	@rm -rf $(path)/$(project)/logs/*
	@rm -rf $(path)/$(project)/jobs/*

veryclean: clean ## Remove all project files
	@printf '$(<b>) > Cleaning project specific files, outputs/*, dbs/*, ... $(</b>)\n'
	@rm -rf $(path)/$(project)/outputs/*
	@rm -rf $(path)/$(project)/dbs/*
	@rm -rf $(path)/$(project)/slurm-*.out

remove: ## Delete the entire project directory
	@printf '$(<b>) > Removing $(project)... $(</b>)\n'
	@rm -rf $(path)/$(project)
