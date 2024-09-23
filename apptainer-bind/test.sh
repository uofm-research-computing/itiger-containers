#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:rtx_6000:1
#SBATCH --mem=100G
#SBATCH --time=00:20:00

# Download the data set to /tmp
wget -P /tmp/ https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/resolve/main/llama-2-7b-chat.Q4_K_M.gguf

# Execute the GPU container and bind the /tmp directory to /tmp inside the container.
# Also, note that the working directory is also exported by default. 
singularity run --bind /tmp:/tmp --nv cuda_ubuntu.sif 

# An equivalent to the above is:
# singularity exec --bind /tmp:/tmp --nv cuda_ubuntu.sif python3 ./test.py

#No cleanup necessary since /tmp is cleared each time a job is run
