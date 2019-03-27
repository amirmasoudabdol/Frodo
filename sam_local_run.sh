#!/bin/bash

source prep_json_file.sh

rrDIR=rscripts
buildDIR=build
configsDIR=configs
outputsDIR=outputs
logsDIR=logs
jobsDIR=jobs
dbsDIR=dbs


while IFS='' read -r line || [[ -n "$line" ]]; do
	params=($line)

	echo
	echo "Preparing the config file..."
	CONFIG_FILE_NAME="$(prepare_json_file params[@] "configs")"
	CONFIG_FILE="configs/${CONFIG_FILE_NAME}.json"

	echo
	echo "Running the simulation..."
	${buildDIR}/SAMpp --config=${CONFIG_FILE}

	echo
	echo "Running Rscripts"
	Rscript ${rrDIR}/post-analyzer.R ${outputsDIR}/${CONFIG_FILE_NAME}_sim.csv FALSE


done < "$1"
