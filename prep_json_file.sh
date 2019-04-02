#!/bin/bash

prepare_json_file() {

	params=("${!1}")
	path=($2)

	uuid=$(uuidgen)
	uuid=${uuid:0:13}

	jsonnet --tla-code debug=$(eval echo ${params[0]}) \
			--tla-code verbose=$(eval echo ${params[1]}) \
			--tla-code progress=$(eval echo ${params[2]}) \
			--tla-code nsims=${params[3]} \
			--tla-code masterseed=${params[4]} \
			--tla-code saveoutput=$(eval echo ${params[5]}) \
			--tla-str outputprefix=${uuid}$(eval echo ${params[6]}) \
			--tla-code metaseed=${params[7]} \
			--tla-str datastrategy=$(eval echo ${params[8]}) \
			--tla-code nc=${params[9]} \
			--tla-code nd=${params[10]} \
			--tla-code ni=${params[11]} \
			--tla-code nobs=${params[12]} \
			--tla-code mu=${params[13]} \
			--tla-code var=${params[14]} \
			--tla-code cov=${params[15]} \
			--tla-code loadings=${params[16]} \
			--tla-code errvars=${params[17]} \
			--tla-code errcovs=${params[18]} \
			--tla-str teststrategy=$(eval echo ${params[19]}) \
			--tla-code testside=${params[20]} \
			--tla-code testalpha=${params[21]} \
			--tla-code pubbias=${params[22]} \
			--tla-str selectionmodel=$(eval echo ${params[23]}) \
			--tla-code maxpubs=${params[24]} \
			--tla-code journalalpha=${params[25]} \
			--tla-code journalside=${params[26]} \
			--tla-code ishacker=$(eval echo ${params[27]}) \
			--tla-str hackid=$(eval echo ${params[28]}) \
			--tla-str decisionstrategy=$(eval echo ${params[29]}) \
			--tla-str decisionpref=$(eval echo ${params[30]}) \
			sam.jsonnet > "${path}/${uuid}.json"

	echo $uuid
}