import json
import uuid
import itertools
import numpy as np
import tqdm

params_info = {
	"n_sims": [1],
	"log_level": ["info"],
	"progress": [False],
	"data_strategy_n_conditions": [2],
	"data_strategy_n_dep_vars": [1],
	"n_obs": [10, 25, 50, 250],
	"k": [x for x in np.arange(2.0, 4.1, 0.1)],
	"seed": ["random"],
	"is_pre_processing": [True],
	"hacking_probability": [0],
	"save_pubs": [True],
	"save_sims": [False],
	"save_stats": [False],
	"save_rejected": [False],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"test_alpha": [0.05],
	"test_strategy_name": ["TTest"],
	"test_strategy_alternative": ["TwoSided"],

	"journal_selection_strategy_name": ["FreeSelection"],
	"journal_max_pubs": [1000],

	"decision_strategy_name": ["DefaultDecisionMaker"],
	"decision_strategy_init_dec_policies": [["id == 1"]]
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
						"measurements": [
							{
							"dist": "normal_distribution",
							"mean": 0,
							"stddev": 1
							},
							{
							"dist": "normal_distribution",
							"mean": 0,
							"stddev": 1
							}
						],
						"name": "LinearModel"
					},
					"effect_strategy": {
						"name": "StandardizedMeanDifference"
					},
					"n_conditions": params["data_strategy_n_conditions"],
					"n_dep_vars": params["data_strategy_n_dep_vars"],
					"n_obs": params["n_obs"],
                    "n_reps": 1,
					"test_strategy": {
						"name": params["test_strategy_name"],
						"alpha": params["test_alpha"],
						"alternative": params["test_strategy_alternative"],
					"var_equal": True
					}
			},
			"journal_parameters": {
					"max_pubs": params["journal_max_pubs"],
					"selection_strategy": {
						"name": params["journal_selection_strategy_name"]
					}
			},
			"researcher_parameters": {
					"decision_strategy": {
				      "name": params["decision_strategy_name"],
				      "between_replications_decision_policies": [[""]],
				      "final_decision_policies": [[""]],
				      "initial_decision_policies": [
				      	params["decision_strategy_init_dec_policies"]
				      ],
				      "submission_policies": [""]
				    },
					"hacking_strategies": [
						[
							{
								"name": "OutliersRemoval",
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
							},
							[[""]]
						]
					],
									"probability_of_being_a_hacker": params["hacking_probability"],
		        "probability_of_committing_a_hack": 1,
					"is_pre_processing": params["is_pre_processing"],
					"pre_processing_methods": [
						{
							"name": "OutliersRemoval",
							"level": "dv",
							"max_attempts": 1,
							"min_observations": 5,
							"multipliers": [
								params["k"]
							],
							"n_attempts": 1,
							"num": params["n_obs"],
							"order": "max first"
						}
					]
			},
			"simulation_parameters": {
					"log_level": params["log_level"],
					"master_seed": params["seed"],
					"n_sims": params["n_sims"],
					"output_path": params["output_path"],
					"output_prefix": "",
					"update_config": True,

					"progress": params["progress"],
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
		data["simulation_parameters"]["output_prefix"] = uid

		with open("configs/" + filename, 'w') as f:
				json.dump(data, f, indent = 4)

	print("> %d configuration files have generated!" % counter)

if __name__ == '__main__':
	main()
