#!/bin/bash

set -e

docker build . -f Dockerfile_kaniko_fixed -t $KANIKO_IMAGE

docker run \
  --tty \
  --interactive \
  --rm \
  --volume "$(pwd):/app" \
  --env "REGISTRY_TOKEN=${REGISTRY_TOKEN}" \
  --env "REGISTRY=${REGISTRY}" \
  --env "NAMESPACE=${NAMESPACE}" \
  --entrypoint "" \
  "${KANIKO_IMAGE}" \
  sh