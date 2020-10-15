#!/bin/bash

stopos next -p yourprojectname_pool

# Checking if the parameters pool is empty
if [ "$STOPOS_RC" != "OK" ]; then
	exit 0
fi

PROJECT_DIR=$1
PROJECT_TMP_DIR=$2

ENTRY=($STOPOS_VALUE)
CONFIG_FILE_NAME=${ENTRY%.json}
CONFIG_FILE="${PROJECT_DIR}/configs/${CONFIG_FILE_NAME}.json"

SAM_EXEC=${PROJECT_TMP_DIR}/SAMrun

# Removing the used parameter from the pool
stopos remove -p yourprojectname_pool

echo
echo "Running the simulation for: ${CONFIG_FILE_NAME}.json"
LOG_FILE="${PROJECT_TMP_DIR}/logs/${CONFIG_FILE_NAME}.log"

# Running SAM
${SAM_EXEC} --config="${CONFIG_FILE}" \
 			--output-path="${PROJECT_TMP_DIR}/outputs/" \
 			--output-prefix="${CONFIG_FILE_NAME}" \
 			--update-config > ${LOG_FILE}

# Masking all possible output files
OUTPUT_FILES="${PROJECT_TMP_DIR}/outputs/${CONFIG_FILE_NAME}_*.csv"

echo # ----------------------------------------
echo "Copying back the output file"

cp -v ${OUTPUT_FILES} ${PROJECT_DIR}/outputs/
cp -v ${LOG_FILE} ${PROJECT_DIR}/logs/