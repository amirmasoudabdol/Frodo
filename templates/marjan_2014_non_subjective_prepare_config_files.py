import json
import uuid
import itertools
import numpy as np
import tqdm

params_info = {
	"n_sims": [1],
	"log_level": ["info"],
	"progress": [False],
	"data_strategy_n_items": [2, 5, 10, 20, 40],
	"n_obs": [10, 20, 40, 100, 500],
	"data_strategy_difficulties_mean": [0, 3],
	"data_strategy_abilities_mean": [[0, 0]],
	"data_strategy_n_categories": [2, 5],
	"data_strategy_n_conditions": [2],
	"data_strategy_n_dep_vars": [1],
	"k": [x for x in np.arange(2.0, 4.1, 0.25)],
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

	"journal_max_pubs": [25000],

	"journal_pub_bias": [z for z in np.arange(0, 0.81, 0.2)],

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
			"name": "Bakker_Non_Subjective",
			"experiment_parameters": {
				"data_strategy": {
					"abilities": {
						"dist": "mvnorm_distribution",
						"means": params["data_strategy_abilities_mean"],
						"stddevs": 1.0,
						"covs": 0.0
					},
					"difficulties": {
	                    "dist": "mvnorm_distribution",
	                    "means": [params["data_strategy_difficulties_mean"]] * (params["data_strategy_n_categories"] - 1),
	                    "stddevs": 1.0,
	                    "covs": 0.0
	                } if params["data_strategy_n_categories"] == 5 else [
	                	{
	                		"dist": "normal_distribution",
	                		"mean": params["data_strategy_difficulties_mean"],
	                		"stddev": 1.0
	                	}
	                ], 
					"n_categories": params["data_strategy_n_categories"],
					"n_items": params["data_strategy_n_items"],
					"response_function": "Rasch",
					"name": "GradedResponseModel"
				},
				"effect_strategy": {
					"name": "MeanDifference"
				},
				"n_conditions": params["data_strategy_n_conditions"],
				"n_dep_vars": params["data_strategy_n_dep_vars"],
				"n_obs": params["n_obs"],
                "n_reps": 1,
				"test_strategy": params["test_strategy"]
			},
			"journal_parameters": {
				"max_pubs": params["journal_max_pubs"],
		        "review_strategy": {
		            "name": "SignificantSelection",
		            "alpha": params["test_alpha"],
		            "pub_bias_rate": params["journal_pub_bias"],
		            "side": 0
		        }
			},
			"researcher_parameters": {
				"research_strategy": {
					"name": params["research_strategy_name"],
					"between_stashed_selection_policies": [
						[""]
					],
					"between_replications_selection_policies": [[""]],
					"initial_selection_policies": [
						[
						    "id == 1"
						]
					],
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
						""
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
						"name": "OutliersRemoval",
						"target": "Both",
						"prevalence": 0.5,
				        "defensibility": 0.1, 
						"min_observations": 5,
						"multipliers": [
							params["k"]
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

	print("> %d configuration files have generated!" % counter)

if __name__ == '__main__':
	main()
