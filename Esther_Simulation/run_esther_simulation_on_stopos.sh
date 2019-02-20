#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p short
#SBATCH --constraint=avx
#SBATCH --mail-type=END
#SBATCH --mail-user=a.m.abdol@uvt.nl

module load stopos
export STOPOS_POOL=esther
ncores=`sara-get-num-cores`

# Setting Paths

sam_oo_home_path=$HOME/Projects/SAMoo/

sim_home_path=${HOME}/SAMoo/Esther_Simulation
sim_tmp_path=${TMPDIR}/SAMoo/Esther_Simulation

sam_pp_exec=${sim_tmp_path}/SAMpp

# samrrpath=$HOME/Projects/SAMrr/

# configpath=${sim_tmp_path}/configs/
# outputpath=${sim_tmp_path}/outputs/


# Copying everything to the /scratch

rsync -av --progress ${sam_oo_home_path} ${TMPDIR} --exclude configs --exclude outputs --exclude .git


# Setting up and running the simulation

nsims=1000

for ((i=1; i<=ncores; i++)) ; do
(
	stopos next

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

	jsonnet --tla-code nsims=${nsims} \
			--tla-code ndvs=${d} \
			--tla-code pubbias=${b} \
			--tla-code maxpubs=${k} \
			--tla-code mu=${e} \
			--tla-code ishacker=${ish} \
			--tla-str hackid=${hid} \
			--tla-str outputpath=${sim_tmp_path}/outputs \
			--tla-str outputfilename=${configprefix} \
			esther.jsonnet > "${sim_tmp_path}/configs/${configprefix}".json

	echo "Configuration file: ${configprefix}.json"
	${sam_pp_exec} --config=${sim_tmp_path}/configs/${configprefix}.json
	echo
	echo "Computing Meta-Analysis Metrics"
	Rscript ${sim_tmp_path}/SAMrr/post-analyzer.R ${sim_tmp_path}/outputs/${configprefix}_sim.csv FALSE
	echo
	rsycn -av ${sim_tmp_path}/configs ${sim_home_path}
	rsycn -av ${sim_tmp_path}/outputs ${sim_home_path}
	stopos remove
) &
done
wait

# Copying eveyrhing back
rsync -av ${TMPDIR}/

# echo "Running the Batch Meta-Analysis"
# Rscript ~/Projects/SAMrr/post-analyzer.R outputs TRUE