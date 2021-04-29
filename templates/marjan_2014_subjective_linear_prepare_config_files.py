import json
import uuid
import itertools
import numpy as np
import tqdm

params_info = {
	"n_sims": [5000],
	"log_level": ["info"],
	"progress": [True],
	"n_obs": [10, 20, 40, 100],
	"data_strategy_means": [[0, 0], [0, 3]],
	"data_strategy_n_conditions": [2],
	"data_strategy_n_dep_vars": [1],
	"seed": ["random"],
	"is_pre_processing": [True],
	"hacking_probability": [0],
	"output_path": ["../outputs/"],
	"output_prefix": [""],

	"test_alpha": [0.05],

	"journal_selection_strategy_name": ["FreeSelection"],
	"journal_max_pubs": [8, 24],

	"journal_pub_bias": [z for z in np.arange(0, 1.01, 0.2)],

	"research_strategy_name": ["DefaultResearchStrategy"],

	"test_strategy": [
		{
			"name": "TTest",
			"alpha": 0.05,
			"alternative": "TwoSided",
			"var_equal": True
		}
	]
}


def main():

	configfilenames = open("configfilenames.pool", 'w')

	counter = 0;
	for param_vals in tqdm.tqdm(itertools.product(*params_info.values()), leave=False):

		counter += 1

		params = dict(zip(params_info.keys(), param_vals))

		data = {
			"name": "Bakker_Subjective_Linear",
			"experiment_parameters": {
				"data_strategy": {
					"measurements": {
						"dist": "mvnorm_distribution",
						"means": params["data_strategy_means"],
						"stddevs": 1.0,
						"covs": 0.0
					},
					"name": "LinearModel"
				},
				"effect_strategy": {
					"name": "StandardizedMeanDifference"
				},
				"n_conditions": params["data_strategy_n_conditions"],
				"n_dep_vars": params["data_strategy_n_dep_vars"],
				"n_obs": params["n_obs"],
                "n_reps": 1,
				"test_strategy": params["test_strategy"]
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
					"name": params["research_strategy_name"],
					"initial_selection_policies": [
						[
						    "id == 1"
						]
					],
					"between_stashed_selection_policies": [
						[""]
					],
					"between_replications_selection_policies": [[""]],
					"stashing_policy": [
						""
					],
					"submission_decision_policies": [
						""
					],
					"will_continue_replicating_decision_policy": [
						""
					],
					"will_start_hacking_decision_policies": [
						"!sig"
					]
			    },
				"hacking_strategies": [
					""
				],
				"probability_of_being_a_hacker": params["hacking_probability"],
	        	"probability_of_committing_a_hack": 1,
				"is_pre_processing": params["is_pre_processing"],
		        "pre_processing_methods": [
		            {
		                "name": "SubjectiveOutlierRemoval",
		                "min_observations": 5,
		                "prevalence": 0.5,
		                "target": "Both",
		                "defensibility": 0.1, 
		                "range": [
		                    2,
		                    3
		                ],
		                "step_size": 0.5,
		                "stopping_condition": [
		                    "sig"
		                ]
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
		        "progress": False,
		        "save_all_pubs": False,
		        "save_meta": True,
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

	print("> %d configuration files have generated!" % counter)

if __name__ == '__main__':
	main()
