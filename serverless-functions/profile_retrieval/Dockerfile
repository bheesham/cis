FROM python:3.13-slim AS build

# docker build -t profile-retrieval -f serverless-functions/profile_retrieval/Dockerfile \
#     --build-context docker=./docker \
#     --build-context python-modules=./python-modules \
#     --build-context serverless-functions=./serverless-functions \
#     .

ARG DEBUG=false
ENV DEBUG=$DEBUG
ARG AWS_LAMBDA_RIE_VERSION=v1.24
ENV AWS_LAMBDA_RIE_VERSION=$AWS_LAMBDA_RIE_VERSION

# User setup, in the build container.
RUN useradd mozilla -d /opt/mozilla && \
    mkdir -p /opt/mozilla && \
    chown -R mozilla:mozilla /opt/mozilla && \
    apt-get -qq update && apt-get -qq install curl

RUN pip install poetry && \
    poetry self add poetry-plugin-export==1.8.0

USER mozilla
ENV PATH="/opt/mozilla/.local/bin:$PATH"
WORKDIR /opt/mozilla

COPY --from=serverless-functions profile_retrieval /opt/mozilla/serverless-functions/profile_retrieval
RUN --mount=from=python-modules,target=/opt/mozilla/python-modules \
    --mount=from=docker,target=/opt/mozilla/docker \
    poetry -C serverless-functions/profile_retrieval export --without-hashes --format=requirements.txt > requirements.txt && \
    pip install -r requirements.txt && \
    ./docker/scripts/debug-install.sh

FROM python:3.13-slim

ARG DEBUG=false
ENV DEBUG=$DEBUG

# User setup, in the runtime container.
RUN useradd mozilla -d /opt/mozilla && \
    mkdir -p /opt/mozilla && \
    chown -R mozilla:mozilla /opt/mozilla
USER mozilla
ENV PATH="/opt/mozilla/.local/bin:$PATH"

COPY --from=build /opt/mozilla/.local /opt/mozilla/.local
COPY --from=docker scripts/run.sh /opt/mozilla/.local/bin/run.sh

COPY --from=build /opt/mozilla/serverless-functions/profile_retrieval /opt/mozilla/serverless-functions/profile_retrieval 
WORKDIR /opt/mozilla/serverless-functions/profile_retrieval /opt/mozilla/serverless-functions/profile_retrieval 

EXPOSE 8080

ENTRYPOINT ["run.sh"]
