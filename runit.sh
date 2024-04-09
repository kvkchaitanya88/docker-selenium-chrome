#!/bin/bash

set -euxo pipefail

# Set working directory
cd $(dirname "$0")

name=${PWD##*/}
artifact=registry.cap1.paas.gsnetcloud.corp/hyperloop/${name}

#Clean up container (ignore missing error)
docker rm --force ${name} || true

#Build and run
docker build --no-cache=true -t ${artifact} .
docker run --name ${name} ${artifact}

