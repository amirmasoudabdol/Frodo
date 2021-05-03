#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node 16
#SBATCH -t 00:15:00
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

module load 2020
module load Stopos/0.93-GCC-9.3.0
module load sara-batch-resources

export STOPOS_POOL=yourprojectname_pool
ncores=`sara-get-num-cores`

# -----------------------------------
# Setting DIRs

PROJECT_DIR=$(pwd)

FRODO_DIR=${PROJECT_DIR}/projects/yourprojectname
SAMrr_DIR=${PROJECT_DIR}/rscripts
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
n_jobs=$(echo $(( ${ncores} * ${nply})) )

# # Getting the next parameters from the pool
# stopos next -p yourprojectname_pool

# # Checking if the parameters pool is empty
# if [ "$STOPOS_RC" != "OK" ]; then
# 	break
# fi

parallel yourprojectname_run_a_config.sh ${PROJECT_DIR} ${PROJECT_TMP_DIR}


echo "Done!"