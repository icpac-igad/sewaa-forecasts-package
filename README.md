# Strengthening Early Warning Systems for Anticipatory Action  

A simplified package (launchpad) for getting started with SEWAA forecast products. The package is compose of several docker services managed using `docker-compose`. As such, `docker` and `docker-compose` must be installed prior to setting up the page.  

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

## Installation  

To run the docker services, one is required to install `docker` and `docker compose` for their operating system.
- Instructions on how to install docker and docker compose (both included in the Docker Desktop) on windows can be found [here](https://docs.docker.com/desktop/setup/install/windows-install/)  
- To install docker and docker-compose (both included in Docker Desktop) on MacOS, follow [this link](https://docs.docker.com/desktop/setup/install/mac-install/)   
- Linux users can either install docker engine and docker-compose binaries separately using [this link](https://docs.docker.com/engine/install/) or install Docker Desktop which includes both docker and docker-compose as described [here](https://docs.docker.com/desktop/setup/install/linux/). It is highly recommended that docker and docker-compose are installed in `rootless` mode on linux. Docker rootless installation instructions can be found [here](https://docs.docker.com/engine/security/rootless/).
  
Once done with the installations, please confirm that `docker` and `docker-compose` was installed successfully by running below commands in your favarite commandline.   

> `docker --version`  
> `docker compose --version`  

If no error was reported, `docker` and `docker-compose` were properly  installed.  

Next, download cGAN models initial conditions contained on cgan [website ftp](https://cgan.icpac.net/ftp/models-config/). if `wget` is installed, execute below commands to download the data.  

> `wget -v https://cgan.icpac.net/ftp/models-config/jurre-brishti.tar.gz`  
> `wget -v https://cgan.icpac.net/ftp/models-config/mvua-kubwa.tar.gz`

With models initial conditions data downloaded, clone this repository using `git` on your favorite commandline (git must be installed before executing below commad).  
 > `git clone https://github.com/icpac-igad/sewaa-forecasts-package.git`  

 Change directory into the package codebase clonned from github.  
 > `cd sewaa-forecasts-package`  

 Create a `data` directory within the `sewaa-forecasts-package` directory.  

 > `mkdir data`  

 Create a `models-config` directory within the `data` directory  

 > `mkdir data/models-config`  

 Unzip previously downloaded models config data into the created `data/models-config` directory  

 > `mkdir data/models-config/jurre-brishti`  
 > `tar -xvzf /path/to/jurre-brishti.tar.gz -C data/models-config/jurre-brishti`  
 > `mkdir data/models-config/mvua-kubwa`  
 > `tar -xvzf /path/to/mvua-kubwa.tar.gz -C data/models-config/mvua-kubwa`  

 Finally, use the manager bash script to build docker images (an equivalent script will be developed for windows. This works on Linux and Mac only)  

 > `sh manager.sh build`  

 Alternatively, the docker images can be built using docker compose as follows  

 > `docker compose build`  


 ## Starting docker services  

 The manager bash script can be used to start docker containers as follows  

 > `sh manager.sh start`  

 This could also be achieved using docker compose as follows  

 > `docker compose up -d`  

 ## Stoping docker services  

 The manager bash script can be used to stop docker containers as follows  

 > `sh manager.sh stop`  

 This could also be achieved using docker compose as follows  

 > `docker compose down`  

 ## cleaning up residuals and dangling docker resources  

The manager bash script can be used to clean idle resources as follows  

 > `sh manager.sh clean`  

 This could also be achieved using docker as follows  

 > `docker system prune -f`  
