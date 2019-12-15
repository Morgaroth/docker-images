#!/usr/bin/env bash

CONTAINER_NAME=jenkins
DATA_DIR=$HOME/docker/data/jenkins


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

mkdir ${DATA_DIR} 2>&1 > /dev/null
DOCKER_OWNER=`stat -c "%u:%g" $DATA_DIR`
echo "Owner of image $CONTAINER_NAME will be $DOCKER_OWNER"

docker run \
    --detach \
    --user ${DOCKER_OWNER} \
    --restart=always \
    --name=${CONTAINER_NAME} \
    --memory=2g \
    --publish=18080:8080 \
    --expose=18080 \
	-v ${DATA_DIR}:/var/jenkins_home \
	jenkins/jenkins:lts

docker exec -ti ${CONTAINER_NAME} /usr/local/bin/install-plugins.sh bitbucket-pullrequest-builder