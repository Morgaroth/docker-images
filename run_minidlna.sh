#!/usr/bin/env bash

CONTAINER_NAME=minidlna

MEDIA_DIR=/opt/filmy

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

docker run \
    --detach \
    --restart=always \
    --name=${CONTAINER_NAME} \
    --memory=300m \
    --net=host \
	-v ${MEDIA_DIR}:/opt \
	derflocki/minidlna
