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
	experiment(ndvs, nobs, mu, sd, cov, loadings=0.1, errsds=0.01, errcovs=0.001): {
	    "--data-strategy": "Linear Model",
	    "--n-conditions": 1,
	    "--n-dep-vars": ndvs,
	    "--n-items": 3,
	    "--n-obs": nobs,
	    "--means": mu,
	    "--sds": sd,
	    "--is-correlated": cov > 0,
	    "--covs": cov,
	    "--loadings": loadings,
	    "--err-sds": errsds,
	    "--err-covs": errcovs
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