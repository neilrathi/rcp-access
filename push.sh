#!/bin/sh

MY_IMAGE=
DOCKER_USERNAME=
docker login
docker tag $MY_IMAGE:latest $DOCKER_USERNAME/$MY_IMAGE:latest
docker push $DOCKER_USERNAME/$MY_IMAGE:latest