#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node 16
#SBATCH -t 01:00:00
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

cd ~/Projects/FRODO/projects/qrps-07/
make summary

make csv from=Publications_Summaries
make stack from=Publications_Summaries

make stats from=Meta_Analysis_Test
make csv from=Meta_Analysis_Test_Stats
make stack from=Meta_Analysis_Test_Stats

make stats from=Caliper_Test
make csv from=Caliper_Test_Stats
make stack from=Caliper_Test_Stats