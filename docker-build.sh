#!/bin/bash

PUSH=true

if [ "$PUSH" = true ]; then
docker buildx build \
--platform linux/arm64 \
--build-arg USE_CUDA=false \
--build-arg USE_OLLAMA=false \
-t docker-sauronagent-release.dr-uw2.adobeitc.com/sauron/open-webui:0.6.28-2 \
.
else
docker buildx build \
--platform linux/amd64,linux/arm64 \
--push \
--build-arg USE_CUDA=false \
--build-arg USE_OLLAMA=false \
-t docker-sauronagent-release.dr-uw2.adobeitc.com/sauron/open-webui:0.6.28-2 \
.
fi

