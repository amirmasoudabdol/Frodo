#!/bin/bash

source prep-json-file.sh

while IFS='' read -r line || [[ -n "$line" ]]; do
	params=($line)

	# `prepare_config_file` is being imported from `prepare-config-file.sh`
	CONFIG_FILE_NAME="$(prepare_json_file params[@] "esther/configs")"
	# CONFIG_FILE="${SIM_TMP_DIR}/configs/${CONFIG_FILE_PREFIX}.json"

done < "$1"
