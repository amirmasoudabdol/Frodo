#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p short
#SBATCH --constraint=avx
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

module load stopos
module load sara-batch-resources

export STOPOS_POOL=yourprojectname
ncores=`sara-get-num-cores`

source ${PROJECT_DIR}/prep_json_file.sh
# -----------------------------------
# Setting DIRs

PROJECT_DIR=$(pwd)

SAMoo_DIR=${PROJECT_DIR}
SAMrr_DIR=${PROJECT_DIR}/rscripts
SAMpp_DIR=${PROJECT_DIR}/build

# -----------------------------------
# Copying everything to the /scratch

PROJECT_TMP_DIR=${TMPDIR}/yourprojectname

mkdir ${PROJECT_TMP_DIR}
rsync -r ${PROJECT_DIR} ${PROJECT_TMP_DIR} --exclude configs \
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

SAM_EXEC=${PROJECT_TMP_DIR}/build/SAMpp

# -----------------------------------
# Setting up and running the simulation

for ((i=1; i<=ncores; i++)) ; do
(
	# Getting the next parameters from the pool
	stopos next

	# Checking if the parameters pool is empty
	if [ "$STOPOS_RC" != "OK" ]; then
		break
	fi

	params=($STOPOS_VALUE)
	
	# `prepare_json_file` is being imported from `prep_json_file.sh`
	CONFIG_FILE_NAME="$(prepare_json_file params[@] ${PROJECT_TMP_DIR}/configs)"
	CONFIG_FILE="${PROJECT_TMP_DIR}/configs/${CONFIG_FILE_NAME}.json"
	
	# Removing the used parameter from the pool
	stopos remove
	
	echo
	echo "Running the simulation for: ${CONFIG_FILE_NAME}.json"
	LOG_FILE="${PROJECT_TMP_DIR}/logs/${CONFIG_FILE_NAME}_sim.log"
	
	# Running SAM
	${SAM_EXEC} --config=${CONFIG_FILE} > ${LOG_FILE}
	SIM_FILE="${PROJECT_TMP_DIR}/outputs/${CONFIG_FILE_NAME}_sim.csv"

	echo # ----------------------------------------
	echo "Copying back the output file"
	
	cp ${SIM_FILE} ${PROJECT_DIR}/outputs/
	cp ${CONFIG_FILE} ${PROJECT_DIR}/configs/
	cp ${LOG_FILE} ${PROJECT_DIR}/logs/
	# ---------------------------------------------

	echo
	echo "Creating a new job file"
	R_JOB_FILE="${PROJECT_DIR}/jobs/${CONFIG_FILE_NAME}_r_job.sh"
	${PROJECT_TMP_DIR}/rscript-job-temp.sh ${CONFIG_FILE_NAME} > ${R_JOB_FILE}
	
	cp ${R_JOB_FILE} ${PROJECT_DIR}/jobs/

	sbatch ${R_JOB_FILE}

) &
done
wait
