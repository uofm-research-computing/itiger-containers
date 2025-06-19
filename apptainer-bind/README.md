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

## Modifying the workflow
If you needed an extra library in "test.py", like cosine-similarity, you could just modify your definition file like:
```
[jspngler@itiger apptainer-bind]$ cat cuda_ubuntu.def
Bootstrap: docker
From: nvidia/cuda:12.5.0-devel-ubuntu22.04

%post
    apt-get update
    apt-get upgrade -y
    apt-get install -y git build-essential python3 python3-pip gcc wget ocl-icd-opencl-dev opencl-headers clinfo libclblast-dev libopenblas-dev
    mkdir -p /etc/OpenCL/vendors
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
    python3 -m pip install --upgrade pip pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette pydantic-settings starlette-context
    CMAKE_ARGS="-DGGML_CUDA=on" pip install llama-cpp-python
    pip install cosine-similarity

%environment
    export LC_ALL=C
    export PATH=/usr/games:$PATH
    export CUDA_DOCKER_ARCH=all
    export GGML_CUDA=1

%runscript
    python3 test.py
```

Then, rebuild with `singularity build cuda_ubuntu.sif cuda_ubuntu.def`, and submit the job with the modified python environment.

If you need to run the python shell or use it on the login node, then you can just execute:
```
singularity exec --bind /tmp:/tmp --bind /project:/project --nv cuda_ubuntu.sif python3 ./test.py
```

## Alias command
Creating an alias can shorten that somewhat (don't worry about the nv files warning, it wouldn't do this on GPU nodes):
```
[jspngler@itiger apptainer-bind]$ python --version #cluster python version
Python 3.9.18
[jspngler@itiger apptainer-bind]$ alias spython="singularity exec --bind /tmp:/tmp --bind /project:/project --nv cuda_ubuntu.sif python3 "
[jspngler@itiger apptainer-bind]$ spython --version #python version from our python
WARNING: Could not find any nv files on this host!
Python 3.10.12
```

Redefining the alias if you want a "clean" environment:
```
[jspngler@itiger apptainer-bind]$ alias spython="singularity exec --cleanenv --bind /tmp:/tmp --bind /project:/project --nv cuda_ubuntu.sif python3 "
[jspngler@itiger apptainer-bind]$ spython --version
WARNING: Could not find any nv files on this host!
Python 3.10.12
```

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

[Alias man page](https://man7.org/linux/man-pages/man1/alias.1p.html)
