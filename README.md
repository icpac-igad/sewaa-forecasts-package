# Strengthening Early Warning Systems for Anticipatory Action  

A simplified package (launchpad) for getting started with SEWAA forecast products. The package is composed of several docker services managed using `docker-compose`. As such, `docker` and `docker-compose` must be installed prior to setting up the page.  

The docker services contained here-in are enlisted on the `docker-compose.yaml` as described below.  

## Packaged Docker Services

- `nginx`. This is the webserver responsible for serviving the interactive forecast products visualizatio interface (website) and other static content.  
- `back-end API`. Forecast products API. Responsible for plots generation on the server side and data syncronization and forecasts generation coordination.  
- `redis`. Used by the API service for server-side caching and requests traffic limiting.  
- `open-ifs` data jobs. Responsible for syncronization of ECMWF open-ifs forecast data.  
- `jurre-brishti-ens` data jobs. Responsible for six (6) hours fifty (50) ensemble member forecast generation using cGAN model.  
- `jurre-brishti-counts` data jobs. Responsible for six (6) hours one thousand (1000) ensemble member forecast generation using cGAN model.  
- `mvua-kubwa-ens` data jobs. Responsible for one (1) day fifty (50) ensemble member forecast generation using cGAN model.  
- `mvua-kubwa-counts` data jobs. Responsible for one (1) day one thousand (1000) ensemble member forecast generation using cGAN model.  

