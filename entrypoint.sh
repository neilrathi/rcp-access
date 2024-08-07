#!/bin/bash

USER_NAME=

export NFS_MOUNT="/mnt/$USER_NAME/"
export nfs="/mnt/$USER_NAME/"

# Set cache directories for HF to use the NFS mount, 
# so it will not re-download for each
export HF_CACHE_HOME="${NFS_MOUNT}/.cache/huggingface"
export HF_HOME="${NFS_MOUNT}/.cache/huggingface"
export HF_DATASETS_CACHE="${HF_HOME}/datasets"
export HF_MODULES_CACHE="${HF_HOME}/modules"

export WORK_DIR="${NFS_MOUNT}/$1"

# get conda setup
source .bashrc

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/mnt/$USER_NAME/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/mnt/$USER_NAME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/mnt/$USER_NAME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/mnt/$USER_NAME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# move to the correct directory
cd $WORK_DIR || exit

# print args to verify
echo "args: $*"

# activate conda environment
conda activate $2

# shift args 2 --> 1, 3 --> 2
shift

# run #2 (formerly #1) with all command line args included
python "${@:2}" 2>&1 | tee -a "runai_output.txt" || { echo 'Success criteria evaluation failed' ; exit 1; }