local lib = import 'sam.libsonnet';
local hacks = import 'hacks.libsonnet';

function(debug=false, verbose=false, progress=true, nsims=1, masterseed=42, saveoutput=true, outputprefix="",
          metaseed=43, datastrategy="LinearModel", nc=1, nd=2, ni=0, nobs=20, mu=0.123, var=0.01, cov=0.0, loadings=0.1, errvars=0.0, errcovs=0.0, teststrategy="TTest", testside=1, testalpha=0.05,
          pubbias=0.95, selectionmodel="SignificantSelection", maxpubs=70, journalalpha=0.05, journalside=1,
          ishacker=false, hackid="0", decisionstrategy="PatientDecisionMaker", decisionpref="MinPvalue") {
  
  "Simulation Parameters": 
    lib.simulation(debug, verbose, progress, nsims, masterseed, saveoutput, outputprefix),
  "Experiment Parameters": 
    lib.experiment(metaseed, datastrategy, nc, nd, ni, nobs, mu, var, cov, loadings, errvars, errcovs, teststrategy, testside, testalpha),
  "Journal Parameters": 
    lib.journal(pubbias, selectionmodel, maxpubs, journalalpha, journalside),
  "Researcher Parameters": 
    lib.researcher(ishacker, hacks, hackid, decisionstrategy, decisionpref)
}