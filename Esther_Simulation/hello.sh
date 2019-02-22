#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 00:05:00
#SBATCH --constraint=avx
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

# -----------------------------------
# Setting Paths
sim_home_path=${HOME}/Projects/SAMoo/Esther_Simulation
mkdir ${sim_home_path}/outputs
mkdir ${sim_home_path}/configs

sam_oo_home_path=/Users/amabdol/Projects/SAMoo/
sam_rr_home_path=/Users/amabdol/Projects/SAMrr/

sim_tmp_path=${TMPDIR}/SAMoo/Esther_Simulation

sam_pp_exec=${sim_tmp_path}/SAMpp

sam_rr_path=${HOME}/Projects/SAMrr

# -----------------------------------
# Copying everything to the /scratch

mkdir ${TMPDIR}/SAMoo
rsync -r ${sam_oo_home_path} ${TMPDIR}/SAMoo --exclude configs --exclude outputs --exclude dbs --exclude .git
mkdir ${sim_tmp_path}/configs
mkdir ${sim_tmp_path}/outputs


echo Computing Meta-Analysis Metrics
Rscript ${sam_rr_path}/post-analyzer.R ${sim_tmp_path}/outputs/hello_sim.csv FALSE
echo

echo Copying back the outputs
rsync -r ${sim_tmp_path}/outputs ${sim_home_path}

