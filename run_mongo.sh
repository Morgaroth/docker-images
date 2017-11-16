#!/usr/bin/env bash


CONTAINER_NAME=mongo

DATA_DIR=$HOME/docker/data

A=`docker inspect -f {{.State.Running}} ${CONTAINER_NAME}`
B=`docker inspect -f {{.State}} ${CONTAINER_NAME}`
echo "'$A' '$B' '$?'"
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
    --restart=always \
    --memory=1g \
    --name ${CONTAINER_NAME} \
    --publish 28017:27017 \
    --expose=28017 \
    --volume ${DATA_DIR}/mongo:/data/db \
    mongo:latest