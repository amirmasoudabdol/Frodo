nsims=1000
ndvs=(4)
biaspool=(0.00 0.05 0.50 1.00)
effectpool=(0.147 0.384 0.669)
metapool=(8 24 70 300)
hackids=(0 1 2 3)
ishacker=(false)

# This will generate a parameters pool from the given parameters.
# ndvs, pubbias, effectsize, metapool, ishacker, hackids

for d in "${ndvs[@]}"
do
	for b in "${biaspool[@]}"
	do
		for e in "${effectpool[@]}"
		do
			for k in "${metapool[@]}"
			do
				for hid in "${hackids[@]}"
				do
					for ish in "${ishacker[@]}"
					do
						echo "${d} ${b} ${e} ${k} ${ish} ${hid}"
					done
				done
			done
		done
	done
done


# TODO: I can create the STOPOS pool here