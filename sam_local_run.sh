#!/bin/bash

source prep_json_file.sh

PROJECT_DIR=$(pwd)

while IFS='' read -r line || [[ -n "$line" ]]; do
	params=($line)

	echo
	echo "Preparing the config file..."
	CONFIG_FILE_NAME="$(prepare_json_file params[@] ${PROJECT_DIR}/configs)"
	CONFIG_FILE="${PROJECT_DIR}/configs/${CONFIG_FILE_NAME}.json"

	echo
	echo "Running the simulation..."
	${PROJECT_DIR}/build/SAMrun --config=${CONFIG_FILE} --output-prefix=${CONFIG_FILE_NAME} --output-path=${PROJECT_DIR}/outputs/ --update-config
	SIM_FILE="${PROJECT_DIR}/outputs/${CONFIG_FILE_NAME}_sim.csv"

	echo
	echo "Running Rscripts"
	Rscript ${PROJECT_DIR}/rscripts/post-analyzer.R ${SIM_FILE} FALSE

done < "$1"
