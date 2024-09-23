#!/bin/bash
#SBATCH --cpus-per-task=64
#SBATCH --gres=gpu:h100_80gb:1
#SBATCH --mem=100G
#SBATCH --time=00:20:00

# Execute the GPU container:
time singularity run --nv cuda_ubuntu.sif 

# Execute the CPU container:
time singularity run ubuntu.sif
