{
  simulation(debug, verbose, progress, nsims, masterseed, saveoutput=true, outputpath, outputprefix): {
    "--debug": debug,
    "--verbose": verbose,
    "--progress": progress,
    "--n-sims": nsims,
    "--master-seed": masterseed,
    "--save-output": saveoutput,
    "--output-path": outputpath,
    "--output-prefix": outputprefix
  },
  experiment(metaseed, datastrategy, nc, nd, ni, nobs, mu, var, cov, loadings, errvars, errcovs, teststrategy, testside, testalpha): {
    "--meta-seed": metaseed,
    "--data-strategy": datastrategy,
    "--n-conditions": nc,
    "--n-dep-vars": nd,
    "--n-items": ni,
    "--n-obs": nobs,
    "--means": mu,
    "--vars": var,
    "--covs": cov,
    "--loadings": loadings,
    "--err-vars": errvars,
    "--err-covs": errcovs,
    "--test-strategy": {
      "type": teststrategy,
      "side": testside,
      "alpha": testalpha
    },
    "--effect-estimators": [
      "Cohens D",
      "Hedges G"
    ]
  },
  journal(pubbias, selectionmodel, maxpubs, journalalpha, journalside): {
    "--pub-bias": pubbias,
    "--journal-selection-model": selectionmodel,
    "--max-pubs": maxpubs,
    "--alpha": journalalpha,
    "--side": journalside
  },
  researcher(ishacker, hackid, decisionstrategy, decisionpref): {
    "--is-phacker": ishacker,
    "--p-hacking-methods": hacks[hackid],
    "--decision-strategy": {
      "name": decisionstrategy,
      "preference": decisionpref
    }
  }
}