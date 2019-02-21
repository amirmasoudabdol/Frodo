{
	simulation(nsims, outputpath, outputfilename): {
		"--debug": false,
		"--verbose": false,
		"--progress": false,
		"--n-sims": nsims,
		"--master-seed": 42,
		"--save-output": true,
		"--output-path": outputpath,
		"--output-prefix": outputfilename
	},
	experiment(ndvs, nobs, mu, sd, cov): {
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
	journal(pubbias, maxpubs, alpha, side): {
	    "--pub-bias": pubbias,
	    "--journal-selection-model": "Significant Selection",
	    "--max-pubs": maxpubs,
	    "--alpha": alpha,
	    "--side": side
	},
	researcher(ishacker, hacks, hackid): {
	    "--is-phacker": ishacker,
	    "--p-hacking-methods": hacks[hackid]
	}
}