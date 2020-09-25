import json
import uuid
import itertools
import numpy as np
import tqdm

nSmall = np.array([5, 10, 20])
nLarge = 5 * nSmall

params_info = {
	"n_sims": [100],
	"log_level": ["info"],
	"progress": [False],
	"data_strategy_n_conditions": [2],
	"data_strategy_n_dep_vars": [2],
	"data_strategy_measurements": [
		{
		"dist": "mvnorm_distribution",
    	"means": [0.0, 0.0, x, x],
        "covs": 0.5,
        "stddevs": 1.0,
        "sigma": [[1.0,   0.5,   0.0,   0.0],
	              [0.5,   1.0,   0.0,   0.0],
	              [0.0,   0.0,   1.0,   0.5],
	              [0.0,   0.0,   0.5,   1.0]]
		} for x in np.arange(0.0, 1.01, 0.1)
	],
	"n_obs": [5, 10, 20, 25, 50, 100],
	"k": [2],
	"seed": ["random"],
	"is_pre_processing": [False],
	"hacking_probability": [1],
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
	"journal_max_pubs": [40],

	"decision_strategy_name": ["DefaultDecisionMaker"],

	"n_reps": [5],
	"nb": [10]
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
				        "name": "LinearModel",
				        "measurements": params["data_strategy_measurements"]
				    },
					"effect_strategy": {
						"name": params["effect_strategy_name"]
					},
					"n_conditions": params["data_strategy_n_conditions"],
					"n_dep_vars": params["data_strategy_n_dep_vars"],
					"n_obs": params["n_obs"],
                    "n_reps": 1 if params["n_obs"] in nLarge else params["n_reps"],
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
					},
			        "meta_analysis_metrics": [
		            {
		                "name": "RandomEffectEstimator",
		                "estimator": "DL"
		            },
		            {
		                "name": "EggersTestEstimator",
		                "alpha": 0.1
		            }
		        ]
			},
			"researcher_parameters": {
					"decision_strategy": {
				      "name": params["decision_strategy_name"],
	                  "between_hacks_selection_policies": [
				                [
				                    "effect > 0",
				                    "min(pvalue)"
				                ],
				                [
				                    "effect < 0",
				                    "max(pvalue)"
				                ]
				            ],
				            "between_replications_selection_policies": [[""]] if params["n_obs"] in nLarge else [["effect > 0", "sig", "first"], ["effect > 0", "min(pvalue)"], ["effect < 0", "max(pvalue)"]],
				            # "between_replications_selection_policies": [[""]] if params["n_obs"] in nLarge else [["last"]],
				            "initial_selection_policies": [
				                [
				                    "id == 2",
				                    "sig",
				                    "effect > 0"
				                ],
				                [
				                    "id == 3",
				                    "sig",
				                    "effect > 0"
				                ]
				            ],
				            "stashing_policy": [
				                "all"
				            ],
				            "submission_decision_policies": [
				                ""
				            ],
				            "will_continue_replicating_decision_policy": [
				                ""
				            ],
				            "will_start_hacking_decision_policies": [
				                "effect < 0",
				                "!sig"
				            ]
				    },
									"probability_of_being_a_hacker": params["hacking_probability"],
		        "probability_of_committing_a_hack": 1,
				    "hacking_strategies": [
				    			[
					                {
					                    "name": "OptionalStopping",
					                    "level": "dv",
					                    "max_attempts": 1,
					                    "n_attempts": 1,
					                    "num": params["nb"]
					                },
					                [
					                    {
					                        "selection": [
					                            [
					                                "effect > 0",
					                                "min(pvalue)"
					                            ]
					                        ]
					                    },
					                    {
					                        "will_continue_hacking_decision_policy": [
					                            "effect < 0",
					                            "!sig"
					                        ]
					                    }
					                ],
					                {
					                    "name": "OutliersRemoval",
					                    "level": "dv",
					                    "max_attempts": 1,
					                    "min_observations": 1,
					                    "multipliers": [
					                        2
					                    ],
					                    "n_attempts": 1,
					                    "num": params["n_obs"],
					                    "order": "random"
					                },
					                [
					                    {
					                        "selection": [
					                            [
					                                "effect > 0",
					                                "min(pvalue)"
					                            ]
					                        ]
					                    },
					                    {
					                        "will_continue_hacking_decision_policy": [
					                            "effect < 0",
					                            "!sig"
					                        ]
					                    }
					                ]
					            ]
					        ],
					"is_pre_processing": params["is_pre_processing"],
					"pre_processing_methods": [
								{
					               "name": "OptionalStopping",
					               "level": "dv",
					               "num": 10,
					               "n_attempts": 1,
					               "max_attempts": 1
					          	},
								{
									"name": "OutliersRemoval",
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

	print(" %d configuration files have generated!" % counter)

if __name__ == '__main__':
	main()