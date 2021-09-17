import json
import uuid
import itertools
import numpy as np
import tqdm

params_info = {
	"n_sims": [1000],
	"log_level": ["info"],
	"progress": [False],
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
		"dist": "piecewise_constant_distribution",
		"intervals": [6, 24, 300],
		"densities": [0.75,  0.25]
	}],
	"seed": ["random"],
	"hacking_probability": [0, 1],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"test_alpha": [0.05, 0.005, 0.0005],
	"test_strategy_name": ["TTest"],
	"test_strategy_alternative": ["TwoSided"],

	"effect_strategy_name": ["StandardizedMeanDifference"],

	"journal_max_pubs": [8, 24, 72],

	"journal_pub_bias": [z for z in np.arange(0, 1.01, 0.1)],

	"research_strategy_name": ["DefaultResearchStrategy"]
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
				"n_dep_vars": params["data_strategy_n_dep_vars"],
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
		        "review_strategy": {
		            "name": "SignificantSelection",
		            "alpha": params["test_alpha"],
		            "pub_bias_rate": params["journal_pub_bias"],
		            "side": 0
		        },
		        "meta_analysis_metrics": [
		            {
		                "name": "RandomEffectEstimator",
		                "estimator": "DL"
		            },
		            {
		                "name": "EggersTestEstimator",
		                "alpha": 0.1
		            },
		            {
		                "name": "TrimAndFill",
		                "alpha": 0.1,
		                "estimator": "R0",
		                "side": "auto"
		            },
		            {
		                "name": "RankCorrelation",
		                "alpha": 0.1,
		                "alternative": "TwoSided"
		            },
		            {
		            	"name": "TestOfObsOverExptSig",
		            	"alpha": 0.1
		            }
		        ]
			},
			"researcher_parameters": {
				"research_strategy": {
			      "name": "DefaultResearchStrategy",
					"initial_selection_policies": [
					    ["min(pvalue)"]
					],
		            "will_start_hacking_decision_policies": [
		                "!sig"
		            ],
		            "stashing_policy": [
		                "min(pvalue)"
		            ],
                    "between_stashed_selection_policies": [
			            ["last"]
		            ],
		            "between_replications_selection_policies": [[""]],
		            "will_continue_replicating_decision_policy": [""],
		            "submission_decision_policies": [
		                ""
		            ],
			    },
				"probability_of_being_a_hacker": params["hacking_probability"],
		        "probability_of_committing_a_hack": 1,
			    "hacking_strategies": [
					[
		                {
		                    "name": "OptionalStopping",
		                    "target": "Both",
		                    "prevalence": 1,
		                    "defensibility": 1,
		                    "n_attempts": 1,
		                    "ratio": 0.3
		                },
						[
                            [
                                "min(pvalue)"
                            ]
                        ],
						[
                            "!sig"
		                ]
	               	],
	               	[
		                {
		                    "name": "OptionalStopping",
		                    "target": "Both",
		                    "prevalence": 1,
		                    "defensibility": 1,
		                    "n_attempts": 1,
		                    "ratio": 0.3
		                },
						[
                            [
                                "min(pvalue)"
                            ]
                        ],
						[
                            "!sig"
		                ]
	               	],
	               	[
		                {
		                    "name": "OptionalStopping",
		                    "target": "Both",
		                    "prevalence": 1,
		                    "defensibility": 1,
		                    "n_attempts": 1,
		                    "ratio": 0.3
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
		        "save_meta": True,
		        "save_overall_summaries": True,
		        "save_pubs_per_sim_summaries": True,
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
