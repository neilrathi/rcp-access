#!/bin/sh

MY_IMAGE=
docker build -f Dockerfile --build-arg DUMMY='' -t $MY_IMAGE --secret id=my_env,src=.env .