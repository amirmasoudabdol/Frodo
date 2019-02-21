#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 03:00:00
#SBATCH --constraint=avx
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

module load stopos
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

nsims=5000

for ((i=1; i<=ncores; i++)) ; do
(
	# Getting the next parameters from the pool
	stopos next

	# Checking if the parameters pool is empty
	if ["$STOPOS_RC" != "OK"]; then
		break
	fi

	params=($STOPOS_VALUE)
	d=${params[0]}
	b=${params[1]}
	e=${params[2]}
	k=${params[3]}
	ish=${params[4]}
	hid="${params[5]}"
	configprefix=d_${d}_b_${b}_e_${e}_k_${k}_${ish}_h_${hid}

	# Preparing the config file for SAMpp using JSONnet
	jsonnet --tla-code nsims=${nsims} \
			--tla-code ndvs=${d} \
			--tla-code pubbias=${b} \
			--tla-code maxpubs=${k} \
			--tla-code mu=${e} \
			--tla-code ishacker=${ish} \
			--tla-str hackid=${hid} \
			--tla-str outputpath=${sim_tmp_path}/outputs/ \
			--tla-str outputfilename=${configprefix} \
			esther.jsonnet > "${sim_tmp_path}/configs/${configprefix}".json

	echo "Running the simulation for: ${configprefix}.json"
	${sam_pp_exec} --config=${sim_tmp_path}/configs/${configprefix}.json
	echo

	echo "Computing Meta-Analysis Metrics"
	nohup Rscript ${sam_rr_path}/post-analyzer.R ${sim_tmp_path}/outputs/${configprefix}_sim.csv FALSE
	echo

	echo "Copying back the outputs"
	rsync -r ${sim_tmp_path}/configs ${sim_home_path}
	rsync -r ${sim_tmp_path}/outputs ${sim_home_path}

	# Removing the used parameter from the pool
	stopos remove
) &
done
wait

# Copying eveyrhing back
# rsync -av ${TMPDIR}/

# echo "Running the Batch Meta-Analysis"
# Rscript ~/Projects/SAMrr/post-analyzer.R outputs TRUE