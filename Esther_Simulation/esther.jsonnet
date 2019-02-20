local lib = import '../sam_config_template.libsonnet';
local hacks = import 'esthers_hacks.libsonnet';

function(nsims=1, outputpath = "outputs/", outputfilename="res",
          ndvs=4, nobs=0, mu=0.1, sd=0.1, cov=0,
          pubbias=0.95, maxpubs=25, alpha=0.05, side = 1,
          ishacker=false, hackid="0") {
  
  "Simulation Parameters": 
    lib.simulation(nsims, outputpath, outputfilename),
  "Journal Parameters": 
    lib.journal(pubbias, maxpubs, alpha, side),
  "Experiment Parameters": 
    lib.experiment(ndvs, nobs, mu, sd, cov),
  "Researcher Parameters": 
    lib.researcher(ishacker, hacks, hackid)
}