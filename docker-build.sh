#!/bin/bash

# Default values
DEFAULT_VERSION="0.6.30"
DEFAULT_PUSH="false"

# Parse command line arguments
usage() {
    echo "Usage: $0 [--version VERSION] [--push] [--no-push] [--help]"
    echo ""
    echo "Options:"
    echo "  -V VERSION    Set the image version (default: $DEFAULT_VERSION)"
    echo "  -P              Enable pushing to registry"
    echo "  --no-push           Disable pushing to registry (default)"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --version 1.0.0 --push"
    echo "  $0 --version latest --no-push"
    echo "  $0 --push"
    exit 1
}

VERSION="$DEFAULT_VERSION"
PUSH="$DEFAULT_PUSH"


while [[ $# -gt 0 ]]; do
    case $1 in
        -V)
            VERSION="$2"
            shift 2
            ;;
        -P)
            PUSH="true"
            shift
            ;;
        --no-push)
            PUSH="false"
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [ "$PUSH" = true ]; then
docker buildx build \
--platform linux/amd64,linux/arm64 \
--push \
--build-arg USE_CUDA=false \
--build-arg USE_OLLAMA=false \
-t docker-sauronagent-release.dr-uw2.adobeitc.com/sauron/open-webui:$VERSION \
.
else
docker buildx build \
--platform linux/arm64 \
--build-arg USE_CUDA=false \
--build-arg USE_OLLAMA=false \
-t docker-sauronagent-release.dr-uw2.adobeitc.com/sauron/open-webui:$VERSION \
.
fi

