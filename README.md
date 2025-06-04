# Getting Started with the RCP (for NeuroAI @ EPFL)

This is a startup guide for using the EPFL compute clusters (particularly RCP). It is semi-specific to the NeuroAI lab (e.g. no NFS mounted storage) but can be generalized.

> [!CAUTION]
> Be mindful of your resources! Jobs create costs, so make sure you **stop jobs when they are done.**

As a broad overview, we have **scratch** storage on RCP at `/mnt/upschrimpf2/scratch/<your_gaspar_username>`. This is where your files (including your code) should be stored. You will be working from the root of your RCP login, and storing things on scratch. There is also `/home/<your_gaspar_username>`. Ignore this, it is confusing.

This guide is built on top of similar guides from the [MLO lab](https://github.com/epfml/getting-started) and [RCP Wiki](https://wiki.rcp.epfl.ch/). It was originally written by Neil Rathi ([rathi@stanford.edu](mailto:rathi@stanford.edu)) with help from Badr AlKhamissi and Kadir Gökce, and updated by Lara Marinov ([lmarinov@andrew.cmu.edu](mailto:lmarinov@andrew.cmu.edu)).

## Pre-setup / Installs

All of the following commands should be run on your local machine unless otherwise explicitly stated. You should use the provided template files from this repository.

### Run:AI
RCP uses [Run:AI](https://www.run.ai/) to submit jobs. Here is how to install Run:AI for RCP.

**Step 1: Kubectl.** There is weird versioning magic happening here. If, for some reason, you run into errors (e.g. if this guide is outdated), follow the [official kubectl guide](https://kubernetes.io/docs/tasks/tools/#kubectl) and the [RCP RunAI guide](https://wiki.rcp.epfl.ch/home/CaaS/FAQ/how-to-use-runai) for the most up-to-date instructions.

```bash
# Apple Silicon:
curl -LO "https://dl.k8s.io/release/v1.29.6/bin/darwin/arm64/kubectl"
# Linux:
# curl -LO "https://dl.k8s.io/release/v1.29.6/bin/linux/amd64/kubectl"

# create executable, give perms, move
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl
```

Next, put the following in your `~/.kube/config` file (if the file doesn't exist, create it). Make sure it is just `config`, not `config.yaml`.

```yaml
apiVersion: v1
current-context: rcp-caas-prod
kind: Config
preferences: {}
clusters:
# Cluster RCP Prod
- name: caas-prod.rcp.epfl.ch
  cluster:
    server: https://caas-prod.rcp.epfl.ch:443
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJRHdwSElpTmQrVUV3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBMk1UUXdPVFU1TWpkYUZ3MHpOREEyTVRJeE1EQTBNamRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURvOHJDRjNjeXdRRTlxTVpEOHNGTXo2K0FzSEpnWi81WVNwMGNhWHNKd0JWUERneGdwRGZKY0hnYXYKS2tOdVhTNGpBN1VrZkg1amZXQitvdytpamN3OUR4cjV6STB2TUNReWtzYk9kMVFFMis0Q0J1U0JXU01Gc1pYZQp2T01SanltN056SytxWkVldHpxR0M0bU5LdU9qbC92cGd4ZDNuM2Y2L3loRHhockp2bkVWKzZlUE5icWpDZURZCld1VWFZdUYxRmM4QnZHN0hma3FYRlRWWVdlNkpNa3JSbDQxOVo5a2diNnIvUFNZVzZqdDhhNThTSGNHSVhnTFcKOTBta3BFb1JCMENOSG0wQllEQjdjNFJxMmdyaWtZTUlldGM0eXk2L3NSdFp6NzFiTUQrM2ZDNk92NDdvOXUzWgpld0VWeEJ4dG11ZkVvVGduVEVyNXFYMlhxWFZMQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSazdCMm84a3cxcyt0Ny9ZaGxmV1h1MnR6TkdEQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQXFOdnQrR01lTwp6QnZZZEQ2SExCakFVeWc1czd0TDgzOVltd0RhRXBseG45ZlBRdUV6UW14cnEwUEoxcnVZNnRvRks1SEN4RFVzCmJDN3R3WlMzaVdNNXQ5NEJveHJGVC92c3QrQmtzbWdvTGM2T0N1MitYcngyMUg3UnFLTnNVR01LN2tFdGN6cHgKeXUrYTB6T0tISEUxNWFSVENPbklzQ1pXaTRhVFhIZ00zQ2U4VEhBMXRxaW9pREFHMVFUQXNhNXhTeVM3RWlUSQpDYi9xbktPRlVvM3V3bkRocWljRTU3dE1LTjliRE8rV3hNMzVxT2lBZXVXOUVnc2JlOFA5aDY2NG1tK1QzbjY0ClJNL1l1NHhmcDZwMHMvdGZyZTVjaUFvT0dGekYyRmVKek5PYm1vRkVseUtKc0RwbEorcWFTVXlaL2NtNWRIYUUKQVUxOVMrUWpFc1cvCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
users:
# Authenticated user on RunAI RCP
- name: runai-rcp-authenticated-user
  user:
    auth-provider:
      name: oidc
      config:
        airgapped: "true"
        auth-flow: remote-browser
        client-id: runai-cli
        idp-issuer-url: https://app.run.ai/auth/realms/rcpepfl
        realm: rcpepfl
        redirect-uri: https://rcpepfl.run.ai/oauth-code
contexts:
# Contexts (a context a cluster associated with a user)
- name: rcp-caas-prod
  context:
    cluster: caas-prod.rcp.epfl.ch
    user: runai-rcp-authenticated-user
```

**Step 2: Run:AI** Go to the [runai portal](http://rcpepfl.run.ai) in your browser and sign in with Tequila. Click `? > Research Command Line Interface` in the top right corner to download the CLI. For more info, check out the official [RunAI installation guide](https://docs.run.ai/latest/admin/researcher-setup/cli-install/).

Then run

```bash
chmod +x runai
sudo mv runai /usr/local/bin/runai
```

Now set the default cluster:
```
# With runai CLI
runai config cluster rcp-caas-prod

# With kubectl cli
kubectl config use-context rcp-caas-prod
```

You can now login to RunAI
```
runai login
```
A link to a webpage will be displayed. Follow that link and enter the given code into the command line prompt. After entering the code, you should see a success message: `INFO[0013] Logged in successfully`.

Now you can configure your default project:
```bash
runai list project
```

and then

```bash
runai config project <project_name>
```

with whatever your project name is (usually `<lab_name>-<gaspar>`, e.g. `upschrimpf2-nrathi`). You are now logged in!

### Hardware-as-a-Service (HaaS)
This is the machine you get to ssh into and store things in, but it has limited compute so isn't useful for jobs. Login via `ssh <gaspar>@haas001.rcp.epfl.ch` and navigate to `/mnt/<lab_name>/scratch/<gaspar>`, e.g.

```bash
cd /mnt/upschrimpf2/scratch/nrathi
```

Clone whatever repository you'd like into this directory.

### Docker
You will also need to install [Docker](https://www.docker.com/) and create an account / login. You can create a personal account or an EPFL account, either works. The Docker image we create below will dictate how your environment is set up.

## Setting up your environment

### Creating a Docker image
This part is super annoying to do from scratch. In essence, we are going to build and push an image that has much of the dependencies you'll need when running jobs. There are many ways of doing this, but this is the easiest / fastest. Once again, this should all be done on your local machine.

First, make sure you have the following files in your working directory:

1. `Dockerfile`
2. `.env` (Update this file with your information)
3. `.bashrc` and `entrypoint.sh`
4. `build.sh` and `push.sh`
5. `pvc-scratch.yaml` (Replace "USER_NAME" with your Gaspar username)

**Setting up .env:** First, connect to haas and run `id -a`, which will give you a bunch of id values. In `.env`, set

```bash
GROUP_ID=<value of upschrimpf_storage_scratch_rcp_AppGrpU>
GROUP_NAME="UPSCHRIMPF2-StaffU"
USER_ID=<value of uid>
```

**Building and pushing:** Go into the `.bashrc`, `.env`, `build.sh`, `entrypoint.sh`, `push.sh`, `pvc-scratch.yaml`, and `submit.sh` files and

1. change the `USER_NAME` variable to your Gaspar username
2. change the `MY_IMAGE` variable to your Docker image name (you can pick whatever you'd like)
3. change the `DOCKER_USERNAME` variable to your Docker username (not your Gaspar if they aren't the same)

Make sure you have the Docker desktop app running in the background. Then, run `build.sh` and then `push.sh`.

Once you've run both scripts, run
```
docker images
```
You should see two entries pointing to the same image id. Something like this:
```
REPOSITORY           TAG       IMAGE ID       ...
topo-img             latest    abc123...
marilari/topo-img    latest    abc123...
```

### Creating your PVC using kubectl

Don't forget to update the `pvc-scratch.yaml` file with your Gaspar username.

Then run
```
kubectl apply -f pvc-scratch.yaml
```
and check it worked with:
```
kubectl get pvc -n runai-upschrimpf2-<username>
```
If `runai-upschrimpf2-<username>-scratch` is not listed, then it hasn’t been created.

### Setting up conda
You can now in theory submit an interactive job, which will let you bash into the cluster. We will use this to install conda such that you can submit training jobs. First, run

```bash
sh submit.sh bash test
```

which will run an `interactive` job with the name `test`. If you get timed out while waiting for the job to set up, run `runai bash test` after waiting a couple seconds. Sometimes this takes a while. If things seem strange, run `runai describe job test`.

Once you are logged in, navigate to root (you're currently in `home`, so you'll need to `cd ..`). To install miniconda, run

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /mnt/upschrimpf2/scratch/<gaspar_username>/miniconda.sh
bash /mnt/upschrimpf2/scratch/<gaspar_username>/miniconda.sh -p /mnt/upschrimpf2/scratch/<gaspar_username>/miniconda3
rm /mnt/upschrimpf2/scratch/<gaspar_username>/miniconda.sh
```

In the `~/.bashrc` file, don't forget to change <gaspar_username> in the following line:
```
export PATH="/mnt/upschrimpf2/scratch/<gaspar_username>/miniconda3/bin:$PATH"
```

You can now create a conda environment like so:
```bash
conda create -n <env_name> python=<python_version>
```

which you can activate with `conda activate <env_name>` and pip install whatever you need. This environment will be persistent across jobs, so you never have to create it (or reinstall packages) again. Now, run `exit` and then `runai delete jobs -A` to delete the job.

> [!CAUTION]
> JOBS CREATE COSTS, SO **MAKE SURE YOU DELETE JOBS AFTER THEY ARE DONE!**

## Submitting Jobs
RunAI / RCP supports two kinds of jobs: `interactive` jobs, which you can bash into (and are useful for debugging), and `train` jobs, which support multiple gpus. You have already seen how to submit interactive jobs above, but for a recap:

1. run `sh submit.sh bash <job_name> '' <num_gpus MAX=1> <num_cpus>`
2. once you are bashed in, run `conda activate <env_name>`
3. run your scripts

Train jobs are slightly different. The Dockerfile is setup such that on train jobs, the script `entrypoint.sh` will be run. This script verifies your conda installation, automatically activates your conda environment, and then runs a command (here, it's set up as a python script, but you can change this to e.g. torchrun in the last line).

To submit a train job, first change `CONDA_ENV` and `REPO_DIR` in `submit.sh` to whatever you've named your conda env and repository. Then run
```bash
sh submit.sh train <job_name> "<script_name> arg1 arg2 ..." <num_gpus> <num_cpus>
```

## runai commands
To check the status of all of your jobs, run
```bash
runai list jobs
```

To describe a specific job, run
```bash
runai describe job <job_name>
```

or to see its logs run

To describe a specific job, run
```bash
runai logs <job_name>
```

To delete a job (or all jobs, using the `-A` flag), run
```bash
runai delete job <job_name>
```
