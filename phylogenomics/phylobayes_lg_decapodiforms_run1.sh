#!/bin/bash
#SBATCH --job-name=gtr
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=128
#SBATCH --mem=500GB
#SBATCH --partition=compute
#SBATCH --time=3-23:59


module load pbmpi/1.8c


mpirun -np 512 pb_mpi -d decapodiformes_final_361_OG.phy -lg -ncat 1 decapodiformes_final_361_OG_GTR_chain1
## Do similar for chain2


