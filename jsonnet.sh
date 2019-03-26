#!/bin/bash

jsonnet --tla-code debug=false \
		--tla-code verbose=false \
		--tla-code progress=true \
		--tla-code nsims=1 \
		--tla-code masterseed=42 \
		--tla-code saveoutput=true \
		--tla-str outputpath="output/" \
		--tla-str outputprefix="" \
		--tla-code metaseed=43 \
		--tla-str datastrategy="Linear Model" \
		--tla-code nc=1 \
		--tla-code nd=2 \
		--tla-code ni=0 \
		--tla-code nobs=20 \
		--tla-code mu=0.123 \
		--tla-code var=0.01 \
		--tla-code cov=0.0 \
		--tla-code loadings=0.1 \
		--tla-code errvars=0.0 \
		--tla-code errcovs=0.0 \
		--tla-str teststrategy="TTest" \
		--tla-code testside=1 \
		--tla-code testalpha=0.05 \
		--tla-code pubbias=0.95 \
		--tla-str selectionmodel="Significant Selection" \
		--tla-code maxpubs=70 \
		--tla-code journalalpha=0.05 \
		--tla-code journalside=1 \
		--tla-code ishacker=false \
		--tla-str hackid="0" \
		--tla-str decisionstrategy="Patient Decision Maker" \
		--tla-str decisionpref="Min Pvalue" \
		sam.jsonnet > config.json