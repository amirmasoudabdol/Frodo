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
	"data_strategy_n_conditions": [2],
	"data_strategy_n_dep_vars": [5],
	"data_strategy_measurements": [
		{
		"dist": "mvnorm_distribution",
		"means": [0.0, 0.0, 0.0, 0.0, 0.0, x, x, x, x, x],
		"covs": 0.5,
		"stddevs": 1.0
		} for x in np.arange(0.0, 1.01, 0.05)
	],
	"n_obs": [50, 100, 200],
	"k": [2],
	"seed": ["random"],
	"is_pre_processing": [False],
	"is_phacker": [True, False],
	"save_pubs": [True],
	"save_sims": [False],
	"save_stats": [False],
	"save_rejected": [False],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"test_alpha": [0.05],
	"test_strategy_name": ["TTest"],
	"test_strategy_alternative": ["TwoSided"],

	"effect_strategy_name": ["MeanDifference"],

	"journal_selection_strategy_name": ["FreeSelection"],
	"journal_max_pubs": [10000],

	"decision_strategy_name": ["ImpatientDecisionMaker"],
	# "decision_strategy_preference": ["PreRegisteredOutcome", "RandomSigPvalue", "MinSigPvalue", "MaxSigPvalue", "RevisedMarjanHacker"],
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
				        "_name": "LinearModel",
				        "measurements": params["data_strategy_measurements"]
				    },
					"effect_strategy": {
							"_name": params["effect_strategy_name"]
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
			            "_name": "ImpatientDecisionMaker",
			            "decision_policies": [
			                [
			                    "sig",
			                    "effect > 0",
			                    "first"
			                ],
			                [
			                	"effect < 0",
			                	"max(pvalue)"
			                ]
			            ],
			            "final_decision_policies": [
			                
			            ],
			            "submission_policies": []
					},
					"hacking_strategies": [
							[
								{
					               "_name": "OptionalStopping",
					               "level": "dv",
					               "num": 10,
					               "n_attempts": 1,
					               "max_attempts": 1
					          	},
								{
									"_name": "SDOutlierRemoval",
									"level": "dv",
									"max_attempts": 1,
									"min_observations": 1,
									"mode": "Recursive",
									"multipliers": [
											2
									],
									"n_attempts": 1,
									"num": params["n_obs"],
									"order": "random"
								}
							]
					],
					"is_phacker": params["is_phacker"],
					"is_pre_processing": params["is_pre_processing"],
					"pre_processing_methods": [
							{"_name": "none"}
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

	print(" %d configuration files have generated!" % counter)

if __name__ == '__main__':
	main()
