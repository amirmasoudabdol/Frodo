#!/bin/bash

PROJECT_DIR=$(pwd)

rm ${PROJECT_DIR}/dbs/yourprojectname.db 
sqlite3 ${PROJECT_DIR}/dbs/yourprojectname.db < tables.sql

IFS="_"
for file in ${PROJECT_DIR}/outputs/*_sim.csv; do
	filename=$(basename ${file})
	read -ra ADDR <<< "${filename}"
	fileprefix=${ADDR[0]}
	echo $fileprefix

	csvsql --db sqlite:///${PROJECT_DIR}/dbs/yourprojectname.db \
											  --insert ${PROJECT_DIR}/outputs/${fileprefix}_sim.csv \
											  --table simdata \
											  --create-if-not-exists \
											  --linenumbers

	csvsql --db sqlite:///${PROJECT_DIR}/dbs/yourprojectname.db \
											  --insert ${PROJECT_DIR}/outputs/${fileprefix}_meta.csv \
											  --table metadata \
											  --create-if-not-exists \
											  --linenumbers
done