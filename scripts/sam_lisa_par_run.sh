#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node 16
#SBATCH -t 00:15:00
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

module load Stopos/0.93-GCC-9.3.0
module load sara-batch-resources

export STOPOS_POOL=yourprojectname_pool
ncores=`sara-get-num-cores`

# -----------------------------------
# Setting DIRs

PROJECT_DIR=$(pwd)

FRODO_DIR=${PROJECT_DIR}/projects/yourprojectname
SAM_DIR=${PROJECT_DIR}/build

# -----------------------------------
# Copying everything to the /scratch

rm -rf ${TMPDIR}/yourprojectname
PROJECT_TMP_DIR=${TMPDIR}/yourprojectname

mkdir ${PROJECT_TMP_DIR}
rsync -r ${PROJECT_DIR}/ ${PROJECT_TMP_DIR}/ --exclude configs \
											 --exclude outputs \
											 --exclude logs \
											 --exclude jobs \
											 --exclude dbs \
											 --exclude .git

mkdir -p ${PROJECT_TMP_DIR}/outputs \
		 ${PROJECT_TMP_DIR}/configs \
		 ${PROJECT_TMP_DIR}/logs \
		 ${PROJECT_TMP_DIR}/jobs \
		 ${PROJECT_TMP_DIR}/dbs

SAM_EXEC=${PROJECT_TMP_DIR}/SAMrun

# -----------------------------------
# Setting up and running the simulation

nply=yourprojectname_nply

for (( k = 0; k < nply; k++ )); do
(

	for ((i = 1; i <= ncores; i++)) ; do
	(
		# Getting the next parameters from the pool
		stopos next -p yourprojectname_pool

		# Checking if the parameters pool is empty
		if [ "$STOPOS_RC" != "OK" ]; then
			break
		fi

		ENTRY=($STOPOS_VALUE)
		CONFIG_FILE_NAME=${ENTRY%.json}
		CONFIG_FILE="${PROJECT_DIR}/configs/${CONFIG_FILE_NAME}.json"
		
		# Removing the used parameter from the pool
		stopos remove -p yourprojectname_pool
		
		echo
		echo "Running the simulation for: ${CONFIG_FILE_NAME}.json"
		LOG_FILE="${PROJECT_TMP_DIR}/logs/${CONFIG_FILE_NAME}.log"
		
		# start=`date +%s`

		# Running SAM
		${SAM_EXEC} --config="${CONFIG_FILE}" \
		 			--output-path="${PROJECT_TMP_DIR}/outputs/" \
		 			--output-prefix="${CONFIG_FILE_NAME}" \
		 			--update-config > ${LOG_FILE}

		end=`date +%s`

		# Calculating and saving the runtime
		# runtime=$((end-start))
		# echo "runtime in seconds: " >> ${LOG_FILE}
		# echo ${runtime} >> ${LOG_FILE}

		# Masking all possible output files
		OUTPUT_FILES="${PROJECT_TMP_DIR}/outputs/${CONFIG_FILE_NAME}_*.csv"

		echo # ----------------------------------------
		echo "Copying back the output file"
		
		cp -v ${OUTPUT_FILES} ${PROJECT_DIR}/outputs/
		# cp -v ${CONFIG_FILE} ${PROJECT_DIR}/configs/
		cp -v ${LOG_FILE} ${PROJECT_DIR}/logs/
		# ---------------------------------------------

		# echo
		# echo "Creating a new job file"
		# R_JOB_FILE="${PROJECT_TMP_DIR}/jobs/${CONFIG_FILE_NAME}_r_job.sh"
		# ${PROJECT_TMP_DIR}/r_job_temp.sh ${CONFIG_FILE_NAME} > ${R_JOB_FILE}
		
		# cp -v ${R_JOB_FILE} ${PROJECT_DIR}/jobs/

		# sbatch ${R_JOB_FILE}

	) &
	done
	wait

)
done
wait

echo "Done!"