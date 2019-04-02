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
			--tla-str outputprefix=${uuid}$(eval echo ${params[5]}) \
			--tla-code metaseed=${params[6]} \
			--tla-str datastrategy=$(eval echo ${params[7]}) \
			--tla-code nc=${params[8]} \
			--tla-code nd=${params[9]} \
			--tla-code ni=${params[10]} \
			--tla-code nobs=$(eval echo ${params[11]}) \
			--tla-code mu=${params[12]} \
			--tla-code var=${params[13]} \
			--tla-code cov=${params[14]} \
			--tla-code loadings=${params[15]} \
			--tla-code errvars=${params[16]} \
			--tla-code errcovs=${params[17]} \
			--tla-str teststrategy=$(eval echo ${params[18]}) \
			--tla-code testside=${params[19]} \
			--tla-code testalpha=${params[20]} \
			--tla-code pubbias=${params[21]} \
			--tla-str selectionmodel=$(eval echo ${params[22]}) \
			--tla-code maxpubs=${params[23]} \
			--tla-code journalalpha=${params[24]} \
			--tla-code journalside=${params[25]} \
			--tla-code ishacker=$(eval echo ${params[26]}) \
			--tla-str hackid=$(eval echo ${params[27]}) \
			--tla-str decisionstrategy=$(eval echo ${params[28]}) \
			--tla-str decisionpref=$(eval echo ${params[29]}) \
			sam.jsonnet > "${path}/${uuid}.json"

	echo $uuid
}