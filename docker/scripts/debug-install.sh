#!/usr/bin/env bash
set -eu

if [ "${DEBUG:-false}" != "true" ]; then
    exit 0
fi

case "$(uname -m)" in
    aarch64)
        ARCH=arm64
        ;;
    *)
        ARCH="$(uname -m)"
        ;;
esac

# Install the AWS Lambda Runtime Interface Emulator
curl -sSL \
    -o /opt/mozilla/.local/bin/aws-lambda-rie \
    "https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/$AWS_LAMBDA_RIE_VERSION/aws-lambda-rie-$ARCH"

chmod +x /opt/mozilla/.local/bin/aws-lambda-rie
