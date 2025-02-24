#/bin/bash
echo $1

CACHE_DIR=./data/cache
LOGS_DIR=./data/logs
JOBS_DATA_DIR=./data/jobs
FORECASTS_DATA_DIR=./data/forecasts

data_volumns=(${CACHE_DIR}, ${LOGS_DIR}, ${JOBS_DATA_DIR}, ${FORECASTS_DATA_DIR})

if [[ $1 == "build" ]]; then
    echo "building docker images"
    docker compose build
    echo "preparing docker services runtime environment"
    for volume in "${data_volumes[@]}"
        do
            docker run -d --rm --user root --name sewaa-build -v "${volume}":/opt/vol icpac/fast-cgan-api tail -f /etc/hosts
            docker exec -it sewaa-build chown job:job /opt/vol
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