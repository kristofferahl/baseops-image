FROM alpine:3.13.5
LABEL maintainer="Kristoffer Ahl kristoffer.ahl@dotnetmentor.se"

ARG WORK_DIR=/work/

# misc
RUN apk --no-cache add \
  bash \
  tar \
  curl \
  jq \
  groff \
  git \
  docker \
  docker-compose

# dig
ARG DIG_VERSION=9.10.2
RUN curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v${DIG_VERSION}/dig.tgz | tar -xzv -C /usr/local/bin/

# aws cli
RUN apk add --no-cache python3 py3-pip \
  && pip3 install --upgrade pip \
  && pip3 install awscli \
  && pip3 cache purge \
  && rm -rf /var/cache/apk/*

COPY ./baseops-versions /usr/local/bin/
RUN chmod +x /usr/local/bin/baseops-versions
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
