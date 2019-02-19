#!/bin/bash

nsims=1000
ndvs=(4)
biaspool=(0.00 0.05 0.50 1.00)
effectpool=(0.147 0.384 0.669)
metapool=(8 24 70 300)
hackingmethods=(Base)

simpath=/Users/amabdol/Projects/SAMoo/Esther_Simulation
configpath=${simpath}/configs/
outputpath=${simpath}/outputs/

sam=${simpath}/SAMpp

samrrpath=/Users/amabdol/Projects/SAMrr/

for h in "${hackingmethods[@]}"
do
	for d in "${ndvs[@]}"
	do
		for b in "${biaspool[@]}"
		do
			# echo "running for b: ", $b
			for e in "${effectpool[@]}"
			do
				# echo "running for e: ", $e
				for k in "${metapool[@]}"
				do
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
					Rscript ${samrrpath}post-analyzer.R ${outputpath}d_${d}_b_${b}_e_${e}_k_${k}_h_${h}_sim.csv FALSE
					echo
					wait
				done
			done
		done
	done
done

# echo "Running the Batch Meta-Analysis"
# Rscript ~/Projects/SAMrr/post-analyzer.R outputs TRUE