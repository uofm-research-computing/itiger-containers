# LLAMA on slurm with singualarity/apptainer
## Introduction
Run a large language model on the cluster. You can use the CPUs (using the non-cuda ubuntu image), but you will get much more acceleration using the GPU. This container definition uses the cuda 12.6 ubuntu 22 image for the GPU. The CPU image is the standard ubuntu 22 docker image for comparison.

## Building the image
Run the following to get the model:
```
wget https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/resolve/main/llama-2-7b-chat.Q4_K_M.gguf
```

Build the containers with:
```
singularity build ubuntu.sif ubuntu.def
singularity build cuda_ubuntu.sif cuda_ubuntu.def
```

The 'ubuntu.sif' container is a CPU only container (default llama python package). The 'cuda_ubuntu.sif' container is a GPU container that requires the '--nv' option when it is executed

## Running the example
Modify the 'test.sh' file for the resources you want to allocate (GPUs, CPUs, Memory, time limits). Also, you can pick a 'sif' file that you want to try or just run both as the given batch file does. Run the job with:
```
sbatch test.sh
```

Check if the job is running with the 'squeue' command:
```
squeue -u $USER
```

If the job doesn't show up, check the completion with the 'sacct' command (if it completed in the last 24 hours):
```
sacct -u $USER
```

Check the slurm output file 'slurm-####.out' to see the output, from the directory that 'sbatch' was run, with your favorite editor or download the file.

## Citations/Data sets
[How to guide for docker](https://ralph.blog.imixs.com/2024/03/19/how-to-run-llms-in-a-docker-container/)

[Data set for model](https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF)

[Dockerhub cuda images](https://hub.docker.com/r/nvidia/cuda)

[Dockerhub ubuntu images](https://hub.docker.com/_/ubuntu/)

[Singularity/Apptainer GPU flag](https://apptainer.org/docs/user/1.0/gpu.html)

[Singularity/Apptainer build guide](https://apptainer.org/docs/user/1.0/build_a_container.html)

