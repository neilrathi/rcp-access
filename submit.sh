#!/bin/bash

USER_NAME=
MY_IMAGE=

command=$1
job_name=$2
script=$3

gpus=${4:-0}
cpus=${5:-1}

REPO_DIR='topo2.0'
CONDA_ENV='topo-env'

# train mode
if [ "$command" == "train" ]; then
    echo "submitting job [$job_name] in [$command] mode"

    runai submit \
        --name $job_name \
        -i $MY_IMAGE \
        --gpu $gpus \
        --cpu $cpus \
        --large-shm \
        --pvc "runai-upschrimpf2-$USER_NAME-scratch:/mnt/" \
        -- \
        $REPO_DIR \
        $CONDA_ENV \
        $script
    exit 0
fi

# interactive mode
if [ "$command" == "bash" ]; then
    echo "submitting job [$job_name] in [$command] mode"

    runai submit $job_name \
        -i $MY_IMAGE \
        --gpu $gpus --cpu $cpus \
        --pvc "runai-upschrimpf2-$USER_NAME-scratch:/mnt/" \
        --large-shm \
        --interactive \
        --attach \
        --command -- "/bin/bash"
    exit 0
fi