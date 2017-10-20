#!/usr/bin/env bash

CONTAINER_NAME=selenium

A=`docker inspect -f {{.State.Running}} ${CONTAINER_NAME}`
B=`docker inspect -f {{.State}} ${CONTAINER_NAME}`
#echo "'$A' '$B' '$?'"
if [ "$A" = "true" ]; then
    echo "Docker $CONTAINER_NAME is running, killing them..."
    docker kill ${CONTAINER_NAME}
else
    echo "Docker $CONTAINER_NAME not found."
fi
sleep 3
if [ "$B" != "" ]; then
    echo "Docker $CONTAINER_NAME exists, removing them..."
    docker rm ${CONTAINER_NAME}
else
    echo "Docker $CONTAINER_NAME not found."
fi

DOCKER_OWNER=`stat -c "%u:%g" $HOME`
echo "Owner of image $CONTAINER_NAME will be $DOCKER_OWNER"

docker run --detach \
    --user ${DOCKER_OWNER} \
    --name ${CONTAINER_NAME} \
    --restart=always \
    --publish 4444:4444 \
    --expose 4444 \
    --volume /dev/shm:/dev/shm \
    selenium/standalone-chrome