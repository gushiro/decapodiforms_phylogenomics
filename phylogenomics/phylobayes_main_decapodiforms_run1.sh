#!/bin/bash
#SBATCH --job-name=cat_gtr_g4
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=128
#SBATCH --mem=500GB
#SBATCH --partition=compute
#SBATCH --time=3-23:59

#### Phylobayes ####

module load pbmpi/1.8c

mpirun -np 512 pb_mpi -d decapodiformes_final_361_OG.phy decapodiformes_final_361_OG_chain1
#mpirun -np 512 pb_mpi decapodiformes_final_361_OG_chain1

## Do similar for chain2

