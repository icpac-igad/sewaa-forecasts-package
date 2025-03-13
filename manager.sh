#!/bin/bash

set -e

# declare reusable helper functions
set_permissions () {
    echo "preparing docker services runtime environment"
    data_volumns=("./data/logs" "./data/jobs" "./data/forecasts" "./data/cache" "")
    for volume in ${data_volumns[@]};
        do
            # confirm data volume exists. otherwise create it.
            if [ ! -d ${volume} ]; then
                echo "data directory ${volume} does not exist. creating it."
                mkdir -p ${volume}
            fi
            echo "setting required directory permissions on ${volume}";
            docker run -d --user root --name sewaa-build -v ${volume}:/opt/vol icpac/fast-cgan-api tail -f /etc/hosts
            sleep 1
            # enter the container as root user and modify data directory permissions
            docker exec -it --user root sewaa-build chown cgan:root /opt/vol
            # stop the container and remove from docker engine cache
            docker stop sewaa-build && docker remove sewaa-build
        done
}

download_config_data () {
    echo "downloading models weights and configuration data"
    fcst_models=("jurre-brishti" "mvua-kubwa" "")
    for fcst_model in ${fcst_models[@]};
        do
            # confirm models-config data does not exist.
            if [ ! -d ./data/models-config/${fcst_model} ]; then
                echo "model config data directory ./data/models-config/${fcst_model} does not exist. creating it."
                mkdir -p ./data/models-config/${fcst_model}
                echo "downloading ${fcst_model} model config data"
                wget -v https://cgan.icpac.net/ftp/models-config/${fcst_model}.tar.gz -C ./data/${fcst_model}.tar.gz
                tar -xvzf ./data/${fcst_model}.gz -C ./data/models-config/${fcst_model}

            fi
        done
}


if [[ $1 == "express" ]]; then
    echo "updating codebase"
    git pull origin main 
    echo "downloading docker images from dockerhub registry"
    docker compose pull
    set_permissions
    download_config_data
    echo "starting docker containers"
    docker compose down && docker compose up -d
    echo "cleaning up unused resources and showing logs on the foreground"
    docker system prune -f && docker compose logs -ft
elif [[ $1 == "restart" ]]; then
    echo "updating docker images from dockerhub registry"
    docker compose pull
    echo "cleaning up residuals and unused resources"
    docker system prune -f 
    echo "starting forecasting services and showing logs"
    docker compose down && docker compose up -d && docker compose logs -ft
elif [[ $1 == "reopen" ]]; then
    echo "stopping actively running docker containers"
    docker compose down
    echo "removing idle resources"
    docker system prune -f
    echo "powering on docker containers and showing logs"
    docker compose up -d && docker compose logs -ft
elif [[ $1 == "update" ]]; then
    echo "cleaning up residuals"
    docker system prune -f
    echo "updating source codes"
    git pull origin main
    echo "rebuilding docker images and restarting docker containers"
    docker compose build --no-cache && docker compose up -d 
    echo "cleaning up residuals and showing logs"
    docker system prune -f && docker compose logs -ft
elif [[ $1 == "pull" ]]; then
    echo "pulling docker images from DockerHub"
    docker compose pull
elif [[ $1 == "build" ]]; then
    echo "building docker $2 image(s) without cache"
    docker compose build --no-cache $2
elif [[ $1 == "setup" ]]; then
    echo "setting up data directory permissions"
    set_permissions
elif [[ $1 == "start" ]]; then
    echo "starting docker services"
    docker compose down && docker compose up -d && docker compose logs -ft
elif [[ $1 == "clean" ]]; then
    echo "cleaning up idle docker resources" 
    docker system prune -f
elif [[ $1 == "stop" ]]; then
    echo "gracefully shutting down docker services and cleaning up residuals"
    docker compose down && docker system prune -f
else
    echo "ERROR: valid commands are start or stop"
fi