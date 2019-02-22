echo "#!/bin/bash"
echo "#SBATCH -N 1"
echo "#SBATCH -n 16"
echo "#SBATCH -p short"
echo "#SBATCH --constraint=avx"
echo "#SBATCH --mail-type=BEGIN,END"
echo "#SBATCH --mail-user=a.m.abdol@uvt.nl"
echo 
echo "# -----------------------------------"
echo "# Setting Paths"
echo "sim_home_path=\${HOME}/Projects/SAMoo/Esther_Simulation"
echo "mkdir \${sim_home_path}/outputs"
echo "mkdir \${sim_home_path}/configs"
echo 
echo "sam_oo_home_path=$HOME/Projects/SAMoo/"
echo "sam_rr_home_path=$HOME/Projects/SAMrr/"
echo 
echo "sim_tmp_path=\${TMPDIR}/SAMoo/Esther_Simulation"
echo 
echo "sam_pp_exec=\${sim_tmp_path}/SAMpp"
echo 
echo "sam_rr_path=\${HOME}/Projects/SAMrr"
echo 
echo "# -----------------------------------"
echo "# Copying everything to the /scratch"
echo 
echo "mkdir \${TMPDIR}/SAMoo"
echo "rsync -r \${sam_oo_home_path} \${TMPDIR}/SAMoo --exclude configs --exclude outputs --exclude dbs --exclude .git"
echo "mkdir \${sim_tmp_path}/configs"
echo "mkdir \${sim_tmp_path}/outputs"
echo 
echo 
echo "echo "Computing Meta-Analysis Metrics""
echo "nohup Rscript \${sam_rr_path}/post-analyzer.R \${sim_tmp_path}/outputs/${1}_sim.csv FALSE"
echo "echo"
echo 
echo "echo "Copying back the outputs""
echo "rsync -r \${sim_tmp_path}/outputs \${sim_home_path}"
echo 
