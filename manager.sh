#!/bin/bash

data_volumns=("./data/logs" "./data/jobs" "./data/forecasts" "./data/cache" "")

if [[ $1 == "build" ]]; then
    echo "building docker images"
    docker compose build --no-cache
    echo "preparing docker services runtime environment"
    for volume in ${data_volumns[@]};
        do
            echo "setting required directory permissions on ${volume}";
            docker run -d --user root --name sewaa-build -v ./data/logs:/opt/vol icpac/fast-cgan-api tail -f /etc/hosts
            sleep 1
            docker exec -it sewaa-build chown cgan:root /opt/vol
            docker stop sewaa-build && docker remove sewaa-build
        done
elif [[ $1 == "clean" ]]; then
    echo "cleaning up idle docker resources" 
    docker system prune -f
elif [[ $1 == "start" ]]; then
    echo "starting docker services"
    docker compose down && docker compose up -d
elif [[ $1 == "restart" ]]; then
    echo "stopping actively running docker containers, cleaning up residuals and rebuilding docker images"
    docker compose down && docker system prune -f && docker compose build --no-cache && docker compose up -d
elif [[ $1 == "stop" ]]; then
    echo "gracefully shutting down docker services"
    docker compose down
else
    echo "ERROR: valid commands are start or stop"
fi