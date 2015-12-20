#!/bin/bash

echo "Using node version `node --version`"

VERSION=`less tutor-student/package.json | jq '.version' | tr -d '"'`

echo "Starting deployment of tutor-student@$VERSION"
echo "Preparing app"
cd tutor-student && npm install && bower install && NODE_ENV=production gulp && cd ..

echo "Building container"

if [ -z "$CACHE" ]; then
  # the default behaviour uses NO CACHE! to avoid caching problems at any costs. Using gulp might change something
	# in the project but docker does not always notice that
	docker build --no-cache -t welfenlab-student:$VERSION . && \
else
  # if CACHE is set explicitly build using cache
	docker build -t welfenlab-student:$VERSION . && \
fi
if [ -z "$LOCAL_REGISTRY" ]; then
  echo "No local registry configured. Won't push into registry."
else
	echo "Registry is configured, updating registry entry in $LOCAL_REGISTRY."
	docker tag -f welfenlab-student:$VERSION $LOCAL_REGISTRY/welfenlab-student:$VERSION && \
	docker push $LOCAL_REGISTRY/welfenlab-student:$VERSION
fi
