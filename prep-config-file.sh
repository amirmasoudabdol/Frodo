#!/bin/bash

prepare_config_file() {
	params=("${!1}")
	path=($2)

	uuid=$(uuidgen)
	uuid=${uuid:0:8}

	d=${params[0]}
	b=${params[1]}
	e=${params[2]}
	k=${params[3]}
	sd=${params[4]}
	cov=${params[5]}
	obs=${params[6]}
	a=${params[7]}
	ish=${params[8]}
	hid="${params[9]}"
	configprefix=d_${d}_b_${b}_e_${e}_k_${k}_sd_${sd}_cov_${cov}_obs_${obs}_a_${a}_${ish}_h_${hid}

	jsonnet --tla-code nsims=${nsims} \
				--tla-code ndvs=${d} \
				--tla-code pubbias=${b} \
				--tla-code maxpubs=${k} \
				--tla-code mu=${e} \
				--tla-code sd=${sd} \
				--tla-code cov=${cov} \
				--tla-code nobs=${obs} \
				--tla-code a=${a} \
				--tla-code ishacker=${ish} \
				--tla-str hackid=${hid} \
				--tla-str outputpath=${path}/outputs/ \
				--tla-str outputfilename=${configprefix} \
				esther.jsonnet > "${path}/configs/${configprefix}".json


	echo $configprefix
}