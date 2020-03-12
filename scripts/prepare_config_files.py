import json
import uuid
import itertools
import numpy as np
import tqdm

params_info = {
	"n_sims": [1],
	"debug": [False],
	"progress": [False],
	"verbose": [False],
	"data_strategy_n_items": [5],
	"data_strategy_difficulties": [[0]],
	"data_strategy_abilities": [[0, 0.2]],
	"data_strategy_n_categories": [1],
	"data_strategy_n_conditions": [2],
	"data_strategy_n_dep_vars": [1],
	"n_obs": [20],
	"k": [2],
	"seed": ["random"],
	"is_pre_processing": [False],
	"is_phacker": [False],
	"save_pubs": [False],
	"save_sims": [False],
	"save_stats": [True],
	"save_rejected": [False],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"test_alpha": [0.05],
	"test_strategy_name": ["TTest"],
	"test_strategy_alternative": ["TwoSided"],

	"journal_selection_strategy_name": ["FreeSelection"],
	"journal_max_pubs": [10],

	"decision_strategy_name": ["PatientDecisionMaker"],
	"decision_strategy_preference": ["MinPvalue"],
	"decision_strategy_submission_policy": ["Anything"]
	}


def main():

	configfilenames = open("configfilenames.pool", 'w')

	counter = 0;
	for param_vals in tqdm.tqdm(itertools.product(*params_info.values()), leave=False):

		counter += 1

		params = dict(zip(params_info.keys(), param_vals))

		data = {
			"experiment_parameters": {
					"data_strategy": {
						"abilities": params["data_strategy_abilities"],
						"difficulties": params["data_strategy_difficulties"],
						"n_categories": params["data_strategy_n_categories"],
						"n_items": params["data_strategy_n_items"],
						"_name": "GradedResponseModel"
					},
					"effect_strategy": {
							"_name": "CohensD"
					},
					"n_conditions": params["data_strategy_n_conditions"],
					"n_dep_vars": params["data_strategy_n_dep_vars"],
					"n_obs": params["n_obs"],
					"test_strategy": {
							"_name": params["test_strategy_name"],
							"alpha": params["test_alpha"],
							"alternative": params["test_strategy_alternative"]
					}
			},
			"journal_parameters": {
					"max_pubs": params["journal_max_pubs"],
					"selection_strategy": {
							"_name": params["journal_selection_strategy_name"]
					}
			},
			"researcher_parameters": {
					"decision_strategy": {
							"_name": params["decision_strategy_name"],
							"preference": params["decision_strategy_preference"],
							"submission_policy": params["decision_strategy_submission_policy"]
					},
					"hacking_strategies": [
							[
									{
											"_name": "SDOutlierRemoval",
											"level": "dv",
											"max_attempts": 10,
											"min_observations": 20,
											"mode": "Recursive",
											"multipliers": [
													1
											],
											"n_attempts": 4,
											"num": 2,
											"order": "max first"
									}
							]
					],
					"is_phacker": params["is_phacker"],
					"is_pre_processing": params["is_pre_processing"],
					"pre_processing_methods": [
							{
									"_name": "SDOutlierRemoval",
									"level": "dv",
									"max_attempts": 1000,
									"min_observations": 5,
									"multipliers": [
											0.5
									],
									"n_attempts": 1000,
									"num": 1000,
									"order": "random"
							}
					]
			},
			"simulation_parameters": {
					"debug": params["debug"],
					"master_seed": params["seed"],
					"n_sims": params["n_sims"],
					"output_path": params["output_path"],
					"output_prefix": "",
					"progress": params["progress"],
					"verbose": params["verbose"],
					"save_pubs": params["save_pubs"],
					"save_sims": params["save_sims"],
					"save_stats": params["save_stats"],
					"save_rejected": params["save_rejected"]
			}
		}

		uid = str(uuid.uuid4())
		filename = uid + ".json" 
		configfilenames.write(filename + "\n")

		# Replacing the output prefix with a unique id
		data["output_prefix"] = uid

		with open("configs/" + filename, 'w') as f:
				json.dump(data, f, indent = 4)

	print("> %d configuration files have generated!" % counter)

if __name__ == '__main__':
	main()