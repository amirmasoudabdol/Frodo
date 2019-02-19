#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 00:15:00

module load stopos

export STOPOS_POOL=esther

ncores=`sara-get-num-cores`

nsims=1000

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
	h=${params[4]}
	jsonnet --tla-code nsims=${nsims} \
			--tla-code ndvs=${d} \
			--tla-code pubbias=${b} \
			--tla-code maxpubs=${k} \
			--tla-code mu=${e} \
			--tla-str output_path=${outputpath} \
			Esther_${h}.jsonnet > ${configpath}d_${d}_b_${b}_e_${e}_k_${k}_h_${h}.json

	echo "Configuration file: d_${d}_b_${b}_e_${e}_k_${k}_h_${h}.json"
	${sam} --config=${configpath}d_${d}_b_${b}_e_${e}_k_${k}_h_${h}.json
	echo
	echo "Computing Meta-Analysis Metrics"
	nohup Rscript ${samrrpath}post-analyzer.R ${outputpath}d_${d}_b_${b}_e_${e}_k_${k}_h_${h}_sim.csv FALSE
	echo
	stopos remove
) &
done

wait

# echo "Running the Batch Meta-Analysis"
# Rscript ~/Projects/SAMrr/post-analyzer.R outputs TRUE