These services are managed using a CI/CD workflow which builds and publishes docker images to [DockerHub](https://hub.docker.com/u/icpac). Below is status badge for each workflow.  

[![Build and Publish Web Proxy Server to DockerHub](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-web.yaml/badge.svg?branch=main&event=push)](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-web.yaml)  
[![Build and Publish API Service to DockerHub](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-api.yaml/badge.svg?branch=main)](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-api.yaml)  
[![Build and Publish Jurre Brishti cGAN Models Docker Image](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-jurre-brishti.yaml/badge.svg?branch=main)](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-jurre-brishti.yaml)  
[![Build and Publish Mvua Kubwa cGAN Models Docker Image](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-mvua-kubwa.yaml/badge.svg?branch=main)](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-mvua-kubwa.yaml)
[![Build and Publish Combined cGAN Models Docker Image](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-models.yaml/badge.svg?branch=main)](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-models.yaml)

## Pre-requisite Setup Dependencies  

This project relies on `docker`, `docker-compose` and `git` to work. In addition, `wget` and `tar` are required for **express** installation. Users opting for advanced step-wise installation do not necessarily require `wget` and `tar`.

### Installing Docker and Docker Compose  

Docker and Docker Compose are cross-platform software that makes it possible to run programs on any operating system with `99%` gurantee that the program will work with no modification.  
Docker Desktop is available for installation in `windows`, `macos` and `linux` operating systems. Docker Desktop contains both `docker` and `docker compose`.  
On `linux`, docker and `docker compose` can be installed manually in `daemon` mode.  

- Instructions on how to install Docker Desktop on windows can be found [here](https://docs.docker.com/desktop/setup/install/windows-install/)  
- To install Docker Desktop on MacOS, follow [this link](https://docs.docker.com/desktop/setup/install/mac-install/)  
- Linux users can either install `docker engine` and `docker-compose` binaries separately using [this link](https://docs.docker.com/engine/install/) or install Docker Desktop as described [here](https://docs.docker.com/desktop/setup/install/linux/). It is highly recommended that `docker` and `docker-compose` are installed in `rootless` mode on linux. Docker rootless installation instructions can be found [here](https://docs.docker.com/engine/security/rootless/). Docker compose plugin must be installed manually as described [here](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)  
  
Once done with the installations, please confirm that `docker` and `docker-compose` was installed successfully by running below commands in your favarite commandline.  

> `docker version`  
> `docker compose version`

### Downloading source code  

The code can be downloaded using `git` as shown below. Ensure git is installed before executing below command. Use [this link](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for instructions on how to install `git` on Linux, MacOS and Windows. When installing `git` on windows, `MSYS` must be enabled to add support for executing bash scripts. To download package source code, please execute below command using `Git Bash` (Windows) or `Terminal` (Linux, MacOS).

> `git clone https://github.com/icpac-igad/sewaa-forecasts-package.git`  

## Express Installation  

The package can be installed by executing a single command on `git bash` or `terminal`. To install, change `bash` or `terminal` to `sewaa-forecasts-package` previously downloaded.  

> `cd sewaa-forecasts-package`  

Then run express manager command to build docker images, download model configuration data and start docker containers.

> `bash manager.sh express`  

## Advanced Step by Step Installation  

 Change directory into the previously downloaded git codebase from GitHub.  
 > `cd sewaa-forecasts-package`  

 Create a directory that will be used to hold `jurre-brishti` model initialization data.  

> `mkdir -p data/models-config/jurre-brishti`  

 Create a directory that will be used to hold `jurre-brishti` model initialization data.  

> `mkdir -p data/models-config/mvua-kubwa`  

Next, download cGAN models initial conditions contained on [cgan website](https://cgan.icpac.net/ftp/models-config/). if `wget` is installed, execute below commands to download the data.  

> `wget -v https://cgan.icpac.net/ftp/models-config/jurre-brishti.tar.gz`  
> `wget -v https://cgan.icpac.net/ftp/models-config/mvua-kubwa.tar.gz`

Unzip the downloaded models initial conditions data into the directories created  

> `tar -xvzf jurre-brishti.tar.gz -C data/models-config/jurre-brishti`  
> `tar -xvzf mvua-kubwa.tar.gz -C data/models-config/mvua-kubwa`  

With model configuration weights downloaded and extracted to their respective directories as outlined above, `docker images` could be compiled from source or downloaded from `dockerhub`. This can be achieved using `manager.sh` bash script. The `manager.sh` script should be executed using `Git Bash` on windows or `Terminal` on Linux and MacOS. Powershell and Command Prompt may not work depending on how `git` and `MSYS` were installed on windows.  

### Download pre-compiled docker images  

Using `GitHub Actions`, required docker images are built and deployed on dockerhub. These images are published on public repositories to ensure open access.  
To download the pre-compiled docker imagers from dockerhub, run below command on Git Bash or Terminal.

> `bash manager.sh pull`  

### Building docker images from source  

To build forecasting system docker images from the source code, run below command.  

> `bash manager.sh build`  

**Please Note**: if building docker images from source-code fails intermittently with *EOF* or *HTTPTimeout* errors due to network instability, consider using `bash manager.sh pull` command to download pre-compiled docker images.  

### Starting docker services  

 The manager bash script can be used to start docker containers as follows  

 > `bash manager.sh start`  

 This could also be achieved using docker compose as follows  

 > `docker compose up -d`  

### Stoping docker services  

 The manager bash script can be used to stop docker containers as follows  

 > `bash manager.sh stop`  

 This could also be achieved using docker compose as follows  

 > `docker compose down`  

### cleaning up residuals and dangling docker resources  

The manager bash script can be used to clean idle resources as follows  

 > `bash manager.sh clean`  

 This could also be achieved using docker as follows  

 > `docker system prune -f`  

 **NOTE**: `bash manager.sh restart` command can be used to stop running docker containers, clean idle resources, update the images and re-start the services. The command combines `stop`, `clean`, `pull` and `start` commands.  

## Updating the systems  

With `git`, updates can be merged into the existing project folder. This would be followed by re-building `docker` images and restarting services.  
To pull update patches, change current directory to the directory with sewaa forecasts package code.  

> `cd /path/to/sewaa-forecasts-package`  

updates can be grabbed using a single management command `update`

> `bash manager.sh update`  

Alternatively, this can be manually achieved using below steps. First update the package codebase.  

> `git pull origin main`  

Then rebuild images  

> `bash manager.sh build`  

Clean cached docker resources  

> `bash manager.sh clean`  

Restart docker services  

> `bash manager.sh start`  

## Accessing Forecast Products  

With a working setup, forecast data products will be generated and made avaiable through a website accessible to you at [http://localhost](http://localhost)  
