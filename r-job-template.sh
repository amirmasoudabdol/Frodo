echo "#!/bin/bash"
echo "#SBATCH -N 1"
echo "#SBATCH -n 16"
echo "#SBATCH -t 00:05:00"
echo "#SBATCH --constraint=avx"
echo "#SBATCH --mail-type=BEGIN,END"
echo "#SBATCH --mail-user=a.m.abdol@uvt.nl"
echo 
echo "# -----------------------------------"
echo "# Setting Paths"
echo "SIM_HOME_DIR=\${HOME}/Projects/SAMoo/Esther_Simulation"
echo "mkdir \${SIM_HOME_DIR}/outputs"
echo "mkdir \${SIM_HOME_DIR}/configs"
echo 
echo "SAMoo_DIR=$HOME/Projects/SAMoo/"
echo "SAMrr_DIR=$HOME/Projects/SAMrr/"
echo 
echo "SIM_TMP_DIR=\${TMPDIR}/SAMoo/Esther_Simulation"
echo 
echo 
echo "SIMrrDIR=\${HOME}/Projects/SAMrr"
echo 
echo "# -----------------------------------"
echo "# Copying everything to the /scratch"
echo 
echo "mkdir \${TMPDIR}/SAMoo"
echo "rsync -r \${SAMoo_DIR} \${TMPDIR}/SAMoo --exclude configs --exclude outputs --exclude dbs --exclude .git"
echo "mkdir \${SIM_TMP_DIR}/configs"
echo "mkdir \${SIM_TMP_DIR}/outputs"
echo 
echo "echo \"Copying the simulation output file to the $TMPDIR\""
echo "cp \${SIM_HOME_DIR}/outputs/${1}_sim.csv \${SIM_TMP_DIR}/outputs/"
echo 
echo "echo \"Computing Meta-Analysis Metrics\""
echo "SIM_OUT_FILE=\"\${SIM_TMP_DIR}/outputs/${1}_sim.csv\""
echo "Rscript \${SIMrrDIR}/post-analyzer.R \${SIM_OUT_FILE} FALSE"
echo "echo"
echo
echo "echo \"Copying back the outputs\""
echo "META_OUT_FILE=\"\${SIM_TMP_DIR}/outputs/${1}_meta.csv\""
echo "cp \${META_OUT_FILE} \${SIM_HOME_DIR}/outputs/"
echo 