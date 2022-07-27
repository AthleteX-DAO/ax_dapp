#!/bin/bash
echo "Container launch release app sequence..."
echo " * FETCHING LATEST CHANGES"
git fetch
echo " * PULL LATEST RELEASE"
git pull
docker-compose pull
docker-compose stop
echo " * CLEANING OLD IMAGES"
docker-compose rm -f
echo " * RESTART CONTAINER WITH LATEST IMAGE"
export BUILD_TYPE=release
export PORT=5000
sudo docker-compose up -d
echo " * PRUNE OLD IMAGES"
docker image prune -af