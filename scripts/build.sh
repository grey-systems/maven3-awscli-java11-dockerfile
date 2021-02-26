#!/bin/bash
set -e

if [[ -z $RELEASE ]]; then
    echo "Error: undefined RELEASE environment variable."
    exit 1
fi

docker build -t eu.greysystems/docker-maven-aws:1.0.0 .