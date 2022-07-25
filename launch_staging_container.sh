#!/bin/bash
echo "Container launch staging app sequence..."
echo " * FETCHING LATEST CHANGES"
git fetch
echo " * PULL LATEST RELEASE"
git pull
docker-compose pull
docker-compose stop
echo " * CLEANING OLD IMAGES"
docker-compose rm -f
echo " * RESTART CONTAINER WITH LATEST IMAGE"
export PORT=6000
export BUILD_TYPE=staging
docker-compose build --build-arg PORT=6000 --build-arg BUILD_TYPE=staging
docker-compose up -d
echo " * PRUNE OLD IMAGES"
docker image prune -af