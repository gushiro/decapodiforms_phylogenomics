#!/bin/bash
#SBATCH --job-name=wastral
#SBATCH --cpus-per-task=32
#SBATCH --mem=750GB
#SBATCH --partition=largemem
#SBATCH --time=1-23:59



/home/g/gustavo-sanchez/programs/ASTER/bin/wastral -t 32 -r 16 -s 16 -u 2 --root vampy -o decapodiforms_reduced_3634_OG.concat.wastral -i concatenated_wastral.treefile 
