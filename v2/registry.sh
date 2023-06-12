#!/bin/bash

set -e
echo "logging to DockerHub"
docker login -u raf4ga
docker build -t raf4ga/node-mongo:1.0.0 .
docker push raf4ga/node-mongo:1.0.0
docker logout
