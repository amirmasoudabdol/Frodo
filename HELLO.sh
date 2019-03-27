#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p short
#SBATCH --constraint=avx
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

# -----------------------------------
# Setting Paths

PROJECT_DIR=$(pwd)

SAMoo_DIR=${PROJECT_DIR}
SAMrr_DIR=${PROJECT_DIR}/rscripts

# -----------------------------------
# Copying everything to the /scratch

PROJECT_TMP_DIR=${TMPDIR}/yourprojectname

mkdir ${PROJECT_TMP_DIR}
rsync -r ${PROJECT_DIR} ${PROJECT_TMP_DIR} --exclude configs --exclude outputs --exclude dbs --exclude .git
mkdir -p ${PROJECT_TMP_DIR}/configs ${PROJECT_TMP_DIR}/outputs

echo "Copying the simulation output file to the ${TMPDIR}"
cp ${PROJECT_DIR}/outputs/HELLO_sim.csv ${PROJECT_TMP_DIR}/outputs/

echo "Computing Meta-Analysis Metrics"
SIM_FILE="${PROJECT_TMP_DIR}/outputs/HELLO_sim.csv"
Rscript ${SIMrrDIR}/post-analyzer.R ${SIM_FILE} FALSE
echo

echo "Copying back the outputs"
META_FILE="${PROJECT_TMP_DIR}/outputs/HELLO_meta.csv"
cp ${META_FILE} ${PROJECT_DIR}/outputs/

