nsims=1000
ndvs=(4)
biaspool=(0.00 0.05 0.50 1.00)
effectpool=(0.147 0.384 0.669)
metapool=(8 24 70 300)
hackingmethods=(Base)

for h in "${hackingmethods[@]}"
do
	for d in "${ndvs[@]}"
	do
		for b in "${biaspool[@]}"
		do
			for e in "${effectpool[@]}"
			do
				for k in "${metapool[@]}"
				do
					echo "${d} ${b} ${e} ${k} ${h}"
				done
			done
		done
	done
done


# TODO: I can create the STOPOS pool here