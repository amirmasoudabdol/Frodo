#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 00:05:00
#SBATCH --constraint=avx
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

# -----------------------------------
# Setting Paths
SIM_HOME_DIR=${HOME}/Projects/SAMoo/Esther_Simulation
mkdir ${SIM_HOME_DIR}/outputs
mkdir ${SIM_HOME_DIR}/configs

SAMoo_DIR=/Users/amabdol/Projects/SAMoo/
SAMrr_DIR=/Users/amabdol/Projects/SAMrr/

SIM_TMP_DIR=${TMPDIR}/SAMoo/Esther_Simulation


SIMrrDIR=${HOME}/Projects/SAMrr

# -----------------------------------
# Copying everything to the /scratch

mkdir ${TMPDIR}/SAMoo
rsync -r ${SAMoo_DIR} ${TMPDIR}/SAMoo --exclude configs --exclude outputs --exclude logs --exclude jobs --exclude dbs --exclude .git
mkdir ${SIM_TMP_DIR}/configs
mkdir ${SIM_TMP_DIR}/outputs

echo "Copying the simulation output file to the /var/folders/x_/2261qy0d4lb6y0dyhs7zwwx80000gn/T/"
cp ${SIM_HOME_DIR}/outputs/hello_sim.csv ${SIM_TMP_DIR}/outputs/

echo "Computing Meta-Analysis Metrics"
SIM_OUT_FILE="${SIM_TMP_DIR}/outputs/hello_sim.csv"
Rscript ${SIMrrDIR}/post-analyzer.R ${SIM_OUT_FILE} FALSE
echo

echo "Copying back the outputs"
META_OUT_FILE="${SIM_TMP_DIR}/outputs/hello_meta.csv"
cp ${META_OUT_FILE} ${SIM_HOME_DIR}/outputs/

