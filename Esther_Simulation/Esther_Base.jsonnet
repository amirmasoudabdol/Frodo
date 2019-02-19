function(nsims=1, nobs=0, ndvs=4, mu=0.1,
           sd=0.1, cov=0, alpha=0.05, pubbias=0.95, maxpubs=25,
           output_path = "outputs/") {
  "--debug": false,
  "--verbose": false,
  "--progress": true,
  "--n-sims": nsims,
  "--master-seed": 42,
  "--save-output": true,
  "--output-path": output_path,
  "--output-prefix": "d_%d_b_%0.2f_e_%0.3f_k_%d_h_Base_sim" % [ndvs, pubbias, mu, maxpubs],
  "Journal Parameters": {
    "--pub-bias": pubbias,
    "--journal-selection-model": "SignificantSelection",
    "--max-pubs": maxpubs,
    "--alpha": alpha,
    "--side": 1
  },
  "Experiment Parameters": {
    "--data-strategy": "FixedModel",
    "--n-conditions": 1,
    "--n-dep-vars": ndvs,
    "--n-items": 3,
    "--n-obs": nobs,
    "--means": mu,
    "--sds": sd,
    "--is-correlated": cov > 0,
    "--covs": cov,
    "--loadings": 0.7,
    "--err-sds": 0.01,
    "--err-covs": 0.001
  },
  "Researcher Parameters": {
    "--is-phacker": false,
    "--selection-pref": "MinPvalue",
    "--p-hacking-methods": [
        {
          "type": "OptionalStopping",
          "size": 3,
          "attempts": 10
        }
    ]
  }
}