#!/bin/bash

PROJECT_DIR=$(pwd)

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	ncores=$(grep -c ^processor /proc/cpuinfo)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ncores=$(sysctl -n hw.ncpu)
else
	echo "Cannot deceted the OS."
fi

echo
echo "Running the simulation on ${ncores} cores."

nconfigfiles=$(wc -l < configfilenames.pool)

niters=$(echo $(( (nconfigfiles / ncores))))

for ((i=0; i<=niters; i++)) ; do

	slinen=$(echo $(((ncores * i)+1)) )
	nlinen=$(echo $((ncores * i + ncores)) )

	span="${slinen},${nlinen}p"

	FILES=$(sed -n ${span} < configfilenames.pool)

	for CONFIG_FILE in $FILES; do
	(
		# Extracting the UUID, i.e., filename without extension
		CONFIG_FILE="configs/${CONFIG_FILE}"
		FILE_NAME=$(basename ${CONFIG_FILE})
		CONFIG_FILE_NAME="${FILE_NAME%%.*}"

		echo "${CONFIG_FILE}"

		"${PROJECT_DIR}"/build/SAMrun --config="${CONFIG_FILE}" \
									--output-path="${PROJECT_DIR}/outputs/" \
									--output-prefix="${CONFIG_FILE_NAME}" \
									--update-config
		SIM_FILE="${PROJECT_DIR}/outputs/${CONFIG_FILE_NAME}_sim.csv"

		# echo
		# echo "Running Rscripts"
		# Rscript ${PROJECT_DIR}/rscripts/post-analyzer.R ${SIM_FILE} FALSE

	) &
	done
	wait

done