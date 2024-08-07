# Getting Started with the RCP (for NeuroAI @ EPFL)

This is a startup guide for using the EPFL compute clusters (particularly RCP, although you can make this work for IC as well). It is semi-specific to the NeuroAI lab (e.g. no NFS mounted storage) but can be generalized.

> [!CAUTION]
> Jobs (especially GPU jobs) create costs, so make sure you stop jobs after they are done. Be mindful of your resources.

As a broad overview, we have **scratch** storage on RCP at `/mnt/upschrimpf2/scratch/<your_gaspar_username>`. This is where your files (including your code) should be stored. You will be working from the root of your RCP login, and storing things on scratch. There is also `/home/<your_gaspar_username>`. Ignore this, it is confusing.

## pre-setup / installs

### Run:AI
Both IC and RCP use [Run:AI](https://www.run.ai/) to submit jobs. Here I describe how to install Run:AI for RCP. See [here](https://inside.epfl.ch/ic-it-docs/ic-cluster/caas/connecting/) for IC instructions.

**Step 1: Kubectl.** There is weird versioning magic happening here. If, for some reason, you run into errors (e.g. if this guide is outdated), follow (1) the [official kubectl guide](https://kubernetes.io/docs/tasks/tools/#kubectl) and (2) the [IC instructions](https://inside.epfl.ch/ic-it-docs/ic-cluster/caas/connecting/). The [RCP guide](https://wiki.rcp.epfl.ch/home/CaaS/Quick_Start) doesn't provide much information.

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
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1EUXlOakE0TVRRME5sb1hEVE16TURReU16QTRNVFEwTmxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTFAxCmtTZ2E4NWRWU0p0VUxGQ1g5VWo1K1lTT2dCbG9MZGVxZVgrM1ByVGtQZkptWFBxeXlsVVBLN0tJUWlvSUplNm8KRTBaS2JZbU03SnEvL0lPaHF4R0VraUNrTHJCamJrYXF5M3NibkNhWGFMa1pQYkhNWjgwdmlMMGNFZHNJTWN4WgozdHpMTzFNTldwZW9mZlJ6L1NvbXpqSTVDQldJbUptTmhvZXpJQUVNOGJuaDJKeFBFNzRwWThTS1BTRk5YVzN0CjgxNmM5cXRvc1lJQjVrTnh1UjRGWVh5bGloZHZ3UmVqVW9wajA2ME1rSkl3QmpXM01YTFUrdkVyandKeFc5Q1cKZ2plUndzOG5kdW5VVHREcy9CVjhGbW5JZy81VVNhZTBzUE5FQWxvZC9TbGhrMnNuWTJvUXZlTHpFNkhrMnluRgpHNXd1VGVXRDZGY2Erd1pNMjM4Q0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZNVVhkVWVnK2xMdTlHWElMQ2VlOVJzOENmUXpNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBR051a2ZUR3E0RTlrckkreVZQbApaem1reSszaUNTMnYvTU9OU3h0S01idWZ2V0ROZFM3QzZaK1RDQTJSd0c1Y2gzZUh5UW9oTSs0K2wrSTJxMTFwCjNJVGRxYVI4RDhpQkFCbXV6Yzl2a3BKanZTTzZ4VVpnTFJZMHRDTUxXZ3g2b2tBcWhxZDV3YTZIYmN6Z1QrSUcKQlVGbERtR0R4K0MxTnFIYVFKUVN1bENqL1ZyS1RROVFlY1NoZGZqVDgvS1NVUjQ4VTlEdlA3dnU0YkRnWW5DKwpoOXEwUlFpUGR4TEtlL2Q5aGd0UnM5TjFQdGRYZXAxdHB3NCs3Y3N4TE1DSXNmYTBwaW8yb3lEems0bTNjSWRNCi9iNElHUEZaM2hYZktOVGtybnUrWmdCUms5Yjk3emNKZVdhendxTXUyd1dkV2JiQjdpaU5ZK2xtWkl1S0dUeFQKWWpRPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://caas-test.rcp.epfl.ch:443
  name: caas-test.rcp.epfl.ch
contexts:
- context:
    cluster: caas-test.rcp.epfl.ch
    user: runai-authenticated-user
  name: runai-authenticated-user
current-context: runai-authenticated-user
kind: Config
preferences: {}
users:
- name: runai-authenticated-user
  user:
    auth-provider:
      config:
        airgapped: "true"
        auth-flow: remote-browser
        client-id: runai-cli
        idp-issuer-url: https://app.run.ai/auth/realms/rcpepfl
        realm: rcpepfl
        redirect-uri: https://rcpepfl.run.ai/oauth-code
      name: oidc
```

**Step 2: Run:AI Login.** Go to the [runai portal](http://rcpepfl.run.ai) in your browser and sign in with Tequila. Click `? > Research Command Line Interface` in the top right corner to download the CLI. For more info, check out the official [RunAI installation guide](https://docs.run.ai/latest/admin/researcher-setup/cli-install/).

Then run

```bash
chmod +x runai
sudo mv runai /usr/local/bin/runai
```

Now you can `runai login` (which will have you authenticate through the browser). Configure your default project by running

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

## setting up your environment

### creating a docker image
This part is super annoying to do from scratch. In essence, we are going to build and push an image that has much of the dependencies you'll need when running jobs. There are many ways of doing this, but this is the easiest / fastest.

First, make sure you have the following files in your working directory:

1. `Dockerfile`
2. `.env` (UPDATE THIS FILE WITH YOUR INFORMATION)
3. `.bashrc` and `.entrypoint.sh`
4. `build.sh` and `push.sh`

**Setting up .env:** First, on haas, run `id -a`, which will give you a bunch of id values. In `.env`, set

```bash
GROUP_ID=<value of upschrimpf_storage_scratch_rcp_AppGrpU>
GROUP_NAME="UPSCHRIMPF2-StaffU"
USER_ID=<value of uid>
```

**Building and pushing:** Go into the rest of the files and

1. in Dockerfile, .bashrc, and .entrypoint.sh, change the `USER_NAME` variable to your Gaspar username
2. in .entrypoint.sh, build.sh, and push.sh, change the `MY_IMAGE` variable to your docker image name

Then, run `build.sh` and then `push.sh`. Make sure you have the Docker desktop app running in the background. This should work without hiccups.

### setting up conda
You can now in theory submit an interactive job, which will let you bash into the cluster. We will use this to install conda such that you can submit training jobs. First, run

```bash
sh submit.sh bash test
```

which will run an `interactive` job with the name `test`. If you get timed out while waiting for the job to set up, run `runai bash test` after waiting a couple seconds. Sometimes this takes a while. If things seem strange, run `runai describe job test`.

Once you are logged in, navigate to root (you're currently in `home`, so you'll need to `cd ..`). To install miniconda, run

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /mnt/<gaspar_username>/miniconda.sh
bash /mnt/<gaspar_username>/miniconda.sh -p /mnt/<gaspar_username>/miniconda3
rm /mnt/<gaspar_username>/miniconda.sh
```

Now run `source .bashrc` to make sure the changes are registered. You can now create a conda environment, i.e.

```bash
conda create -n <env_name> python=<python_version>
```

which you can activate with `conda activate <env_name>` and pip install whatever you need. This environment will be persistent across jobs, so you never have to create it (or reinstall packages) again. Now, run `exit` and then `runai delete jobs -A` to delete the job.

> [!CAUTION]
> JOBS CREATE COSTS, SO **MAKE SURE YOU DELETE JOBS AFTER THEY ARE DONE!**

## submitting jobs
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
