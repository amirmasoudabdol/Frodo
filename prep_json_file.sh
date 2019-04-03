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
			--tla-str datastrategy=$(eval echo ${params[6]}) \
			--tla-code nc=${params[7]} \
			--tla-code nd=${params[8]} \
			--tla-code ni=${params[9]} \
			--tla-code nobs=$(eval echo ${params[10]}) \
			--tla-code mu=${params[11]} \
			--tla-code var=${params[12]} \
			--tla-code cov=${params[13]} \
			--tla-code loadings=${params[14]} \
			--tla-code errvars=${params[15]} \
			--tla-code errcovs=${params[16]} \
			--tla-str teststrategy=$(eval echo ${params[17]}) \
			--tla-code testside=${params[18]} \
			--tla-code testalpha=${params[19]} \
			--tla-code pubbias=${params[20]} \
			--tla-str selectionmodel=$(eval echo ${params[21]}) \
			--tla-code maxpubs=${params[22]} \
			--tla-code journalalpha=${params[23]} \
			--tla-code journalside=${params[24]} \
			--tla-code ishacker=$(eval echo ${params[25]}) \
			--tla-str hackid=$(eval echo ${params[26]}) \
			--tla-str decisionstrategy=$(eval echo ${params[27]}) \
			--tla-str decisionpref=$(eval echo ${params[28]}) \
			sam.jsonnet > "${path}/${uuid}.json"

	echo $uuid
}