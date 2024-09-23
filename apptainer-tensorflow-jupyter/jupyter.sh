#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:h100_80gb:1
# #SBATCH --gres=gpu:rtx_5000:1
#SBATCH --mem=100G
#SBATCH --time=01:30:00

# Execute the GPU container:
singularity run --nv cuda_ubuntu_jupyter.sif

