#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node 16
#SBATCH -t 00:15:00
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=a.m.abdol@uvt.nl

cd ~/Projects/FRODO/projects/qrps-03/
make summary

make csv from=Publications_Summaries
make stack from=Publications_Summaries

rm ~/Projects/FRODO/projects/qrps-03/*_prepared.csv

make stats from=Meta_Analysis
make csv from=Meta_Analysis_Stats
make stack from=Meta_Analysis_Stats

rm ~/Projects/FRODO/projects/qrps-03/*_prepared.csv

make stats from=Caliper_Test
make csv from=Caliper_Test_Stats
make stack from=Caliper_Test_Stats

rm ~/Projects/FRODO/projects/qrps-03/*_prepared.csv