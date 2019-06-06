#!/bin/bash

PROJECT_DIR=$(pwd)

for CONFIG_FILE in "configs/"*.json; do

	# Extracting the UUID, i.e., filename without extension
	CONFIG_FILE_NAME="${CONFIG_FILE%%.*}"

	echo
	echo "Running the simulation..."
	"${PROJECT_DIR}"/build/SAMrun --config="${CONFIG_FILE}" \
								--output-path="${PROJECT_DIR}/outputs/" \
								--output-prefix="${CONFIG_FILE_NAME}" \
								--update-config
	SIM_FILE="${PROJECT_DIR}/outputs/${CONFIG_FILE_NAME}_sim.csv"

	# echo
	# echo "Running Rscripts"
	# Rscript ${PROJECT_DIR}/rscripts/post-analyzer.R ${SIM_FILE} FALSE

done
