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
	"data_strategy_n_dep_vars": [2],
	"n_obs": [x for x in range(8, 100)],
	"data_strategy_measurements": [
		{
		"dist": "mvnorm_distribution",
    	"means": [0.0, 0.0, x, x],
        "covs": 0.5,
        "stddevs": 1.0
		} for x in np.arange(0.0, 1.01, 0.1)
	] + [
		{
		"dist": "mvnorm_distribution",
    	"means": [0.0, 0.0, 0.0, x, x, x],
        "covs": 0.5,
        "stddevs": 1.0
		} for x in np.arange(0.0, 1.01, 0.1)
	] + [
		{
		"dist": "mvnorm_distribution",
    	"means": [0.0, 0.0, 0.0, 0.0, x, x, x, x],
        "covs": 0.5,
        "stddevs": 1.0
		} for x in np.arange(0.0, 1.01, 0.1)
	] + [
		{
		"dist": "mvnorm_distribution",
    	"means": [0.0, 0.0, 0.0, 0.0, 0.0, x, x, x, x, x],
        "covs": 0.5,
        "stddevs": 1.0
		} for x in np.arange(0.0, 1.01, 0.1)
	],
	"seed": ["random"],
	"hacking_probability": [0],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"test_alpha": [0.05],
	"test_strategy_name": ["TTest"],
	"test_strategy_alternative": ["TwoSided"],

	"effect_strategy_name": ["StandardizedMeanDifference"],

	"journal_max_pubs": [5000],

	"journal_pub_bias": [z for z in np.arange(0, 0.91, 0.1)],

	"decision_strategy_name": ["DefaultDecisionMaker"]
	}


def main():

	configfilenames = open("configfilenames.pool", 'w')

	counter = 0;
	for param_vals in tqdm.tqdm(itertools.product(*params_info.values()), leave=False):

		counter += 1

		params = dict(zip(params_info.keys(), param_vals))

		data = {
			"experiment_parameters": {
                    "n_reps": 1,
					"n_conditions": params["data_strategy_n_conditions"],
					"n_dep_vars": len(params["data_strategy_measurements"]["means"]) // 2,
					"n_obs": params["n_obs"],
				    "data_strategy": {
				        "name": "LinearModel",
				        "measurements": params["data_strategy_measurements"]
				    },
					"effect_strategy": {
							"name": params["effect_strategy_name"]
					},
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
		            "name": "SignificantSelection",
		            "alpha": params["test_alpha"],
		            "pub_bias": params["journal_pub_bias"],
		            "side": 0
		        },
		        "meta_analysis_metrics": [
		            {
		                "name": "EggersTestEstimator",
		                "alpha": 0.1
		            }
		        ]
			},
			"researcher_parameters": {
				"decision_strategy": {
			        "name": "DefaultDecisionMaker",
		            "initial_selection_policies": [
		                ["effect > 0", "sig", "first"], ["effect > 0", "min(pvalue)"], ["effect < 0", "max(pvalue)"]
		            ],
		            "will_start_hacking_decision_policies": [
		                "!sig"
		            ],
		            "stashing_policy": [
		                ""
		            ],
                    "between_hacks_selection_policies": [
		                [""]
		            ],
		            "between_replications_selection_policies": [[""]],
		            "will_continue_replicating_decision_policy": [""],
		            "submission_decision_policies": [
		                ""
		            ]
			    },
				"probability_of_being_a_hacker": params["hacking_probability"],
		        "probability_of_committing_a_hack": 1,
			    "hacking_strategies": [
					""
			    ],
				"is_pre_processing": False,
				"pre_processing_methods": [
					""
				]
			},
			"simulation_parameters": {
				"log_level": params["log_level"],
				"master_seed": params["seed"],
				"n_sims": params["n_sims"],
				"output_path": params["output_path"],
				"output_prefix": "",
		        "update_config": True,
		        "progress": False,
		        "save_all_pubs": False,
		        "save_meta": False,
		        "save_overall_summaries": True,
		        "save_pubs_per_sim_summaries": False,
		        "save_rejected": False
			}
		}

		uid = str(uuid.uuid4())
		filename = uid + ".json" 
		configfilenames.write(filename + "\n")

		# Replacing the output prefix with a unique id
		data["simulation_parameters"]["output_prefix"] = uid

		with open("configs/" + filename, 'w') as f:
				json.dump(data, f, indent = 4)

	print(" %d configuration files have generated!" % counter)

if __name__ == '__main__':
	main()
