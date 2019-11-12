import json
import uuid
import itertools
import numpy as np

params_info = {
    "n_sims": [1],
    "debug": [False],
    "progress": [False],
    "verbose": [False],
    "n_items": [5],
    "difficulties": [[0]],
    "abilities": [[0, 0.2]],
    "n_categories": [1],
    "n_obs": [20],
    "k": [2],
    "seed": ["random"],
    "is_pre_processing": [False],
    "is_phacker": [False],
    "save_pubs": [False],
    "save_sims": [False],
    "save_stats": [True],
    "output_path": ["../outputs/"],
    "output_prefix": [""],
    "max_pubs": [10],
    "test_alpha": [0.05],
    "test_strategy_name": ["TTest"]
    }


def main():

  configfilenames = open("configfilenames.pool", 'w')

  counter = 0;
  for param_vals in itertools.product(*params_info.values()):

      counter += 1

      params = dict(zip(params_info.keys(), param_vals))

      data = {
          "ExperimentParameters": {
              "data_strategy": {
                "abilities": params["abilities"],
                "difficulties": params["difficulties"],
                "n_categories": params["n_categories"],
                "n_items": params["n_items"],
                "_name": "GradedResponseModel"
              },
              "effect_strategy": {
                  "_name": "CohensD"
              },
              "n_conditions": 2,
              "n_dep_vars": 1,
              "n_obs": params["n_obs"],
              "test_strategy": {
                  "_name": params["test_strategy_name"],
                  "alpha": params["test_alpha"],
                  "side": "TwoSided"
              }
          },
          "JournalParameters": {
              "max_pubs": params["max_pubs"],
              "selection_strategy": {
                  "_name": "FreeSelection"
              }
          },
          "ResearcherParameters": {
              "decision_strategy": {
                  "_name": "PatientDecisionMaker",
                  "preference": "MinPvalue"
              },
              "hacking_strategies": [
                  [
                      {
                          "_name": "SDOutlierRemoval",
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
                      }
                  ]
              ],
              "is_phacker": params["is_phacker"],
              "is_pre_processing": params["is_pre_processing"],
              "pre_processing_methods": [
                  {
                      "_name": "SDOutlierRemoval",
                      "level": "dv",
                      "max_attempts": 1000,
                      "min_observations": 5,
                      "multipliers": [
                          0.5
                      ],
                      "n_attempts": 1000,
                      "num": 1000,
                      "order": "random"
                  }
              ]
          },
          "SimulationParameters": {
              "debug": params["debug"],
              "master_seed": params["seed"],
              "n_sims": params["n_sims"],
              "output_path": params["output_path"],
              "output_prefix": "",
              "progress": params["progress"],
              "verbose": params["verbose"],
              "save_pubs": params["save_pubs"],
              "save_sims": params["save_sims"],
              "save_stats": params["save_stats"]
          }
      }

      uid = str(uuid.uuid4())
      filename = uid + ".json" 
      configfilenames.write(filename + "\n")

      # Replacing the output prefix with a unique id
      data["output_prefix"] = uid

      with open("configs/" + filename, 'w') as f:
          json.dump(data, f, indent = 4)

  print("%d configuration files have generated!" % counter)

if __name__ == '__main__':
  main()