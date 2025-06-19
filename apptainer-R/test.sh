#!/bin/bash
#SBATCH -c 4
#SBATCH --mem=8G
#SBATCH --gres=gpu:rtx_6000:1
#SBATCH -t 00:10:00

# Run the gpuTest.R case with singularity built in runscript
singularity run --nv --bind=/project:/project cuda_ubuntu_R.sif

# Run the cpuTest.R case with singularity exec command
singularity exec --nv --bind=/project:/project cuda_ubuntu_R.sif R CMD BATCH cpuTest.R
