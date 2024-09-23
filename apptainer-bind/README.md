# Using bind to export a filesystem to the container
## Introduction
This follows the apptainer-llama example, but uses /tmp to cache data.

## Building the image
Build the container with:
```
singularity build cuda_ubuntu.sif cuda_ubuntu.def
```

Note that the 'bind' export doesn't happen here. It happens at runtime in the test.sh batch submission file.

## Running the example
Modify the 'test.sh' file for the resources you want to allocate (GPUs, CPUs, Memory, time limits). Run the job with:
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

## Note about /tmp on itiger
The /tmp directory is created when a job is submitted. The directory itself comes from a local '/scratch/jobid' directory. The '/scratch' filesystem is a very fast 14 TB local NVME disk. 

## Citations/Data sets
[How to guide for docker](https://ralph.blog.imixs.com/2024/03/19/how-to-run-llms-in-a-docker-container/)
[Data set for model](https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF)
[Dockerhub cuda images](https://hub.docker.com/r/nvidia/cuda)
[Dockerhub ubuntu images](https://hub.docker.com/_/ubuntu/)
[Singularity/Apptainer GPU flag](https://apptainer.org/docs/user/1.0/gpu.html)
[Singularity/Apptainer build guide](https://apptainer.org/docs/user/1.0/build_a_container.html)
[Singluarity/Apptainer bind guide](https://apptainer.org/docs/user/main/bind_paths_and_mounts.html)

