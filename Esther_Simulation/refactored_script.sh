#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p short
#SBATCH --constraint=avx
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

module load stopos
module load sara-batch-resources

source ${HOME}/Projects/SAMoo/prep-config-file.sh

export STOPOS_POOL=esther
ncores=`sara-get-num-cores`

# -----------------------------------
# Setting DIRs

SIM_HOME_DIR=${HOME}/Projects/SAMoo/Esther_Simulation
mkdir ${SIM_HOME_DIR}/outputs
mkdir ${SIM_HOME_DIR}/configs

SAMoo_DIR=$HOME/Projects/SAMoo/
SAMrr_DIR=$HOME/Projects/SAMrr/
SAMpp_DIR=$HOME/Projects/SAMpp/

SIM_TMP_DIR=${TMPDIR}/SAMoo/Esther_Simulation

SAM_EXEC=${SIM_TMP_DIR}/SAMpp

# -----------------------------------
# Copying everything to the /scratch

mkdir ${TMPDIR}/SAMoo
rsync -r ${SAMoo_DIR} ${TMPDIR}/SAMoo --exclude configs \
									  --exclude outputs \
									  --exclute logs \
									  --exclude jobs \
									  --exclude dbs \
									  --exclude .git
# rsync -r ${SAMrr_DIR} ${TMPDIR}/SAMrr --exclude .git
mkdir ${SIM_TMP_DIR}/configs
mkdir ${SIM_TMP_DIR}/outputs

# -----------------------------------
# Setting up and running the simulation

nsims=10

for ((i=1; i<=ncores; i++)) ; do
(
	# Getting the next parameters from the pool
	stopos next

	# Checking if the parameters pool is empty
	if [ "$STOPOS_RC" != "OK" ]; then
		break
	fi

	params=($STOPOS_VALUE)
	
	# `prepare_config_file` is being imported from `prepare-config-file.sh`
	CONFIG_FILE_PREFIX="$(prepare_config_file params[@] $SIM_TMP_DIR)"
	CONFIG_FILE="${SIM_TMP_DIR}/configs/${CONFIG_FILE_PREFIX}.json"
	
	cp ${CONFIG_FILE} $SIM_HOME_DIR/configs/

	# Removing the used parameter from the pool
	stopos remove
	
	echo
	echo "Running the simulation for: ${CONFIG_FILE_PREFIX}.json"
	SIM_LOG_FILE="${SIM_TMP_DIR}/logs/${CONFIG_FILE_PREFIX}_sim.log"
	${SAM_EXEC} --config=${CONFIG_FILE} > ${SIM_LOG_FILE}

	cp $SIM_LOG_FILE $SIM_HOME_DIR/logs/

	echo
	echo "Copying back the output file"
	SIM_OUT_FILE="${SIM_TMP_DIR}/outputs/${CONFIG_FILE_PREFIX}_sim.csv"
	cp ${SIM_OUT_FILE} $SIM_HOME_DIR/outputs/


	echo
	echo "Creating a new job file"
	R_JOB_FILE="${SIM_HOME_DIR}/jobs/${CONFIG_FILE_PREFIX}_r_job.sh"
	${SIM_TMP_DIR}/rscript-job-temp.sh ${CONFIG_FILE_PREFIX} > ${R_JOB_FILE}
	cp ${R_JOB_FILE} $SIM_HOME_DIR/jobs/

	sbatch ${R_JOB_FILE}


) &
done
wait

# Copying eveyrhing back
# rsync -av ${TMPDIR}/

# echo "Running the Batch Meta-Analysis"
# Rscript ~/Projects/SAMrr/post-analyzer.R outputs TRUE