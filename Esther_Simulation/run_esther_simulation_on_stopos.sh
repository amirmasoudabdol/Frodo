#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 01:00:00
#SBATCH --constraint=avx
#SBATCH --mail-type=END
#SBATCH --mail-user=a.m.abdol@uvt.nl

module load stopos

export STOPOS_POOL=esther

ncores=`sara-get-num-cores`

nsims=5000

simpath=/home/amabdol/Projects/SAMoo/Esther_Simulation
configpath=${simpath}/configs/
outputpath=${simpath}/outputs/

sam=${simpath}/SAMpp

samrrpath=/home/amabdol/Projects/SAMrr/

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
			--tla-str outputpath=${outputpath} \
			--tla-str outputfilename=${configprefix} \
			esther.jsonnet > "${configpath}${configprefix}".json

	echo "Configuration file: ${configprefix}.json"
	${sam} --config=${configpath}${configprefix}.json
	echo
	echo "Computing Meta-Analysis Metrics"
	Rscript ${samrrpath}post-analyzer.R ${outputpath}${configprefix}_sim.csv FALSE
	echo
	stopos remove
) &
done

wait

# echo "Running the Batch Meta-Analysis"
# Rscript ~/Projects/SAMrr/post-analyzer.R outputs TRUE