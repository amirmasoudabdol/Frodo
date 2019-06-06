# Setup your paramters grid
# You can modify the configuration template ...

params = {
    # SimulationParameters
        "debug": [False]
        ,
        "verbose": [False]
        ,
        "progress": [False]
        ,
        "n_sims": [1, 2, 3]
        ,
        "output_path": ["../outputs/"]
        ,
        # If "auto", SAM will generate unique ID for each file
        "output_prefix": ["auto"]
        ,
    # ExperimentParameters
        "covs": [0.0],
        "data_strategy": [
            {
                "name": "LinearModel"
            }
        ]
        ,
        "effect_estimators": [
            {
                "name": "CohensD"
            }
        ],
        "err_covs": [0.001]
        ,
        "err_means": [0.0]
        ,
        "err_vars": [0.01]
        ,
        "loadings": [0.7]
        ,
        "means": [0.5]
        ,
        "n_conditions": [3]
        ,
        "n_dep_vars": [3]
        ,
        "n_items": [3]
        ,
        "n_obs": [10]
        ,
        "test_strategy": [
            {
                "alpha": 0.05,
                "name": "TTest",
                "side": "TwoSided"
            }
        ],
        "vars": [1]
        ,
    # JournalParameters
        "pubbias": [0.95]
        ,
        "selection_strategy": [
            {
                "alpha": 0.05,
                "name": "SignificantSelection",
                "pub_bias": 0.95,
                "selection_seed": 565444343,
                "side": 0
            }
        ]
    ,
    # ResearcherParameters
        "decision_strategy": [
            {
                "name": "D1"
            },
            {
                "name": "D2"
            }
        ]
        ,
        "hacking_strategies": 
        [ # Collections of Sets
            # Different Sets
            [ # Set 1
                [ # Group 1
                    {
                        "name": "S1; G1; M1"
                    },
                    {
                        "name": "S1; G1; M2"
                    }
                ],
                [
                    # Group 2
                    {"name": "S1; G2: M1"}
                ]
            ],
            [ # Set 2
                [ # 
                    {
                        "name": "S2; G1; M1"
                    }
                ]
            ]
        ]
}