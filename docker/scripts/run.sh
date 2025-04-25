#!/usr/bin/env bash
set -eu

if [ "${DEBUG:-false}" != "true" ]; then
    python3 -m awslambdaric handler.handle
else
    aws-lambda-rie python3 -m awslambdaric handler.handle
fi

