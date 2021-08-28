#!/usr/bin/env bash

# builds the docker images locally and pushes them to the repo

# Build and push the database image
docker buildx build \
  -f Dockerfile \
  --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag nikc9/postgres-client .
