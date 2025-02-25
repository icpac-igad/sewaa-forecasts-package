#/bin/bash

data_volumns=("./data/logs" "./data/jobs" "./data/forecasts" "./data/cache" "")

if [[ $1 == "build" ]]; then
    echo "building docker images"
    docker compose build
    echo "preparing docker services runtime environment"
    for volume in ${data_volumns[@]};
        do
            echo "setting required directory permissions on ${volume}";
            docker run -d --rm --user root --name sewaa-build -v "${volume}":/opt/vol icpac/fast-cgan-api tail -f /etc/hosts
            docker exec -it sewaa-build chown cgan:cgan /opt/vol
            docker stop sewaa-build && docker remove sewaa-build
        done
elif [[ $1 == "clean" ]]; then
    echo "cleaning up idle docker resources" 
    docker system prune -f
elif [[ $1 == "start" ]]; then
    echo "starting docker services"
    docker compose up -d
elif [[ $1 == "stop" ]]; then
    echo "gracefully shutting down docker services"
    docker compose down
else
    echo "ERROR: valid commands are start or stop"
fi