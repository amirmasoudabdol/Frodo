.DEFAULT_GOAL:=help
SHELL:=/bin/bash

<b>:=\033[1m
</b>:=\033[0m

# This is a utility Makefile

SAMpp_DIR=$(HOME)/Projects/SAMpp
baaraan_DIR=$(HOME)/Projects/baaraan
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
	@printf "\n This is SAMoo, a handy toolset for preparing a new project using SAM.\n"
	@printf " In the process of 'prepare'-ing a new project, this Makefile produces\n"
	@printf " several template files for configuring and running a SAM project on\n"
	@printf " your local machine or on Lisa cluster.\n\n"
	@printf "$(<b>)> Make sure that this Makefile knows where SAM and other $(</b>)\n"
	@printf "$(<b>)  dependencies are located. You can set their path through the $(</b>)\n"
	@printf "$(<b>)  parameters defined in line 9 – 12 of the Makefile.$(</b>)\n"
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

##@ -----------------------------------------------------------
##@ Build

prepare: ## Create a new project by running <config> and <sam>
	@printf '$(<b>)> Preparing $(project)... $(</b>)\n'
	@mkdir -p $(path)/$(project)/build
	@mkdir -p $(path)/$(project)/configs

	@mkdir -p $(path)/$(project)/scripts
	
	@mkdir -p $(path)/$(project)/outputs
	@mkdir -p $(path)/$(project)/logs
	@mkdir -p $(path)/$(project)/jobs
	@mkdir -p $(path)/$(project)/dbs

	@$(MAKE) config

	@$(MAKE) sam

	@printf '$(<b>)> Successfully preapred and saved "$(project)" in "$(path)" ... $(</b>)\n'
	@printf '$(<b>)> `cd` into the project folder and start with the `make` command ... $(</b>)\n'

config: ## Building necessary files and folders for a new project
	
	@printf '$(<b>)> Prepare a copy of SAM for $(project)... $(</b>)\n'

	@printf '$(<b>)> Preparing project files... $(</b>)\n'

	@cp scripts/sam_local_seq_run.sh $(path)/$(project)/scripts/$(project)_local_seq_run.sh
	@chmod +x $(path)/$(project)/scripts/$(project)_local_seq_run.sh

	@cp scripts/sam_local_par_run.sh $(path)/$(project)/scripts/$(project)_local_par_run.sh
	@chmod +x $(path)/$(project)/scripts/$(project)_local_par_run.sh
	
	@cp scripts/sam_lisa_par_run.sh $(path)/$(project)/scripts/$(project)_lisa_par_run.sh
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/scripts/$(project)_lisa_par_run.sh > tmp && mv tmp $(path)/$(project)/scripts/$(project)_lisa_par_run.sh
	@chmod +x $(path)/$(project)/scripts/$(project)_lisa_par_run.sh

	@cp scripts/r_job_temp.sh $(path)/$(project)/scripts/$(project)_r_job_temp.sh
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/scripts/$(project)_r_job_temp.sh > tmp && mv tmp $(path)/$(project)/scripts/$(project)_r_job_temp.sh
	@chmod +x $(path)/$(project)/scripts/$(project)_r_job_temp.sh

	@cp scripts/post_processing.R $(path)/$(project)/scripts/$(project)_post_processing.R
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/scripts/$(project)_post_processing.R > tmp && mv tmp $(path)/$(project)/scripts/$(project)_post_processing.R
	@chmod +x $(path)/$(project)/scripts/$(project)_post_processing.R

	@cp scripts/to_sqlite.py $(path)/$(project)/scripts/$(project)_to_sqlite.py
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/scripts/$(project)_to_sqlite.py > tmp && mv tmp $(path)/$(project)/scripts/$(project)_to_sqlite.py
	@chmod +x $(path)/$(project)/scripts/$(project)_to_sqlite.py

	@cp scripts/to_csv.py $(path)/$(project)/scripts/$(project)_to_csv.py
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/scripts/$(project)_to_csv.py > tmp && mv tmp $(path)/$(project)/scripts/$(project)_to_csv.py
	@chmod +x $(path)/$(project)/scripts/$(project)_to_csv.py

	@cp scripts/config_template.json $(path)/$(project)/scripts/$(project)_config_template.json
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/scripts/$(project)_config_template.json > tmp && mv tmp $(path)/$(project)/scripts/$(project)_config_template.json

	@cp scripts/prepare_config_files.py $(path)/$(project)/scripts/$(project)_prepare_config_files.py
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/scripts/$(project)_prepare_config_files.py > tmp && mv tmp $(path)/$(project)/scripts/$(project)_prepare_config_files.py
	@chmod +x $(path)/$(project)/scripts/$(project)_prepare_config_files.py

	@cp scripts/ProjectMakefileTemplate $(path)/$(project)/Makefile
	@awk '{gsub(/yourprojectname/,"$(project)");}1' $(path)/$(project)/Makefile > tmp && mv tmp $(path)/$(project)/Makefile

load:
	@printf '$(<b>)> Loading existing project files... $(</b>)\n'

ifneq ("$(wildcard templates/$(project)_post_processing.R)","")
	@echo "Found and copied $(project)_post_processing.R"
	@cp $(shell pwd)/templates/$(project)_post_processing.R $(path)/$(project)/scripts/$(project)_post_processing.R
endif

ifneq ("$(wildcard templates/$(project)_prepare_config_files.py)","")
	@echo "Found and copied $(project)_prepare_config_files.py"
	@cp $(shell pwd)/templates/$(project)_prepare_config_files.py $(path)/$(project)/scripts/$(project)_prepare_config_files.py
endif

ifneq ("$(wildcard templates/$(project)_lisa_par_run.sh)","")
	@echo "Found and copied $(project)_lisa_par_run.sh"
	@cp $(shell pwd)/templates/$(project)_lisa_par_run.sh $(path)/$(project)/scripts/$(project)_lisa_par_run.sh
endif

sam: ## Build SAMrun executable. Note: This will update SAM source directory and rebuild it
	@printf '$(<b>)> Copying SAM... $(</b>)\n'
	@mkdir -p $(path)/$(project)/SAM
	@rsync -rtu ${SAMpp_DIR}/ $(path)/$(project)/SAM/SAMpp/ --exclude-from=.rsync-exclude-list
	@rsync -rtu ${baaraan_DIR}/ $(path)/$(project)/SAM/baaraan/ --exclude-from=.rsync-exclude-list

	@mkdir -p $(path)/$(project)/SAM/SAMpp/build
	
	@printf '$(<b>)> Configuring SAM... $(</b>)\n'
	@cmake -DCMAKE_BUILD_TYPE=Release -H$(path)/$(project)/SAM/SAMpp -B$(path)/$(project)/SAM/SAMpp/build
	
	@printf '$(<b>)> Building SAM... $(</b>)\n'
	@cmake --build $(path)/$(project)/SAM/SAMpp/build --parallel 10
	
	@mv $(path)/$(project)/SAM/SAMpp/build/SAMrun $(path)/$(project)/

compress: ## Zip everything in the <project>
	@printf '$(<b>)> Compressing $(project)... $(</b>)\n'
	7z a -mx=0 -mmt=16 $(project)_$(currentdatetime).zip $(path)/$(project)/

##@ Cleanup

clean: ## Remove all output files, i.e., configs, outputs, logs, jobs
	@printf '$(<b>)> Cleaning up configs/*, logs/*, and jobs/*... $(</b>)\n'
	@rm -rf $(path)/$(project)/configs/*
	@rm -rf $(path)/$(project)/logs/*
	@rm -rf $(path)/$(project)/jobs/*

veryclean: clean ## Remove all project files
	@printf '$(<b>)> Cleaning project specific files, outputs/*, dbs/*, ... $(</b>)\n'
	@rm -rf $(path)/$(project)/outputs/*
	@rm -rf $(path)/$(project)/dbs/*
	@rm -rf $(path)/$(project)/slurm-*.out

remove: ## Delete the entire project directory
	@printf '$(<b>)> Removing $(project)... $(</b>)\n'
	@rm -rf $(path)/$(project)
