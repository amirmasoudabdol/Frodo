{
  simulation(debug, verbose, progress, nsims, masterseed, outputprefix): {
    "debug": debug,
    "verbose": verbose,
    "progress": progress,
    "n-sims": nsims,
    "master-seed": masterseed,
    "output-path": "../outputs/",
    "output-prefix": outputprefix
  },
  experiment(datastrategy, nc, nd, ni, nobs, mu, var, cov, loadings, errvars, errcovs, teststrategy, testside, testalpha): {
    "data-strategy": datastrategy,
    "n-conditions": nc,
    "n-dep-vars": nd,
    "n-items": ni,
    "n-obs": nobs,
    "means": mu,
    "vars": var,
    "covs": cov,
    "loadings": loadings,
    "err-vars": errvars,
    "err-covs": errcovs,
    "test-strategy": {
      "name": teststrategy,
      "side": testside,
      "alpha": testalpha
    },
    "effect-estimators": [
      "CohensD",
      "HedgesG"
    ]
  },
  journal(pubbias, selectionmodel, maxpubs, journalalpha, journalside): {
    "max-pubs": maxpubs,
    "selection-strategy": {
      "name": selectionmodel,
      "side": journalside,
      "alpha": journalalpha,
      "pub-bias": pubbias
    }
  },
  researcher(ishacker, hacks, hackid, decisionstrategy, decisionpref): {
    "is-phacker": ishacker,
    "hacking-strategies": hacks[hackid],
    "decision-strategy": {
      "name": decisionstrategy,
      "preference": decisionpref
    }
  }
}