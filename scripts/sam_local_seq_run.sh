#!/bin/bash

PROJECT_DIR=$(pwd)

echo
echo "Running the simulation..."

for CONFIG_FILE in "configs/"*.json; do

	# Extracting the UUID, i.e., filename without extension
	FILE_NAME=$(basename ${CONFIG_FILE})
	CONFIG_FILE_NAME="${FILE_NAME%%.*}"

	echo "${CONFIG_FILE}"

	"${PROJECT_DIR}"/SAMrun --config="${CONFIG_FILE}" \
								--output-path="${PROJECT_DIR}/outputs/" \
								--output-prefix="${CONFIG_FILE_NAME}" \
								--update-config
	SIM_FILE="${PROJECT_DIR}/outputs/${CONFIG_FILE_NAME}_sim.csv"

	# echo
	# echo "Running Rscripts"
	# Rscript ${PROJECT_DIR}/rscripts/post-analyzer.R ${SIM_FILE} FALSE

done
