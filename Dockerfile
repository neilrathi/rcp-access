################################################################################
# Choose a docker template
################################################################################
# FROM --platform=linux/amd64 nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04
FROM --platform=linux/amd64 nvidia/cuda:11.0.3-devel-ubuntu18.04

################################################################################
# Set default shell to /bin/bash
################################################################################
SHELL ["/bin/bash", "-cu"]

################################################################################
# Install dependencies
################################################################################
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        g++ \
        git \
        curl \
        vim \
        unzip \
        wget \
        tmux \
        screen \
        ca-certificates \
        apt-utils \
        libjpeg-dev \
        libpng-dev \
        ffmpeg \
        libgl1 \
        libglib2.0-0

RUN apt-get install -y nano htop iotop rsync sudo git-lfs

WORKDIR /
ENV USER_NAME=""

RUN --mount=type=secret,id=my_env source /run/secrets/my_env && \
    groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -rm -d /home/${USER_NAME} -s /bin/bash -g ${GROUP_ID} -u ${USER_ID} ${USER_NAME} && \
    chown ${USER_ID} -R /home/${USER_NAME} && \
    # Change the password
    echo -e "${USER_NAME}\n${USER_NAME}" | passwd ${USER_NAME} && \
    usermod -a -G ${GROUP_NAME} ${USER_NAME}

RUN echo "${USER_NAME}   ALL = NOPASSWD: ALL" > /etc/sudoers

################################################################################
# Git configuration (optional, you can also use a repo saved in the NFS)
################################################################################
RUN --mount=type=secret,id=my_env source /run/secrets/my_env && \
    git config --global user.name ${GITHUB_NAME}
RUN --mount=type=secret,id=my_env source /run/secrets/my_env && \
    git config --global user.email ${GITHUB_EMAIL}

# Install OpenSSH for MPI to communicate between containers
# RUN apt-get update && apt-get install -y --no-install-recommends openssh-client openssh-server && \
#     mkdir -p /var/run/sshd
# RUN echo 'root:root' | chpasswd
# RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
# RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
# ENV NOTVISIBLE="in users profile"
# RUN echo "export VISIBLE=now" >> /etc/profile
# EXPOSE 22

# To rebuild from this point on (e.g. checking out a branch, pulling ...) and 
# not have to rerun heavy system installation change a dummy arg as shown in build.sh
ARG DUMMY=unknown
RUN DUMMY=${DUMMY}

# The ENTRYPOINT describes which file to run once the node is setup.
# This can be your experiment script
COPY ./.bashrc .
COPY ./entrypoint.sh .

RUN --mount=type=secret,id=my_env source /run/secrets/my_env && \
    chown ${USER_ID} -R /home/${USER_NAME} 

################################################################################
# Switch to user instead of root for NFS + home directory access
################################################################################
RUN chmod +x ./entrypoint.sh
USER ${USER_NAME}
ENTRYPOINT ["./entrypoint.sh"]