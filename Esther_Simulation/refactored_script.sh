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
# Setting Paths
sim_home_path=${HOME}/Projects/SAMoo/Esther_Simulation
mkdir ${sim_home_path}/outputs
mkdir ${sim_home_path}/configs

sam_oo_home_path=$HOME/Projects/SAMoo/
sam_rr_home_path=$HOME/Projects/SAMrr/

sim_tmp_path=${TMPDIR}/SAMoo/Esther_Simulation

sam_pp_exec=${sim_tmp_path}/SAMpp

sam_rr_path=${HOME}/Projects/SAMrr

# -----------------------------------
# Copying everything to the /scratch

mkdir ${TMPDIR}/SAMoo
# mkdir ${TMPDIR}/SAMrr
rsync -r ${sam_oo_home_path} ${TMPDIR}/SAMoo --exclude configs --exclude outputs --exclude dbs --exclude .git
# rsync -r ${sam_rr_home_path} ${TMPDIR}/SAMrr --exclude .git
mkdir ${sim_tmp_path}/configs
mkdir ${sim_tmp_path}/outputs

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
	configfilename="$(prepare_config_file params[@] $sim_tmp_path)"
	configfile="${sim_tmp_path}/configs/${configfilename}.json"
	
	cp ${configfile} $sim_home_path/configs/

	# Removing the used parameter from the pool
	stopos remove
	
	echo
	echo "Running the simulation for: ${configfilename}.json"
	simlogfile="${sim_tmp_path}/logs/${configfilename}_sim.log"
	${sam_pp_exec} --config=${configfile} > ${simlogfile}

	cp $simlogfile $sim_home_path/logs/

	echo
	echo "Copying back the output file"
	outputfile="${sim_tmp_path}/outputs/${configfilename}_sim.csv"
	cp ${outputfile} $sim_home_path/outputs/


	echo
	echo "Creating a new job file"
	rjobfile="${sim_tmp_path}/jobs/${configfilename}_r_job.sh"
	${sim_tmp_path}/rscript-job-temp.sh ${configfilename} > ${rjobfile}
	cp ${rjobfile} $sim_home_path/jobs/

	sbatch ${rjobfile}


) &
done
wait

# Copying eveyrhing back
# rsync -av ${TMPDIR}/

# echo "Running the Batch Meta-Analysis"
# Rscript ~/Projects/SAMrr/post-analyzer.R outputs TRUE