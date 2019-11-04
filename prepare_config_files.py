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
    "seed": ["random"]
    }


def main():

  configfilenames = open("configfilenames.pool", 'w')

  for param_vals in itertools.product(*params_info.values()):

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
              "effect_estimators": {
                  "_name": "CohensD"
              },
              "n_conditions": 2,
              "n_dep_vars": 1,
              "n_obs": params["n_obs"],
              "test_strategy": {
                  "_name": "TTest",
                  "alpha": 0.05,
                  "side": "TwoSided"
              }
          },
          "JournalParameters": {
              "max_pubs": 10,
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
              "is_phacker": True
          },
          "SimulationParameters": {
              "debug": params["debug"],
              "master_seed": params["seed"],
              "n_sims": params["n_sims"],
              "output_path": "../outputs/",
              "output_prefix": "",
              "progress": params["progress"],
              "verbose": params["verbose"]
          }
      }

      uid = str(uuid.uuid4())
      filename = uid + ".json" 
      configfilenames.write(filename + "\n")

      data["output_prefix"] = uid

      with open("configs/" + filename, 'w') as f:
          json.dump(data, f, indent = 4)

if __name__ == '__main__':
  main()