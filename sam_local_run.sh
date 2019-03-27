#!/bin/bash

source prep_json_file.sh

SAM_EXEC=build/SAMpp


while IFS='' read -r line || [[ -n "$line" ]]; do
	params=($line)

	# `prepare_config_file` is being imported from `prepare-config-file.sh`
	echo "Preparing the config file..."
	CONFIG_FILE_NAME="$(prepare_json_file params[@] "configs")"
	CONFIG_FILE="configs/${CONFIG_FILE_NAME}.json"

	echo "Running the simulation..."
	${SAM_EXEC} --config=${CONFIG_FILE}

done < "$1"
