#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 00:15:00
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

make csv from=EggersTestEstimator_Summaries; make stack from=EggersTestEstimator_Summaries; make csv from=RandomEffectEstimator_Summaries; make stack from=RandomEffectEstimator_Summaries; make csv from=Publications_Summaries; make stack from=Publications_Summaries