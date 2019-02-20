#!/bin/bash

nsims=100

simpath=$HOME/Projects/SAMoo/Esther_Simulation
configpath=${simpath}/configs/
outputpath=${simpath}/outputs/

sam=${simpath}/SAMpp

samrrpath=$HOME/Projects/SAMrr/

while IFS='' read -r line || [[ -n "$line" ]]; do
	params=($line)
	d=${params[0]}
	b=${params[1]}
	e=${params[2]}
	k=${params[3]}
	ish=${params[4]}
	hid="${params[5]}"

	configprefix=d_${d}_b_${b}_e_${e}_k_${k}_h_${hid}

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
	${sam} --config="${configpath}${configprefix}".json
	echo
	echo "Computing Meta-Analysis Metrics"
	nohup Rscript ${samrrpath}post-analyzer.R ${outputpath}${configprefix}_sim.csv FALSE
	echo

wait
done < "$1"



# echo "Running the Batch Meta-Analysis"
# Rscript ~/Projects/SAMrr/post-analyzer.R outputs TRUE