# Using bind to export a filesystem to the container
## Introduction
This is an example image that installs R on a container.

## Building the image
Build the container with:
```
singularity build cuda_ubuntu_R.sif cuda_ubuntu_R.def
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

Check the slurm output file 'slurm-####.out' to see the if there are errors, from the directory that 'sbatch' was run, with your favorite editor or download the file. Also, check gpuTest.Rout and cpuTest.Rout for timings. gpuTest.Rout should be about 4 times faster for the small matrix multiplication operation than cpuTest.Rout. Not a great test for the GPU performance, but it does show it works.

## Modifying the workflow
If you needed an extra library in "gpuTest.R", like jsonlite, you could just modify your definition file in the %post section as shown below:
```
[jspngler@itiger apptainer-R]$ cat cuda_ubuntu_R.def 
Bootstrap: docker
From: nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

%post
    export DEBIAN_FRONTEND=noninteractive
    apt-get update 
    apt-get upgrade -y 
    apt-get install -y git build-essential python3 python3-pip gcc wget ocl-icd-opencl-dev opencl-headers clinfo libclblast-dev libopenblas-dev  python3-venv python3-dev
    apt-get install -y r-base r-base-dev libssl-dev libfontconfig1-dev libcurl4-openssl-dev libxml2-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev
    mkdir -p /etc/OpenCL/vendors 
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
    python3 -m pip install --upgrade pip pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette pydantic-settings starlette-context
    CMAKE_ARGS="-DGGML_CUDA=on" pip install llama-cpp-python
    R --slave -e 'install.packages("testthat",repos="https://mirrors.nics.utk.edu/cran/")'
    R --slave -e 'install.packages("pkgload",repos="https://mirrors.nics.utk.edu/cran/")'
    R --slave -e 'install.packages("devtools",repos="https://mirrors.nics.utk.edu/cran/")'
    R --slave -e 'install.packages("torch",repos="https://mirrors.nics.utk.edu/cran/"); library(torch); install_torch()'
    python3 -m pip install tensorflow[and-cuda]
    R --slave -e 'install.packages("tensorflow",repos="https://mirrors.nics.utk.edu/cran/");'
    R --slave -e 'install.packages("GPUmatrix",repos="https://mirrors.nics.utk.edu/cran/")'
    R --slave -e 'install.packages("jsonlite",repos="https://mirrors.nics.utk.edu/cran/")'

%environment
    export LC_ALL=C
    export PATH=/usr/games:$PATH
    export CUDA_DOCKER_ARCH=all
    export GGML_CUDA=1

%runscript
    R CMD BATCH gpuTest.R
```

Then, rebuild with `singularity build cuda_ubuntu_R.sif cuda_ubuntu_R.def`, and submit the job with the modified python environment.

If you need to run the R shell or use it on the login node, then you can just execute:
```
singularity exec --bind /tmp:/tmp --bind /project:/project --nv cuda_ubuntu_R.sif R
```

## Citations/Data sets
[GPUmatrix vignette](https://cran.r-project.org/web/packages/GPUmatrix/vignettes/Vignette.html)

[Dockerhub cuda images](https://hub.docker.com/r/nvidia/cuda)

[Singularity/Apptainer GPU flag](https://apptainer.org/docs/user/1.0/gpu.html)

[Singularity/Apptainer build guide](https://apptainer.org/docs/user/1.0/build_a_container.html)

[Singluarity/Apptainer bind guide](https://apptainer.org/docs/user/main/bind_paths_and_mounts.html)

