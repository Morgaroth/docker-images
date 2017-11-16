#!/usr/bin/env bash


CONTAINER_NAME=postgres

DATA_DIR=$HOME/docker/data

mkdir $DATA_DIR/postgres_tmp

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

#DOCKER_OWNER=`stat -c "%u:%g" $HOME`
#echo "Owner of image $CONTAINER_NAME will be $DOCKER_OWNER"

docker run --detach \
    --restart=always \
    --name ${CONTAINER_NAME} \
    --env POSTGRES_PASSWORD=ala123 \
    --env POSTGRES_USER=morgaroth_user \
    --env PGDATA=/var/lib/postgresql/data/pgdata \
    --publish 15432:5432 \
    --expose 15432 \
    --volume ${DATA_DIR}/postgres:/var/lib/postgresql/data/pgdata \
    --volume /data/data:/data/data \
    postgres:9

#docker stop ${CONTAINER_NAME}
#sleep 3
#sudo chown ${DOCKER_OWNER} ${DATA_DIR}/postgres -R

