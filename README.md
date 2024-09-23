# itiger-containers
The following git repository is a collection of examples for the itiger cluster at the University of Memphis. The examples can be modified to use on the Bigblue cluster with the proper partition and module inclusions. To clone the repository on either itiger or bigblue, just run the following command:
```
git clone https://github.com/uofm-research-computing/itiger-containers.git
```

## apptainer-llama 
Simple example to use a large language model with the llama-cpp python package. Not an example of training anything.

## apptainer-bind 
Same as the apptainer-llama with a GPU, but uses '/tmp' to cache the files needed for the model. A kind of scratch for your container.

## apptainer-tensorflow-jupyter 
Tensorflow example using jupyter notebook with a GPU. This one is a little more involved, and if your training stage requires a long time to run, it is recommended you don't use jupyter notebook.

## I ran out of storage!
Please try to run:
```
apptainer cache clean
```
