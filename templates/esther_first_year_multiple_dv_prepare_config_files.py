import json
import uuid
import itertools
import numpy as np
import tqdm

params_info = {
	"n_sims": [1000],
	"debug": [False],
	"progress": [False],
	"verbose": [False],
	"data_strategy_n_conditions": [5],
	"data_strategy_n_dep_vars": [1],
	"data_strategy_measurements": [
		{
		"dist": "mvnorm_distribution",
    	"means": [0.0, x, x, x, x],
        "covs": 0.0,
        "stddevs": 1.0
		} for x in np.arange(0.0, 1.01, 0.1)
	],
	"n_obs": [{
		"dist": "piecewise_linear_distribution",
		"intervals": [0, 3, 5.9, 6, 20, 24, 25 , 30  , 40 , 50,   100,  200,  300],
		"densities": [0, 0,   0, 1,  1,  1, 0.75, 0.25, 0.1, 0.1, 0.05, 0.05, 0.05]
	}],
	"seed": ["random"],
	"is_pre_processing": [False],
	"is_phacker": [True, False],
	"save_pubs": [True],
	"save_sims": [False],
	"save_stats": [False],
	"save_rejected": [False],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"test_alpha": [0.05, 0.005, 0.0005, 0.00005],
	"test_strategy_name": ["TTest"],
	"test_strategy_alternative": ["TwoSided"],

	"effect_strategy_name": ["MeanDifference"],

	"journal_max_pubs": [8, 24, 72],

	"journal_pub_bias": [z for z in np.arange(0, 1.01, 0.1)],

	"decision_strategy_name": ["MarjansDecisionMaker"]
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
                    "n_reps": 1,
					"test_strategy": {
							"_name": params["test_strategy_name"],
							"alpha": params["test_alpha"],
							"alternative": params["test_strategy_alternative"]
					}
			},
			"journal_parameters": {
					"max_pubs": params["journal_max_pubs"],
			        "selection_strategy": {
			            "_name": "SignificantSelection",
			            "alpha": params["test_alpha"],
			            "pub_bias": params["journal_pub_bias"],
			            "side": 0
			        },
			        "meta_analysis_metrics": [
			            {
			                "_name": "FixedEffectEstimator"
			            },
			            {
			                "_name": "RandomEffectEstimator",
			                "estimator": "DL"
			            },
			            {
			                "_name": "EggersTestEstimator",
			                "alpha": 0.1
			            },
			            {
			                "_name": "TestOfObsOverExptSig",
			                "alpha": 0.05
			            },
			            {
			                "_name": "TrimAndFill",
			                "alpha": 0.05,
			                "estimator": "R0",
			                "side": "right"
			            },
			            {
			                "_name": "RankCorrelation",
			                "alpha": 0.05,
			                "alternative": "TwoSided"
			            }
			        ]
			},
			"researcher_parameters": {
					"decision_strategy": {
				      "_name": "MarjansDecisionMaker",
	                  "between_hacks_selection_policies": [
				                ["last"]
				            ],
				            "between_replications_selection_policies": [[""]],
				            "initial_selection_policies": [
				                [
				                    "effect > 0", "min(pvalue)"
				                ]
				            ],
				            "stashing_policy": [
				                "min(pvalue)"
				            ],
				            "submission_decision_policies": [
				                ""
				            ],
				            "will_continue_replicating_decision_policy": [""],
				            "will_start_hacking_decision_policies": [
				                "!sig"
				            ]
				    },
					"is_phacker": params["is_phacker"],
				    "hacking_strategies": [
							[
				                {
				                    "_name": "OptionalStopping",
				                    "level": "dv",
				                    "max_attempts": 1,
				                    "n_attempts": 1,
				                    "num": 0,
				                    "add_by_fraction": 0.3
				                },
				                [
				                    {
				                        "selection": [
				                            [
				                                "min(pvalue)"
				                            ]
				                        ]
				                    },
				                    {
				                        "will_continue_hacking_decision_policy": [
				                            "!sig"
				                        ]
				                    }
				                ]
			               	],
			               	[
				                {
				                    "_name": "OptionalStopping",
				                    "level": "dv",
				                    "max_attempts": 1,
				                    "n_attempts": 1,
				                    "num": 0,
				                    "add_by_fraction": 0.3
				                },
				                [
				                    {
				                        "selection": [
				                            [
				                                "min(pvalue)"
				                            ]
				                        ]
				                    },
				                    {
				                        "will_continue_hacking_decision_policy": [
				                            "!sig"
				                        ]
				                    }
				                ]
			               	],
			               	[
				                {
				                    "_name": "OptionalStopping",
				                    "level": "dv",
				                    "max_attempts": 1,
				                    "n_attempts": 1,
				                    "num": 0,
				                    "add_by_fraction": 0.3
				                },
				                [
				                    {
				                        "selection": [
				                            [
				                                "min(pvalue)"
				                            ]
				                        ]
				                    },
				                    {
				                        "will_continue_hacking_decision_policy": [
				                            "!sig"
				                        ]
				                    }
				                ]
			               	]
					    ],
					"is_pre_processing": params["is_pre_processing"],
					"pre_processing_methods": [
						{
			               "_name": "OptionalStopping",
			               "level": "dv",
			               "num": 10,
			               "n_attempts": 1,
			               "max_attempts": 1
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
		data["simulation_parameters"]["output_prefix"] = uid

		with open("configs/" + filename, 'w') as f:
				json.dump(data, f, indent = 4)

	print(" %d configuration files have generated!" % counter)

if __name__ == '__main__':
	main()
