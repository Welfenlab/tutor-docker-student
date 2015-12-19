#!/bin/bash

: "${LOCAL_REGISTRY?Need to set LOCAL_REGISTRY for publishing}"

echo "Using node version `node --version`"

VERSION=`less tutor-student/package.json | jq '.version' | tr -d '"'`

echo "Starting deployment of tutor-student@$VERSION"
echo "Preparing app"
cd tutor-student && npm install && bower install && NODE_ENV=production gulp && cd ..

echo "Building container"

#docker build --no-cache -t welfenlab-student:$VERSION . && \
docker build -t welfenlab-student:$VERSION . && \
docker tag -f welfenlab-student:$VERSION $LOCAL_REGISTRY/welfenlab-student:$VERSION && \
docker push $LOCAL_REGISTRY/welfenlab-student:$VERSION
