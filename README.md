[![Build and Publish Web Proxy Server to DockerHub](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-web.yaml/badge.svg?branch=main&event=push)](https://github.com/icpac-igad/sewaa-forecasts-package/actions/workflows/build-web.yaml)

# Strengthening Early Warning Systems for Anticipatory Action  

A simplified package (launchpad) for getting started with SEWAA forecast products. The package is composed of several docker services managed using `docker-compose`. As such, `docker` and `docker-compose` must be installed prior to setting up the page.  

The docker services contained here-in are enlisted on the `docker-compose.yaml` as described below.  

## Packaged Docker Services

- `nginx`  
- `redis`  
- `back-end API`  
- `open-ifs` data jobs  
- `jurre-brishti-ens` data jobs  
- `jurre-brishti-counts` data jobs  
- `mvua-kubwa-ens` data jobs  
- `mvua-kubwa-counts` data jobs  

## Pre-requisite Setup Dependencies  

This project relies on `docker`, `docker-compose` and `git` to work. In addition, `wget` and `tar` are required for **express** users. Users installing the package manually do not necessarily require `wget` and `tar`.

### Installing Docker and Docker Compose  

Docker and Docker Compose are cross-platform software that makes it possible to run programs on any operating system with `99%` gurantee that the program will work with no modification.  
Docker Desktop is available for installation in `window`, `macos` and `linux`. Docker Desktop contains both `docker` and `docker compose`.  
On `linux`, docker and `docker compose` can be installed manually in `daemon` mode.  

- Instructions on how to install Docker Desktop on windows can be found [here](https://docs.docker.com/desktop/setup/install/windows-install/)  
- To install Docker Desktop on MacOS, follow [this link](https://docs.docker.com/desktop/setup/install/mac-install/)  
- Linux users can either install `docker engine` and `docker-compose` binaries separately using [this link](https://docs.docker.com/engine/install/) or install Docker Desktop as described [here](https://docs.docker.com/desktop/setup/install/linux/). It is highly recommended that docker and docker-compose are installed in `rootless` mode on linux. Docker rootless installation instructions can be found [here](https://docs.docker.com/engine/security/rootless/).
  
Once done with the installations, please confirm that `docker` and `docker-compose` was installed successfully by running below commands in your favarite commandline.  

> `docker version`  
> `docker compose version`

### Downloading source code  

The code can be downloaded using `git` as shown below. Ensure git is installed before executing below command. Use [this link](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for instructions on how to install `git` on Linux, MacOS and Windows. When installing `git` on windows, `MSYS` must be enabled to add support for executing bash scripts.  

> `git clone https://github.com/icpac-igad/sewaa-forecasts-package.git`  

## Express Installation  

The package can be installed by executing a single command on `git bash` or `terminal`. To install, change `bash` or `terminal` to `sewaa-forecasts-package` previously downloaded.  

> `cd sewaa-forecasts-package`  

Then run express manager command to build docker images, download model configuration data and start docker containers.

> `bash manager.sh express`  

## Advanced Installation  

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

 Finally, use the manager bash script to build docker images. On windows, use either git bash or powershell to execute the script. Powershell may not work depending on how `git` was installed on windows.

 > `bash manager.sh build`  

## Starting docker services  

 The manager bash script can be used to start docker containers as follows  

 > `bash manager.sh start`  

 This could also be achieved using docker compose as follows  

 > `docker compose up -d`  

## Stoping docker services  

 The manager bash script can be used to stop docker containers as follows  

 > `bash manager.sh stop`  

 This could also be achieved using docker compose as follows  

 > `docker compose down`  

## cleaning up residuals and dangling docker resources  

The manager bash script can be used to clean idle resources as follows  

 > `bash manager.sh clean`  

 This could also be achieved using docker as follows  

 > `docker system prune -f`  

 **NOTE**: `bash manager.sh restart` command can be used to stop running docker containers, clean idle resources, re-build the images and re-start the services. The command combines `stop`, `clean`, `build` and `start` commands.  

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
