function(nsims=1, nobs=25, ndvs=4, mu=0.1, sd=0.1, cov=0, alpha=0.05, pubbias=0.95, maxpubs=25) {
    "--debug": false,
    "--verbose": false,
    "--progress": true,
    "--n-sims": nsims,
    "--pub-bias": pubbias,
    "--journal-selection-model": "default",
    "--master-seed": 42,
    "--n-conditions": 1,
    "--n-dep-vars": ndvs,
    "--n-items": 0,
    "--n-obs": nobs,
    "--alpha": alpha,
    "--data-strategy": "FixedModel",
    "--means": [mu for i in std.range(1, ndvs)],
    "--sds": [sd for i in std.range(1, ndvs)],
    "--is-correlated": cov > 0,
    "--is-multivariate": cov > 0,
    "--cov-const": cov,
    "--cov-matrix": [[1, 0.5, 0.5, 0.5], [0.5, 1, 0.5, 0.5], [0.5, 0.5, 1, 0.5], [0.5, 0.5, 0.5, 1]],
    "--max-pubs": maxpubs,
    "--save-output": true,
    "--output-path": "outputs/",
    "--output-prefix": "d_%d_b_%0.2f_e_%0.3f_k_%d_h_OS-SR_sim" % [ndvs, pubbias, mu, maxpubs],
    "--is-phacker": true,
    "--selection-pref": "MinPvalue",
    "--p-hacking-methods": [
        {
          "type": "OptionalStopping",
          "size": 0,
          "attempts": 3
        }
    ]
}