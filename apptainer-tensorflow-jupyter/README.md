# Image classification with Jupyter notebook
## Introduction
This example uses the tensorflow 2.16 image from docker with jupyter notebook on a GPU. You can use the image 'as-is' or modify the image with Singularity/apptainer '%post' section, similar to what is in 'cuda_ubuntu_jupyter.def.old'. The dockerhub page isn't explicit about the version of linux they are using, but it appears to be an ubuntu/debian variant of linux (using 'apt' rather than 'dnf' for package installation).

## Building the image
Run the singularity build command to create a 'sif' image file:
```
singularity build cuda_ubuntu_jupyter.sif cuda_ubuntu_jupyter.def
```

You can modify the definition file any way you would prefer. You can change installed applications, move files into the image, setup environment variables, and even change the docker image.

## Running the example
Modify the 

Download the jupyter notebook example:
```
wget https://storage.googleapis.com/tensorflow_docs/docs/site/en/tutorials/images/classification.ipynb
```

Submit the batch job:
```
sbatch jupyter.sh
```

Check the queue with the squeue command (note the node):
```
squeue -u $USER
```

Look for the port and localhost url (including key) used by the jupyter notebook session in a 'slurm-####.out' file:
```
tail slurm-*.out
```

Login on a seperate terminal with an ssh terminal and forward the port used by the url. Let's assume you are using Windows subsystem for linux or some other terminal that you can use the full ssh command (and assume it is 8888 in this example):
```
ssh -L 8888:localhost:8888 username@itiger.memphis.edu
ssh -L 8888:localhost:8888 username@node
```

The command can be shortened using the '-J' option and specifying both the login node and the compute node (although, if the port is in use on the login node, you may have to use the previous option and specify a different set of ports for each 'jump'):
```
ssh -L 8888:localhost:8888 -J node username@itiger.memphis.edu
```

Take the localhost url you received from the 'slurm-####.out' file and put it in your local computer's browser. Open the 'classification.ipynb' and try the examples. Keep in mind that the 'tensorflow-lite' applications probably won't work.


## Citations/Data sets
[Tensorflow container on dockerhub](https://hub.docker.com/r/tensorflow/tensorflow)

[Tensorflow image classification example](https://www.tensorflow.org/tutorials/images/classification)

[Singularity/Apptainer GPU flag](https://apptainer.org/docs/user/1.0/gpu.html)

[Singularity/Apptainer build guide](https://apptainer.org/docs/user/1.0/build_a_container.html)

