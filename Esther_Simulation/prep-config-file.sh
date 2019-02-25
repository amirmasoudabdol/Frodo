#!/bin/bash

prepare_config_file() {
	params=("${!1}")
	path=($2)

	d=${params[0]}
	b=${params[1]}
	e=${params[2]}
	k=${params[3]}
	ish=${params[4]}
	hid="${params[5]}"
	configprefix=d_${d}_b_${b}_e_${e}_k_${k}_${ish}_h_${hid}

	jsonnet --tla-code nsims=${nsims} \
				--tla-code ndvs=${d} \
				--tla-code pubbias=${b} \
				--tla-code maxpubs=${k} \
				--tla-code mu=${e} \
				--tla-code ishacker=${ish} \
				--tla-str hackid=${hid} \
				--tla-str outputpath=${path}/outputs/ \
				--tla-str outputfilename=${configprefix} \
				esther.jsonnet > "${path}/configs/${configprefix}".json


	echo $configprefix
}