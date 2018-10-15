#!/bin/bash

THIS_DIR=$( (cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P) )

IMAGE_PREFIX=${IMAGE_PREFIX:-grafana}
IMAGE_TAG=${IMAGE_TAG:-5.1.5}
IMAGE_NAME=${IMAGE_PREFIX}:${IMAGE_TAG}

cd "$THIS_DIR"

set -xe
docker run -p 3000:3000 \
       --name=grafana \
       --rm -ti "${IMAGE_NAME}" "$@"
