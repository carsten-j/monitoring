#!/usr/bin/env sh

if [ ! "$(docker network ls | grep monitoring_network)" ]; then
    docker network create --driver bridge monitoring_network
fi