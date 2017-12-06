#!/usr/bin/env bash


CONTAINER_NAME=rabbitmq

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

docker run --detach \
    --restart=always \
    --name ${CONTAINER_NAME} \
    --memory=2g \
    --env RABBITMQ_VM_MEMORY_HIGH_WATERMARK=0.20 \
    --publish 15673:15672 \
    --publish 5673:5672 \
    --expose 15673 \
    --expose 5673 \
    rabbitmq:3-management

