import os
import sys
import glob
import json
from tqdm import tqdm
import pandas as pd
from sqlalchemy import create_engine
from flatten_json import flatten


def extract_params(configfile):
	with open(configfile, 'r') as f:
		config = json.load(open(configfile, 'r'))

	config = flatten(config)

	paramslist = ["n-conditions", "n-dep-vars", "n-items", "n-obs",
				  "means", "vars", "covs", 
				  "pub-bias", "max-pubs", "alpha",
				  "is-hacker", "id", "name"]

	filtered_dict = {k:v for (k,v) in config.items() if any([(k.find(p) != -1) for p in paramslist])}

	names = ["ExperimentParameters_",
			 "JournalParameters_",
			 "ResearcherParameters_",
			 "SimulationParameters_"]

	new_filtered_dict = {}
	for k in filtered_dict.keys():
		newkey = k
		for name in names:
			newkey = newkey.replace(name, "")
		newkey = newkey.replace("-","_")
		new_filtered_dict[newkey] = filtered_dict[k]

	return new_filtered_dict

def main():
	filenames = glob.glob("outputs/*_sim.csv")

	engine = create_engine("sqlite:///dbs/yourprojectname.db")

	print("Prepareing the database...")

	for i in tqdm(range(len(filenames))):
		fbase = os.path.basename(filenames[i])
		fprefix = fbase.split("_")[0]

		params = extract_params("configs/" + fprefix + ".json")

		df = pd.read_csv("outputs/" + fprefix + "_sim.csv")
		df.assign(**params).to_sql('sim', con = engine, if_exists='append', index=False)

		df = pd.read_csv("outputs/" + fprefix + "_meta.csv")
		df.assign(**params).to_sql('meta', con = engine, if_exists='append', index=False)

if __name__ == '__main__':
	main()
