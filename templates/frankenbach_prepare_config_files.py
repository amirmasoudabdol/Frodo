import json
import uuid
import itertools
import numpy as np
import tqdm

params_info = {
	"n_sims": [1000],
	"log_level": ["info"],
	"progress": [False],
	"data_strategy_n_conditions": [2],
	"data_strategy_n_dep_vars": [1],
	"data_strategy_measurements": [
		{
		"dist": "mvnorm_distribution",
    	"means": [0.0, x],
        "covs": 0.0,
        "stddevs": 1.0
		} for x in [0.1, 0.2, 0.35, 0.5, 0.65, 0.8]
		# } for x in np.arange(0.0, 1.01, 0.1)
	],
	"data_strategy_errors": [
		{
		"dist": "mvnorm_distribution",
    	"means": [0.0, 0.0],
        "covs": 0.0,
        "stddevs": tau
        } for tau in [0, 0.1, 0.2, .32]
		# } for tau in np.arange(0.0, 1.01, 0.1)
	],
	"n_obs": [
	{
		"dist": "piecewise_linear_distribution",
		"intervals": [0, x - 1, x - 1, x, x   , x + 5, x + 10, x + x, x + 40, x + 60, x + 80],
		"densities": [0, 0 , 0.0 , 0 , 0.75 , .8     , 1     , .7     , .3     , .1  ,0]
	} for x in [10, 20, 50, 70]
	],
	"seed": ["random"],
	"is_pre_processing": [False],
	"hacking_probability": [1],
	"save_all_pubs": [False],
	"save_meta": [False],
	"save_overall_summaries": [True],
	"save_pubs_per_sim_summaries": [False],
	"save_rejected": [False],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"hacking_prob_base_hp": [0, 0.2, 0.4, 0.6, 0.8, 1.0],
	# "hacking_prob_base_hp": [p for p in np.arange(0, 1.01, 0.1)],

	"hacking_prob_lo_se": [0.0, 0.2, 0.4, 0.6, 0.8],
	# "hacking_prob_lo_se": [lop for lop in np.arange(0, 1.01, 0.1)],

	"researcher_submission_pro": [1.0, 0.9, 0.8, 0.7],
	# "researcher_submission_pro": [sp for sp in np.arange(0, 1.01, 0.1)],

	"test_alpha": [0.05],
	"test_strategy_name": ["TTest"],
	"test_strategy_alternative": ["TwoSided"],

	"effect_strategy_name": ["CohensD"],

	"journal_max_pubs": [8],

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
				    "data_strategy": {
				        "name": "LinearModel",
				        "measurements": params["data_strategy_measurements"],
				        "errors": params["data_strategy_errors"]
				    },
					"effect_strategy": {
							"name": params["effect_strategy_name"]
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
			            "name": "SignificantSelection",
			            "alpha": params["test_alpha"],
			            "pub_bias": params["journal_pub_bias"],
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
			            }
			        ]
			},
			"researcher_parameters": {
					"research_strategy": {
				      "name": "DefaultResearchStrategy",
	                  "between_stashed_selection_policies": [
				                ["sig", "min(pvalue)"]
				            ],
				            "between_replications_selection_policies": [[""]],
				            "initial_selection_policies": [
				                ["id == 1"]
				            ],
				            "stashing_policy": [
				                "sig"
				            ],
				            "submission_decision_policies": [
				                ""
				            ],
				            "will_continue_replicating_decision_policy": [""],
				            "will_start_hacking_decision_policies": [
				                "!sig"
				            ]
				    },
				    "submission_probability": params["researcher_submission_pro"],
					"probability_of_being_a_hacker": params["hacking_probability"],
		        	"probability_of_committing_a_hack": 1,
					"hacking_probability_strategy": {
			            "base_hp": params["hacking_prob_base_hp"],
			            "lo_p": params["hacking_prob_lo_se"],
			            "hi_p": params["hacking_prob_lo_se"] + 0.2,
			            "lo_sei": 0.1,
			            "hi_sei": 0.6,
			            "method": "FrankenbachStrategy"
			        },
				    "hacking_strategies": [
				    			[
					                {
					                    "name": "OptionalStopping",
					                    "level": "dv",
					                    "max_attempts": 1,
					                    "n_attempts": 1,
					                    "num": 0,
					                    "ratio": 0.5
					                },
					                [
					                    {
					                        "selection": [
					                            [
					                                "sig", "min(pvalue)"
					                            ]
					                        ]
					                    },
					                    {
					                        "will_continue_hacking_decision_policy": [
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
					                    "num": 10,
					                    "order": "random"
					                },
					                [
					                    {
					                        "selection": [
					                            [
					                                "sig", "min(pvalue)"
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
			               "name": "OptionalStopping",
			               "level": "dv",
			               "num": 10,
			               "n_attempts": 1,
			               "max_attempts": 1
			          	}
					]
			},
			"simulation_parameters": {
					"log_level": "off",
					"master_seed": params["seed"],
					"n_sims": params["n_sims"],
					"output_path": params["output_path"],
					"output_prefix": "",
					"update_config": True,

					"progress": params["progress"],
			        "save_all_pubs": params["save_all_pubs"],
			        "save_meta": params["save_meta"],
			        "save_overall_summaries": params["save_overall_summaries"],
			        "save_pubs_per_sim_summaries": params["save_pubs_per_sim_summaries"],
			        "save_rejected": params["save_rejected"],
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
