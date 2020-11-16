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
	"n_obs": [5, 10, 20, 30, 50, 80],
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
	"hacking_probability": [1],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"test_alpha": [0.05, 0.005, 0.0005],
	"test_strategy_name": ["TTest"],
	"test_strategy_alternative": ["TwoSided"],

	"effect_strategy_name": ["StandardizedMeanDifference"],

	"journal_max_pubs": [10000],

	"journal_pub_bias": [0, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95],

	"decision_strategy_name": ["DefaultDecisionMaker"],
	"decision_initial_selection": [
		["sig", "effect > 0", "random"]
	],

	"hacking_strategies": [
		[
		    [
                {
                    "name": "OptionalStopping",
		            "target": "Both",
		            "prevalence": 1,
		            "defensibility": 1,
                    "max_attempts": 1,
                    "n_attempts": 1,
                    "num": 0,
                    "add_by_fraction": f,
                    "stopping_condition": ["sig"]
                },
				[
                    [
                        "min(pvalue)"
                    ]
                ],
				[
                    "!sig"
                ]
           	]
		] for f in [0.1, 0.2, 0.3, 0.4, 0.5]
	]
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
		        }
			},
			"researcher_parameters": {
				"decision_strategy": {
			        "name": "DefaultDecisionMaker",
		            "initial_selection_policies": [
		                params["decision_initial_selection"], ["effect > 0", "min(pvalue)"], ["effect < 0", "max(pvalue)"]
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
					params["hacking_strategies"]
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
